import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'condition_chip_model.dart';
export 'condition_chip_model.dart';

class ConditionChipWidget extends StatefulWidget {
  const ConditionChipWidget({
    super.key,
    String? label,
    bool? selected,
  })  : this.label = label ?? 'Greens: 10.5',
        this.selected = selected ?? true;

  final String label;
  final bool selected;

  @override
  State<ConditionChipWidget> createState() => _ConditionChipWidgetState();
}

class _ConditionChipWidgetState extends State<ConditionChipWidget> {
  late ConditionChipModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConditionChipModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: valueOrDefault<Color>(
          valueOrDefault<bool>(
            widget.selected,
            true,
          )
              ? Color(0xFFE3F2FD)
              : FlutterFlowTheme.of(context).secondaryBackground,
          Color(0xFFE3F2FD),
        ),
        borderRadius: BorderRadius.circular(16.0),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: valueOrDefault<Color>(
            valueOrDefault<bool>(
              widget.selected,
              true,
            )
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            FlutterFlowTheme.of(context).primary,
          ),
          width: valueOrDefault<double>(
            valueOrDefault<bool>(
              widget.selected,
              true,
            )
                ? 1.0
                : 1.0,
            1.0,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 16.0),
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 18.0,
                height: 18.0,
                child: Stack(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: valueOrDefault<Color>(
                        valueOrDefault<bool>(
                          widget.selected,
                          true,
                        )
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).secondaryText,
                        FlutterFlowTheme.of(context).primary,
                      ),
                      size: 18.0,
                    ),
                    Icon(
                      Icons.radio_button_unchecked_rounded,
                      color: valueOrDefault<Color>(
                        valueOrDefault<bool>(
                          widget.selected,
                          true,
                        )
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).secondaryText,
                        FlutterFlowTheme.of(context).primary,
                      ),
                      size: 18.0,
                    ),
                  ],
                ),
              ),
              Text(
                valueOrDefault<String>(
                  widget.label,
                  'Greens: 10.5',
                ),
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodySmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodySmall.fontStyle,
                      ),
                      color: valueOrDefault<Color>(
                        valueOrDefault<bool>(
                          widget.selected,
                          true,
                        )
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).primaryText,
                        FlutterFlowTheme.of(context).primary,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodySmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodySmall.fontStyle,
                      lineHeight: 1.6,
                    ),
              ),
            ].divide(SizedBox(width: 8.0)),
          ),
        ),
      ),
    );
  }
}
