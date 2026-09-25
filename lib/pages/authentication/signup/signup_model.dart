import '/components/header_section_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'signup_widget.dart' show SignupWidget;
import 'package:flutter/material.dart';

class SignupModel extends FlutterFlowModel<SignupWidget> {
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

  // State field(s) for confirm_pass_field widget.
  FocusNode? confirmPassFieldFocusNode;
  TextEditingController? confirmPassFieldTextController;
  late bool confirmPassFieldVisibility;
  String? Function(BuildContext, String?)?
      confirmPassFieldTextControllerValidator;
  String? _confirmPassFieldTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Confirm Password is required';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    headerSectionModel = createModel(context, () => HeaderSectionModel());
    emailFieldTextControllerValidator = _emailFieldTextControllerValidator;
    passFieldVisibility = false;
    passFieldTextControllerValidator = _passFieldTextControllerValidator;
    confirmPassFieldVisibility = false;
    confirmPassFieldTextControllerValidator =
        _confirmPassFieldTextControllerValidator;
  }

  @override
  void dispose() {
    headerSectionModel.dispose();
    emailFieldFocusNode?.dispose();
    emailFieldTextController?.dispose();

    passFieldFocusNode?.dispose();
    passFieldTextController?.dispose();

    confirmPassFieldFocusNode?.dispose();
    confirmPassFieldTextController?.dispose();
  }
}
