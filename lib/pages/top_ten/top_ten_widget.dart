import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/club_card_wide/club_card_wide_widget.dart';
import '/components/loader_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'top_ten_model.dart';
export 'top_ten_model.dart';

class TopTenWidget extends StatefulWidget {
  const TopTenWidget({super.key});

  static String routeName = 'topTen';
  static String routePath = '/topTen';

  @override
  State<TopTenWidget> createState() => _TopTenWidgetState();
}

class _TopTenWidgetState extends State<TopTenWidget> {
  late TopTenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TopTenModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.currentUser = await UsersTable().queryRows(
        queryFn: (q) => q.eqOrNull(
          'id',
          currentUserUid,
        ),
      );
      if (_model.currentUser?.firstOrNull?.role == 'admin') {
        context.goNamed(AdminHomeWidget.routeName);
      } else {
        _model.isLoading = false;
        safeSetState(() {});
      }
    });

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
      child: PopScope(
        canPop: false,
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
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
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
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
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
            child: Builder(
              builder: (context) {
                if (!_model.isLoading) {
                  return Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Top Clubs',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 24.0,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/images/WhatsApp_Image_2026-09-07_at_3.03.02_AM.jpeg',
                                width: 100.0,
                                height: 70.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(),
                            child: FutureBuilder<List<GolfClubsRow>>(
                              future: GolfClubsTable().queryRows(
                                queryFn: (q) => q
                                    .eqOrNull(
                                      'isCompleted',
                                      true,
                                    )
                                    .order('name', ascending: true)
                                    .order('overall_rating'),
                                limit: 10,
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
                                List<GolfClubsRow> listViewGolfClubsRowList =
                                    snapshot.data!;

                                return ListView.separated(
                                  padding: EdgeInsets.fromLTRB(
                                    0,
                                    0,
                                    0,
                                    16.0,
                                  ),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: listViewGolfClubsRowList.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 16.0),
                                  itemBuilder: (context, listViewIndex) {
                                    final listViewGolfClubsRow =
                                        listViewGolfClubsRowList[listViewIndex];
                                    return wrapWithModel(
                                      model: _model.clubCardWideModels.getModel(
                                        listViewGolfClubsRow.id.toString(),
                                        listViewIndex,
                                      ),
                                      updateCallback: () => safeSetState(() {}),
                                      child: ClubCardWideWidget(
                                        key: Key(
                                          'Keydja_${listViewGolfClubsRow.id.toString()}',
                                        ),
                                        img: listViewGolfClubsRow.imageUrl,
                                        loc: listViewGolfClubsRow.address,
                                        name: listViewGolfClubsRow.name,
                                        price: listViewGolfClubsRow.greenFee,
                                        rating: '4.9',
                                        clubDetails: listViewGolfClubsRow,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ].divide(SizedBox(height: 16.0)),
                    ),
                  );
                } else {
                  return Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: wrapWithModel(
                      model: _model.loaderModel,
                      updateCallback: () => safeSetState(() {}),
                      child: LoaderWidget(),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
