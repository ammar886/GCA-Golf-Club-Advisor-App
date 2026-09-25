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
  const RouterWidget({super.key});

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
      _model.currentUser = await UsersTable().queryRows(
        queryFn: (q) => q.eqOrNull(
          'id',
          currentUserUid,
        ),
      );
      if (_model.currentUser?.firstOrNull?.role == 'admin') {
        context.goNamed(AdminHomeWidget.routeName);
      } else {
        context.goNamed(HomeWidget.routeName);
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
