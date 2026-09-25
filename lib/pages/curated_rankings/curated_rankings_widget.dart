import '/components/course_rank_card/course_rank_card_widget.dart';
import '/components/tab_item/tab_item_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'curated_rankings_model.dart';
export 'curated_rankings_model.dart';

class CuratedRankingsWidget extends StatefulWidget {
  const CuratedRankingsWidget({super.key});

  static String routeName = 'CuratedRankings';
  static String routePath = '/curatedRankings';

  @override
  State<CuratedRankingsWidget> createState() => _CuratedRankingsWidgetState();
}

class _CuratedRankingsWidgetState extends State<CuratedRankingsWidget> {
  late CuratedRankingsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CuratedRankingsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                shape: BoxShape.rectangle,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 16.0),
                    child: Container(
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
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 32.0,
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      borderRadius: BorderRadius.circular(12.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Icon(
                                      Icons.golf_course_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .onPrimary,
                                      size: 20.0,
                                    ),
                                  ),
                                  Text(
                                    'advisor',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.w900,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineSmall
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w900,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineSmall
                                                  .fontStyle,
                                          lineHeight: 1.4,
                                        ),
                                  ),
                                ].divide(SizedBox(width: 8.0)),
                              ),
                              FlutterFlowIconButton(
                                borderRadius: 8.0,
                                buttonSize: 40.0,
                                fillColor: Colors.transparent,
                                icon: Icon(
                                  Icons.search_rounded,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  context.goNamed(SearchWidget.routeName);
                                },
                              ),
                            ],
                          ),
                          Text(
                            'Curated Rankings',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  font: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .fontStyle,
                                  lineHeight: 1.35,
                                ),
                          ),
                        ].divide(SizedBox(height: 16.0)),
                      ),
                    ),
                  ),
                  Container(
                    height: 1.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                shape: BoxShape.rectangle,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 8.0),
                    child: Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            wrapWithModel(
                              model: _model.tabItemModel1,
                              updateCallback: () => safeSetState(() {}),
                              child: TabItemWidget(
                                label: 'Top 100',
                                selected: true,
                              ),
                            ),
                            wrapWithModel(
                              model: _model.tabItemModel2,
                              updateCallback: () => safeSetState(() {}),
                              child: TabItemWidget(
                                label: 'Best Value',
                                selected: false,
                              ),
                            ),
                            wrapWithModel(
                              model: _model.tabItemModel3,
                              updateCallback: () => safeSetState(() {}),
                              child: TabItemWidget(
                                label: 'Best Winter',
                                selected: false,
                              ),
                            ),
                            wrapWithModel(
                              model: _model.tabItemModel4,
                              updateCallback: () => safeSetState(() {}),
                              child: TabItemWidget(
                                label: 'Bucket List',
                                selected: false,
                              ),
                            ),
                          ].divide(SizedBox(width: 16.0)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 1.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'World\'s Top 100 Courses',
                                    style: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleLarge
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleLarge
                                                  .fontStyle,
                                          lineHeight: 1.5,
                                        ),
                                  ),
                                  Text(
                                    'The definitive list of the greatest tracks on earth, as rated by our community.',
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
                                              .secondaryText,
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
                                  ),
                                ].divide(SizedBox(height: 4.0)),
                              ),
                              wrapWithModel(
                                model: _model.courseRankCardModel1,
                                updateCallback: () => safeSetState(() {}),
                                child: CourseRankCardWidget(
                                  accent: Color(0x00000000),
                                  fee: '£295',
                                  img:
                                      'https://dimg.dreamflow.cloud/v1/image/the%20old%20course%20st%20andrews%20golf',
                                  location: 'St Andrews, Scotland',
                                  name: 'St Andrews (Old Course)',
                                  rank: 1.0,
                                  rating: '4.9',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.courseRankCardModel2,
                                updateCallback: () => safeSetState(() {}),
                                child: CourseRankCardWidget(
                                  accent: Color(0x00000000),
                                  fee: '£325',
                                  img:
                                      'https://dimg.dreamflow.cloud/v1/image/royal%20county%20down%20golf%20course%20mountains',
                                  location: 'Newcastle, Northern Ireland',
                                  name: 'Royal County Down',
                                  rank: 2.0,
                                  rating: '4.8',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.courseRankCardModel3,
                                updateCallback: () => safeSetState(() {}),
                                child: CourseRankCardWidget(
                                  accent: Color(0x00000000),
                                  fee: '£310',
                                  img:
                                      'https://dimg.dreamflow.cloud/v1/image/muirfield%20golf%20link%20course',
                                  location: 'Gullane, Scotland',
                                  name: 'Muirfield',
                                  rank: 3.0,
                                  rating: '4.8',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.courseRankCardModel4,
                                updateCallback: () => safeSetState(() {}),
                                child: CourseRankCardWidget(
                                  accent: Color(0x00000000),
                                  fee: '£250',
                                  img:
                                      'https://dimg.dreamflow.cloud/v1/image/royal%20dornoch%20golf%20green%20ocean',
                                  location: 'Dornoch, Scotland',
                                  name: 'Royal Dornoch',
                                  rank: 4.0,
                                  rating: '4.7',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.courseRankCardModel5,
                                updateCallback: () => safeSetState(() {}),
                                child: CourseRankCardWidget(
                                  accent: Color(0x00000000),
                                  fee: '£395',
                                  img:
                                      'https://dimg.dreamflow.cloud/v1/image/turnberry%20lighthouse%20golf%20course',
                                  location: 'Ayrshire, Scotland',
                                  name: 'Trump Turnberry',
                                  rank: 5.0,
                                  rating: '4.7',
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'More Rankings',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                          lineHeight: 1.5,
                                        ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            context.goNamed(
                                                CuratedRankingsWidget
                                                    .routeName);
                                          },
                                          child: Container(
                                            height: 100.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF1E3A8A),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Container(
                                                child: Container(
                                                  height: 68.0,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Icon(
                                                        Icons.savings_rounded,
                                                        size: 24.0,
                                                      ),
                                                      Text(
                                                        'Best Value\nCourses',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              font: GoogleFonts
                                                                  .inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                              lineHeight: 1.6,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            context.goNamed(
                                                CuratedRankingsWidget
                                                    .routeName);
                                          },
                                          child: Container(
                                            height: 100.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF065F46),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Container(
                                                child: Container(
                                                  height: 68.0,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Icon(
                                                        Icons.ac_unit_rounded,
                                                        size: 24.0,
                                                      ),
                                                      Text(
                                                        'Top Winter\nPlay',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              font: GoogleFonts
                                                                  .inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                              lineHeight: 1.6,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 16.0)),
                                  ),
                                ].divide(SizedBox(height: 16.0)),
                              ),
                            ].divide(SizedBox(height: 24.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
