import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/loader_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/user_profile/golfer_card/golfer_card_widget.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'user_profile_model.dart';
export 'user_profile_model.dart';

class UserProfileWidget extends StatefulWidget {
  const UserProfileWidget({
    super.key,
    bool? isAdmin,
  }) : this.isAdmin = isAdmin ?? false;

  final bool isAdmin;

  static String routeName = 'UserProfile';
  static String routePath = '/userProfile';

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  late UserProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserProfileModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (FFAppState().isGuest) {
        _model.isLoading = false;
        safeSetState(() {});
        return;
      }
      _model.userDetails = await UsersTable().queryRows(
        queryFn: (q) => q.eqOrNull(
          'id',
          currentUserUid,
        ),
      );
      _model.isLoading = false;
      safeSetState(() {});
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
                  child: RichText(
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
                                color: FlutterFlowTheme.of(context).secondary,
                                fontSize: 22.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w800,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .fontStyle,
                              ),
                        ),
                        TextSpan(
                          text: 'C',
                          style: TextStyle(
                            color: FlutterFlowTheme.of(context).tertiary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: 'a',
                          style: TextStyle(
                            color: FlutterFlowTheme.of(context).primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: ' Profile',
                          style: TextStyle(),
                        )
                      ],
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
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
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: (FFMainAxisAlignment.end).flutterValue,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 40.0,
                      fillColor: Colors.transparent,
                      icon: Icon(
                        Icons.rate_review_outlined,
                        color: FlutterFlowTheme.of(context).tertiary,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        if (FFAppState().isGuest) {
                          await showGuestAuthBottomSheet(
                            context,
                            title: 'Sign In to View Reviews',
                            message:
                                'Guest users can browse clubs and public reviews. Sign in or create an account to view and manage your submitted reviews.',
                          );
                          return;
                        }
                        context.pushNamed(MyReviewsWidget.routeName);
                      },
                    ),
                    FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 40.0,
                      fillColor: Colors.transparent,
                      icon: Icon(
                        Icons.edit,
                        color: FlutterFlowTheme.of(context).tertiary,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        if (FFAppState().isGuest) {
                          await showGuestAuthBottomSheet(
                            context,
                            title: 'Sign In to Edit Profile',
                            message:
                                'Guest users cannot edit profile. Sign in or create an account to manage your golfer profile.',
                            icon: Icons.edit_rounded,
                          );
                          return;
                        }
                        context.pushNamed(
                          EditProfileWidget.routeName,
                          queryParameters: {
                            'userDetails': serializeParam(
                              _model.userDetails?.firstOrNull,
                              ParamType.SupabaseRow,
                            ),
                          }.withoutNulls,
                        );
                      },
                    ),
                    FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 40.0,
                      fillColor: Colors.transparent,
                      icon: Icon(
                        Icons.logout_rounded,
                        color: FlutterFlowTheme.of(context).tertiary,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        if (FFAppState().isGuest) {
                          FFAppState().clearGuestMode();
                          context.goNamedAuth(
                              SplashWidget.routeName, context.mounted);
                          return;
                        }
                        GoRouter.of(context).prepareAuthEvent();
                        await authManager.signOut();
                        GoRouter.of(context).clearRedirectLocation();

                        context.goNamedAuth(
                            SplashWidget.routeName, context.mounted);
                      },
                    ),
                  ].divide(SizedBox(width: 12.0)),
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
                return Stack(
                  alignment: AlignmentDirectional(-1.0, -1.0),
                  children: [
                    SingleChildScrollView(
                      primary: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (FFAppState().isGuest)
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(24.0),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 80.0,
                                            height: 80.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary
                                                      .withOpacity(0.12),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.person_outline_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 44.0,
                                            ),
                                          ),
                                          SizedBox(height: 16.0),
                                          Text(
                                            'Guest Golfer',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          ),
                                          SizedBox(height: 6.0),
                                          Text(
                                            'Guest Mode Active',
                                            style: GoogleFonts.inter(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                          ),
                                          SizedBox(height: 14.0),
                                          Text(
                                            'You are currently exploring Golf Club Advisor as a guest. Sign in or create an account to view your personalized golfer profile, save your preferences, and submit reviews.',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontSize: 13.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              height: 1.5,
                                            ),
                                          ),
                                          SizedBox(height: 24.0),
                                          FFButtonWidget(
                                            onPressed: () async {
                                              context.pushNamed(
                                                  LoginWidget.routeName);
                                            },
                                            text: 'Sign In',
                                            options: FFButtonOptions(
                                              width: double.infinity,
                                              height: 44.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              textStyle:
                                                  GoogleFonts.plusJakartaSans(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          SizedBox(height: 12.0),
                                          FFButtonWidget(
                                            onPressed: () async {
                                              context.pushNamed(
                                                  SignupWidget.routeName);
                                            },
                                            text: 'Create an Account',
                                            options: FFButtonOptions(
                                              width: double.infinity,
                                              height: 44.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              textStyle:
                                                  GoogleFonts.plusJakartaSans(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0,
                                              ),
                                              borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(
                                                        context)
                                                    .primary,
                                                width: 1.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else if (!widget.isAdmin)
                                    wrapWithModel(
                                      model: _model.golferCardModel,
                                      updateCallback: () => safeSetState(() {}),
                                      child: GolferCardWidget(
                                        golferDetails:
                                            _model.userDetails?.firstOrNull,
                                      ),
                                    ),
                                ].divide(SizedBox(height: 24.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
    );
  }
}
