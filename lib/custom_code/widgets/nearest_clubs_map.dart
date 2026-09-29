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
import 'package:flutter/material.dart';
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
  }) : super(key: key);

  final double? width;
  final double? height;
  final List<GolfClubsRow> clubs;
  final LatLng userLocation;
  final Future Function(GolfClubsRow club)? onClubTap;

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
    if (!_sameClubs(oldWidget.clubs, widget.clubs)) {
      _prepare();
      _loadVisibleImages();
    }
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: gmaps.GoogleMap(
        initialCameraPosition: gmaps.CameraPosition(
          target: gmaps.LatLng(
            widget.userLocation.latitude,
            widget.userLocation.longitude,
          ),
          zoom: 12,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (c) {
          _controller = c;
          // Small delay so the map has its bounds ready
          Future.delayed(const Duration(milliseconds: 500), _loadVisibleImages);
        },
        onCameraIdle: _loadVisibleImages,
      ),
    );
  }
}
