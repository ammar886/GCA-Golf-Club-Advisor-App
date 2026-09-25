import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'club_card_nearby_model.dart';
export 'club_card_nearby_model.dart';

class ClubCardNearbyWidget extends StatefulWidget {
  const ClubCardNearbyWidget({
    super.key,
    String? dist,
    String? img,
    String? name,
    String? rating,
  })  : this.dist = dist ?? '2.4 miles',
        this.img = img ??
            'https://dimg.dreamflow.cloud/v1/image/lush%20green%20golf%20course%20fairway%20with%20tall%20pines',
        this.name = name ?? 'Sunningdale (Old)',
        this.rating = rating ?? '4.9';

  final String dist;
  final String img;
  final String name;
  final String rating;

  @override
  State<ClubCardNearbyWidget> createState() => _ClubCardNearbyWidgetState();
}

class _ClubCardNearbyWidgetState extends State<ClubCardNearbyWidget> {
  late ClubCardNearbyModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ClubCardNearbyModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        width: 220.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          shape: BoxShape.rectangle,
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.star_rounded,
                  color: FlutterFlowTheme.of(context).warning,
                  size: 14.0,
                ),
                Text(
                  valueOrDefault<String>(
                    '${widget.rating}',
                    '4.9',
                  ),
                  style: FlutterFlowTheme.of(context).labelSmall.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontStyle:
                              FlutterFlowTheme.of(context).labelSmall.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelSmall.fontStyle,
                        lineHeight: 1.4,
                      ),
                ),
              ].divide(SizedBox(width: 4.0)),
            ),
            Container(
              height: 120.0,
              child: CachedNetworkImage(
                fadeInDuration: Duration(milliseconds: 0),
                fadeOutDuration: Duration(milliseconds: 0),
                imageUrl: valueOrDefault<String>(
                  widget.img,
                  'https://dimg.dreamflow.cloud/v1/image/lush%20green%20golf%20course%20fairway%20with%20tall%20pines',
                ),
                fit: BoxFit.cover,
                alignment: Alignment(0.0, 0.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.name,
                          maxLines: 1,
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                    lineHeight: 1.5,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${widget.dist}miles away',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                              lineHeight: 1.6,
                            ),
                      ),
                    ],
                  ),
                ].divide(SizedBox(height: 4.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
