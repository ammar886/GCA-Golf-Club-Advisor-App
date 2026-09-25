import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/course_details_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'create_course_widget.dart' show CreateCourseWidget;
import 'package:flutter/material.dart';

class CreateCourseModel extends FlutterFlowModel<CreateCourseWidget> {
  ///  Local state fields for this page.

  FFUploadedFile? coverPhoto;

  bool photoValidation = true;

  List<CourseObjStruct> courseObjects = [];
  void addToCourseObjects(CourseObjStruct item) => courseObjects.add(item);
  void removeFromCourseObjects(CourseObjStruct item) =>
      courseObjects.remove(item);
  void removeAtIndexFromCourseObjects(int index) =>
      courseObjects.removeAt(index);
  void insertAtIndexInCourseObjects(int index, CourseObjStruct item) =>
      courseObjects.insert(index, item);
  void updateCourseObjectsAtIndex(
          int index, Function(CourseObjStruct) updateFn) =>
      courseObjects[index] = updateFn(courseObjects[index]);

  List<GolfCoursesRow> preAddedCourses = [];
  void addToPreAddedCourses(GolfCoursesRow item) => preAddedCourses.add(item);
  void removeFromPreAddedCourses(GolfCoursesRow item) =>
      preAddedCourses.remove(item);
  void removeAtIndexFromPreAddedCourses(int index) =>
      preAddedCourses.removeAt(index);
  void insertAtIndexInPreAddedCourses(int index, GolfCoursesRow item) =>
      preAddedCourses.insert(index, item);
  void updatePreAddedCoursesAtIndex(
          int index, Function(GolfCoursesRow) updateFn) =>
      preAddedCourses[index] = updateFn(preAddedCourses[index]);

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - Query Rows] action in createCourse widget.
  List<GolfCoursesRow>? courses;
  // Stores action output result for [Custom Action - uploadImage] action in Button widget.
  FFUploadedFile? uploadImg1;
  // Stores action output result for [Custom Action - uploadImage] action in Icon widget.
  FFUploadedFile? uploadImg2;
  // State field(s) for clubName widget.
  FocusNode? clubNameFocusNode;
  TextEditingController? clubNameTextController;
  String? Function(BuildContext, String?)? clubNameTextControllerValidator;
  String? _clubNameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Golf Course Name is Required';
    }

    return null;
  }

  // State field(s) for city widget.
  FocusNode? cityFocusNode;
  TextEditingController? cityTextController;
  String? Function(BuildContext, String?)? cityTextControllerValidator;
  String? _cityTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'City is Required';
    }

    return null;
  }

  // State field(s) for country widget.
  FocusNode? countryFocusNode;
  TextEditingController? countryTextController;
  String? Function(BuildContext, String?)? countryTextControllerValidator;
  String? _countryTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Country is Required';
    }

    return null;
  }

  // State field(s) for greenFee widget.
  String? greenFeeValue;
  FormFieldController<String>? greenFeeValueController;
  // State field(s) for website widget.
  FocusNode? websiteFocusNode;
  TextEditingController? websiteTextController;
  String? Function(BuildContext, String?)? websiteTextControllerValidator;
  String? _websiteTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Website is required';
    }

    return null;
  }

  // State field(s) for address widget.
  FocusNode? addressFocusNode;
  TextEditingController? addressTextController;
  String? Function(BuildContext, String?)? addressTextControllerValidator;
  String? _addressTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Address is Required';
    }

    return null;
  }

  // State field(s) for lat widget.
  FocusNode? latFocusNode;
  TextEditingController? latTextController;
  String? Function(BuildContext, String?)? latTextControllerValidator;
  // State field(s) for lng widget.
  FocusNode? lngFocusNode;
  TextEditingController? lngTextController;
  String? Function(BuildContext, String?)? lngTextControllerValidator;
  // Models for courseDetails dynamic component.
  late FlutterFlowDynamicModels<CourseDetailsModel> courseDetailsModels;
  bool isDataUploading_uploadDataG6w = false;
  FFUploadedFile uploadedLocalFile_uploadDataG6w =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataG6w = '';

  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  GolfClubsRow? clubCreated;
  bool isDataUploading_uploadData7qg = false;
  FFUploadedFile uploadedLocalFile_uploadData7qg =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadData7qg = '';

  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<GolfCoursesRow>? prevCourses;

  @override
  void initState(BuildContext context) {
    clubNameTextControllerValidator = _clubNameTextControllerValidator;
    cityTextControllerValidator = _cityTextControllerValidator;
    countryTextControllerValidator = _countryTextControllerValidator;
    websiteTextControllerValidator = _websiteTextControllerValidator;
    addressTextControllerValidator = _addressTextControllerValidator;
    courseDetailsModels = FlutterFlowDynamicModels(() => CourseDetailsModel());
  }

  @override
  void dispose() {
    clubNameFocusNode?.dispose();
    clubNameTextController?.dispose();

    cityFocusNode?.dispose();
    cityTextController?.dispose();

    countryFocusNode?.dispose();
    countryTextController?.dispose();

    websiteFocusNode?.dispose();
    websiteTextController?.dispose();

    addressFocusNode?.dispose();
    addressTextController?.dispose();

    latFocusNode?.dispose();
    latTextController?.dispose();

    lngFocusNode?.dispose();
    lngTextController?.dispose();

    courseDetailsModels.dispose();
  }
}
