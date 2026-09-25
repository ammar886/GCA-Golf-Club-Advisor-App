import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/club_search_d_d_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/pages/user_profile/golfer_card/golfer_card_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'user_profile_widget.dart' show UserProfileWidget;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserProfileModel extends FlutterFlowModel<UserProfileWidget> {
  ///  Local state fields for this page.

  String? selectedClub;

  FFUploadedFile? profilePhotoUploaded;

  bool selectedClubVal = true;

  bool homeClubVal = true;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - Query Rows] action in UserProfile widget.
  List<UsersRow>? userDetails;
  // Model for golferCard component.
  late GolferCardModel golferCardModel;
  bool isDataUploading_uploadData5vnn = false;
  FFUploadedFile uploadedLocalFile_uploadData5vnn = FFUploadedFile(
    bytes: Uint8List.fromList([]),
    originalFilename: '',
  );

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

  // State field(s) for Handicap widget.
  FocusNode? handicapFocusNode;
  TextEditingController? handicapTextController;
  String? Function(BuildContext, String?)? handicapTextControllerValidator;
  String? _handicapTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Handicap is required';
    }

    return null;
  }

  // State field(s) for ClubBrandDD widget.
  String? clubBrandDDValue;
  FormFieldController<String>? clubBrandDDValueController;
  bool isDataUploading_uploadDataWlcterj = false;
  FFUploadedFile uploadedLocalFile_uploadDataWlcterj = FFUploadedFile(
    bytes: Uint8List.fromList([]),
    originalFilename: '',
  );
  String uploadedFileUrl_uploadDataWlcterj = '';

  @override
  void initState(BuildContext context) {
    golferCardModel = createModel(context, () => GolferCardModel());
    firstNameTextControllerValidator = _firstNameTextControllerValidator;
    lastNameTextControllerValidator = _lastNameTextControllerValidator;
    handicapTextControllerValidator = _handicapTextControllerValidator;
  }

  @override
  void dispose() {
    golferCardModel.dispose();
    firstNameFocusNode?.dispose();
    firstNameTextController?.dispose();

    lastNameFocusNode?.dispose();
    lastNameTextController?.dispose();

    handicapFocusNode?.dispose();
    handicapTextController?.dispose();
  }
}
