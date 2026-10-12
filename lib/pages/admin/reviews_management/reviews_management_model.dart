import '/components/navbar_widget.dart';
import '/components/review_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'reviews_management_widget.dart' show ReviewsManagementWidget;
import 'package:flutter/material.dart';

class ReviewsManagementModel extends FlutterFlowModel<ReviewsManagementWidget> {
  ///  Local state fields for this page.

  bool isSearchOn = false;

  ///  State fields for stateful widgets in this page.

  // Models for review dynamic component.
  late FlutterFlowDynamicModels<ReviewModel> reviewModels;
  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    reviewModels = FlutterFlowDynamicModels(() => ReviewModel());
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    reviewModels.dispose();
    navbarModel.dispose();
  }
}
