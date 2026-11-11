import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/loader_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'router_model.dart';
export 'router_model.dart';

class RouterWidget extends StatefulWidget {
  const RouterWidget({
    super.key,
    this.fetchUserRole,
    this.isLoggedInOverride,
    this.userIdOverride,
  });

  final Future<String?> Function(String uid)? fetchUserRole;
  final bool? isLoggedInOverride;
  final String? userIdOverride;

  static String routeName = 'router';
  static String routePath = '/router';

  @override
  State<RouterWidget> createState() => _RouterWidgetState();
}

class _RouterWidgetState extends State<RouterWidget> {
  late RouterModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RouterModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _resolveRoute();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> _resolveRoute() async {
    final isUserLoggedIn = widget.isLoggedInOverride ?? loggedIn;
    final uid = widget.userIdOverride ?? currentUserUid;

    if (!isUserLoggedIn || uid.isEmpty) {
      if (!mounted) return;
      if (FFAppState().isGuest) {
        context.goNamed(HomeWidget.routeName);
      } else {
        context.goNamed(SplashWidget.routeName);
      }
      return;
    }

    String? role;
    try {
      if (widget.fetchUserRole != null) {
        role = await widget.fetchUserRole!(uid)
            .timeout(const Duration(seconds: 10));
      } else {
        _model.currentUser = await UsersTable()
            .queryRows(
              queryFn: (q) => q.eqOrNull(
                'id',
                uid,
              ),
            )
            .timeout(const Duration(seconds: 10));
        role = _model.currentUser?.firstOrNull?.role;
      }
    } catch (e) {
      debugPrint('Error resolving route in RouterWidget: $e');
    }

    if (!mounted) return;

    final stillLoggedIn = widget.isLoggedInOverride ?? loggedIn;
    final currentUid = widget.userIdOverride ?? currentUserUid;
    if (!stillLoggedIn || currentUid.isEmpty) {
      if (FFAppState().isGuest) {
        context.goNamed(HomeWidget.routeName);
      } else {
        context.goNamed(SplashWidget.routeName);
      }
      return;
    }

    if (role != null && role.isNotEmpty) {
      FFAppState().currentRole = role;
    }

    final effectiveRole = (role ?? FFAppState().currentRole).toLowerCase();
    if (effectiveRole == 'admin' || effectiveRole == 'subadmin') {
      context.goNamed(AdminHomeWidget.routeName);
    } else {
      context.goNamed(HomeWidget.routeName);
    }
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
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                wrapWithModel(
                  model: _model.loaderModel,
                  updateCallback: () => safeSetState(() {}),
                  child: LoaderWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
