import '/backend/supabase/supabase.dart';
import '/components/club_card_wide/club_card_wide_widget.dart';
import '/components/loader_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'top_ten_widget.dart' show TopTenWidget;
import 'package:flutter/material.dart';

class TopTenModel extends FlutterFlowModel<TopTenWidget> {
  ///  Local state fields for this page.

  bool isLoading = true;

  bool isSearchActive = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in topTen widget.
  List<UsersRow>? currentUser;
  // Models for ClubCardWide.
  late FlutterFlowDynamicModels<ClubCardWideModel> clubCardWideModels;
  // Model for loader component.
  late LoaderModel loaderModel;

  @override
  void initState(BuildContext context) {
    clubCardWideModels = FlutterFlowDynamicModels(() => ClubCardWideModel());
    loaderModel = createModel(context, () => LoaderModel());
  }

  @override
  void dispose() {
    clubCardWideModels.dispose();
    loaderModel.dispose();
  }
}
