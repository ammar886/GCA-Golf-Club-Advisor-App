import '/components/button/button_widget.dart';
import '/components/condition_stat/condition_stat_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'condition_card_widget.dart' show ConditionCardWidget;
import 'package:flutter/material.dart';

class ConditionCardModel extends FlutterFlowModel<ConditionCardWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for ConditionStat.
  late ConditionStatModel conditionStatModel1;
  // Model for ConditionStat.
  late ConditionStatModel conditionStatModel2;
  // Model for ConditionStat.
  late ConditionStatModel conditionStatModel3;
  // Model for ConditionStat.
  late ConditionStatModel conditionStatModel4;
  // Model for Button.
  late ButtonModel buttonModel;

  @override
  void initState(BuildContext context) {
    conditionStatModel1 = createModel(context, () => ConditionStatModel());
    conditionStatModel2 = createModel(context, () => ConditionStatModel());
    conditionStatModel3 = createModel(context, () => ConditionStatModel());
    conditionStatModel4 = createModel(context, () => ConditionStatModel());
    buttonModel = createModel(context, () => ButtonModel());
  }

  @override
  void dispose() {
    conditionStatModel1.dispose();
    conditionStatModel2.dispose();
    conditionStatModel3.dispose();
    conditionStatModel4.dispose();
    buttonModel.dispose();
  }
}
