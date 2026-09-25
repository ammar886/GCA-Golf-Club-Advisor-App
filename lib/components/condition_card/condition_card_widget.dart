import '/components/button/button_widget.dart';
import '/components/condition_stat/condition_stat_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'condition_card_model.dart';
export 'condition_card_model.dart';

class ConditionCardWidget extends StatefulWidget {
  const ConditionCardWidget({
    super.key,
    String? cartPath,
    String? clubName,
    String? comment,
    String? comments,
    String? greensSpeed,
    String? likes,
    String? location,
    String? rainImpact,
    String? timeAgo,
    String? turfHealth,
  })  : this.cartPath = cartPath ?? '18 Holes',
        this.clubName = clubName ?? 'Royal County Down',
        this.comment = comment ??
            'Greens are running beautifully today. Super fast at 10.5 but well maintained. Weather is holding up.',
        this.comments = comments ?? '3',
        this.greensSpeed = greensSpeed ?? '10.5',
        this.likes = likes ?? '24',
        this.location = location ?? 'Newcastle, NI',
        this.rainImpact = rainImpact ?? 'Minimal',
        this.timeAgo = timeAgo ?? '12m ago',
        this.turfHealth = turfHealth ?? 'Excellent';

  final String cartPath;
  final String clubName;
  final String comment;
  final String comments;
  final String greensSpeed;
  final String likes;
  final String location;
  final String rainImpact;
  final String timeAgo;
  final String turfHealth;

  @override
  State<ConditionCardWidget> createState() => _ConditionCardWidgetState();
}

class _ConditionCardWidgetState extends State<ConditionCardWidget> {
  late ConditionCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConditionCardModel());

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
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(16.0),
            shape: BoxShape.rectangle,
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Container(
                          width: 48.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            shape: BoxShape.rectangle,
                          ),
                          child: CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 0),
                            fadeOutDuration: Duration(milliseconds: 0),
                            imageUrl:
                                'https://dimg.dreamflow.cloud/v1/image/golf%20course%20green%20close%20up',
                            fit: BoxFit.cover,
                            alignment: Alignment(0.0, 0.0),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              valueOrDefault<String>(
                                widget.clubName,
                                'Royal County Down',
                              ),
                              maxLines: 1,
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                    lineHeight: 1.5,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 14.0,
                                ),
                                Text(
                                  valueOrDefault<String>(
                                    widget.location,
                                    'Newcastle, NI',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                        lineHeight: 1.4,
                                      ),
                                ),
                              ].divide(SizedBox(width: 4.0)),
                            ),
                          ].divide(SizedBox(height: 4.0)),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12.0),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 4.0, 8.0, 4.0),
                          child: Container(
                            child: Text(
                              valueOrDefault<String>(
                                widget.timeAgo,
                                '12m ago',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF2E7D32),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontStyle,
                                    lineHeight: 1.4,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 16.0)),
                  ),
                  Divider(
                    height: 16.0,
                    thickness: 1.0,
                    indent: 0.0,
                    endIndent: 0.0,
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                  GridView(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 0.0,
                      childAspectRatio: 3.0,
                    ),
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      wrapWithModel(
                        model: _model.conditionStatModel1,
                        updateCallback: () => safeSetState(() {}),
                        child: ConditionStatWidget(
                          icon: Icon(
                            Icons.speed_rounded,
                            color: Color(0xFF2E7D32),
                            size: 18.0,
                          ),
                          label: 'Green Speed',
                          value: valueOrDefault<String>(
                            widget.greensSpeed,
                            '10.5',
                          ),
                        ),
                      ),
                      wrapWithModel(
                        model: _model.conditionStatModel2,
                        updateCallback: () => safeSetState(() {}),
                        child: ConditionStatWidget(
                          icon: Icon(
                            Icons.water_drop_rounded,
                            color: Color(0xFF2E7D32),
                            size: 18.0,
                          ),
                          label: 'Rain Impact',
                          value: valueOrDefault<String>(
                            widget.rainImpact,
                            'Minimal',
                          ),
                        ),
                      ),
                      wrapWithModel(
                        model: _model.conditionStatModel3,
                        updateCallback: () => safeSetState(() {}),
                        child: ConditionStatWidget(
                          icon: Icon(
                            Icons.directions_car_rounded,
                            color: Color(0xFF2E7D32),
                            size: 18.0,
                          ),
                          label: 'Cart Path',
                          value: valueOrDefault<String>(
                            widget.cartPath,
                            '18 Holes',
                          ),
                        ),
                      ),
                      wrapWithModel(
                        model: _model.conditionStatModel4,
                        updateCallback: () => safeSetState(() {}),
                        child: ConditionStatWidget(
                          icon: Icon(
                            Icons.eco_rounded,
                            color: Color(0xFF2E7D32),
                            size: 18.0,
                          ),
                          label: 'Turf Health',
                          value: valueOrDefault<String>(
                            widget.turfHealth,
                            'Excellent',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 18.0,
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                valueOrDefault<String>(
                                  widget.comment,
                                  'Greens are running beautifully today. Super fast at 10.5 but well maintained. Weather is holding up.',
                                ),
                                maxLines: 3,
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
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                      lineHeight: 1.6,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ].divide(SizedBox(width: 8.0)),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.thumb_up_off_alt_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 18.0,
                              ),
                              Text(
                                valueOrDefault<String>(
                                  widget.likes,
                                  '24',
                                ),
                                style: FlutterFlowTheme.of(context)
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
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                      lineHeight: 1.4,
                                    ),
                              ),
                            ].divide(SizedBox(width: 4.0)),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.reply_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 18.0,
                              ),
                              Text(
                                valueOrDefault<String>(
                                  widget.comments,
                                  '3',
                                ),
                                style: FlutterFlowTheme.of(context)
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
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                      lineHeight: 1.4,
                                    ),
                              ),
                            ].divide(SizedBox(width: 4.0)),
                          ),
                        ].divide(SizedBox(width: 16.0)),
                      ),
                      wrapWithModel(
                        model: _model.buttonModel,
                        updateCallback: () => safeSetState(() {}),
                        child: ButtonWidget(
                          icon: Icon(
                            Icons.check_circle_outline_rounded,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                          iconPresent: true,
                          iconEndPresent: false,
                          content: 'Confirm',
                          variant: 'ghost',
                          size: 'small',
                          fullWidth: false,
                          loading: false,
                          disabled: false,
                        ),
                      ),
                    ],
                  ),
                ].divide(SizedBox(height: 16.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
