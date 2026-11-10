import 'dart:math' as math;
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
  });

  final Future<List<GolfClubsRow>> Function()? loadClubs;
  final LatLng? initialUserLocation;
  final Future<void> Function(GolfClubsRow club)? onClubSelected;
  final Widget Function(
    BuildContext context,
    List<GolfClubsRow> clubs,
    LatLng userLocation,
    LatLng? focusLocation,
    int focusVersion,
    LatLng? searchedPinLocation,
    Future<void> Function(GolfClubsRow club) onClubTap,
  )? mapBuilder;

  static String routeName = 'Map';
  static String routePath = '/map';

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

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;
  LatLng? _focusLocation;
  int _focusVersion = 0;
  LatLng? _searchedPinLocation;
  bool _showSearchResults = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MapModel());
    _model.searchController ??= TextEditingController();
    _model.searchFocusNode ??= FocusNode();
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

  Future<void> _selectClub(GolfClubsRow club) async {
    _model.searchController?.text = club.name ?? '';
    _model.searchController?.selection = TextSelection.fromPosition(
      TextPosition(offset: _model.searchController?.text.length ?? 0),
    );
    _unfocusAndHideDropdown();

    if (MapWidget.hasValidCoordinates(club)) {
      _focusLocation = LatLng(club.latitude!, club.longitude!);
      _focusVersion++;
      _searchedPinLocation = null;
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
      _focusVersion++;
      _searchedPinLocation = coords;
    });
  }

  Future<void> _submitSearch(List<GolfClubsRow> clubs) async {
    final query = _model.searchController?.text ?? '';
    final parsedCoord = MapWidget.parseLatLng(query);
    if (parsedCoord != null) {
      _goToCoordinates(parsedCoord);
      return;
    }

    final matches = MapWidget.searchClubs(clubs, query);
    if (matches.isNotEmpty) {
      await _selectClub(matches.first);
    } else {
      _unfocusAndHideDropdown();
      safeSetState(() {});
    }
  }

  void _clearSearch() {
    _model.searchController?.clear();
    _unfocusAndHideDropdown();
    safeSetState(() {
      _searchedPinLocation = null;
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
    final matches = _showSearchResults && trimmed.isNotEmpty
        ? MapWidget.searchClubs(clubs, trimmed)
        : const <GolfClubsRow>[];

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
              hintText: 'Search by club name, address, or lat, lng',
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
              suffixIcon: trimmed.isNotEmpty
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
        if (_showSearchResults && trimmed.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Material(
              elevation: 6.0,
              borderRadius: BorderRadius.circular(14.0),
              color: FlutterFlowTheme.of(context).secondaryBackground,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 260.0),
                child: (parsedCoord == null && matches.isEmpty)
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
                        itemCount: matches.length + (parsedCoord != null ? 1 : 0),
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

                          final clubIndex =
                              parsedCoord != null ? index - 1 : index;
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
                          )
                        : custom_widgets.NearestClubsMap(
                            width: double.infinity,
                            height: double.infinity,
                            clubs: containerGolfClubsRowList,
                            userLocation: currentUserLocationValue!,
                            focusLocation: _focusLocation,
                            focusVersion: _focusVersion,
                            searchedPinLocation: _searchedPinLocation,
                            mapPadding: const EdgeInsets.only(top: 76.0),
                            onClubTap: _showClubCardDialog,
                          ),
                  ),
                  Positioned(
                    top: 12.0,
                    left: 16.0,
                    right: 16.0,
                    child: _buildSearchOverlay(containerGolfClubsRowList),
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
