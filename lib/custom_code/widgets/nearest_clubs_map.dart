// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

/// NearestClubsMap
class NearestClubsMap extends StatefulWidget {
  const NearestClubsMap({
    Key? key,
    this.width,
    this.height,
    required this.clubs,
    required this.userLocation,
    this.onClubTap,
    this.focusLocation,
    this.focusSouthwest,
    this.focusNortheast,
    this.focusVersion = 0,
    this.focusZoom = 14.5,
    this.searchedPinLocation,
    this.searchedPinTitle,
    this.searchRadiusKm,
    this.mapPadding = EdgeInsets.zero,
  }) : super(key: key);

  final double? width;
  final double? height;
  final List<GolfClubsRow> clubs;
  final LatLng userLocation;
  final Future Function(GolfClubsRow club)? onClubTap;
  final LatLng? focusLocation;
  final LatLng? focusSouthwest;
  final LatLng? focusNortheast;
  final int focusVersion;
  final double focusZoom;
  final LatLng? searchedPinLocation;
  final String? searchedPinTitle;
  final double? searchRadiusKm;
  final EdgeInsets mapPadding;

  @override
  State<NearestClubsMap> createState() => _NearestClubsMapState();
}

class _NearestClubsMapState extends State<NearestClubsMap> {
  // Tuning knobs
  static const double _minZoomForImages = 11;
  static const int _maxImagesPerView = 25;
  static const int _concurrency = 4;

  static final Map<String, gmaps.BitmapDescriptor> _iconCache = {};
  static final Set<String> _failedUrls = {};

  gmaps.GoogleMapController? _controller;
  List<GolfClubsRow> _valid = [];
  Set<gmaps.Marker> _markers = {};
  bool _loadingImages = false;
  bool _pendingReload = false;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  void didUpdateWidget(covariant NearestClubsMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final clubsChanged = !_sameClubs(oldWidget.clubs, widget.clubs);
    final pinChanged =
        oldWidget.searchedPinLocation != widget.searchedPinLocation ||
            oldWidget.searchedPinTitle != widget.searchedPinTitle;
    if (clubsChanged) {
      _prepare();
      _loadVisibleImages();
    } else if (pinChanged) {
      _refreshMarkers();
    }

    final focusChanged = widget.focusVersion != oldWidget.focusVersion ||
        widget.focusLocation != oldWidget.focusLocation ||
        widget.focusSouthwest != oldWidget.focusSouthwest ||
        widget.focusNortheast != oldWidget.focusNortheast;
    if (widget.focusLocation != null && focusChanged) {
      _animateToFocus();
    }
  }

  Future<void> _animateToFocus() async {
    final controller = _controller;
    final target = widget.focusLocation;
    if (controller == null || target == null || !mounted) return;

    final sw = widget.focusSouthwest;
    final ne = widget.focusNortheast;
    if (sw != null &&
        ne != null &&
        sw.latitude < ne.latitude &&
        sw.longitude < ne.longitude) {
      try {
        await controller.animateCamera(
          gmaps.CameraUpdate.newLatLngBounds(
            gmaps.LatLngBounds(
              southwest: gmaps.LatLng(sw.latitude, sw.longitude),
              northeast: gmaps.LatLng(ne.latitude, ne.longitude),
            ),
            48.0,
          ),
        );
        return;
      } catch (_) {
        // Fallback to center + zoom if bounds cannot be applied yet.
      }
    }

    await controller.animateCamera(
      gmaps.CameraUpdate.newCameraPosition(
        gmaps.CameraPosition(
          target: gmaps.LatLng(target.latitude, target.longitude),
          zoom: widget.focusZoom,
        ),
      ),
    );
  }

  bool _sameClubs(List<GolfClubsRow> a, List<GolfClubsRow> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  void _prepare() {
    _valid = widget.clubs
        .where((c) =>
            c.latitude != null &&
            c.longitude != null &&
            !(c.latitude == 0 && c.longitude == 0))
        .toList();
    _refreshMarkers();
  }

  void _refreshMarkers() {
    final markers = _valid.map((club) {
      final url = club.imageUrl;
      final icon = (url != null ? _iconCache[url] : null) ??
          gmaps.BitmapDescriptor.defaultMarker;
      return gmaps.Marker(
        markerId: gmaps.MarkerId(club.id.toString()),
        position: gmaps.LatLng(club.latitude!, club.longitude!),
        icon: icon,
        onTap: () => widget.onClubTap?.call(club),
      );
    }).toSet();

    final pin = widget.searchedPinLocation;
    if (pin != null) {
      markers.add(
        gmaps.Marker(
          markerId: const gmaps.MarkerId('__searched_location__'),
          position: gmaps.LatLng(pin.latitude, pin.longitude),
          icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
            gmaps.BitmapDescriptor.hueAzure,
          ),
          infoWindow: gmaps.InfoWindow(
            title: (widget.searchedPinTitle?.trim().isNotEmpty ?? false)
                ? widget.searchedPinTitle!.trim()
                : 'Searched Location',
            snippet:
                '${pin.latitude.toStringAsFixed(4)}, ${pin.longitude.toStringAsFixed(4)}',
          ),
        ),
      );
    }

    if (mounted) setState(() => _markers = markers);
  }

  Future<gmaps.BitmapDescriptor?> _circleImage(String url) async {
    final cached = _iconCache[url];
    if (cached != null) return cached;
    if (_failedUrls.contains(url)) return null;
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) throw Exception('bad status');

      const size = 110;
      final codec = await ui.instantiateImageCodec(
        res.bodyBytes,
        targetWidth: size,
        targetHeight: size,
      );
      final img = (await codec.getNextFrame()).image;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final rect = Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble());

      canvas.drawCircle(
          Offset(size / 2, size / 2), size / 2, Paint()..color = Colors.white);
      canvas.save();
      canvas.clipPath(Path()..addOval(rect.deflate(4)));
      canvas.drawImageRect(
        img,
        Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
        rect,
        Paint(),
      );
      canvas.restore();

      final out = await recorder.endRecording().toImage(size, size);
      final bytes = await out.toByteData(format: ui.ImageByteFormat.png);
      final icon =
          gmaps.BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
      _iconCache[url] = icon;
      return icon;
    } catch (_) {
      _failedUrls.add(url);
      return null;
    }
  }

  Future<void> _loadVisibleImages() async {
    final controller = _controller;
    if (controller == null || !mounted) return;

    // Avoid overlapping runs; re-run once after the current one finishes
    if (_loadingImages) {
      _pendingReload = true;
      return;
    }
    _loadingImages = true;

    try {
      final zoom = await controller.getZoomLevel();
      if (zoom < _minZoomForImages) return;

      final bounds = await controller.getVisibleRegion();
      final center = gmaps.LatLng(
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
      );

      double dist(GolfClubsRow c) {
        final dLat = c.latitude! - center.latitude;
        final dLng = c.longitude! - center.longitude;
        return math.sqrt(dLat * dLat + dLng * dLng);
      }

      final targets = _valid
          .where((c) =>
              c.imageUrl != null &&
              c.imageUrl!.isNotEmpty &&
              !_iconCache.containsKey(c.imageUrl) &&
              !_failedUrls.contains(c.imageUrl) &&
              bounds.contains(gmaps.LatLng(c.latitude!, c.longitude!)))
          .toList()
        ..sort((a, b) => dist(a).compareTo(dist(b)));

      final limited = targets.take(_maxImagesPerView).toList();

      for (var i = 0; i < limited.length; i += _concurrency) {
        if (!mounted) return;
        final batch = limited.skip(i).take(_concurrency);
        await Future.wait(batch.map((c) => _circleImage(c.imageUrl!)));
        _refreshMarkers();
      }
    } finally {
      _loadingImages = false;
      if (_pendingReload) {
        _pendingReload = false;
        _loadVisibleImages();
      }
    }
  }

  Set<gmaps.Circle> _buildCircles() {
    final pin = widget.searchedPinLocation;
    final radiusKm = widget.searchRadiusKm;
    if (pin == null || radiusKm == null || radiusKm <= 0) {
      return const {};
    }
    final primary = FlutterFlowTheme.of(context).primary;
    return {
      gmaps.Circle(
        circleId: const gmaps.CircleId('__search_radius__'),
        center: gmaps.LatLng(pin.latitude, pin.longitude),
        radius: radiusKm * 1000.0,
        fillColor: primary.withValues(alpha: 0.10),
        strokeColor: primary.withValues(alpha: 0.45),
        strokeWidth: 2,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final initialTarget = widget.focusLocation ?? widget.userLocation;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: gmaps.GoogleMap(
        initialCameraPosition: gmaps.CameraPosition(
          target: gmaps.LatLng(
            initialTarget.latitude,
            initialTarget.longitude,
          ),
          zoom: widget.focusLocation != null ? widget.focusZoom : 12,
        ),
        padding: widget.mapPadding,
        markers: _markers,
        circles: _buildCircles(),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (c) {
          _controller = c;
          if (widget.focusLocation != null &&
              widget.focusSouthwest != null &&
              widget.focusNortheast != null) {
            Future.delayed(const Duration(milliseconds: 200), _animateToFocus);
          }
          // Small delay so the map has its bounds ready
          Future.delayed(const Duration(milliseconds: 500), _loadVisibleImages);
        },
        onCameraIdle: _loadVisibleImages,
      ),
    );
  }
}
