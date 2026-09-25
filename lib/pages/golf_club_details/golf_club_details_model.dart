import '/components/button/button_widget.dart';
import '/components/facility_tag/facility_tag_widget.dart';
import '/components/rating_item/rating_item_widget.dart';
import '/components/review_card/review_card_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'golf_club_details_widget.dart' show GolfClubDetailsWidget;
import 'package:flutter/material.dart';

class GolfClubDetailsModel extends FlutterFlowModel<GolfClubDetailsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for RatingItem.
  late RatingItemModel ratingItemModel1;
  // Model for RatingItem.
  late RatingItemModel ratingItemModel2;
  // Model for RatingItem.
  late RatingItemModel ratingItemModel3;
  // Model for RatingItem.
  late RatingItemModel ratingItemModel4;
  // Model for RatingItem.
  late RatingItemModel ratingItemModel5;
  // Model for RatingItem.
  late RatingItemModel ratingItemModel6;
  // Model for RatingItem.
  late RatingItemModel ratingItemModel7;
  // Model for FacilityTag.
  late FacilityTagModel facilityTagModel1;
  // Model for FacilityTag.
  late FacilityTagModel facilityTagModel2;
  // Model for FacilityTag.
  late FacilityTagModel facilityTagModel3;
  // Model for FacilityTag.
  late FacilityTagModel facilityTagModel4;
  // Model for FacilityTag.
  late FacilityTagModel facilityTagModel5;
  // Model for FacilityTag.
  late FacilityTagModel facilityTagModel6;
  // State field(s) for Map Google Map widget.
  LatLng? mapGoogleMapsCenter;
  final mapGoogleMapsController = Completer<GoogleMapController>();
  // Model for Button.
  late ButtonModel buttonModel;
  // Model for ReviewCard.
  late ReviewCardModel reviewCardModel1;
  // Model for ReviewCard.
  late ReviewCardModel reviewCardModel2;

  @override
  void initState(BuildContext context) {
    ratingItemModel1 = createModel(context, () => RatingItemModel());
    ratingItemModel2 = createModel(context, () => RatingItemModel());
    ratingItemModel3 = createModel(context, () => RatingItemModel());
    ratingItemModel4 = createModel(context, () => RatingItemModel());
    ratingItemModel5 = createModel(context, () => RatingItemModel());
    ratingItemModel6 = createModel(context, () => RatingItemModel());
    ratingItemModel7 = createModel(context, () => RatingItemModel());
    facilityTagModel1 = createModel(context, () => FacilityTagModel());
    facilityTagModel2 = createModel(context, () => FacilityTagModel());
    facilityTagModel3 = createModel(context, () => FacilityTagModel());
    facilityTagModel4 = createModel(context, () => FacilityTagModel());
    facilityTagModel5 = createModel(context, () => FacilityTagModel());
    facilityTagModel6 = createModel(context, () => FacilityTagModel());
    buttonModel = createModel(context, () => ButtonModel());
    reviewCardModel1 = createModel(context, () => ReviewCardModel());
    reviewCardModel2 = createModel(context, () => ReviewCardModel());
  }

  @override
  void dispose() {
    ratingItemModel1.dispose();
    ratingItemModel2.dispose();
    ratingItemModel3.dispose();
    ratingItemModel4.dispose();
    ratingItemModel5.dispose();
    ratingItemModel6.dispose();
    ratingItemModel7.dispose();
    facilityTagModel1.dispose();
    facilityTagModel2.dispose();
    facilityTagModel3.dispose();
    facilityTagModel4.dispose();
    facilityTagModel5.dispose();
    facilityTagModel6.dispose();
    buttonModel.dispose();
    reviewCardModel1.dispose();
    reviewCardModel2.dispose();
  }
}
