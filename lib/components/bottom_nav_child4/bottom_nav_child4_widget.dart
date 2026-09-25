import '/components/nav_item/nav_item_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'bottom_nav_child4_model.dart';
export 'bottom_nav_child4_model.dart';

class BottomNavChild4Widget extends StatefulWidget {
  const BottomNavChild4Widget({super.key});

  @override
  State<BottomNavChild4Widget> createState() => _BottomNavChild4WidgetState();
}

class _BottomNavChild4WidgetState extends State<BottomNavChild4Widget> {
  late BottomNavChild4Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BottomNavChild4Model());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        wrapWithModel(
          model: _model.navItemModel1,
          updateCallback: () => safeSetState(() {}),
          child: NavItemWidget(
            label: 'Home',
            icon: Icon(
              Icons.home_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            target: 'Home',
            selected: false,
          ),
        ),
        wrapWithModel(
          model: _model.navItemModel2,
          updateCallback: () => safeSetState(() {}),
          child: NavItemWidget(
            label: 'Search',
            icon: Icon(
              Icons.search_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            target: 'Search',
            selected: false,
          ),
        ),
        wrapWithModel(
          model: _model.navItemModel3,
          updateCallback: () => safeSetState(() {}),
          child: NavItemWidget(
            label: 'Map',
            icon: Icon(
              Icons.map_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            target: 'Map',
            selected: false,
          ),
        ),
        wrapWithModel(
          model: _model.navItemModel4,
          updateCallback: () => safeSetState(() {}),
          child: NavItemWidget(
            label: 'Rankings',
            icon: Icon(
              Icons.leaderboard_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            target: 'CuratedRankings',
            selected: true,
          ),
        ),
        wrapWithModel(
          model: _model.navItemModel5,
          updateCallback: () => safeSetState(() {}),
          child: NavItemWidget(
            label: 'Profile',
            icon: Icon(
              Icons.person_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            target: 'UserProfile',
            selected: false,
          ),
        ),
      ],
    );
  }
}
