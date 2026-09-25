import '/components/nav_item/nav_item_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'bottom_nav_child2_model.dart';
export 'bottom_nav_child2_model.dart';

class BottomNavChild2Widget extends StatefulWidget {
  const BottomNavChild2Widget({super.key});

  @override
  State<BottomNavChild2Widget> createState() => _BottomNavChild2WidgetState();
}

class _BottomNavChild2WidgetState extends State<BottomNavChild2Widget> {
  late BottomNavChild2Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BottomNavChild2Model());

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
            label: 'Reviews',
            icon: Icon(
              Icons.rate_review_rounded,
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
              Icons.person_outline_rounded,
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
