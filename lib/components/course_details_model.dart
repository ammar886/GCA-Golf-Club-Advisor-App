import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'course_details_widget.dart' show CourseDetailsWidget;
import 'package:flutter/material.dart';

class CourseDetailsModel extends FlutterFlowModel<CourseDetailsWidget> {
  ///  Local state fields for this component.

  CourseObjStruct? courseObject;
  void updateCourseObjectStruct(Function(CourseObjStruct) updateFn) {
    updateFn(courseObject ??= CourseObjStruct());
  }

  ///  State fields for stateful widgets in this component.

  // State field(s) for length_m widget.
  FocusNode? lengthMFocusNode;
  TextEditingController? lengthMTextController;
  String? Function(BuildContext, String?)? lengthMTextControllerValidator;
  // State field(s) for length_f widget.
  FocusNode? lengthFFocusNode;
  TextEditingController? lengthFTextController;
  String? Function(BuildContext, String?)? lengthFTextControllerValidator;
  // State field(s) for holes widget.
  int? holesValue;
  FormFieldController<int>? holesValueController;
  // State field(s) for par widget.
  double? parValue1;
  FormFieldController<double>? parValueController1;
  // State field(s) for par widget.
  double? parValue2;
  FormFieldController<double>? parValueController2;
  // State field(s) for courseType widget.
  String? courseTypeValue;
  FormFieldController<String>? courseTypeValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    lengthMFocusNode?.dispose();
    lengthMTextController?.dispose();

    lengthFFocusNode?.dispose();
    lengthFTextController?.dispose();
  }
}
