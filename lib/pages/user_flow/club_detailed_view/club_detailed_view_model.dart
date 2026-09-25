import '/backend/supabase/supabase.dart';
import '/components/fab_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'club_detailed_view_widget.dart' show ClubDetailedViewWidget;
import 'package:flutter/material.dart';

class ClubDetailedViewModel extends FlutterFlowModel<ClubDetailedViewWidget> {
  ///  Local state fields for this page.

  bool isLoading = true;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in clubDetailedView widget.
  List<GolfCoursesRow>? coursesInClub;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();
  // Model for fab component.
  late FabModel fabModel;

  @override
  void initState(BuildContext context) {
    fabModel = createModel(context, () => FabModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    fabModel.dispose();
  }
}
