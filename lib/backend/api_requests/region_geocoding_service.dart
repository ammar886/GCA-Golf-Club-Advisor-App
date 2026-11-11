import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '/backend/supabase/supabase.dart';

class GeocodedRegion {
  const GeocodedRegion({
    required this.displayName,
    required this.center,
    this.southwest,
    this.northeast,
  });

  final String displayName;
  final LatLng center;
  final LatLng? southwest;
  final LatLng? northeast;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeocodedRegion &&
          runtimeType == other.runtimeType &&
          displayName == other.displayName &&
          center == other.center &&
          southwest == other.southwest &&
          northeast == other.northeast;

  @override
  int get hashCode =>
      Object.hash(displayName, center, southwest, northeast);
}

/// Resolves zipcodes, international/UK postcodes, and region names to
/// geographic coordinates and bounding boxes via OpenStreetMap Nominatim.
class RegionGeocodingService {
  RegionGeocodingService({http.Client? client})
      : _client = client ?? http.Client();

  static const String _nominatimHost = 'nominatim.openstreetmap.org';
  static const Duration _requestTimeout = Duration(seconds: 8);

  final http.Client _client;
  final Map<String, List<GeocodedRegion>> _cache = {};

  /// Checks whether [raw] matches common numeric zipcodes or alphanumeric
  /// international/UK postcodes (including outward codes like `SW1A` or `KY16`).
  static bool isLikelyPostalCode(String raw) {
    final text = raw.trim().toUpperCase();
    if (text.isEmpty) {
      return false;
    }

    // US 5-digit / ZIP+4 or general 4-6 digit postal codes.
    if (RegExp(r'^\d{4,6}(?:-\d{4})?$').hasMatch(text)) {
      return true;
    }

    // Full UK postcode (e.g. SW1A 1AA, KY16 9SF, M1 1AE, EC1A 1BB).
    if (RegExp(r'^[A-Z]{1,2}\d[A-Z\d]?\s*\d[A-Z]{2}$').hasMatch(text)) {
      return true;
    }

    // UK outward postcode district (e.g. SW1A, KY16, EH1, M1).
    if (RegExp(r'^[A-Z]{1,2}\d[A-Z\d]?$').hasMatch(text)) {
      return true;
    }

    // Canadian postal code (e.g. K1A 0B1).
    if (RegExp(r'^[A-Z]\d[A-Z]\s*\d[A-Z]\d$').hasMatch(text)) {
      return true;
    }

    // Netherlands / similar alphanumeric codes (e.g. 1012 AB).
    if (RegExp(r'^\d{4}\s*[A-Z]{2}$').hasMatch(text)) {
      return true;
    }

    return false;
  }

  Future<GeocodedRegion?> searchRegion(
    String rawQuery, {
    List<GolfClubsRow> clubs = const [],
  }) async {
    final results = await searchRegions(rawQuery);
    if (results.isEmpty) {
      return null;
    }
    return selectBestRegion(results, clubs: clubs);
  }

  Future<List<GeocodedRegion>> searchRegions(String rawQuery) async {
    final query = rawQuery.trim();
    if (query.isEmpty) {
      return const [];
    }

    final cacheKey = query.toLowerCase();
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    List<GeocodedRegion> regions = const [];
    if (isLikelyPostalCode(query)) {
      regions = await _queryNominatim({'postalcode': query});
    }

    if (regions.isEmpty) {
      regions = await _queryNominatim({'q': query});
    }

    _cache[cacheKey] = regions;
    return regions;
  }

  Future<List<GeocodedRegion>> _queryNominatim(
    Map<String, String> queryParams,
  ) async {
    final uri = Uri.https(
      _nominatimHost,
      '/search',
      {
        ...queryParams,
        'format': 'jsonv2',
        'addressdetails': '1',
        'limit': '5',
      },
    );

    final headers = <String, String>{
      'Accept': 'application/json',
      if (!kIsWeb)
        'User-Agent': 'GolfClubAdvisorApp/1.0 (https://golfclubadvisor.co.uk)',
    };

    final response =
        await _client.get(uri, headers: headers).timeout(_requestTimeout);
    if (response.statusCode != 200) {
      throw Exception('Geocoding failed with status ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      return const [];
    }

    final regions = <GeocodedRegion>[];
    for (final item in decoded) {
      if (item is! Map<String, dynamic>) {
        continue;
      }
      final parsed = _parseNominatimItem(item);
      if (parsed != null) {
        regions.add(parsed);
      }
    }
    return regions;
  }

  static GeocodedRegion? _parseNominatimItem(Map<String, dynamic> item) {
    final lat = double.tryParse(item['lat']?.toString() ?? '');
    final lon = double.tryParse(item['lon']?.toString() ?? '');
    if (lat == null || lon == null || !lat.isFinite || !lon.isFinite) {
      return null;
    }
    if (lat < -90.0 || lat > 90.0 || lon < -180.0 || lon > 180.0) {
      return null;
    }

    final displayName =
        (item['display_name']?.toString().trim().isNotEmpty ?? false)
            ? item['display_name'].toString().trim()
            : '${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}';

    LatLng? sw;
    LatLng? ne;
    final bbox = item['boundingbox'];
    if (bbox is List && bbox.length == 4) {
      final south = double.tryParse(bbox[0].toString());
      final north = double.tryParse(bbox[1].toString());
      final west = double.tryParse(bbox[2].toString());
      final east = double.tryParse(bbox[3].toString());
      if (south != null &&
          north != null &&
          west != null &&
          east != null &&
          south.isFinite &&
          north.isFinite &&
          west.isFinite &&
          east.isFinite &&
          south <= north &&
          west <= east) {
        sw = LatLng(south, west);
        ne = LatLng(north, east);
      }
    }

    return GeocodedRegion(
      displayName: displayName,
      center: LatLng(lat, lon),
      southwest: sw,
      northeast: ne,
    );
  }

  /// Picks the candidate region closest to known golf clubs when numeric
  /// postal codes exist in multiple countries; falls back to the first result.
  static GeocodedRegion selectBestRegion(
    List<GeocodedRegion> candidates, {
    List<GolfClubsRow> clubs = const [],
  }) {
    if (candidates.length == 1 || clubs.isEmpty) {
      return candidates.first;
    }

    final validClubs = clubs
        .where((c) =>
            c.latitude != null &&
            c.longitude != null &&
            !(c.latitude == 0 && c.longitude == 0))
        .toList();
    if (validClubs.isEmpty) {
      return candidates.first;
    }

    GeocodedRegion best = candidates.first;
    double bestMinDist = double.infinity;

    for (final candidate in candidates) {
      double minDist = double.infinity;
      for (final club in validClubs) {
        final d = _haversineKm(
          candidate.center,
          LatLng(club.latitude!, club.longitude!),
        );
        if (d < minDist) {
          minDist = d;
        }
      }
      // Prefer a candidate that has at least one club within 150 km;
      // preserve Nominatim's ranking if multiple/none are nearby.
      if (minDist < 150.0 && minDist < bestMinDist) {
        bestMinDist = minDist;
        best = candidate;
      }
    }

    return best;
  }

  /// Expands or builds bounding coordinates covering at least [minRadiusKm]
  /// around [region.center] so small postcodes frame nearby clubs cleanly.
  static (LatLng southwest, LatLng northeast) computeRegionBounds(
    GeocodedRegion region, {
    double minRadiusKm = 25.0,
  }) {
    final center = region.center;
    final latDelta = minRadiusKm / 111.32;
    final cosLat = math.max(math.cos(center.latitude * math.pi / 180.0), 0.1);
    final lngDelta = minRadiusKm / (111.32 * cosLat);

    final radiusSouth = math.max(-85.0, center.latitude - latDelta);
    final radiusNorth = math.min(85.0, center.latitude + latDelta);
    final radiusWest = math.max(-180.0, center.longitude - lngDelta);
    final radiusEast = math.min(180.0, center.longitude + lngDelta);

    final sw = region.southwest;
    final ne = region.northeast;
    if (sw == null || ne == null) {
      return (
        LatLng(radiusSouth, radiusWest),
        LatLng(radiusNorth, radiusEast),
      );
    }

    return (
      LatLng(
        math.min(sw.latitude, radiusSouth).clamp(-85.0, 85.0),
        math.min(sw.longitude, radiusWest).clamp(-180.0, 180.0),
      ),
      LatLng(
        math.max(ne.latitude, radiusNorth).clamp(-85.0, 85.0),
        math.max(ne.longitude, radiusEast).clamp(-180.0, 180.0),
      ),
    );
  }

  static double _haversineKm(LatLng a, LatLng b) {
    const double earthRadiusKm = 6371.0;
    double toRad(double deg) => deg * math.pi / 180.0;
    final dLat = toRad(b.latitude - a.latitude);
    final dLon = toRad(b.longitude - a.longitude);
    final sinDLat = math.sin(dLat / 2);
    final sinDLon = math.sin(dLon / 2);
    final h = sinDLat * sinDLat +
        math.cos(toRad(a.latitude)) *
            math.cos(toRad(b.latitude)) *
            sinDLon *
            sinDLon;
    return 2 * earthRadiusKm * math.asin(math.sqrt(h.clamp(0.0, 1.0)));
  }
}

