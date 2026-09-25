import '/components/navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'reviews_management_widget.dart' show ReviewsManagementWidget;
import 'package:flutter/material.dart';

class ReviewsManagementModel extends FlutterFlowModel<ReviewsManagementWidget> {
  ///  Local state fields for this page.

  bool isSearchOn = false;

  ///  State fields for stateful widgets in this page.

  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    navbarModel.dispose();
  }
}
