import '/components/course_rank_card/course_rank_card_widget.dart';
import '/components/tab_item/tab_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'curated_rankings_widget.dart' show CuratedRankingsWidget;
import 'package:flutter/material.dart';

class CuratedRankingsModel extends FlutterFlowModel<CuratedRankingsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TabItem.
  late TabItemModel tabItemModel1;
  // Model for TabItem.
  late TabItemModel tabItemModel2;
  // Model for TabItem.
  late TabItemModel tabItemModel3;
  // Model for TabItem.
  late TabItemModel tabItemModel4;
  // Model for CourseRankCard.
  late CourseRankCardModel courseRankCardModel1;
  // Model for CourseRankCard.
  late CourseRankCardModel courseRankCardModel2;
  // Model for CourseRankCard.
  late CourseRankCardModel courseRankCardModel3;
  // Model for CourseRankCard.
  late CourseRankCardModel courseRankCardModel4;
  // Model for CourseRankCard.
  late CourseRankCardModel courseRankCardModel5;

  @override
  void initState(BuildContext context) {
    tabItemModel1 = createModel(context, () => TabItemModel());
    tabItemModel2 = createModel(context, () => TabItemModel());
    tabItemModel3 = createModel(context, () => TabItemModel());
    tabItemModel4 = createModel(context, () => TabItemModel());
    courseRankCardModel1 = createModel(context, () => CourseRankCardModel());
    courseRankCardModel2 = createModel(context, () => CourseRankCardModel());
    courseRankCardModel3 = createModel(context, () => CourseRankCardModel());
    courseRankCardModel4 = createModel(context, () => CourseRankCardModel());
    courseRankCardModel5 = createModel(context, () => CourseRankCardModel());
  }

  @override
  void dispose() {
    tabItemModel1.dispose();
    tabItemModel2.dispose();
    tabItemModel3.dispose();
    tabItemModel4.dispose();
    courseRankCardModel1.dispose();
    courseRankCardModel2.dispose();
    courseRankCardModel3.dispose();
    courseRankCardModel4.dispose();
    courseRankCardModel5.dispose();
  }
}
