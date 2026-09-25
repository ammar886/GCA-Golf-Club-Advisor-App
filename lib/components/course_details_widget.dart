import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'course_details_model.dart';
export 'course_details_model.dart';

class CourseDetailsWidget extends StatefulWidget {
  const CourseDetailsWidget({
    super.key,
    this.storeCourseDetails,
    this.index,
    this.op,
    this.preExistingCourse,
    this.deleteCourse,
  });

  final Future Function(CourseObjStruct obj)? storeCourseDetails;
  final int? index;
  final CrudOp? op;
  final CourseObjStruct? preExistingCourse;
  final Future Function()? deleteCourse;

  @override
  State<CourseDetailsWidget> createState() => _CourseDetailsWidgetState();
}

class _CourseDetailsWidgetState extends State<CourseDetailsWidget> {
  late CourseDetailsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CourseDetailsModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.op != CrudOp.create) {
        if (widget.preExistingCourse?.lengthM != null) {
          safeSetState(() {
            _model.lengthMTextController?.text =
                widget.preExistingCourse!.lengthM.toString();
          });
        }
        if (widget.preExistingCourse?.lengthF != null) {
          safeSetState(() {
            _model.lengthFTextController?.text =
                widget.preExistingCourse!.lengthF.toString();
          });
        }
        if (widget.preExistingCourse?.holes != null) {
          safeSetState(() {
            _model.holesValueController?.value =
                widget.preExistingCourse!.holes;
            _model.holesValue = widget.preExistingCourse!.holes;
          });
        }
        if (widget.preExistingCourse?.parM != null) {
          safeSetState(() {
            _model.parValueController1?.value = widget.preExistingCourse!.parM;
            _model.parValue1 = widget.preExistingCourse!.parM;
          });
        }
        if (widget.preExistingCourse?.parF != null) {
          safeSetState(() {
            _model.parValueController2?.value = widget.preExistingCourse!.parF;
            _model.parValue2 = widget.preExistingCourse!.parF;
          });
        }
        if (widget.preExistingCourse?.courseType != null) {
          safeSetState(() {
            _model.courseTypeValueController?.value =
                widget.preExistingCourse!.courseType!.name;
            _model.courseTypeValue =
                widget.preExistingCourse!.courseType!.name;
          });
        }
        _model.updateCourseObjectStruct(
          (e) => e
            ..holes = widget.preExistingCourse?.holes
            ..parM = widget.preExistingCourse?.parM
            ..lengthM = widget.preExistingCourse?.lengthM
            ..lengthF = widget.preExistingCourse?.lengthF
            ..courseType = widget.preExistingCourse?.courseType
            ..parF = widget.preExistingCourse?.parF,
        );
        safeSetState(() {});
      }
    });

    _model.lengthMTextController ??= TextEditingController(
        text: widget.preExistingCourse?.lengthM.toString());
    _model.lengthMFocusNode ??= FocusNode();

    _model.lengthFTextController ??= TextEditingController(
        text: widget.preExistingCourse?.lengthF.toString());
    _model.lengthFFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional(1.0, -1.0),
      children: [
        Align(
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Course ${((widget.index!) + 1).toString()}',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      fontSize: 18.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Length *',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  Icon(
                    Icons.circle_sharp,
                    color: FlutterFlowTheme.of(context).warning,
                    size: 16.0,
                  ),
                ].divide(SizedBox(width: 8.0)),
              ),
              Container(
                width: double.infinity,
                child: TextFormField(
                  controller: _model.lengthMTextController,
                  focusNode: _model.lengthMFocusNode,
                  onChanged: (_) => EasyDebounce.debounce(
                    '_model.lengthMTextController',
                    Duration(milliseconds: 2000),
                    () async {
                      _model.updateCourseObjectStruct(
                        (e) => e
                          ..lengthM = double.tryParse(
                              _model.lengthMTextController.text),
                      );
                      safeSetState(() {});
                      await widget.storeCourseDetails?.call(
                        _model.courseObject!,
                      );
                    },
                  ),
                  autofocus: false,
                  enabled: widget.op != CrudOp.view,
                  obscureText: false,
                  decoration: InputDecoration(
                    isDense: true,
                    labelStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                    hintText: 'Add Length Gents',
                    hintStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                  keyboardType: TextInputType.number,
                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                  enableInteractiveSelection: true,
                  validator: _model.lengthMTextControllerValidator
                      .asValidator(context),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Length *',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  Icon(
                    Icons.circle_sharp,
                    color: FlutterFlowTheme.of(context).tertiary,
                    size: 16.0,
                  ),
                ].divide(SizedBox(width: 8.0)),
              ),
              Container(
                width: double.infinity,
                child: TextFormField(
                  controller: _model.lengthFTextController,
                  focusNode: _model.lengthFFocusNode,
                  onChanged: (_) => EasyDebounce.debounce(
                    '_model.lengthFTextController',
                    Duration(milliseconds: 2000),
                    () async {
                      _model.updateCourseObjectStruct(
                        (e) => e
                          ..lengthF = double.tryParse(
                              _model.lengthFTextController.text),
                      );
                      safeSetState(() {});
                      await widget.storeCourseDetails?.call(
                        _model.courseObject!,
                      );
                    },
                  ),
                  autofocus: false,
                  enabled: widget.op != CrudOp.view,
                  obscureText: false,
                  decoration: InputDecoration(
                    isDense: true,
                    labelStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                    hintText: 'Add Length Ladies',
                    hintStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                  keyboardType: TextInputType.number,
                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                  enableInteractiveSelection: true,
                  validator: _model.lengthFTextControllerValidator
                      .asValidator(context),
                ),
              ),
              Text(
                'Holes *',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              FlutterFlowDropDown<int>(
                controller: _model.holesValueController ??=
                    FormFieldController<int>(
                  _model.holesValue ??= widget.preExistingCourse?.holes,
                ),
                options: List<int>.from([9, 18, 27]),
                optionLabels: ['9', '18', '27'],
                onChanged: (val) async {
                  safeSetState(() => _model.holesValue = val);
                  _model.updateCourseObjectStruct(
                    (e) => e..holes = _model.holesValue,
                  );
                  safeSetState(() {});
                  await widget.storeCourseDetails?.call(
                    _model.courseObject!,
                  );
                },
                width: double.infinity,
                height: 40.0,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                hintText: 'Select Number of Holes',
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                elevation: 2.0,
                borderColor: Colors.transparent,
                borderWidth: 0.0,
                borderRadius: 8.0,
                margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                hidesUnderline: true,
                disabled: widget.op == CrudOp.view,
                isOverButton: false,
                isSearchable: false,
                isMultiSelect: false,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Par *',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  Icon(
                    Icons.circle_sharp,
                    color: FlutterFlowTheme.of(context).warning,
                    size: 16.0,
                  ),
                ].divide(SizedBox(width: 8.0)),
              ),
              FlutterFlowDropDown<double>(
                controller: _model.parValueController1 ??=
                    FormFieldController<double>(
                  _model.parValue1 ??= widget.preExistingCourse?.parM,
                ),
                options: List<double>.from([
                  65.0,
                  66.0,
                  67.0,
                  68.0,
                  69.0,
                  70.0,
                  71.0,
                  72.0,
                  73.0,
                  74.0,
                  75.0,
                  76.0
                ]),
                optionLabels: [
                  '65',
                  '66',
                  '67',
                  '68',
                  '69',
                  '70',
                  '71',
                  '72',
                  '73',
                  '74',
                  '75',
                  '76'
                ],
                onChanged: (val) async {
                  safeSetState(() => _model.parValue1 = val);
                  _model.updateCourseObjectStruct(
                    (e) => e..parM = _model.parValue1,
                  );
                  safeSetState(() {});
                  await widget.storeCourseDetails?.call(
                    _model.courseObject!,
                  );
                },
                width: double.infinity,
                height: 40.0,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                hintText: 'Select Par Gents',
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                elevation: 2.0,
                borderColor: Colors.transparent,
                borderWidth: 0.0,
                borderRadius: 8.0,
                margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                hidesUnderline: true,
                disabled: widget.op == CrudOp.view,
                isOverButton: false,
                isSearchable: false,
                isMultiSelect: false,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Par *',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  Icon(
                    Icons.circle_sharp,
                    color: FlutterFlowTheme.of(context).tertiary,
                    size: 16.0,
                  ),
                ].divide(SizedBox(width: 8.0)),
              ),
              FlutterFlowDropDown<double>(
                controller: _model.parValueController2 ??=
                    FormFieldController<double>(
                  _model.parValue2 ??= widget.preExistingCourse?.parF,
                ),
                options: List<double>.from([
                  65.0,
                  66.0,
                  67.0,
                  68.0,
                  69.0,
                  70.0,
                  71.0,
                  72.0,
                  73.0,
                  74.0,
                  75.0,
                  76.0
                ]),
                optionLabels: [
                  '65',
                  '66',
                  '67',
                  '68',
                  '69',
                  '70',
                  '71',
                  '72',
                  '73',
                  '74',
                  '75',
                  '76'
                ],
                onChanged: (val) async {
                  safeSetState(() => _model.parValue2 = val);
                  _model.updateCourseObjectStruct(
                    (e) => e..parF = _model.parValue2,
                  );
                  safeSetState(() {});
                  await widget.storeCourseDetails?.call(
                    _model.courseObject!,
                  );
                },
                width: double.infinity,
                height: 40.0,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                hintText: 'Select Par Ladies',
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                elevation: 2.0,
                borderColor: Colors.transparent,
                borderWidth: 0.0,
                borderRadius: 8.0,
                margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                hidesUnderline: true,
                disabled: widget.op == CrudOp.view,
                isOverButton: false,
                isSearchable: false,
                isMultiSelect: false,
              ),
              Text(
                'Course Type *',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              FlutterFlowDropDown<String>(
                controller: _model.courseTypeValueController ??=
                    FormFieldController<String>(
                  _model.courseTypeValue ??= valueOrDefault<String>(
                    widget.preExistingCourse?.courseType?.name,
                    'Lynx',
                  ),
                ),
                options: CourseType.values.map((e) => e.name).toList(),
                onChanged: (val) async {
                  safeSetState(() => _model.courseTypeValue = val);
                  _model.updateCourseObjectStruct(
                    (e) => e
                      ..courseType =
                          _model.courseTypeValue == CourseType.Links.name
                              ? CourseType.Links
                              : CourseType.Parkland,
                  );
                  safeSetState(() {});
                  await widget.storeCourseDetails?.call(
                    _model.courseObject!,
                  );
                },
                width: double.infinity,
                height: 40.0,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                hintText: 'Select Course Type',
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                elevation: 2.0,
                borderColor: Colors.transparent,
                borderWidth: 0.0,
                borderRadius: 8.0,
                margin: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                hidesUnderline: true,
                disabled: widget.op == CrudOp.view,
                isOverButton: false,
                isSearchable: false,
                isMultiSelect: false,
              ),
            ].divide(SizedBox(height: 16.0)),
          ),
        ),
        if (widget.op != CrudOp.view)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                await widget.deleteCourse?.call();
              },
              child: Icon(
                Icons.delete,
                color: FlutterFlowTheme.of(context).error,
                size: 24.0,
              ),
            ),
          ),
      ],
    );
  }
}
