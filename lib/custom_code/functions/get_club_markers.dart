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

List<LatLng> getClubMarkers(List<GolfClubsRow> clubs) {
  final List<LatLng> markers = [];

  for (final club in clubs) {
    final lat = club.latitude;
    final lng = club.longitude;

    // Safety check; getNearestClubs already filters these out
    if (lat == null || lng == null) continue;
    if (lat == 0 && lng == 0) continue;

    markers.add(LatLng(lat, lng));
  }

  return markers;
}
