import '/components/navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'user_management_widget.dart' show UserManagementWidget;
import 'package:flutter/material.dart';

class UserManagementModel extends FlutterFlowModel<UserManagementWidget> {
  /// State fields for stateful widgets in this page.
  final unfocusNode = FocusNode();

  // Search text field
  FocusNode? searchFocusNode;
  TextEditingController? searchController;

  // Selected filters
  String selectedRoleFilter = 'All'; // 'All', 'admin', 'subAdmin', 'user'
  String selectedStatusFilter = 'All'; // 'All', 'active', 'blocked'

  // Model for navbar component
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    searchFocusNode?.dispose();
    searchController?.dispose();
    navbarModel.dispose();
  }
}
