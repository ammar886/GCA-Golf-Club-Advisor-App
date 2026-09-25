import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'write_review_widget.dart' show WriteReviewWidget;
import 'package:flutter/material.dart';

class WriteReviewModel extends FlutterFlowModel<WriteReviewWidget> {
  ///  Local state fields for this page.

  bool? playToggle;
  GolfClubsRow? selectedClub;
  List<String> uploadedPhotoUrls = [];
  bool isUploadingPhoto = false;
  bool isSubmitting = false;

  ///  State fields for stateful widgets in this page.

  DateTime? datePicked;
  // State field(s) for RatingBar widget.
  double? ratingBarValue1 = 0.0;
  // State field(s) for RatingBar widget.
  double? ratingBarValue2 = 0.0;
  // State field(s) for RatingBar widget.
  double? ratingBarValue3 = 0.0;
  // State field(s) for RatingBar widget.
  double? ratingBarValue4 = 0.0;
  // State field(s) for RatingBar widget.
  double? ratingBarValue5 = 0.0;
  // State field(s) for RatingBar widget.
  double? ratingBarValue6 = 0.0;
  // State field(s) for RatingBar widget.
  double? ratingBarValue7 = 0.0;
  // State field(s) for RatingBar widget.
  double? ratingBarValue8 = 0.0;
  // State field(s) for RatingBar widget.
  double? ratingBarValue9 = 0.0;
  // State field(s) for RatingBar widget.
  double? ratingBarValue10 = 0.0;
  // State field(s) for RatingBar widget.
  double? ratingBarValue11 = 0.0;
  // State field(s) for RatingBar widget.
  double? ratingBarValue12 = 0.0;
  // State field(s) for RatingBar widget.
  double? ratingBarValue13 = 0.0;
  // State field(s) for RatingBar widget.
  double? ratingBarValue14 = 0.0;
  // State field(s) for RatingBar widget.
  double? ratingBarValue15 = 0.0;
  // State field(s) for RatingBar widget.
  double? ratingBarValue16 = 0.0;
  // State field(s) for RatingBar widget.
  double? ratingBarValue17 = 0.0;
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
