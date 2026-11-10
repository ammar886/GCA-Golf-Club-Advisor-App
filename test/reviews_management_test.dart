import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golf_club_advisor/app_state.dart';
import 'package:golf_club_advisor/backend/supabase/supabase.dart';
import 'package:golf_club_advisor/pages/admin/reviews_management/reviews_management_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    FFAppState.reset();
    await FFAppState().initializePersistedState();
    FFAppState().currentRole = 'admin';
  });

  ClubReviewsRow makeReview({
    required String id,
    required String? status,
    required String comment,
  }) {
    return ClubReviewsRow({
      'id': id,
      'club_id': 1,
      'user_id': 'u1',
      'overall_rating': 4,
      'status': status,
      'comment': comment,
      'created_at': '2026-10-01T12:00:00.000Z',
    });
  }

  Widget wrap(Widget child) {
    return ChangeNotifierProvider<FFAppState>.value(
      value: FFAppState(),
      child: MaterialApp(home: child),
    );
  }

  test('filterByStatus filters pending and approved reviews accurately', () {
    final reviews = [
      makeReview(id: '1', status: 'pending', comment: 'Pending 1'),
      makeReview(id: '2', status: 'approved', comment: 'Approved 1'),
      makeReview(id: '3', status: 'rejected', comment: 'Rejected 1'),
      makeReview(id: '4', status: 'Pending', comment: 'Pending 2'),
      makeReview(id: '5', status: null, comment: 'Null status'),
    ];

    final pending = ReviewsManagementWidget.filterByStatus(reviews, 'pending');
    final approved =
        ReviewsManagementWidget.filterByStatus(reviews, 'approved');

    expect(pending.map((r) => r.id), ['1', '4']);
    expect(approved.map((r) => r.id), ['2']);
  });

  testWidgets(
      'ReviewsManagementWidget shows Pending Reviews and Approved Reviews tabs with filtered items',
      (tester) async {
    final reviews = [
      makeReview(id: 'r1', status: 'pending', comment: 'Great fairways pending'),
      makeReview(
          id: 'r2', status: 'approved', comment: 'Amazing greens approved'),
      makeReview(
          id: 'r3', status: 'rejected', comment: 'Spam review rejected'),
    ];

    await tester.pumpWidget(
      wrap(
        ReviewsManagementWidget(
          loadReviews: () async => reviews,
          reviewItemBuilder: (review, _) => Text(review.comment ?? ''),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pending Reviews'), findsOneWidget);
    expect(find.text('Approved Reviews'), findsOneWidget);

    // Initially on Pending Reviews tab.
    expect(find.text('Great fairways pending'), findsOneWidget);
    expect(find.text('Amazing greens approved'), findsNothing);
    expect(find.text('Spam review rejected'), findsNothing);

    // Switch to Approved Reviews tab.
    await tester.tap(find.text('Approved Reviews'));
    await tester.pumpAndSettle();

    expect(find.text('Amazing greens approved'), findsOneWidget);
    expect(find.text('Great fairways pending'), findsNothing);
    expect(find.text('Spam review rejected'), findsNothing);
  });

  testWidgets('ReviewsManagementWidget displays empty state per tab',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        ReviewsManagementWidget(
          loadReviews: () async => [],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No pending reviews'), findsOneWidget);

    await tester.tap(find.text('Approved Reviews'));
    await tester.pumpAndSettle();

    expect(find.text('No approved reviews'), findsOneWidget);
  });
}

