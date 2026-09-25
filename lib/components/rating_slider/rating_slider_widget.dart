import '/components/slider/slider_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rating_slider_model.dart';
export 'rating_slider_model.dart';

class RatingSliderWidget extends StatefulWidget {
  const RatingSliderWidget({
    super.key,
    String? label,
    double? value,
  })  : this.label = label ?? 'Greens',
        this.value = value ?? 9.0;

  final String label;
  final double value;

  @override
  State<RatingSliderWidget> createState() => _RatingSliderWidgetState();
}

class _RatingSliderWidgetState extends State<RatingSliderWidget> {
  late RatingSliderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RatingSliderModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              valueOrDefault<String>(
                widget.label,
                'Greens',
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    lineHeight: 1.6,
                  ),
            ),
            Text(
              valueOrDefault<String>(
                '${widget.value.toString()}/10',
                '9/10',
              ),
              style: FlutterFlowTheme.of(context).labelLarge.override(
                    font: GoogleFonts.inter(
                      fontWeight:
                          FlutterFlowTheme.of(context).labelLarge.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelLarge.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primary,
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).labelLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelLarge.fontStyle,
                    lineHeight: 1.4,
                  ),
            ),
          ],
        ),
        wrapWithModel(
          model: _model.sliderModel,
          updateCallback: () => safeSetState(() {}),
          child: SliderWidget(
            label: '',
            labelPresent: false,
            description: '',
            descriptionPresent: false,
            valueLabel: '',
            valueLabelPresent: false,
            step: 0.0,
            divisions: 10,
            valuePercentage: valueOrDefault<double>(
              widget.value,
              9.0,
            ),
            color: FlutterFlowTheme.of(context).primary,
            variant: 'Material',
            disabled: false,
            showTicks: true,
          ),
        ),
      ].divide(SizedBox(height: 4.0)),
    );
  }
}
