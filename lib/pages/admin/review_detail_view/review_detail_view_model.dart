import '/backend/supabase/supabase.dart';
import '/components/loader_widget.dart';
import '/components/navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'review_detail_view_widget.dart' show ReviewDetailViewWidget;
import 'package:flutter/material.dart';

class ReviewDetailViewModel extends FlutterFlowModel<ReviewDetailViewWidget> {
  ///  Local state fields for this page.

  bool isSearchOn = false;

  ClubReviewsRow? reviewDetails;

  bool isLoading = true;

  ///  State fields for stateful widgets in this page.

  // State field(s) for RatingBar widget.
  double? ratingBarValue10;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<ClubReviewsRow>? updated;
  // Model for navbar component.
  late NavbarModel navbarModel;
  // Model for loader component.
  late LoaderModel loaderModel;

  @override
  void initState(BuildContext context) {
    navbarModel = createModel(context, () => NavbarModel());
    loaderModel = createModel(context, () => LoaderModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    navbarModel.dispose();
    loaderModel.dispose();
  }
}
