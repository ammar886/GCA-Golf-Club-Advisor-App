import '/components/condition_card/condition_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'course_condition_updates_widget.dart' show CourseConditionUpdatesWidget;
import 'package:flutter/material.dart';

class CourseConditionUpdatesModel
    extends FlutterFlowModel<CourseConditionUpdatesWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for ConditionCard.
  late ConditionCardModel conditionCardModel1;
  // Model for ConditionCard.
  late ConditionCardModel conditionCardModel2;
  // Model for ConditionCard.
  late ConditionCardModel conditionCardModel3;
  // Model for ConditionCard.
  late ConditionCardModel conditionCardModel4;

  @override
  void initState(BuildContext context) {
    conditionCardModel1 = createModel(context, () => ConditionCardModel());
    conditionCardModel2 = createModel(context, () => ConditionCardModel());
    conditionCardModel3 = createModel(context, () => ConditionCardModel());
    conditionCardModel4 = createModel(context, () => ConditionCardModel());
  }

  @override
  void dispose() {
    conditionCardModel1.dispose();
    conditionCardModel2.dispose();
    conditionCardModel3.dispose();
    conditionCardModel4.dispose();
  }
}
