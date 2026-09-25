import '/backend/supabase/supabase.dart';
import '/components/header_section_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'login_widget.dart' show LoginWidget;
import 'package:flutter/material.dart';

class LoginModel extends FlutterFlowModel<LoginWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Model for HeaderSection.
  late HeaderSectionModel headerSectionModel;
  // State field(s) for email_field widget.
  FocusNode? emailFieldFocusNode;
  TextEditingController? emailFieldTextController;
  String? Function(BuildContext, String?)? emailFieldTextControllerValidator;
  String? _emailFieldTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Email Address is required';
    }

    return null;
  }

  // State field(s) for pass_field widget.
  FocusNode? passFieldFocusNode;
  TextEditingController? passFieldTextController;
  late bool passFieldVisibility;
  String? Function(BuildContext, String?)? passFieldTextControllerValidator;
  String? _passFieldTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Password is required';
    }

    return null;
  }

  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<UsersRow>? authUser;

  @override
  void initState(BuildContext context) {
    headerSectionModel = createModel(context, () => HeaderSectionModel());
    emailFieldTextControllerValidator = _emailFieldTextControllerValidator;
    passFieldVisibility = false;
    passFieldTextControllerValidator = _passFieldTextControllerValidator;
  }

  @override
  void dispose() {
    headerSectionModel.dispose();
    emailFieldFocusNode?.dispose();
    emailFieldTextController?.dispose();

    passFieldFocusNode?.dispose();
    passFieldTextController?.dispose();
  }
}
