import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'club_card_top_ten_model.dart';
export 'club_card_top_ten_model.dart';

class ClubCardTopTenWidget extends StatefulWidget {
  const ClubCardTopTenWidget({
    super.key,
    String? img,
    String? loc,
    String? name,
    String? price,
    String? rating,
    required this.clubDetails,
    this.index,
  })  : this.img = img ??
            'https://dimg.dreamflow.cloud/v1/image/links%20golf%20course%20by%20the%20sea%20with%20deep%20bunkers',
        this.loc = loc ?? 'Sandwich, Kent',
        this.name = name ?? 'Royal St George\'s',
        this.price = price ?? '£250',
        this.rating = rating ?? '4.9';

  final String img;
  final String loc;
  final String name;
  final String price;
  final String rating;
  final GolfClubsRow? clubDetails;
  final int? index;

  @override
  State<ClubCardTopTenWidget> createState() => _ClubCardTopTenWidgetState();
}

class _ClubCardTopTenWidgetState extends State<ClubCardTopTenWidget> {
  late ClubCardTopTenModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ClubCardTopTenModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClubRatingStatsRow>>(
      future: ClubRatingStatsTable().querySingleRow(
        queryFn: (q) => q.eqOrNull(
          'club_id',
          widget.clubDetails?.id,
        ),
      ),
      builder: (context, snapshot) {
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
        List<ClubRatingStatsRow> containerClubRatingStatsRowList =
            snapshot.data!;

        final containerClubRatingStatsRow =
            containerClubRatingStatsRowList.isNotEmpty
                ? containerClubRatingStatsRowList.first
                : null;

        return InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            context.pushNamed(
              ClubDetailedViewWidget.routeName,
              queryParameters: {
                'clubDetails': serializeParam(
                  widget.clubDetails,
                  ParamType.SupabaseRow,
                ),
              }.withoutNulls,
            );
          },
          child: Material(
            color: Colors.transparent,
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(16.0),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.transparent,
                    width: 0.0,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 6.0, 6.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 0.5,
                          shape: const CircleBorder(),
                          child: Container(
                            width: 26.0,
                            height: 26.0,
                            decoration: BoxDecoration(
                              color: () {
                                if (widget.index == 0) {
                                  return Color(0xFFD4621A);
                                } else if (widget.index == 1) {
                                  return Color(0xFFEEEEEE);
                                } else if (widget.index == 2) {
                                  return Color(0xFF4D2A00);
                                } else {
                                  return Color(0xFFF2F2F2);
                                }
                              }(),
                              shape: BoxShape.circle,
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              () {
                                if (widget.index == 0) {
                                  return '1';
                                } else if (widget.index == 1) {
                                  return '2';
                                } else if (widget.index == 2) {
                                  return '3';
                                } else {
                                  return ((widget.index!) + 1).toString();
                                }
                              }(),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w900,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: () {
                                      if (widget.index == 0) {
                                        return FlutterFlowTheme.of(context)
                                            .secondaryBackground;
                                      } else if (widget.index == 1) {
                                        return FlutterFlowTheme.of(context)
                                            .primaryText;
                                      } else if (widget.index == 2) {
                                        return FlutterFlowTheme.of(context)
                                            .secondaryText;
                                      } else {
                                        return FlutterFlowTheme.of(context)
                                            .primaryText;
                                      }
                                    }(),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 80.0,
                        height: 60.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 0),
                            fadeOutDuration: Duration(milliseconds: 0),
                            imageUrl: valueOrDefault<String>(
                              widget.img,
                              'https://dimg.dreamflow.cloud/v1/image/links%20golf%20course%20by%20the%20sea%20with%20deep%20bunkers',
                            ),
                            fit: BoxFit.cover,
                            alignment: Alignment(0.0, 0.0),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      valueOrDefault<String>(
                                        widget.name,
                                        'Royal St George\'s',
                                      ),
                                      maxLines: 1,
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                            lineHeight: 1.5,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 16.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      valueOrDefault<String>(
                                        widget.loc,
                                        'Sandwich, Kent',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontStyle,
                                            lineHeight: 1.6,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ].divide(SizedBox(width: 4.0)),
                              ),
                            ].divide(SizedBox(height: 2.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: FlutterFlowTheme.of(context).warning,
                              size: 20.0,
                            ),
                            Text(
                              valueOrDefault<String>(
                                '${valueOrDefault<String>(
                                  containerClubRatingStatsRow?.overallRating
                                      ?.toString(),
                                  '0.0',
                                )}',
                                '4.9',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                    lineHeight: 1.6,
                                  ),
                            ),
                          ].divide(SizedBox(width: 4.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
