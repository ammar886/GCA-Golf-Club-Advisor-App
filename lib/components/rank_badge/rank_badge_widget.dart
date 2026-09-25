import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rank_badge_model.dart';
export 'rank_badge_model.dart';

class RankBadgeWidget extends StatefulWidget {
  const RankBadgeWidget({
    super.key,
    String? rank,
    Color? tone,
  })  : this.rank = rank ?? 'SlotValue(\$rank)',
        this.tone = tone ?? const Color(0x00000000);

  final String rank;
  final Color tone;

  @override
  State<RankBadgeWidget> createState() => _RankBadgeWidgetState();
}

class _RankBadgeWidgetState extends State<RankBadgeWidget> {
  late RankBadgeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RankBadgeModel());

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
          Color(0x00000000),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          bottomLeft: Radius.circular(12.0),
        ),
        shape: BoxShape.rectangle,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
        child: Container(
          child: Text(
            valueOrDefault<String>(
              '#${widget.rank}',
              '#',
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).onPrimary,
                  fontSize: 12.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  lineHeight: 1.6,
                ),
          ),
        ),
      ),
    );
  }
}
