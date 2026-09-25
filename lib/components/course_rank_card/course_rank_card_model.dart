import '/components/rank_badge/rank_badge_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'course_rank_card_widget.dart' show CourseRankCardWidget;
import 'package:flutter/material.dart';

class CourseRankCardModel extends FlutterFlowModel<CourseRankCardWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for RankBadge.
  late RankBadgeModel rankBadgeModel;

  @override
  void initState(BuildContext context) {
    rankBadgeModel = createModel(context, () => RankBadgeModel());
  }

  @override
  void dispose() {
    rankBadgeModel.dispose();
  }
}
