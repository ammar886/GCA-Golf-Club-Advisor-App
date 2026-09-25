import '/backend/supabase/supabase.dart';
import '/components/club_card_wide/club_card_wide_widget.dart';
import '/components/loader_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home_widget.dart' show HomeWidget;
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  ///  Local state fields for this page.

  bool isLoading = true;

  bool isSearchActive = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in Home widget.
  List<UsersRow>? currentUser;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - Query Rows] action in TextField widget.
  List<GolfClubsRow>? searchRes;
  // State field(s) for ListView widget.

  PagingController<int, GolfClubsRow>? listViewPagingController1;
  Future<List<GolfClubsRow>> Function(int)? listViewPageQuery1;
  List<Object?>? listViewQueryKey1;
  int listViewQueryRevision1 = 0;

  // Models for ClubCardWide.
  late FlutterFlowDynamicModels<ClubCardWideModel> clubCardWideModels1;
  // Models for ClubCardWide.
  late FlutterFlowDynamicModels<ClubCardWideModel> clubCardWideModels2;
  // Model for loader component.
  late LoaderModel loaderModel;

  @override
  void initState(BuildContext context) {
    clubCardWideModels1 = FlutterFlowDynamicModels(() => ClubCardWideModel());
    clubCardWideModels2 = FlutterFlowDynamicModels(() => ClubCardWideModel());
    loaderModel = createModel(context, () => LoaderModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    listViewPagingController1?.dispose();
    listViewPagingController1 = null;
    clubCardWideModels1.dispose();
    clubCardWideModels2.dispose();
    loaderModel.dispose();
  }

  /// Additional helper methods.
  PagingController<int, GolfClubsRow> setListViewController1(
    Future<List<GolfClubsRow>> Function(int) getPage, {
    List<Object?> queryKey = const [],
  }) {
    listViewPageQuery1 = getPage;
    if (listViewPagingController1 == null) {
      listViewQueryKey1 = _listViewQueryKey1Snapshot(queryKey);
      return listViewPagingController1 = _createListViewController1();
    }
    // The controller outlives a rebuild, so a filter or ordering bound to a
    // page parameter / App State changing would otherwise keep the rows the
    // OLD query loaded and append later pages from the NEW one. Reset instead.
    if (!_listViewQueryKey1Equals(listViewQueryKey1, queryKey)) {
      listViewQueryKey1 = _listViewQueryKey1Snapshot(queryKey);
      // refresh() cannot cancel a page request already in flight. Bumping the
      // revision makes any such request discard its own result instead of
      // appending the previous query's rows into the refreshed controller.
      listViewQueryRevision1++;
      listViewPagingController1!.refresh();
    }
    return listViewPagingController1!;
  }

  /// A defensive deep copy of one bound query input.
  ///
  /// A collection-valued filter usually points straight at an App State
  /// value, and App State mutates collections IN PLACE. Storing the caller's
  /// reference would make the stored key mutate along with it, so the next
  /// comparison would find them equal and never refresh. The recursion
  /// matters because a value is not always a flat list: a jsonb column or a
  /// JSON-typed App State variable arrives as a Map, or as lists and maps
  /// nested inside one another.
  Object? _listViewQueryKey1ValueSnapshot(Object? value) {
    if (value is List) {
      return value.map(_listViewQueryKey1ValueSnapshot).toList();
    }
    if (value is Set) {
      return value.map(_listViewQueryKey1ValueSnapshot).toSet();
    }
    if (value is Map) {
      return {
        for (final entry in value.entries)
          entry.key: _listViewQueryKey1ValueSnapshot(entry.value),
      };
    }
    return value;
  }

  List<Object?> _listViewQueryKey1Snapshot(List<Object?> queryKey) =>
      queryKey.map(_listViewQueryKey1ValueSnapshot).toList();

  /// Structural equality for one bound query input. Written out rather than
  /// using DeepCollectionEquality so the model file needs no extra import.
  ///
  /// Collections are compared element by element: Dart's `==` on a List, Map
  /// or Set is identity, so a freshly allocated but equal value would
  /// otherwise read as a query change and refresh on every rebuild.
  bool _listViewQueryKey1ValueEquals(Object? a, Object? b) {
    if (identical(a, b)) {
      return true;
    }
    if (a is List) {
      if (b is! List || a.length != b.length) {
        return false;
      }
      for (var i = 0; i < a.length; i++) {
        if (!_listViewQueryKey1ValueEquals(a[i], b[i])) {
          return false;
        }
      }
      return true;
    }
    if (a is Set) {
      if (b is! Set || a.length != b.length) {
        return false;
      }
      // Set members are scalars in practice; `contains` uses their own
      // ==/hashCode, which is the best available without ordering them.
      return a.every(b.contains);
    }
    if (a is Map) {
      if (b is! Map || a.length != b.length) {
        return false;
      }
      for (final entry in a.entries) {
        if (!b.containsKey(entry.key) ||
            !_listViewQueryKey1ValueEquals(entry.value, b[entry.key])) {
          return false;
        }
      }
      return true;
    }
    return a == b;
  }

  bool _listViewQueryKey1Equals(List<Object?>? a, List<Object?> b) {
    if (a == null || a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (!_listViewQueryKey1ValueEquals(a[i], b[i])) {
        return false;
      }
    }
    return true;
  }

  PagingController<int, GolfClubsRow> _createListViewController1() {
    final controller = PagingController<int, GolfClubsRow>(firstPageKey: 0);
    return controller..addPageRequestListener(listViewGetRowsPage1);
  }

  void listViewGetRowsPage1(int nextPageMarker) {
    final requestRevision = listViewQueryRevision1;
    listViewPageQuery1!(nextPageMarker).then((rows) {
      // Dropped if the query changed while this request was in flight: its
      // rows came from the old filters, and its offset means nothing against
      // the new result set.
      if (requestRevision != listViewQueryRevision1) {
        return;
      }
      listViewPagingController1?.appendPage(
        rows,
        rows.length < 8 ? null : nextPageMarker + rows.length,
      );
    }).catchError((e) {
      if (requestRevision != listViewQueryRevision1) {
        return;
      }
      listViewPagingController1?.error = e;
    });
  }
}
