import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'create_sub_admin_widget.dart' show CreateSubAdminWidget;
import 'package:flutter/material.dart';

class CreateSubAdminModel extends FlutterFlowModel<CreateSubAdminWidget> {
  ///  Local state fields for this component.

  String? randomPass;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for firstname widget.
  FocusNode? firstnameFocusNode;
  TextEditingController? firstnameTextController;
  String? Function(BuildContext, String?)? firstnameTextControllerValidator;
  String? _firstnameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'First Name is Required';
    }

    return null;
  }

  // State field(s) for lastname widget.
  FocusNode? lastnameFocusNode;
  TextEditingController? lastnameTextController;
  String? Function(BuildContext, String?)? lastnameTextControllerValidator;
  String? _lastnameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Last Name is Required';
    }

    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  String? _textController3Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Email Address is required';
    }

    return null;
  }

  // Stores action output result for [Backend Call - API (createSubAdmin)] action in Button widget.
  ApiCallResponse? subAdminCreateRes;
  // Stores action output result for [Backend Call - API (sendBrevoMail)] action in Button widget.
  ApiCallResponse? apiResultjqm;

  @override
  void initState(BuildContext context) {
    firstnameTextControllerValidator = _firstnameTextControllerValidator;
    lastnameTextControllerValidator = _lastnameTextControllerValidator;
    textController3Validator = _textController3Validator;
  }

  @override
  void dispose() {
    firstnameFocusNode?.dispose();
    firstnameTextController?.dispose();

    lastnameFocusNode?.dispose();
    lastnameTextController?.dispose();

    textFieldFocusNode?.dispose();
    textController3?.dispose();
  }
}
