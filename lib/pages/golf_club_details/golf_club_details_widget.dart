import '/backend/supabase/supabase.dart';
import '/components/button/button_widget.dart';
import '/components/facility_tag/facility_tag_widget.dart';
import '/components/rating_item/rating_item_widget.dart';
import '/components/review_card/review_card_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'golf_club_details_model.dart';
export 'golf_club_details_model.dart';

class GolfClubDetailsWidget extends StatefulWidget {
  const GolfClubDetailsWidget({
    super.key,
    this.clubDetails,
  });

  final GolfClubsRow? clubDetails;

  static String routeName = 'GolfClubDetails';
  static String routePath = '/golfClubDetails';

  @override
  State<GolfClubDetailsWidget> createState() => _GolfClubDetailsWidgetState();
}

class _GolfClubDetailsWidgetState extends State<GolfClubDetailsWidget> {
  late GolfClubDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GolfClubDetailsModel());

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
        resizeToAvoidBottomInset: false,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            context.goNamed(WriteReviewWidget.routeName);
          },
          backgroundColor: FlutterFlowTheme.of(context).primary,
          icon: Icon(
            Icons.edit_rounded,
            color: FlutterFlowTheme.of(context).onPrimary,
            size: 24.0,
          ),
          elevation: 0.0,
          label: Text(
            'Write Review',
            style: FlutterFlowTheme.of(context).labelLarge.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).labelLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelLarge.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).onPrimary,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).labelLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                  lineHeight: 1.4,
                ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300.0,
              child: Stack(
                alignment: AlignmentDirectional(-1.0, -1.0),
                children: [
                  CachedNetworkImage(
                    fadeInDuration: Duration(milliseconds: 0),
                    fadeOutDuration: Duration(milliseconds: 0),
                    imageUrl: valueOrDefault<String>(
                      widget.clubDetails?.imageUrl,
                      'https://dimg.dreamflow.cloud/v1/image/scenic%20golf%20course%20green%20with%20bunkers',
                    ),
                    height: 300.0,
                    fit: BoxFit.cover,
                    alignment: Alignment(0.0, 0.0),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1.0, -1.0),
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Container(
                          child: FlutterFlowIconButton(
                            borderRadius: 9999.0,
                            buttonSize: 40.0,
                            fillColor: FlutterFlowTheme.of(context).surface80,
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              context.goNamed(HomeWidget.routeName);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(1.0, -1.0),
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FlutterFlowIconButton(
                                borderRadius: 100.0,
                                buttonSize: 40.0,
                                fillColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                icon: Icon(
                                  Icons.arrow_back,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  context.safePop();
                                },
                              ),
                              if (responsiveVisibility(
                                context: context,
                                phone: false,
                                tablet: false,
                                tabletLandscape: false,
                                desktop: false,
                              ))
                                FlutterFlowIconButton(
                                  borderRadius: 9999.0,
                                  buttonSize: 40.0,
                                  fillColor:
                                      FlutterFlowTheme.of(context).surface80,
                                  icon: Icon(
                                    Icons.share_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
                                  ),
                                  onPressed: () {
                                    print('IconButton pressed ...');
                                  },
                                ),
                              FlutterFlowIconButton(
                                borderRadius: 9999.0,
                                buttonSize: 40.0,
                                fillColor:
                                    FlutterFlowTheme.of(context).surface80,
                                icon: Icon(
                                  Icons.favorite_outline_rounded,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                onPressed: () {
                                  print('IconButton pressed ...');
                                },
                              ),
                            ].divide(SizedBox(width: 8.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 24.0),
                child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              valueOrDefault<String>(
                                widget.clubDetails?.name,
                                'Golf Club Golf Club Golf Club Golf Club Golf Club ',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontStyle,
                                    lineHeight: 1.35,
                                  ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).success,
                              borderRadius: BorderRadius.circular(12.0),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 8.0, 16.0, 8.0),
                              child: Container(
                                child: Text(
                                  '4.9',
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .onSuccess,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                        lineHeight: 1.5,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: FlutterFlowTheme.of(context).secondary,
                            size: 16.0,
                          ),
                          Text(
                            valueOrDefault<String>(
                              widget.clubDetails?.address,
                              'address',
                            ),
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
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                  lineHeight: 1.6,
                                ),
                          ),
                        ].divide(SizedBox(width: 4.0)),
                      ),
                      Divider(
                        height: 16.0,
                        thickness: 1.0,
                        indent: 0.0,
                        endIndent: 0.0,
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                      if (responsiveVisibility(
                        context: context,
                        phone: false,
                        tablet: false,
                        tabletLandscape: false,
                        desktop: false,
                      ))
                        Text(
                          'Course Ratings',
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                    lineHeight: 1.5,
                                  ),
                        ),
                      if (responsiveVisibility(
                        context: context,
                        phone: false,
                        tablet: false,
                        tabletLandscape: false,
                        desktop: false,
                      ))
                        Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(16.0),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                wrapWithModel(
                                  model: _model.ratingItemModel1,
                                  updateCallback: () => safeSetState(() {}),
                                  child: RatingItemWidget(
                                    label: 'Greens',
                                    score: 0.95,
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.ratingItemModel2,
                                  updateCallback: () => safeSetState(() {}),
                                  child: RatingItemWidget(
                                    label: 'Fairways',
                                    score: 0.92,
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.ratingItemModel3,
                                  updateCallback: () => safeSetState(() {}),
                                  child: RatingItemWidget(
                                    label: 'Bunkers',
                                    score: 0.88,
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.ratingItemModel4,
                                  updateCallback: () => safeSetState(() {}),
                                  child: RatingItemWidget(
                                    label: 'Layout',
                                    score: 0.98,
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.ratingItemModel5,
                                  updateCallback: () => safeSetState(() {}),
                                  child: RatingItemWidget(
                                    label: 'Clubhouse',
                                    score: 0.85,
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.ratingItemModel6,
                                  updateCallback: () => safeSetState(() {}),
                                  child: RatingItemWidget(
                                    label: 'Food & Drink',
                                    score: 0.82,
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.ratingItemModel7,
                                  updateCallback: () => safeSetState(() {}),
                                  child: RatingItemWidget(
                                    label: 'Practice Facilities',
                                    score: 0.9,
                                  ),
                                ),
                              ].divide(SizedBox(height: 16.0)),
                            ),
                          ),
                        ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(16.0),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Green Fees',
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .fontStyle,
                                              lineHeight: 1.4,
                                            ),
                                      ),
                                      Text(
                                        valueOrDefault<String>(
                                          widget.clubDetails?.greenFee,
                                          '25',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              font: GoogleFonts.plusJakartaSans(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                              lineHeight: 1.5,
                                            ),
                                      ),
                                    ].divide(SizedBox(height: 4.0)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(width: 16.0)),
                      ),
                      if (responsiveVisibility(
                        context: context,
                        phone: false,
                        tablet: false,
                        tabletLandscape: false,
                        desktop: false,
                      ))
                        Text(
                          'Facilities',
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                    lineHeight: 1.5,
                                  ),
                        ),
                      if (responsiveVisibility(
                        context: context,
                        phone: false,
                        tablet: false,
                        tabletLandscape: false,
                        desktop: false,
                      ))
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          direction: Axis.horizontal,
                          runAlignment: WrapAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          clipBehavior: Clip.none,
                          children: [
                            wrapWithModel(
                              model: _model.facilityTagModel1,
                              updateCallback: () => safeSetState(() {}),
                              child: FacilityTagWidget(
                                icon: Icon(
                                  Icons.shopping_bag_rounded,
                                  color: FlutterFlowTheme.of(context).secondary,
                                  size: 16.0,
                                ),
                                label: 'Pro Shop',
                              ),
                            ),
                            wrapWithModel(
                              model: _model.facilityTagModel2,
                              updateCallback: () => safeSetState(() {}),
                              child: FacilityTagWidget(
                                icon: Icon(
                                  Icons.home_rounded,
                                  color: FlutterFlowTheme.of(context).secondary,
                                  size: 16.0,
                                ),
                                label: 'Clubhouse',
                              ),
                            ),
                            wrapWithModel(
                              model: _model.facilityTagModel3,
                              updateCallback: () => safeSetState(() {}),
                              child: FacilityTagWidget(
                                icon: Icon(
                                  Icons.sports_golf_rounded,
                                  color: FlutterFlowTheme.of(context).secondary,
                                  size: 16.0,
                                ),
                                label: 'Driving Range',
                              ),
                            ),
                            wrapWithModel(
                              model: _model.facilityTagModel4,
                              updateCallback: () => safeSetState(() {}),
                              child: FacilityTagWidget(
                                icon: Icon(
                                  Icons.electric_car_rounded,
                                  color: FlutterFlowTheme.of(context).secondary,
                                  size: 16.0,
                                ),
                                label: 'Buggies',
                              ),
                            ),
                            wrapWithModel(
                              model: _model.facilityTagModel5,
                              updateCallback: () => safeSetState(() {}),
                              child: FacilityTagWidget(
                                icon: Icon(
                                  Icons.help,
                                  color: FlutterFlowTheme.of(context).secondary,
                                  size: 16.0,
                                ),
                                label: 'Locker Rooms',
                              ),
                            ),
                            wrapWithModel(
                              model: _model.facilityTagModel6,
                              updateCallback: () => safeSetState(() {}),
                              child: FacilityTagWidget(
                                icon: Icon(
                                  Icons.person_rounded,
                                  color: FlutterFlowTheme.of(context).secondary,
                                  size: 16.0,
                                ),
                                label: 'Caddies',
                              ),
                            ),
                          ],
                        ),
                      Text(
                        'Location',
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                  lineHeight: 1.5,
                                ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Container(
                            width: 300.0,
                            height: 180.0,
                            child: FlutterFlowGoogleMap(
                              controller: _model.mapGoogleMapsController,
                              onCameraIdle: (latLng) =>
                                  _model.mapGoogleMapsCenter = latLng,
                              initialLocation: _model.mapGoogleMapsCenter ??=
                                  functions.returnLatLng(
                                      widget.clubDetails!.latitude!,
                                      widget.clubDetails!.longitude!),
                              markerColor: GoogleMarkerColor.violet,
                              mapType: MapType.normal,
                              style: GoogleMapStyle.standard,
                              initialZoom: 14.0,
                              allowInteraction: false,
                              allowZoom: false,
                              showZoomControls: false,
                              showLocation: false,
                              showCompass: false,
                              showMapToolbar: false,
                              showTraffic: false,
                              centerMapOnMarkerTap: true,
                              mapTakesGesturePreference: false,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'User Reviews (1,240)',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                  lineHeight: 1.5,
                                ),
                          ),
                          wrapWithModel(
                            model: _model.buttonModel,
                            updateCallback: () => safeSetState(() {}),
                            child: ButtonWidget(
                              iconPresent: false,
                              iconEndPresent: false,
                              content: 'See All',
                              variant: 'ghost',
                              size: 'small',
                              fullWidth: false,
                              loading: false,
                              disabled: false,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          wrapWithModel(
                            model: _model.reviewCardModel1,
                            updateCallback: () => safeSetState(() {}),
                            child: ReviewCardWidget(
                              content:
                                  'The ultimate bucket list course. The history is palpable at every turn. Greens were running at 10.5 and true as steel.',
                              date: 'Oct 12, 2023',
                              score: '5',
                              user: 'Marcus Thorne',
                            ),
                          ),
                          wrapWithModel(
                            model: _model.reviewCardModel2,
                            updateCallback: () => safeSetState(() {}),
                            child: ReviewCardWidget(
                              content:
                                  'Incredible experience but hard to get a tee time! The bunkers are deeper than they look on TV. Food in the clubhouse was excellent.',
                              date: 'Sep 28, 2023',
                              score: '4.5',
                              user: 'Sarah Jenkins',
                            ),
                          ),
                        ].divide(SizedBox(height: 16.0)),
                      ),
                    ].divide(SizedBox(height: 16.0)),
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
