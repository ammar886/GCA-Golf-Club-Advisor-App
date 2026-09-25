import '/backend/api_requests/api_calls.dart';
import '/components/navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'update_password_widget.dart' show UpdatePasswordWidget;
import 'package:flutter/material.dart';

class UpdatePasswordModel extends FlutterFlowModel<UpdatePasswordWidget> {
  ///  Local state fields for this page.

  String? selectedClub;

  FFUploadedFile? profilePhotoUploaded;

  bool selectedClubVal = true;

  bool homeClubVal = true;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for currentPass widget.
  FocusNode? currentPassFocusNode;
  TextEditingController? currentPassTextController;
  late bool currentPassVisibility;
  String? Function(BuildContext, String?)? currentPassTextControllerValidator;
  String? _currentPassTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Current Password can\'t be empty';
    }

    return null;
  }

  // State field(s) for newPass widget.
  FocusNode? newPassFocusNode;
  TextEditingController? newPassTextController;
  late bool newPassVisibility;
  String? Function(BuildContext, String?)? newPassTextControllerValidator;
  String? _newPassTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'New Password can\'t be empty';
    }

    return null;
  }

  // Stores action output result for [Backend Call - API (updatePassword)] action in Button widget.
  ApiCallResponse? apiResultdlf;
  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    currentPassVisibility = false;
    currentPassTextControllerValidator = _currentPassTextControllerValidator;
    newPassVisibility = false;
    newPassTextControllerValidator = _newPassTextControllerValidator;
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    currentPassFocusNode?.dispose();
    currentPassTextController?.dispose();

    newPassFocusNode?.dispose();
    newPassTextController?.dispose();

    navbarModel.dispose();
  }
}
