import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:golf_club_advisor/app_state.dart';
import 'package:golf_club_advisor/auth/base_auth_user_provider.dart';
import 'package:golf_club_advisor/pages/admin/admin_home/admin_home_widget.dart';
import 'package:golf_club_advisor/pages/home/home_widget.dart';
import 'package:golf_club_advisor/router/router_widget.dart';
import 'package:golf_club_advisor/splash/splash_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class _FakeAuthUser extends BaseAuthUser {
  _FakeAuthUser(this._uid);
  final String _uid;

  @override
  bool get loggedIn => true;

  @override
  bool get emailVerified => true;

  @override
  AuthUserInfo get authUserInfo => AuthUserInfo(uid: _uid);

  @override
  Future? delete() => null;

  @override
  Future? sendEmailVerification() => null;

  @override
  Future? updateEmail(String email) => null;

  @override
  Future? updatePassword(String newPassword) => null;
}

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

  Widget buildRouterTestApp({required Widget routerChild}) {
    final goRouter = GoRouter(
      initialLocation: RouterWidget.routePath,
      routes: [
        GoRoute(
          name: RouterWidget.routeName,
          path: RouterWidget.routePath,
          builder: (_, __) => routerChild,
        ),
        GoRoute(
          name: SplashWidget.routeName,
          path: SplashWidget.routePath,
          builder: (_, __) => const Scaffold(body: Text('SPLASH_DEST')),
        ),
        GoRoute(
          name: HomeWidget.routeName,
          path: HomeWidget.routePath,
          builder: (_, __) => const Scaffold(body: Text('HOME_DEST')),
        ),
        GoRoute(
          name: AdminHomeWidget.routeName,
          path: AdminHomeWidget.routePath,
          builder: (_, __) => const Scaffold(body: Text('ADMIN_DEST')),
        ),
      ],
    );

    return ChangeNotifierProvider<FFAppState>.value(
      value: FFAppState(),
      child: MaterialApp.router(routerConfig: goRouter),
    );
  }

  testWidgets('RouterWidget redirects to Splash when logged out without querying',
      (tester) async {
    bool queried = false;
    await tester.pumpWidget(
      buildRouterTestApp(
        routerChild: RouterWidget(
          isLoggedInOverride: false,
          userIdOverride: '',
          fetchUserRole: (_) async {
            queried = true;
            return null;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(queried, isFalse);
    expect(find.text('SPLASH_DEST'), findsOneWidget);
  });

  testWidgets('RouterWidget redirects guest users to Home without querying',
      (tester) async {
    FFAppState().isGuest = true;
    bool queried = false;

    await tester.pumpWidget(
      buildRouterTestApp(
        routerChild: RouterWidget(
          isLoggedInOverride: false,
          userIdOverride: '',
          fetchUserRole: (_) async {
            queried = true;
            return null;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(queried, isFalse);
    expect(find.text('HOME_DEST'), findsOneWidget);
  });

  testWidgets('RouterWidget routes admin and subAdmin to AdminHome',
      (tester) async {
    await tester.pumpWidget(
      buildRouterTestApp(
        routerChild: RouterWidget(
          isLoggedInOverride: true,
          userIdOverride: 'uid-1',
          fetchUserRole: (_) async => 'subAdmin',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ADMIN_DEST'), findsOneWidget);
  });

  testWidgets('RouterWidget routes regular user to Home', (tester) async {
    await tester.pumpWidget(
      buildRouterTestApp(
        routerChild: RouterWidget(
          isLoggedInOverride: true,
          userIdOverride: 'uid-2',
          fetchUserRole: (_) async => 'user',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('HOME_DEST'), findsOneWidget);
  });

  testWidgets('RouterWidget does not get stuck when role query throws',
      (tester) async {
    await tester.pumpWidget(
      buildRouterTestApp(
        routerChild: RouterWidget(
          isLoggedInOverride: true,
          userIdOverride: 'uid-3',
          fetchUserRole: (_) async => throw Exception('network error'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('HOME_DEST'), findsOneWidget);
  });

  testWidgets('RouterWidget routes to Splash if user logs out during fetch',
      (tester) async {
    final completer = Completer<String?>();
    currentUser = _FakeAuthUser('uid-4');
    addTearDown(() => currentUser = null);

    await tester.pumpWidget(
      buildRouterTestApp(
        routerChild: RouterWidget(
          fetchUserRole: (_) => completer.future,
        ),
      ),
    );
    await tester.pump();

    // Simulate logout completing while role query is still in flight.
    currentUser = null;
    completer.complete('user');
    await tester.pumpAndSettle();

    expect(find.text('SPLASH_DEST'), findsOneWidget);
  });
}
