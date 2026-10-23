import '/components/navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'user_detail_view_widget.dart' show UserDetailViewWidget;
import 'package:flutter/material.dart';

class UserDetailViewModel extends FlutterFlowModel<UserDetailViewWidget> {
  /// State fields for stateful widgets in this page.
  final unfocusNode = FocusNode();

  // Model for navbar component.
  late NavbarModel navbarModel;

  bool isUpdating = false;

  @override
  void initState(BuildContext context) {
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    navbarModel.dispose();
  }
}
