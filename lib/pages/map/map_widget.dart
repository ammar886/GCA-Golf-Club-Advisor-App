import 'dart:math' as math;
import '/backend/api_requests/region_geocoding_service.dart';
import '/backend/supabase/supabase.dart';
import '/components/club_map_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'map_model.dart';
export 'map_model.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    super.key,
    this.loadClubs,
    this.initialUserLocation,
    this.mapBuilder,
    this.onClubSelected,
    this.geocodingService,
  });

  final Future<List<GolfClubsRow>> Function()? loadClubs;
  final LatLng? initialUserLocation;
  final Future<void> Function(GolfClubsRow club)? onClubSelected;
  final RegionGeocodingService? geocodingService;
  final Widget Function(
    BuildContext context,
    List<GolfClubsRow> clubs,
    LatLng userLocation,
    LatLng? focusLocation,
    int focusVersion,
    LatLng? searchedPinLocation,
    Future<void> Function(GolfClubsRow club) onClubTap,
    LatLng? focusSouthwest,
    LatLng? focusNortheast,
    double? searchRadiusKm,
  )? mapBuilder;

  static const double defaultRegionRadiusKm = 25.0;

  static String routeName = 'Map';
  static String routePath = '/map';

  static bool isLikelyPostalCode(String raw) =>
      RegionGeocodingService.isLikelyPostalCode(raw);

  static ({List<GolfClubsRow> clubs, bool withinRadius}) findNearbyClubs(
    List<GolfClubsRow> clubs,
    LatLng center, {
    double radiusKm = defaultRegionRadiusKm,
    int fallbackLimit = 8,
  }) {
    final withDistance = <(GolfClubsRow, double)>[];
    for (final club in clubs) {
      if (!hasValidCoordinates(club)) {
        continue;
      }
      final dist = distanceKm(center, LatLng(club.latitude!, club.longitude!));
      withDistance.add((club, dist));
    }
    withDistance.sort((a, b) => a.$2.compareTo(b.$2));

    final inRadius = withDistance
        .where((entry) => entry.$2 <= radiusKm)
        .map((entry) => entry.$1)
        .toList();
    if (inRadius.isNotEmpty) {
      return (clubs: inRadius, withinRadius: true);
    }

    return (
      clubs: withDistance.take(fallbackLimit).map((entry) => entry.$1).toList(),
      withinRadius: false,
    );
  }

  /// Parses coordinate strings such as `"33.5021, -82.0226"`,
  /// `"33.5021 -82.0226"`, or `"LatLng(lat: 33.5021, lng: -82.0226)"`.
  static LatLng? parseLatLng(String raw) {
    final text = raw.trim();
    if (text.isEmpty) {
      return null;
    }

    final match = RegExp(
      r'^(?:latlng\s*\(\s*)?\(?\s*(?:lat(?:itude)?\s*[:=]\s*)?([+-]?\d+(?:\.\d+)?)\s*(?:,\s*|\s+)(?:(?:lng|lon|longitude)\s*[:=]\s*)?([+-]?\d+(?:\.\d+)?)\s*\)?\)?$',
      caseSensitive: false,
    ).firstMatch(text);
    if (match == null) {
      return null;
    }

    final lat = double.tryParse(match.group(1)!);
    final lng = double.tryParse(match.group(2)!);
    if (lat == null || lng == null || !lat.isFinite || !lng.isFinite) {
      return null;
    }
    if (lat < -90.0 || lat > 90.0 || lng < -180.0 || lng > 180.0) {
      return null;
    }
    return LatLng(lat, lng);
  }

  static double distanceKm(LatLng a, LatLng b) {
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

  static bool hasValidCoordinates(GolfClubsRow club) {
    final lat = club.latitude;
    final lng = club.longitude;
    return lat != null && lng != null && !(lat == 0 && lng == 0);
  }

  /// Searches clubs by name, address/city/country, or lat/lng coordinates.
  static List<GolfClubsRow> searchClubs(
    List<GolfClubsRow> clubs,
    String rawQuery,
  ) {
    final query = rawQuery.trim();
    if (query.isEmpty) {
      return const [];
    }

    final parsedCoord = parseLatLng(query);
    if (parsedCoord != null) {
      final valid = clubs.where(hasValidCoordinates).toList();
      valid.sort((a, b) => distanceKm(
            parsedCoord,
            LatLng(a.latitude!, a.longitude!),
          ).compareTo(distanceKm(
            parsedCoord,
            LatLng(b.latitude!, b.longitude!),
          )));
      return valid.take(5).toList();
    }

    final q = query.toLowerCase();
    final scored = <(GolfClubsRow, int)>[];

    for (final club in clubs) {
      final name = (club.name ?? '').toLowerCase();
      final address = (club.address ?? '').toLowerCase();
      final city = (club.city ?? '').toLowerCase();
      final country = (club.country ?? '').toLowerCase();
      final fullAddress = [address, city, country]
          .where((part) => part.isNotEmpty)
          .join(', ');
      final latLngSpaced = (club.latitude != null && club.longitude != null)
          ? '${club.latitude}, ${club.longitude}'.toLowerCase()
          : '';
      final latLngCompact = (club.latitude != null && club.longitude != null)
          ? '${club.latitude},${club.longitude}'.toLowerCase()
          : '';

      int? rank;
      if (name.startsWith(q)) {
        rank = 0;
      } else if (name.contains(q)) {
        rank = 1;
      } else if (address.contains(q) || fullAddress.contains(q)) {
        rank = 2;
      } else if (latLngSpaced.contains(q) || latLngCompact.contains(q)) {
        rank = 3;
      }

      if (rank != null) {
        scored.add((club, rank));
      }
    }

    scored.sort((a, b) {
      final byRank = a.$2.compareTo(b.$2);
      if (byRank != 0) {
        return byRank;
      }
      return (a.$1.name ?? '')
          .toLowerCase()
          .compareTo((b.$1.name ?? '').toLowerCase());
    });

    return scored.map((e) => e.$1).toList();
  }

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late MapModel _model;
  late Future<List<GolfClubsRow>> _clubsFuture;
  late final RegionGeocodingService _geocodingService;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;
  LatLng? _focusLocation;
  LatLng? _focusSouthwest;
  LatLng? _focusNortheast;
  double _focusZoom = 14.5;
  int _focusVersion = 0;
  LatLng? _searchedPinLocation;
  String? _searchedPinTitle;
  double? _searchRadiusKm;
  GeocodedRegion? _activeRegion;
  bool _isRegionPanelMinimized = false;
  bool _showSearchResults = false;
  bool _isGeocoding = false;
  String? _geocodingMessage;
  int _geocodeRequestToken = 0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MapModel());
    _model.searchController ??= TextEditingController();
    _model.searchFocusNode ??= FocusNode();
    _geocodingService = widget.geocodingService ?? RegionGeocodingService();
    _clubsFuture = _fetchClubs();

    if (widget.initialUserLocation != null) {
      currentUserLocationValue = widget.initialUserLocation;
    } else {
      getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0), cached: true)
          .then((loc) => safeSetState(() => currentUserLocationValue = loc));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<List<GolfClubsRow>> _fetchClubs() {
    if (widget.loadClubs != null) {
      return widget.loadClubs!();
    }
    return GolfClubsTable().queryRows(
      queryFn: (q) => q.eqOrNull(
        'isCompleted',
        true,
      ),
    );
  }

  Future<void> _showClubCardDialog(GolfClubsRow club) async {
    _model.selectedMarker = club;
    safeSetState(() {});
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          alignment: AlignmentDirectional(0.0, 1.0)
              .resolve(Directionality.of(context)),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(dialogContext).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: ClubMapCardWidget(
              clubDetails: _model.selectedMarker,
            ),
          ),
        );
      },
    );
  }

  void _unfocusAndHideDropdown() {
    FocusScope.of(context).unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    _showSearchResults = false;
  }

  Future<void> _selectClub(
    GolfClubsRow club, {
    bool clearRegion = true,
  }) async {
    if (clearRegion) {
      _model.searchController?.text = club.name ?? '';
      _model.searchController?.selection = TextSelection.fromPosition(
        TextPosition(offset: _model.searchController?.text.length ?? 0),
      );
    }
    _unfocusAndHideDropdown();
    _geocodingMessage = null;

    if (MapWidget.hasValidCoordinates(club)) {
      _focusLocation = LatLng(club.latitude!, club.longitude!);
      _focusSouthwest = null;
      _focusNortheast = null;
      _focusZoom = 14.5;
      _focusVersion++;
      if (clearRegion) {
        _searchedPinLocation = null;
        _searchedPinTitle = null;
        _searchRadiusKm = null;
        _activeRegion = null;
      }
    }
    safeSetState(() {});
    if (widget.onClubSelected != null) {
      await widget.onClubSelected!(club);
    } else {
      await _showClubCardDialog(club);
    }
  }

  void _goToCoordinates(LatLng coords) {
    _unfocusAndHideDropdown();
    safeSetState(() {
      _focusLocation = coords;
      _focusSouthwest = null;
      _focusNortheast = null;
      _focusZoom = 13.5;
      _focusVersion++;
      _searchedPinLocation = coords;
      _searchedPinTitle = 'Searched Location';
      _searchRadiusKm = null;
      _activeRegion = null;
      _geocodingMessage = null;
    });
  }

  Future<void> _searchRegion(
    String rawQuery,
    List<GolfClubsRow> clubs,
  ) async {
    final query = rawQuery.trim();
    if (query.isEmpty) {
      return;
    }

    final token = ++_geocodeRequestToken;
    _unfocusAndHideDropdown();
    safeSetState(() {
      _isGeocoding = true;
      _geocodingMessage = null;
    });

    try {
      final region =
          await _geocodingService.searchRegion(query, clubs: clubs);
      if (!mounted || token != _geocodeRequestToken) {
        return;
      }

      if (region == null) {
        safeSetState(() {
          _isGeocoding = false;
          _geocodingMessage =
              'No location or zipcode found for "$query".';
        });
        return;
      }

      final bounds = RegionGeocodingService.computeRegionBounds(
        region,
        minRadiusKm: MapWidget.defaultRegionRadiusKm,
      );

      safeSetState(() {
        _isGeocoding = false;
        _geocodingMessage = null;
        _focusLocation = region.center;
        _focusSouthwest = bounds.$1;
        _focusNortheast = bounds.$2;
        _focusZoom = 11.5;
        _focusVersion++;
        _searchedPinLocation = region.center;
        _searchedPinTitle = region.displayName;
        _searchRadiusKm = MapWidget.defaultRegionRadiusKm;
        _activeRegion = region;
        _isRegionPanelMinimized = false;
      });
    } catch (_) {
      if (!mounted || token != _geocodeRequestToken) {
        return;
      }
      safeSetState(() {
        _isGeocoding = false;
        _geocodingMessage =
            'Unable to look up "$query" right now. Please try again.';
      });
    }
  }

  Future<void> _submitSearch(List<GolfClubsRow> clubs) async {
    final query = (_model.searchController?.text ?? '').trim();
    if (query.isEmpty) {
      return;
    }

    final parsedCoord = MapWidget.parseLatLng(query);
    if (parsedCoord != null) {
      _goToCoordinates(parsedCoord);
      return;
    }

    final matches = MapWidget.searchClubs(clubs, query);
    if (MapWidget.isLikelyPostalCode(query) || matches.isEmpty) {
      await _searchRegion(query, clubs);
      return;
    }

    await _selectClub(matches.first);
  }

  void _clearSearch() {
    _geocodeRequestToken++;
    _model.searchController?.clear();
    _unfocusAndHideDropdown();
    safeSetState(() {
      _isGeocoding = false;
      _geocodingMessage = null;
      _searchedPinLocation = null;
      _searchedPinTitle = null;
      _searchRadiusKm = null;
      _activeRegion = null;
      _focusSouthwest = null;
      _focusNortheast = null;
      _focusZoom = 14.5;
    });
  }

  void _dismissActiveRegion() {
    safeSetState(() {
      _activeRegion = null;
      _searchedPinLocation = null;
      _searchedPinTitle = null;
      _searchRadiusKm = null;
      _focusSouthwest = null;
      _focusNortheast = null;
      _focusZoom = 14.5;
    });
  }

  String _formatClubAddress(GolfClubsRow club) {
    final parts = [
      club.address,
      club.city,
      club.country,
    ]
        .where((part) => part != null && part.trim().isNotEmpty)
        .map((part) => part!.trim())
        .toList();
    return parts.isNotEmpty ? parts.join(', ') : 'Address unavailable';
  }

  Widget _buildSearchOverlay(List<GolfClubsRow> clubs) {
    final query = _model.searchController?.text ?? '';
    final trimmed = query.trim();
    final parsedCoord = MapWidget.parseLatLng(trimmed);
    final isPostal = MapWidget.isLikelyPostalCode(trimmed);
    final matches = _showSearchResults && trimmed.isNotEmpty
        ? MapWidget.searchClubs(clubs, trimmed)
        : const <GolfClubsRow>[];
    final showRegionAction =
        _showSearchResults && trimmed.length >= 2 && parsedCoord == null;

    final itemCount = (parsedCoord != null ? 1 : 0) +
        (showRegionAction ? 1 : 0) +
        matches.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(14.0),
          color: FlutterFlowTheme.of(context).secondaryBackground,
          child: TextFormField(
            controller: _model.searchController,
            focusNode: _model.searchFocusNode,
            textInputAction: TextInputAction.search,
            onTap: () {
              if ((_model.searchController?.text.trim() ?? '').isNotEmpty) {
                safeSetState(() => _showSearchResults = true);
              }
            },
            onChanged: (value) {
              safeSetState(() {
                _geocodingMessage = null;
                _showSearchResults = value.trim().isNotEmpty;
              });
            },
            onFieldSubmitted: (_) => _submitSearch(clubs),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                ),
            decoration: InputDecoration(
              hintText: 'Search club, address, zipcode, or lat, lng',
              hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                    font: GoogleFonts.inter(),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 13.0,
                    letterSpacing: 0.0,
                  ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: FlutterFlowTheme.of(context).primary,
                size: 22.0,
              ),
              suffixIcon: _isGeocoding
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 18.0,
                        height: 18.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ),
                    )
                  : trimmed.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 20.0,
                          ),
                          onPressed: _clearSearch,
                        )
                      : null,
              filled: true,
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 12.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        if (_geocodingMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(12.0),
              color: FlutterFlowTheme.of(context).secondaryBackground,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 10.0,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: FlutterFlowTheme.of(context).error,
                      size: 18.0,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        _geocodingMessage!,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => safeSetState(() => _geocodingMessage = null),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18.0,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (_showSearchResults && trimmed.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Material(
              elevation: 6.0,
              borderRadius: BorderRadius.circular(14.0),
              color: FlutterFlowTheme.of(context).secondaryBackground,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 260.0),
                child: itemCount == 0
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 20.0,
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                'No golf clubs match "$trimmed"',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 13.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        itemCount: itemCount,
                        separatorBuilder: (_, __) => Divider(
                          height: 1.0,
                          color: FlutterFlowTheme.of(context).alternate,
                        ),
                        itemBuilder: (context, index) {
                          if (parsedCoord != null && index == 0) {
                            return ListTile(
                              dense: true,
                              leading: Icon(
                                Icons.my_location_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                              title: Text(
                                'Go to coordinates',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.0,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              subtitle: Text(
                                '${parsedCoord.latitude.toStringAsFixed(4)}, ${parsedCoord.longitude.toStringAsFixed(4)}',
                                style: GoogleFonts.inter(
                                  fontSize: 12.0,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                              onTap: () => _goToCoordinates(parsedCoord),
                            );
                          }

                          final regionActionIndex = parsedCoord != null
                              ? -1
                              : (isPostal ? 0 : matches.length);

                          if (showRegionAction && index == regionActionIndex) {
                            return ListTile(
                              dense: true,
                              leading: Icon(
                                Icons.location_searching_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                              title: Text(
                                isPostal
                                    ? 'Search zipcode "$trimmed"'
                                    : 'Search region "$trimmed"',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.0,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              subtitle: Text(
                                'Move map to area and show nearby clubs',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                              onTap: () => _searchRegion(trimmed, clubs),
                            );
                          }

                          int clubIndex = index;
                          if (parsedCoord != null) {
                            clubIndex = index - 1;
                          } else if (showRegionAction && isPostal) {
                            clubIndex = index - 1;
                          }
                          final club = matches[clubIndex];
                          final hasCoords = MapWidget.hasValidCoordinates(club);
                          final addressLine = _formatClubAddress(club);
                          final coordText = hasCoords
                              ? '${club.latitude!.toStringAsFixed(4)}, ${club.longitude!.toStringAsFixed(4)}'
                              : null;
                          final distanceText = (parsedCoord != null && hasCoords)
                              ? '${MapWidget.distanceKm(parsedCoord, LatLng(club.latitude!, club.longitude!)).toStringAsFixed(1)} km away'
                              : null;
                          final metaLine = [
                            if (distanceText != null) distanceText,
                            if (coordText != null) coordText,
                          ].join(' • ');

                          return ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.golf_course_rounded,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            title: Text(
                              club.name ?? 'Golf Club',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.0,
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            subtitle: Text(
                              metaLine.isNotEmpty
                                  ? '$addressLine\n$metaLine'
                                  : addressLine,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                            onTap: () => _selectClub(club),
                          );
                        },
                      ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNearbyRegionPanel(List<GolfClubsRow> allClubs) {
    final region = _activeRegion!;
    final nearby = MapWidget.findNearbyClubs(
      allClubs,
      region.center,
      radiusKm: MapWidget.defaultRegionRadiusKm,
    );

    final subtitleText = nearby.clubs.isEmpty
        ? 'No golf clubs with coordinates found'
        : nearby.withinRadius
            ? '${nearby.clubs.length} ${nearby.clubs.length == 1 ? 'club' : 'clubs'} within ${MapWidget.defaultRegionRadiusKm.toInt()} km'
            : 'No clubs within ${MapWidget.defaultRegionRadiusKm.toInt()} km • Nearest clubs';

    return Material(
      elevation: 6.0,
      borderRadius: BorderRadius.circular(16.0),
      color: FlutterFlowTheme.of(context).secondaryBackground,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 10.0, 8.0, 10.0),
            child: Row(
              children: [
                Icon(
                  Icons.place_rounded,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 20.0,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        region.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                      Text(
                        subtitleText,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    _isRegionPanelMinimized
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                  onPressed: () => safeSetState(
                    () => _isRegionPanelMinimized = !_isRegionPanelMinimized,
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18.0,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  onPressed: _dismissActiveRegion,
                ),
              ],
            ),
          ),
          if (!_isRegionPanelMinimized && nearby.clubs.isNotEmpty) ...[
            Divider(
              height: 1.0,
              color: FlutterFlowTheme.of(context).alternate,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150.0),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                itemCount: nearby.clubs.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1.0,
                  color: FlutterFlowTheme.of(context).alternate,
                ),
                itemBuilder: (context, index) {
                  final club = nearby.clubs[index];
                  final distKm = MapWidget.distanceKm(
                    region.center,
                    LatLng(club.latitude!, club.longitude!),
                  );
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.golf_course_rounded,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 20.0,
                    ),
                    title: Text(
                      club.name ?? 'Golf Club',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                    subtitle: Text(
                      _formatClubAddress(club),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11.0,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                    trailing: Text(
                      '${distKm.toStringAsFixed(1)} km',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.5,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                    onTap: () => _selectClub(club, clearRegion: false),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserLocationValue == null) {
      return Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (_showSearchResults) {
          safeSetState(() => _showSearchResults = false);
        }
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/copilot_image_1786136711562.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'G',
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .fontStyle,
                                    ),
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    fontSize: 22.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontStyle,
                                  ),
                            ),
                            TextSpan(
                              text: 'olf ',
                              style: TextStyle(),
                            ),
                            TextSpan(
                              text: 'C',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).tertiary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: 'lub ',
                              style: TextStyle(),
                            ),
                            TextSpan(
                              text: 'a',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: 'dvisor',
                              style: TextStyle(),
                            )
                          ],
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                font: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 22.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .fontStyle,
                              ),
                        ),
                      ),
                      Text(
                        'REAL GOLFERS. REAL REVIEWS.',
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              font: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primary,
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontStyle,
                            ),
                      ),
                    ].divide(SizedBox(height: 6.0)),
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(SupportWidget.routeName);
                  },
                  child: Icon(
                    Icons.support_agent,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                ),
              ].divide(SizedBox(width: 8.0)),
            ),
            actions: [],
            centerTitle: true,
            elevation: 2.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: FutureBuilder<List<GolfClubsRow>>(
            future: _clubsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Failed to load golf clubs.',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                );
              }
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                );
              }
              List<GolfClubsRow> containerGolfClubsRowList = snapshot.data!;

              return Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: widget.mapBuilder != null
                        ? widget.mapBuilder!(
                            context,
                            containerGolfClubsRowList,
                            currentUserLocationValue!,
                            _focusLocation,
                            _focusVersion,
                            _searchedPinLocation,
                            _showClubCardDialog,
                            _focusSouthwest,
                            _focusNortheast,
                            _searchRadiusKm,
                          )
                        : custom_widgets.NearestClubsMap(
                            width: double.infinity,
                            height: double.infinity,
                            clubs: containerGolfClubsRowList,
                            userLocation: currentUserLocationValue!,
                            focusLocation: _focusLocation,
                            focusSouthwest: _focusSouthwest,
                            focusNortheast: _focusNortheast,
                            focusZoom: _focusZoom,
                            focusVersion: _focusVersion,
                            searchedPinLocation: _searchedPinLocation,
                            searchedPinTitle: _searchedPinTitle,
                            searchRadiusKm: _searchRadiusKm,
                            mapPadding: EdgeInsets.only(
                              top: 76.0,
                              bottom: _activeRegion != null
                                  ? (_isRegionPanelMinimized ? 76.0 : 220.0)
                                  : 0.0,
                            ),
                            onClubTap: _showClubCardDialog,
                          ),
                  ),
                  Positioned(
                    top: 12.0,
                    left: 16.0,
                    right: 16.0,
                    child: _buildSearchOverlay(containerGolfClubsRowList),
                  ),
                  if (_activeRegion != null)
                    Positioned(
                      left: 16.0,
                      right: 16.0,
                      bottom: 16.0,
                      child: _buildNearbyRegionPanel(containerGolfClubsRowList),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
