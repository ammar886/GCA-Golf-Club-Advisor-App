import '/components/header_section_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'create_profile_widget.dart' show CreateProfileWidget;
import 'package:flutter/material.dart';

class CreateProfileModel extends FlutterFlowModel<CreateProfileWidget> {
  ///  Local state fields for this page.

  FFUploadedFile? uploadedImage;

  bool imageVal = true;

  String? selectedClub;

  bool homeClubVal = true;

  bool clubBrandVal = true;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Model for HeaderSection.
  late HeaderSectionModel headerSectionModel;
  bool isDataUploading_uploadDataNxn = false;
  FFUploadedFile uploadedLocalFile_uploadDataNxn =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

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

  // State field(s) for first_name widget.
  FocusNode? firstNameFocusNode;
  TextEditingController? firstNameTextController;
  String? Function(BuildContext, String?)? firstNameTextControllerValidator;
  String? _firstNameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'First Name is Required';
    }

    return null;
  }

  // State field(s) for last_name widget.
  FocusNode? lastNameFocusNode;
  TextEditingController? lastNameTextController;
  String? Function(BuildContext, String?)? lastNameTextControllerValidator;
  String? _lastNameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Last Name is Required';
    }

    return null;
  }

  // State field(s) for golf_handicap widget.
  FocusNode? golfHandicapFocusNode;
  TextEditingController? golfHandicapTextController;
  String? Function(BuildContext, String?)? golfHandicapTextControllerValidator;
  String? _golfHandicapTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Enter your Golf Handicap is required';
    }

    return null;
  }

  // State field(s) for clubBrand widget.
  String? clubBrandValue;
  FormFieldController<String>? clubBrandValueController;
  bool isDataUploading_uploadData5bu = false;
  FFUploadedFile uploadedLocalFile_uploadData5bu =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadData5bu = '';

  @override
  void initState(BuildContext context) {
    headerSectionModel = createModel(context, () => HeaderSectionModel());
    emailFieldTextControllerValidator = _emailFieldTextControllerValidator;
    firstNameTextControllerValidator = _firstNameTextControllerValidator;
    lastNameTextControllerValidator = _lastNameTextControllerValidator;
    golfHandicapTextControllerValidator = _golfHandicapTextControllerValidator;
  }

  @override
  void dispose() {
    headerSectionModel.dispose();
    emailFieldFocusNode?.dispose();
    emailFieldTextController?.dispose();

    firstNameFocusNode?.dispose();
    firstNameTextController?.dispose();

    lastNameFocusNode?.dispose();
    lastNameTextController?.dispose();

    golfHandicapFocusNode?.dispose();
    golfHandicapTextController?.dispose();
  }
}
