import '/components/category_chip/category_chip_widget.dart';
import '/components/course_list_item/course_list_item_widget.dart';
import '/components/section_header/section_header_widget.dart';
import '/components/text_field/text_field_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'search_model.dart';
export 'search_model.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  static String routeName = 'Search';
  static String routePath = '/search';

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late SearchModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchModel());

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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              primary: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 24.0, 24.0, 16.0),
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Search',
                                      style: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineMedium
                                                    .fontStyle,
                                            lineHeight: 1.35,
                                          ),
                                    ),
                                    FlutterFlowIconButton(
                                      borderRadius: 12.0,
                                      buttonSize: 40.0,
                                      fillColor: Color(0xFFE3F2FD),
                                      icon: Icon(
                                        Icons.tune_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 24.0,
                                      ),
                                      onPressed: () {
                                        print('IconButton pressed ...');
                                      },
                                    ),
                                  ],
                                ),
                                wrapWithModel(
                                  model: _model.textFieldModel,
                                  updateCallback: () => safeSetState(() {}),
                                  child: TextFieldWidget(
                                    label: '',
                                    labelPresent: false,
                                    helper: '',
                                    helperPresent: false,
                                    leadingIcon: Icon(
                                      Icons.search_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 24.0,
                                    ),
                                    leadingIconPresent: true,
                                    trailingIconPresent: false,
                                    hint: 'Search courses, towns, or postcodes',
                                    value: '',
                                    onChange: '',
                                    onSubmit: '',
                                    variant: 'filled',
                                    error: false,
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
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                child: Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      wrapWithModel(
                                        model: _model.categoryChipModel1,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: CategoryChipWidget(
                                          icon: Icon(
                                            Icons.workspace_premium_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .onPrimary,
                                            size: 18.0,
                                          ),
                                          label: 'Top 100',
                                          selected: true,
                                        ),
                                      ),
                                      wrapWithModel(
                                        model: _model.categoryChipModel2,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: CategoryChipWidget(
                                          icon: Icon(
                                            Icons.payments_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 18.0,
                                          ),
                                          label: 'Best Value',
                                          selected: false,
                                        ),
                                      ),
                                      wrapWithModel(
                                        model: _model.categoryChipModel3,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: CategoryChipWidget(
                                          icon: Icon(
                                            Icons.wb_sunny_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 18.0,
                                          ),
                                          label: 'Best Winter',
                                          selected: false,
                                        ),
                                      ),
                                      wrapWithModel(
                                        model: _model.categoryChipModel4,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: CategoryChipWidget(
                                          icon: Icon(
                                            Icons.favorite_border_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 18.0,
                                          ),
                                          label: 'Bucket List',
                                          selected: false,
                                        ),
                                      ),
                                      wrapWithModel(
                                        model: _model.categoryChipModel5,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: CategoryChipWidget(
                                          icon: Icon(
                                            Icons.near_me_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 18.0,
                                          ),
                                          label: 'Nearby',
                                          selected: false,
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 8.0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ].divide(SizedBox(height: 16.0)),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Course Condition Updates',
                          style: FlutterFlowTheme.of(context)
                              .labelLarge
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .fontStyle,
                                ),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .fontStyle,
                                lineHeight: 1.4,
                              ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(16.0),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Color(0xFFC8E6C9),
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 8.0,
                                    height: 8.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).success,
                                      borderRadius:
                                          BorderRadius.circular(9999.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'St Andrews (Old): Greens running at 10.5 today. Perfectly firm and fast.',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF1B5E20),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                            lineHeight: 1.6,
                                          ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: Color(0xFF1B5E20),
                                    size: 24.0,
                                  ),
                                ].divide(SizedBox(width: 16.0)),
                              ),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(height: 8.0)),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        wrapWithModel(
                          model: _model.sectionHeaderModel1,
                          updateCallback: () => safeSetState(() {}),
                          child: SectionHeaderWidget(
                            title: 'Top Rated Courses',
                          ),
                        ),
                        wrapWithModel(
                          model: _model.courseListItemModel1,
                          updateCallback: () => safeSetState(() {}),
                          child: CourseListItemWidget(
                            fees: '£52.50',
                            imgDesc:
                                'https://dimg.dreamflow.cloud/v1/image/famous%20golf%20course%20links%20scotland',
                            location: 'St Andrews, Scotland',
                            name: 'St Andrews Links',
                            rating: '4.9',
                            update: 'Greens: 10.5',
                          ),
                        ),
                        wrapWithModel(
                          model: _model.courseListItemModel2,
                          updateCallback: () => safeSetState(() {}),
                          child: CourseListItemWidget(
                            fees: '£45.00',
                            imgDesc:
                                'https://dimg.dreamflow.cloud/v1/image/links%20golf%20course%20northern%20ireland',
                            location: 'Newcastle, N. Ireland',
                            name: 'Royal County Down',
                            rating: '4.8',
                            update: 'Fairways: Firm',
                          ),
                        ),
                        wrapWithModel(
                          model: _model.courseListItemModel3,
                          updateCallback: () => safeSetState(() {}),
                          child: CourseListItemWidget(
                            fees: '£49.50',
                            imgDesc:
                                'https://dimg.dreamflow.cloud/v1/image/scottish%20links%20golf%20course',
                            location: 'Gullane, Scotland',
                            name: 'Muirfield',
                            rating: '4.8',
                            update: 'Open to Play',
                          ),
                        ),
                        Container(
                          height: 16.0,
                        ),
                        wrapWithModel(
                          model: _model.sectionHeaderModel2,
                          updateCallback: () => safeSetState(() {}),
                          child: SectionHeaderWidget(
                            title: 'Best Value for Money',
                          ),
                        ),
                        wrapWithModel(
                          model: _model.courseListItemModel4,
                          updateCallback: () => safeSetState(() {}),
                          child: CourseListItemWidget(
                            fees: '£38.00',
                            imgDesc:
                                'https://dimg.dreamflow.cloud/v1/image/modern%20links%20golf%20course',
                            location: 'Portmarnock, Ireland',
                            name: 'Royal County Dublin',
                            rating: '4.7',
                            update: 'Pace: Fast',
                          ),
                        ),
                        wrapWithModel(
                          model: _model.courseListItemModel5,
                          updateCallback: () => safeSetState(() {}),
                          child: CourseListItemWidget(
                            fees: '£29.50',
                            imgDesc:
                                'https://dimg.dreamflow.cloud/v1/image/scottish%20coast%20golf%20course',
                            location: 'Turnberry, Scotland',
                            name: 'Machrihanish',
                            rating: '4.6',
                            update: 'Greens: Excellent',
                          ),
                        ),
                      ],
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
