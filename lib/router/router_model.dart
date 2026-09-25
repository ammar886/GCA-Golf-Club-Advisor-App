import '/backend/supabase/supabase.dart';
import '/components/loader_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'router_widget.dart' show RouterWidget;
import 'package:flutter/material.dart';

class RouterModel extends FlutterFlowModel<RouterWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in router widget.
  List<UsersRow>? currentUser;
  // Model for loader component.
  late LoaderModel loaderModel;

  @override
  void initState(BuildContext context) {
    loaderModel = createModel(context, () => LoaderModel());
  }

  @override
  void dispose() {
    loaderModel.dispose();
  }
}
