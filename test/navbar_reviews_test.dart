import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golf_club_advisor/app_state.dart';
import 'package:golf_club_advisor/main.dart';
import 'package:golf_club_advisor/pages/my_reviews/my_reviews_widget.dart';
import 'package:golf_club_advisor/pages/user_profile/user_profile/user_profile_widget.dart';
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
  });

  Widget buildWithAppState(Widget child) {
    return ChangeNotifierProvider<FFAppState>.value(
      value: FFAppState(),
      child: MaterialApp(home: child),
    );
  }

  testWidgets('NavBarPage shows Reviews item for regular user and navigates to MyReviews',
      (tester) async {
    FFAppState().clearGuestMode();
    FFAppState().currentRole = 'user';

    await tester.pumpWidget(
      buildWithAppState(NavBarPage(page: const SizedBox())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reviews'), findsOneWidget);
    expect(find.byIcon(Icons.rate_review_rounded), findsOneWidget);
    expect(find.text('Users'), findsNothing);

    await tester.tap(find.text('Reviews'));
    await tester.pumpAndSettle();

    expect(find.byType(MyReviewsWidget), findsOneWidget);
    expect(find.text('My Reviews'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsNothing);
  });

  testWidgets('NavBarPage hides Reviews item for admin', (tester) async {
    FFAppState().clearGuestMode();
    FFAppState().currentRole = 'admin';

    await tester.pumpWidget(
      buildWithAppState(NavBarPage(page: const SizedBox())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reviews'), findsNothing);
    expect(find.byIcon(Icons.rate_review_rounded), findsNothing);
    expect(find.text('Users'), findsOneWidget);
  });

  testWidgets('NavBarPage hides Reviews item for subAdmin', (tester) async {
    FFAppState().clearGuestMode();
    FFAppState().currentRole = 'subAdmin';

    await tester.pumpWidget(
      buildWithAppState(NavBarPage(page: const SizedBox())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reviews'), findsNothing);
    expect(find.byIcon(Icons.rate_review_rounded), findsNothing);
    expect(find.text('Users'), findsNothing);
  });

  testWidgets('NavBarPage handles role change off MyReviews cleanly at 360px',
      (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    FFAppState().clearGuestMode();
    FFAppState().currentRole = 'user';

    await tester.pumpWidget(
      buildWithAppState(
        NavBarPage(
          initialPage: 'MyReviews',
          page: const SizedBox(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    var navBar =
        tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
    expect(navBar.currentIndex, 4);
    expect(find.text('Reviews'), findsOneWidget);

    FFAppState().currentRole = 'subadmin';
    await tester.pumpAndSettle();

    navBar =
        tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
    expect(navBar.currentIndex, 0);
    expect(find.text('Reviews'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('MyReviewsWidget shows back button only when route can pop',
      (tester) async {
    FFAppState().isGuest = true;

    await tester.pumpWidget(
      buildWithAppState(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const MyReviewsWidget(),
                ),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byType(MyReviewsWidget), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('NavBarPage shows guest auth prompt when guest taps Reviews',
      (tester) async {
    FFAppState().isGuest = true;
    FFAppState().currentRole = 'guest';

    await tester.pumpWidget(
      buildWithAppState(NavBarPage(page: const SizedBox())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reviews'), findsOneWidget);
    await tester.tap(find.text('Reviews'));
    await tester.pumpAndSettle();

    expect(find.text('Sign In to View Reviews'), findsOneWidget);
    expect(find.byType(MyReviewsWidget), findsNothing);
  });

  testWidgets('UserProfileWidget no longer has Reviews icon button',
      (tester) async {
    FFAppState().isGuest = true;
    FFAppState().currentRole = 'guest';

    await tester.pumpWidget(
      buildWithAppState(const UserProfileWidget()),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.rate_review_outlined), findsNothing);
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
  });
}

