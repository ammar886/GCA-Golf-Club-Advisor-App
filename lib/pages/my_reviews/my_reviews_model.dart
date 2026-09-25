import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'my_reviews_widget.dart' show MyReviewsWidget;
import 'package:flutter/material.dart';

class MyReviewsModel extends FlutterFlowModel<MyReviewsWidget> {
  ///  State fields for stateful widgets in this page.

  List<ClubReviewsRow>? userReviews;
  Map<int, GolfClubsRow> clubMap = {};
  bool isLoading = true;
  String currentFilter = 'All'; // 'All', 'pending', 'approved', 'rejected'
  Set<String> expandedReviewIds = {};

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
