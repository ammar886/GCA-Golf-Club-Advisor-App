import '/components/navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/admin/components/sub_admin_card/sub_admin_card_widget.dart';
import 'sub_admin_management_widget.dart' show SubAdminManagementWidget;
import 'package:flutter/material.dart';

class SubAdminManagementModel
    extends FlutterFlowModel<SubAdminManagementWidget> {
  ///  Local state fields for this page.

  bool isSearchOn = false;

  ///  State fields for stateful widgets in this page.

  // Models for subAdminCard dynamic component.
  late FlutterFlowDynamicModels<SubAdminCardModel> subAdminCardModels;
  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    subAdminCardModels = FlutterFlowDynamicModels(() => SubAdminCardModel());
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    subAdminCardModels.dispose();
    navbarModel.dispose();
  }
}
