import '/flutter_flow/flutter_flow_util.dart';
import 'write_review_widget.dart' show WriteReviewWidget;
import 'package:flutter/material.dart';

class WriteReviewModel extends FlutterFlowModel<WriteReviewWidget> {
  ///  Local state fields for this page.

  bool? playToggle = true;

  ///  State fields for stateful widgets in this page.

  DateTime? datePicked;
  // State field(s) for RatingBar widget.
  double? ratingBarValue1;
  // State field(s) for RatingBar widget.
  double? ratingBarValue2;
  // State field(s) for RatingBar widget.
  double? ratingBarValue3;
  // State field(s) for RatingBar widget.
  double? ratingBarValue4;
  // State field(s) for RatingBar widget.
  double? ratingBarValue5;
  // State field(s) for RatingBar widget.
  double? ratingBarValue6;
  // State field(s) for RatingBar widget.
  double? ratingBarValue7;
  // State field(s) for RatingBar widget.
  double? ratingBarValue8;
  // State field(s) for RatingBar widget.
  double? ratingBarValue9;
  // State field(s) for RatingBar widget.
  double? ratingBarValue10;
  // State field(s) for RatingBar widget.
  double? ratingBarValue11;
  // State field(s) for RatingBar widget.
  double? ratingBarValue12;
  // State field(s) for RatingBar widget.
  double? ratingBarValue13;
  // State field(s) for RatingBar widget.
  double? ratingBarValue14;
  // State field(s) for RatingBar widget.
  double? ratingBarValue15;
  // State field(s) for RatingBar widget.
  double? ratingBarValue16;
  // State field(s) for RatingBar widget.
  double? ratingBarValue17;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
