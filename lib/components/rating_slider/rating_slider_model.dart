import '/components/slider/slider_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'rating_slider_widget.dart' show RatingSliderWidget;
import 'package:flutter/material.dart';

class RatingSliderModel extends FlutterFlowModel<RatingSliderWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for Slider.
  late SliderModel sliderModel;

  @override
  void initState(BuildContext context) {
    sliderModel = createModel(context, () => SliderModel());
  }

  @override
  void dispose() {
    sliderModel.dispose();
  }
}
