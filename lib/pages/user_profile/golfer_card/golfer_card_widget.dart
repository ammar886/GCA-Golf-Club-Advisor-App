import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'golfer_card_model.dart';
export 'golfer_card_model.dart';

class GolferCardWidget extends StatefulWidget {
  const GolferCardWidget({
    super.key,
    this.golferDetails,
  });

  final UsersRow? golferDetails;

  @override
  State<GolferCardWidget> createState() => _GolferCardWidgetState();
}

class _GolferCardWidgetState extends State<GolferCardWidget> {
  late GolferCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GolferCardModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Container(
                      width: 90.0,
                      height: 90.0,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/WhatsApp_Image_2026-09-12_at_1.27.44_AM.jpeg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 70.0,
                            height: 70.0,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/images/logo_gca.JPG',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            valueOrDefault<String>(
                              '${valueOrDefault<String>(
                                widget.golferDetails?.firstName,
                                'name',
                              )} ${valueOrDefault<String>(
                                widget.golferDetails?.lastName,
                                'last',
                              )}',
                              'Jeremy Davies',
                            ),
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  fontSize: 20.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                          Text(
                            'GOLFER PROFILE',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: AlignmentDirectional(1.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 10.0),
                          child: Container(
                            width: 65.0,
                            height: 65.0,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/images/WhatsApp_Image_2026-09-12_at_11.26.45_PM-removebg-preview.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 50.0,
              child: Divider(
                thickness: 2.0,
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
            Container(
              height: 450.0,
              child: Stack(
                alignment: AlignmentDirectional(0.0, 0.0),
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.0, -1.0),
                    child: Builder(
                      builder: (context) {
                        if (widget.golferDetails?.clubBrand != 'Other') {
                          return Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 4.0),
                            child: FutureBuilder<List<GolfClubsRow>>(
                              future: GolfClubsTable().querySingleRow(
                                queryFn: (q) => q.eqOrNull(
                                  'name',
                                  widget.golferDetails?.homeClub,
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
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          FlutterFlowTheme.of(context).primary,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                List<GolfClubsRow> imageGolfClubsRowList =
                                    snapshot.data!;

                                final imageGolfClubsRow =
                                    imageGolfClubsRowList.isNotEmpty
                                        ? imageGolfClubsRowList.first
                                        : null;

                                return ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                  ),
                                  child: Image.network(
                                    imageGolfClubsRow!.imageUrl!,
                                    width: double.infinity,
                                    height: 250.0,
                                    fit: BoxFit.fill,
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0),
                              ),
                              child: Image.asset(
                                'assets/images/WhatsApp_Image_2026-09-11_at_1.33.19_AM.jpeg',
                                width: double.infinity,
                                height: 250.0,
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 180.0, 0.0, 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: Color(0x1C64748B),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: Color(0x5384E4BC),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Icon(
                                    Icons.home_outlined,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 24.0,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'HOME CLUB',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 10.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        valueOrDefault<String>(
                                          widget.golferDetails?.homeClub,
                                          'HOME CLUB HOME CLUB HOME CLUB HOME CLUB HOME CLUB ',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                            Divider(
                              thickness: 2.0,
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: Color(0x5384E4BC),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Icon(
                                    Icons.golf_course,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 24.0,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'HANDICAP',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontSize: 10.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 12.0, 0.0),
                                  child: Text(
                                    valueOrDefault<String>(
                                      formatNumber(
                                        widget.golferDetails?.golfHandicap,
                                        formatType: FormatType.custom,
                                        format: '#',
                                        locale: '',
                                      ),
                                      '14',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w800,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          fontSize: 24.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w800,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                            Divider(
                              thickness: 2.0,
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: Color(0x5384E4BC),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Icon(
                                    Icons.sports_golf,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 24.0,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Club Brand',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontSize: 10.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                                Builder(
                                  builder: (context) {
                                    if (widget.golferDetails?.clubBrand ==
                                        'TAYLORMADE') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/TAYLORMADW.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'TITLEIST') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/TITLEIST.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'PING') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/PING.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'ODYSSEY') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/ODYSSEY.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'COBRA GOLF') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/COBRA.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.contain,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'CALLAWAY GOLF') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/CALAWAY.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.contain,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'WILSON') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/WILSON.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'BENROSS') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/BENROSS.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'MIZUNO GOLF') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/MIZUNO.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.contain,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'BETTINARD') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/B_HEX.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.contain,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'TOUR EDGE') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/TE.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.contain,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'FAZER') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/FAZER.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'CLEVELAND GOLF') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/CleveLandGolf.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.contain,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'RIFE') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/RIFE.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'LA GOLF') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/LAgolf.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'SRIXON') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/SRIXON.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'INDI GOLF') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/IndiGolf.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.contain,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'MACGREGOR') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/MacGregor.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'SKYMAX') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/WhatsApp_Image_2026-09-12_at_1.40.35_AM.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.contain,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'LAB GOLF') {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/WhatsApp_Image_2026-09-12_at_1.40.32_AM.jpeg',
                                          width: 150.0,
                                          height: 40.0,
                                          fit: BoxFit.contain,
                                        ),
                                      );
                                    } else if (widget
                                            .golferDetails?.clubBrand ==
                                        'IVAN BALLESTEROS') {
                                      return Text(
                                        'IVAN BALLESTEROS',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w800,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w800,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      );
                                    } else {
                                      return Text(
                                        'OTHER',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w800,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w800,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      );
                                    }
                                  },
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
