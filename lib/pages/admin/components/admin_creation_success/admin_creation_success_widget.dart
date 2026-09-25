import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_creation_success_model.dart';
export 'admin_creation_success_model.dart';

class AdminCreationSuccessWidget extends StatefulWidget {
  const AdminCreationSuccessWidget({super.key});

  @override
  State<AdminCreationSuccessWidget> createState() =>
      _AdminCreationSuccessWidgetState();
}

class _AdminCreationSuccessWidgetState
    extends State<AdminCreationSuccessWidget> {
  late AdminCreationSuccessModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminCreationSuccessModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        height: 500.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [FlutterFlowTheme.of(context).primary, Color(0x2E00509D)],
            stops: [0.0, 1.0],
            begin: AlignmentDirectional(0.74, 1.0),
            end: AlignmentDirectional(-0.74, -1.0),
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12.0, 16.0, 12.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: FlutterFlowTheme.of(context).secondaryBackground,
                size: 56.0,
              ),
              Align(
                alignment: AlignmentDirectional(0.0, -1.0),
                child: Text(
                  'Subadmin Added \nSuccessfully!',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        fontSize: 24.0,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ),
              FFButtonWidget(
                onPressed: () async {
                  Navigator.pop(context);
                },
                text: 'Continue',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 56.0,
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.plusJakartaSans(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: Colors.white,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                  elevation: 0.0,
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ].divide(SizedBox(height: 26.0)),
          ),
        ),
      ),
    );
  }
}
