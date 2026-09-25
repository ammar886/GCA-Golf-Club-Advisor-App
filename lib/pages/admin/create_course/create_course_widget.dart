import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/course_details_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'create_course_model.dart';
export 'create_course_model.dart';

class CreateCourseWidget extends StatefulWidget {
  const CreateCourseWidget({
    super.key,
    this.crudOp,
    this.clubDetails,
  });

  final CrudOp? crudOp;
  final GolfClubsRow? clubDetails;

  static String routeName = 'createCourse';
  static String routePath = '/createCourse';

  @override
  State<CreateCourseWidget> createState() => _CreateCourseWidgetState();
}

class _CreateCourseWidgetState extends State<CreateCourseWidget> {
  late CreateCourseModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateCourseModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.crudOp == CrudOp.create) {
        _model.addToCourseObjects(CourseObjStruct());
        safeSetState(() {});
      } else {
        if (widget.clubDetails?.name != null &&
            widget.clubDetails?.name != '') {
          safeSetState(() {
            _model.clubNameTextController?.text = widget.clubDetails!.name!;
          });
        }
        if (widget.clubDetails?.city != null &&
            widget.clubDetails?.city != '') {
          safeSetState(() {
            _model.cityTextController?.text = widget.clubDetails!.city!;
          });
        }
        if (widget.clubDetails?.country != null &&
            widget.clubDetails?.country != '') {
          safeSetState(() {
            _model.countryTextController?.text = widget.clubDetails!.country!;
          });
        }
        if (widget.clubDetails?.greenFee != null &&
            widget.clubDetails?.greenFee != '') {
          safeSetState(() {
            _model.greenFeeValueController?.value =
                widget.clubDetails!.greenFee!;
            _model.greenFeeValue = widget.clubDetails!.greenFee!;
          });
        }
        if (widget.clubDetails?.address != null &&
            widget.clubDetails?.address != '') {
          safeSetState(() {
            _model.addressTextController?.text = widget.clubDetails!.address!;
          });
        }
        if (widget.clubDetails?.website != null &&
            widget.clubDetails?.website != '') {
          safeSetState(() {
            _model.websiteTextController?.text = widget.clubDetails!.website!;
          });
        }
        if (widget.clubDetails?.latitude != null) {
          safeSetState(() {
            _model.latTextController?.text = valueOrDefault<String>(
              widget.clubDetails?.latitude?.toString(),
              '0.0',
            );
          });
        }
        if (widget.clubDetails?.longitude != null) {
          safeSetState(() {
            _model.lngTextController?.text = valueOrDefault<String>(
              widget.clubDetails?.longitude?.toString(),
              '0.0',
            );
          });
        }
        _model.courses = await GolfCoursesTable().queryRows(
          queryFn: (q) => q
              .eqOrNull(
                'club_id',
                widget.clubDetails?.id,
              )
              .order('id', ascending: true),
        );
        _model.preAddedCourses =
            _model.courses!.toList().cast<GolfCoursesRow>();
        safeSetState(() {});
        if (_model.courses!.length > 0) {
          for (int loop1Index = 0;
              loop1Index < _model.courses!.map((e) => e).toList().length;
              loop1Index++) {
            final currentLoop1Item =
                _model.courses!.map((e) => e).toList()[loop1Index];
            _model.addToCourseObjects(CourseObjStruct(
              holes: currentLoop1Item.holes,
              parM: currentLoop1Item.parM,
              lengthM: currentLoop1Item.lengthM,
              lengthF: currentLoop1Item.lenthF,
              courseType: currentLoop1Item.courseType == CourseType.Links.name
                  ? CourseType.Links
                  : CourseType.Parkland,
              parF: currentLoop1Item.parF,
            ));
            safeSetState(() {});
          }
        } else {
          _model.addToCourseObjects(CourseObjStruct());
          safeSetState(() {});
        }

        if (widget.clubDetails?.imageUrl != null &&
            widget.clubDetails?.imageUrl != '') {
          _model.photoValidation = true;
          safeSetState(() {});
        } else {
          _model.photoValidation = false;
          safeSetState(() {});
        }
      }
    });

    _model.clubNameTextController ??=
        TextEditingController(text: widget.clubDetails?.name);
    _model.clubNameFocusNode ??= FocusNode();

    _model.cityTextController ??=
        TextEditingController(text: widget.clubDetails?.city);
    _model.cityFocusNode ??= FocusNode();

    _model.countryTextController ??=
        TextEditingController(text: widget.clubDetails?.country);
    _model.countryFocusNode ??= FocusNode();

    _model.websiteTextController ??=
        TextEditingController(text: widget.clubDetails?.website);
    _model.websiteFocusNode ??= FocusNode();

    _model.addressTextController ??=
        TextEditingController(text: widget.clubDetails?.address);
    _model.addressFocusNode ??= FocusNode();

    _model.latTextController ??=
        TextEditingController(text: widget.clubDetails?.latitude?.toString());
    _model.latFocusNode ??= FocusNode();

    _model.lngTextController ??=
        TextEditingController(text: widget.clubDetails?.longitude?.toString());
    _model.lngFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.goNamed(AdminHomeWidget.routeName);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                ),
                Container(
                  width: 50.0,
                  height: 50.0,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/copilot_image_1786136711562.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Golf Club',
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              font: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 22.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontStyle,
                            ),
                      ),
                    ].divide(SizedBox(height: 6.0)),
                  ),
                ),
              ].divide(SizedBox(width: 8.0)),
            ),
            actions: [],
            centerTitle: true,
            elevation: 2.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Form(
            key: _model.formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cover Photo *',
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
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                    Builder(
                      builder: (context) {
                        if (widget.crudOp == CrudOp.create) {
                          return Builder(
                            builder: (context) {
                              if (_model.coverPhoto == null ||
                                  (_model.coverPhoto?.bytes?.isEmpty ?? true)) {
                                return Container(
                                  width: double.infinity,
                                  height: 200.0,
                                  decoration: BoxDecoration(),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      _model.uploadImg1 =
                                          await actions.uploadImage();
                                      _model.coverPhoto = _model.uploadImg1;
                                      _model.photoValidation = true;
                                      safeSetState(() {});

                                      safeSetState(() {});
                                    },
                                    text: 'Upload Photo',
                                    icon: Icon(
                                      Icons.upload,
                                      size: 24.0,
                                    ),
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                );
                              } else {
                                return Stack(
                                  alignment: AlignmentDirectional(1.0, -1.0),
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.memory(
                                        _model.coverPhoto?.bytes ??
                                            Uint8List.fromList([]),
                                        width: double.infinity,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    if (widget.crudOp != CrudOp.view)
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 12.0, 0.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            _model.coverPhoto = null;
                                            safeSetState(() {});
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            size: 24.0,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              }
                            },
                          );
                        } else {
                          return Builder(
                            builder: (context) {
                              if (_model.coverPhoto != null &&
                                  (_model.coverPhoto?.bytes?.isNotEmpty ??
                                      false)) {
                                return Stack(
                                  alignment: AlignmentDirectional(1.0, -1.0),
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.memory(
                                        _model.coverPhoto?.bytes ??
                                            Uint8List.fromList([]),
                                        width: double.infinity,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    if (widget.crudOp != CrudOp.view)
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 12.0, 0.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            _model.coverPhoto = null;
                                            safeSetState(() {});
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            size: 24.0,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              } else {
                                return Stack(
                                  alignment: AlignmentDirectional(1.0, -1.0),
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        valueOrDefault<String>(
                                          widget.clubDetails?.imageUrl,
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWzls9bV_bfijQRpj6QHzM-LL5eqGA9A532fYpYQuGXw&s=10',
                                        ),
                                        width: double.infinity,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    if (widget.crudOp != CrudOp.view)
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 12.0, 0.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            _model.uploadImg2 =
                                                await actions.uploadImage();
                                            _model.coverPhoto =
                                                _model.uploadImg2;
                                            _model.photoValidation = true;
                                            safeSetState(() {});

                                            safeSetState(() {});
                                          },
                                          child: Icon(
                                            Icons.upload_sharp,
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            size: 24.0,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                    if (!_model.photoValidation)
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                        child: Text(
                          'Cover Photo is Required',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).tertiary,
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                        ),
                      ),
                    Text(
                      'Golf Club Name *',
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
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                    Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.clubNameTextController,
                        focusNode: _model.clubNameFocusNode,
                        autofocus: false,
                        enabled: true,
                        readOnly: widget.crudOp == CrudOp.view,
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
                          hintText: 'Add Golf Club Name',
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
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                        cursorColor: FlutterFlowTheme.of(context).primaryText,
                        enableInteractiveSelection: true,
                        validator: _model.clubNameTextControllerValidator
                            .asValidator(context),
                      ),
                    ),
                    Text(
                      'City *',
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
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                    Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.cityTextController,
                        focusNode: _model.cityFocusNode,
                        autofocus: false,
                        enabled: true,
                        readOnly: widget.crudOp == CrudOp.view,
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
                          hintText: 'Add City',
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
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                        cursorColor: FlutterFlowTheme.of(context).primaryText,
                        enableInteractiveSelection: true,
                        validator: _model.cityTextControllerValidator
                            .asValidator(context),
                      ),
                    ),
                    Text(
                      'Country *',
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
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                    Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.countryTextController,
                        focusNode: _model.countryFocusNode,
                        autofocus: false,
                        enabled: true,
                        readOnly: widget.crudOp == CrudOp.view,
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
                          hintText: 'Add Country',
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
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                        cursorColor: FlutterFlowTheme.of(context).primaryText,
                        enableInteractiveSelection: true,
                        validator: _model.countryTextControllerValidator
                            .asValidator(context),
                      ),
                    ),
                    Text(
                      'Green Fee *',
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
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                    FlutterFlowDropDown<String>(
                      controller: _model.greenFeeValueController ??=
                          FormFieldController<String>(
                        _model.greenFeeValue ??= widget.clubDetails?.greenFee,
                      ),
                      options: [
                        '£15-30',
                        '£20-40',
                        '£30-50',
                        '£40-65',
                        '£50-80',
                        '£70-140',
                        '£150+'
                      ],
                      onChanged: (val) =>
                          safeSetState(() => _model.greenFeeValue = val),
                      width: double.infinity,
                      height: 40.0,
                      textStyle: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                      hintText: 'Select Green Fee',
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      elevation: 2.0,
                      borderColor: Colors.transparent,
                      borderWidth: 0.0,
                      borderRadius: 8.0,
                      margin:
                          EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                      hidesUnderline: true,
                      isOverButton: false,
                      isSearchable: false,
                      isMultiSelect: false,
                    ),
                    Text(
                      'Website *',
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
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                    Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.websiteTextController,
                        focusNode: _model.websiteFocusNode,
                        autofocus: false,
                        enabled: true,
                        readOnly: widget.crudOp == CrudOp.view,
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
                          hintText: 'Add Website',
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
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                        cursorColor: FlutterFlowTheme.of(context).primaryText,
                        enableInteractiveSelection: true,
                        validator: _model.websiteTextControllerValidator
                            .asValidator(context),
                      ),
                    ),
                    Text(
                      'Address *',
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
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                    Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.addressTextController,
                        focusNode: _model.addressFocusNode,
                        autofocus: false,
                        enabled: true,
                        readOnly: widget.crudOp == CrudOp.view,
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
                          hintText: 'Add Address',
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
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                        cursorColor: FlutterFlowTheme.of(context).primaryText,
                        enableInteractiveSelection: true,
                        validator: _model.addressTextControllerValidator
                            .asValidator(context),
                      ),
                    ),
                    Text(
                      'Location Details *',
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
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                            width: 200.0,
                            child: TextFormField(
                              controller: _model.latTextController,
                              focusNode: _model.latFocusNode,
                              autofocus: false,
                              enabled: true,
                              readOnly: widget.crudOp == CrudOp.view,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
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
                                hintText: 'Lat',
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
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
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                              cursorColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              enableInteractiveSelection: true,
                              validator: _model.latTextControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 200.0,
                            child: TextFormField(
                              controller: _model.lngTextController,
                              focusNode: _model.lngFocusNode,
                              autofocus: false,
                              enabled: true,
                              readOnly: widget.crudOp == CrudOp.view,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
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
                                hintText: 'Lng',
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
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
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                              cursorColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              enableInteractiveSelection: true,
                              validator: _model.lngTextControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(width: 12.0)),
                    ),
                    Builder(
                      builder: (context) {
                        final courses = _model.courseObjects.toList();

                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: courses.length,
                          separatorBuilder: (_, __) => SizedBox(height: 16.0),
                          itemBuilder: (context, coursesIndex) {
                            final coursesItem = courses[coursesIndex];
                            return wrapWithModel(
                              model: _model.courseDetailsModels.getModel(
                                coursesIndex.toString(),
                                coursesIndex,
                              ),
                              updateCallback: () => safeSetState(() {}),
                              updateOnChange: true,
                              child: CourseDetailsWidget(
                                key: Key(
                                  'Keybrp_${coursesIndex.toString()}',
                                ),
                                index: coursesIndex,
                                op: widget.crudOp,
                                preExistingCourse: coursesItem,
                                storeCourseDetails: (obj) async {
                                  _model.updateCourseObjectsAtIndex(
                                    coursesIndex,
                                    (e) => e
                                      ..holes = obj.holes
                                      ..parM = obj.parM
                                      ..lengthM = obj.lengthM
                                      ..lengthF = obj.lengthF
                                      ..courseType = obj.courseType != null
                                          ? obj.courseType
                                          : CourseType.Links
                                      ..parF = obj.parF,
                                  );
                                  safeSetState(() {});
                                },
                                deleteCourse: () async {
                                  _model.removeAtIndexFromCourseObjects(
                                      coursesIndex);
                                  safeSetState(() {});
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                    if (widget.crudOp != CrudOp.view)
                      Align(
                        alignment: AlignmentDirectional(1.0, -1.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            _model.addToCourseObjects(CourseObjStruct());
                            safeSetState(() {});
                          },
                          text: 'Add another Course',
                          icon: Icon(
                            Icons.add,
                            size: 15.0,
                          ),
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.plusJakartaSans(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    if (widget.crudOp != CrudOp.view)
                      Builder(
                        builder: (context) {
                          if (widget.crudOp == CrudOp.create) {
                            return FFButtonWidget(
                              onPressed: () async {
                                var _shouldSetState = false;
                                if (_model.coverPhoto != null &&
                                    (_model.coverPhoto?.bytes?.isNotEmpty ??
                                        false)) {
                                  {
                                    safeSetState(() => _model
                                        .isDataUploading_uploadDataG6w = true);
                                    var selectedUploadedFiles =
                                        <FFUploadedFile>[];
                                    var selectedMedia = <SelectedFile>[];
                                    var downloadUrls = <String>[];
                                    try {
                                      selectedUploadedFiles =
                                          _model.coverPhoto!.bytes!.isNotEmpty
                                              ? [_model.coverPhoto!]
                                              : <FFUploadedFile>[];
                                      selectedMedia =
                                          selectedFilesFromUploadedFiles(
                                        selectedUploadedFiles,
                                        storageFolderPath: 'users',
                                      );
                                      downloadUrls =
                                          await uploadSupabaseStorageFiles(
                                        bucketName: 'golfClub',
                                        selectedFiles: selectedMedia,
                                      );
                                    } finally {
                                      _model.isDataUploading_uploadDataG6w =
                                          false;
                                    }
                                    if (selectedUploadedFiles.length ==
                                            selectedMedia.length &&
                                        downloadUrls.length ==
                                            selectedMedia.length) {
                                      safeSetState(() {
                                        _model.uploadedLocalFile_uploadDataG6w =
                                            selectedUploadedFiles.first;
                                        _model.uploadedFileUrl_uploadDataG6w =
                                            downloadUrls.first;
                                      });
                                    } else {
                                      safeSetState(() {});
                                      return;
                                    }
                                  }
                                } else {
                                  _model.photoValidation = false;
                                  safeSetState(() {});
                                  if (_shouldSetState) safeSetState(() {});
                                  return;
                                }

                                if (_model.formKey.currentState == null ||
                                    !_model.formKey.currentState!.validate()) {
                                  return;
                                }
                                _model.clubCreated =
                                    await GolfClubsTable().insert({
                                  'id': random_data.randomInteger(900, 9999),
                                  'created_at': supaSerialize<DateTime>(
                                      getCurrentTimestamp),
                                  'name': _model.clubNameTextController.text,
                                  'city': _model.cityTextController.text,
                                  'country': _model.countryTextController.text,
                                  'image_url':
                                      _model.uploadedFileUrl_uploadDataG6w,
                                  'green_fee': _model.greenFeeValue,
                                  'website': _model.websiteTextController.text,
                                  'address': _model.addressTextController.text,
                                  'latitude': double.tryParse(
                                      _model.latTextController.text),
                                  'longitude': double.tryParse(
                                      _model.lngTextController.text),
                                });
                                _shouldSetState = true;
                                for (int loop1Index = 0;
                                    loop1Index <
                                        _model.courseObjects
                                            .map((e) => e)
                                            .toList()
                                            .length;
                                    loop1Index++) {
                                  final currentLoop1Item = _model.courseObjects
                                      .map((e) => e)
                                      .toList()[loop1Index];
                                  await GolfCoursesTable().insert({
                                    'created_at': supaSerialize<DateTime>(
                                        getCurrentTimestamp),
                                    'club_id': _model.clubCreated?.id,
                                    'length_m': currentLoop1Item.lengthM,
                                    'lenth_f': currentLoop1Item.lengthF,
                                    'course_type':
                                        currentLoop1Item.courseType?.name,
                                    'holes': currentLoop1Item.holes,
                                    'par_m': currentLoop1Item.parM,
                                    'par_f': currentLoop1Item.parF,
                                  });
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Course Created Successfully!',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).secondary,
                                  ),
                                );

                                context.pushNamed(AdminHomeWidget.routeName);

                                if (_shouldSetState) safeSetState(() {});
                              },
                              text: 'Create Club',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: GoogleFonts.plusJakartaSans(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            );
                          } else {
                            return FFButtonWidget(
                              onPressed: () async {
                                if (_model.coverPhoto != null &&
                                    (_model.coverPhoto?.bytes?.isNotEmpty ??
                                        false)) {
                                  {
                                    safeSetState(() => _model
                                        .isDataUploading_uploadData7qg = true);
                                    var selectedUploadedFiles =
                                        <FFUploadedFile>[];
                                    var selectedMedia = <SelectedFile>[];
                                    var downloadUrls = <String>[];
                                    try {
                                      selectedUploadedFiles =
                                          _model.coverPhoto!.bytes!.isNotEmpty
                                              ? [_model.coverPhoto!]
                                              : <FFUploadedFile>[];
                                      selectedMedia =
                                          selectedFilesFromUploadedFiles(
                                        selectedUploadedFiles,
                                        storageFolderPath: 'users',
                                      );
                                      downloadUrls =
                                          await uploadSupabaseStorageFiles(
                                        bucketName: 'golfClub',
                                        selectedFiles: selectedMedia,
                                      );
                                    } finally {
                                      _model.isDataUploading_uploadData7qg =
                                          false;
                                    }
                                    if (selectedUploadedFiles.length ==
                                            selectedMedia.length &&
                                        downloadUrls.length ==
                                            selectedMedia.length) {
                                      safeSetState(() {
                                        _model.uploadedLocalFile_uploadData7qg =
                                            selectedUploadedFiles.first;
                                        _model.uploadedFileUrl_uploadData7qg =
                                            downloadUrls.first;
                                      });
                                    } else {
                                      safeSetState(() {});
                                      return;
                                    }
                                  }

                                  await GolfClubsTable().update(
                                    data: {
                                      'name':
                                          _model.clubNameTextController.text,
                                      'city': _model.cityTextController.text,
                                      'country':
                                          _model.countryTextController.text,
                                      'image_url':
                                          _model.uploadedFileUrl_uploadData7qg,
                                      'green_fee': _model.greenFeeValue,
                                      'website':
                                          _model.websiteTextController.text,
                                      'address':
                                          _model.addressTextController.text,
                                      'latitude': double.tryParse(
                                          _model.latTextController.text),
                                      'longitude': double.tryParse(
                                          _model.lngTextController.text),
                                    },
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'id',
                                      widget.clubDetails?.id,
                                    ),
                                  );
                                } else {
                                  await GolfClubsTable().update(
                                    data: {
                                      'name':
                                          _model.clubNameTextController.text,
                                      'city': _model.cityTextController.text,
                                      'country':
                                          _model.countryTextController.text,
                                      'green_fee': _model.greenFeeValue,
                                      'website':
                                          _model.websiteTextController.text,
                                      'address':
                                          _model.addressTextController.text,
                                      'latitude': double.tryParse(
                                          _model.latTextController.text),
                                      'longitude': double.tryParse(
                                          _model.lngTextController.text),
                                    },
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'id',
                                      widget.clubDetails?.id,
                                    ),
                                  );
                                }

                                _model.prevCourses =
                                    await GolfCoursesTable().queryRows(
                                  queryFn: (q) => q.eqOrNull(
                                    'club_id',
                                    widget.clubDetails?.id,
                                  ),
                                );
                                for (int loop1Index = 0;
                                    loop1Index <
                                        _model.prevCourses!
                                            .map((e) => e)
                                            .toList()
                                            .length;
                                    loop1Index++) {
                                  final currentLoop1Item = _model.prevCourses!
                                      .map((e) => e)
                                      .toList()[loop1Index];
                                  await GolfCoursesTable().delete(
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'id',
                                      currentLoop1Item.id,
                                    ),
                                  );
                                }
                                for (int loop2Index = 0;
                                    loop2Index < _model.courseObjects.length;
                                    loop2Index++) {
                                  final currentLoop2Item =
                                      _model.courseObjects[loop2Index];
                                  await GolfCoursesTable().insert({
                                    'created_at': supaSerialize<DateTime>(
                                        getCurrentTimestamp),
                                    'club_id': widget.clubDetails?.id,
                                    'length_m': currentLoop2Item.lengthM,
                                    'lenth_f': currentLoop2Item.lengthF,
                                    'holes': currentLoop2Item.holes,
                                    'course_type':
                                        currentLoop2Item.courseType?.name,
                                    'par_m': currentLoop2Item.parM,
                                    'par_f': currentLoop2Item.parF,
                                  });
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Changes Saved Successfully!',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).secondary,
                                  ),
                                );

                                safeSetState(() {});
                              },
                              text: 'Save Changes',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: GoogleFonts.plusJakartaSans(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            );
                          }
                        },
                      ),
                  ].divide(SizedBox(height: 16.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
