import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'feature_badge_model.dart';
export 'feature_badge_model.dart';

class FeatureBadgeWidget extends StatefulWidget {
  const FeatureBadgeWidget({
    super.key,
    this.icon,
    String? label,
    Color? tone,
  })  : this.label = label ?? 'Top 100',
        this.tone = tone ?? const Color(0x00000000);

  final Widget? icon;
  final String label;
  final Color tone;

  @override
  State<FeatureBadgeWidget> createState() => _FeatureBadgeWidgetState();
}

class _FeatureBadgeWidgetState extends State<FeatureBadgeWidget> {
  late FeatureBadgeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FeatureBadgeModel());

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
          widget.tone,
          FlutterFlowTheme.of(context).secondary,
        ),
        shape: BoxShape.rectangle,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: valueOrDefault<Color>(
                widget.tone,
                FlutterFlowTheme.of(context).secondary,
              ),
              borderRadius: BorderRadius.circular(9999.0),
              shape: BoxShape.rectangle,
            ),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: widget.icon!,
          ),
          Text(
            valueOrDefault<String>(
              widget.label,
              'Top 100',
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            style: FlutterFlowTheme.of(context).labelSmall.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelSmall.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelSmall.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelSmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                  lineHeight: 1.4,
                ),
          ),
        ].divide(SizedBox(height: 8.0)),
      ),
    );
  }
}
