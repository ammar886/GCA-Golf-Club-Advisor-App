import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

List<GolfClubsRow> getNearestClubs(
  List<GolfClubsRow> clubs,
  LatLng userLocation,
) {
  const int limit = 5;
  const double earthRadiusKm = 6371.0;

  double toRad(double deg) => deg * math.pi / 180.0;

  double haversineKm(double lat1, double lon1, double lat2, double lon2) {
    final dLat = toRad(lat2 - lat1);
    final dLon = toRad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(toRad(lat1)) *
            math.cos(toRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return 2 * earthRadiusKm * math.asin(math.sqrt(a.clamp(0.0, 1.0)));
  }

  final List<MapEntry<GolfClubsRow, double>> withDistance = [];

  for (final club in clubs) {
    final lat = club.latitude;
    final lng = club.longitude;

    // Skip missing or placeholder coordinates
    if (lat == null || lng == null) continue;
    if (lat == 0 && lng == 0) continue;

    final distance = haversineKm(
      userLocation.latitude,
      userLocation.longitude,
      lat,
      lng,
    );
    withDistance.add(MapEntry(club, distance));
  }

  withDistance.sort((a, b) => a.value.compareTo(b.value));

  return withDistance.take(limit).map((e) => e.key).toList();
}
