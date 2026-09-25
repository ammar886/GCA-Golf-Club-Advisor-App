import '/backend/supabase/supabase.dart';
import '/components/navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'admin_profile_widget.dart' show AdminProfileWidget;
import 'package:flutter/material.dart';

class AdminProfileModel extends FlutterFlowModel<AdminProfileWidget> {
  ///  Local state fields for this page.

  String? selectedClub;

  FFUploadedFile? profilePhotoUploaded;

  bool selectedClubVal = true;

  bool homeClubVal = true;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - Query Rows] action in adminProfile widget.
  List<UsersRow>? userDetails;
  bool isDataUploading_uploadData5vn = false;
  FFUploadedFile uploadedLocalFile_uploadData5vn =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // State field(s) for FirstName widget.
  FocusNode? firstNameFocusNode;
  TextEditingController? firstNameTextController;
  String? Function(BuildContext, String?)? firstNameTextControllerValidator;
  String? _firstNameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'First Name is required';
    }

    return null;
  }

  // State field(s) for LastName widget.
  FocusNode? lastNameFocusNode;
  TextEditingController? lastNameTextController;
  String? Function(BuildContext, String?)? lastNameTextControllerValidator;
  String? _lastNameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Last Name is required';
    }

    return null;
  }

  bool isDataUploading_uploadDataWlcter = false;
  FFUploadedFile uploadedLocalFile_uploadDataWlcter =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataWlcter = '';

  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    firstNameTextControllerValidator = _firstNameTextControllerValidator;
    lastNameTextControllerValidator = _lastNameTextControllerValidator;
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    firstNameFocusNode?.dispose();
    firstNameTextController?.dispose();

    lastNameFocusNode?.dispose();
    lastNameTextController?.dispose();

    navbarModel.dispose();
  }
}
