import '/components/club_preview_card/club_preview_card_widget.dart';
import '/components/map_pin/map_pin_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'map_widget.dart' show MapWidget;
import 'package:flutter/material.dart';

class MapModel extends FlutterFlowModel<MapWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Map Google Map widget.
  LatLng? mapGoogleMapsCenter;
  final mapGoogleMapsController = Completer<GoogleMapController>();
  // Model for MapPin.
  late MapPinModel mapPinModel1;
  // Model for MapPin.
  late MapPinModel mapPinModel2;
  // Model for MapPin.
  late MapPinModel mapPinModel3;
  // Model for MapPin.
  late MapPinModel mapPinModel4;
  // Model for ClubPreviewCard.
  late ClubPreviewCardModel clubPreviewCardModel1;
  // Model for ClubPreviewCard.
  late ClubPreviewCardModel clubPreviewCardModel2;
  // Model for ClubPreviewCard.
  late ClubPreviewCardModel clubPreviewCardModel3;

  @override
  void initState(BuildContext context) {
    mapPinModel1 = createModel(context, () => MapPinModel());
    mapPinModel2 = createModel(context, () => MapPinModel());
    mapPinModel3 = createModel(context, () => MapPinModel());
    mapPinModel4 = createModel(context, () => MapPinModel());
    clubPreviewCardModel1 = createModel(context, () => ClubPreviewCardModel());
    clubPreviewCardModel2 = createModel(context, () => ClubPreviewCardModel());
    clubPreviewCardModel3 = createModel(context, () => ClubPreviewCardModel());
  }

  @override
  void dispose() {
    mapPinModel1.dispose();
    mapPinModel2.dispose();
    mapPinModel3.dispose();
    mapPinModel4.dispose();
    clubPreviewCardModel1.dispose();
    clubPreviewCardModel2.dispose();
    clubPreviewCardModel3.dispose();
  }
}
