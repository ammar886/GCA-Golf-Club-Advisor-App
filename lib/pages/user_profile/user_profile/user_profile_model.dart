import '/backend/supabase/supabase.dart';
import '/components/loader_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/user_profile/golfer_card/golfer_card_widget.dart';
import '/index.dart';
import 'user_profile_widget.dart' show UserProfileWidget;
import 'package:flutter/material.dart';

class UserProfileModel extends FlutterFlowModel<UserProfileWidget> {
  ///  Local state fields for this page.

  String? selectedClub;

  FFUploadedFile? profilePhotoUploaded;

  bool selectedClubVal = true;

  bool homeClubVal = true;

  bool isLoading = true;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in UserProfile widget.
  List<UsersRow>? userDetails;
  // Model for golferCard component.
  late GolferCardModel golferCardModel;
  // Model for loader component.
  late LoaderModel loaderModel;

  @override
  void initState(BuildContext context) {
    golferCardModel = createModel(context, () => GolferCardModel());
    loaderModel = createModel(context, () => LoaderModel());
  }

  @override
  void dispose() {
    golferCardModel.dispose();
    loaderModel.dispose();
  }
}
