import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golf_club_advisor/backend/supabase/supabase.dart';
import 'package:golf_club_advisor/pages/map/map_widget.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  GolfClubsRow makeClub({
    required int id,
    required String name,
    required String address,
    String? city,
    String? country,
    required double lat,
    required double lng,
  }) {
    return GolfClubsRow({
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'country': country,
      'latitude': lat,
      'longitude': lng,
      'isCompleted': true,
    });
  }

  final clubs = [
    makeClub(
      id: 1,
      name: 'Augusta National Golf Club',
      address: '2604 Washington Rd',
      city: 'Augusta',
      country: 'USA',
      lat: 33.5021,
      lng: -82.0226,
    ),
    makeClub(
      id: 2,
      name: 'Pebble Beach Golf Links',
      address: '1700 17 Mile Dr',
      city: 'Pebble Beach',
      country: 'USA',
      lat: 36.5681,
      lng: -121.9506,
    ),
    makeClub(
      id: 3,
      name: 'Lahore Gymkhana Golf Club',
      address: 'Mall Road, Upper Mall',
      city: 'Lahore',
      country: 'Pakistan',
      lat: 31.5497,
      lng: 74.3436,
    ),
  ];

  group('MapWidget.parseLatLng', () {
    test('parses valid lat/lng formats', () {
      expect(
        MapWidget.parseLatLng('33.5021, -82.0226'),
        const LatLng(33.5021, -82.0226),
      );
      expect(
        MapWidget.parseLatLng('33.5021 -82.0226'),
        const LatLng(33.5021, -82.0226),
      );
      expect(
        MapWidget.parseLatLng('LatLng(lat: 31.5497, lng: 74.3436)'),
        const LatLng(31.5497, 74.3436),
      );
      expect(
        MapWidget.parseLatLng('lat: -33.8688, lon: 151.2093'),
        const LatLng(-33.8688, 151.2093),
      );
    });

    test('rejects invalid ranges and non-coordinate queries', () {
      expect(MapWidget.parseLatLng('2604 Washington Rd'), isNull);
      expect(MapWidget.parseLatLng('Augusta National'), isNull);
      expect(MapWidget.parseLatLng('33.5021'), isNull);
      expect(MapWidget.parseLatLng('95.0, 10.0'), isNull);
      expect(MapWidget.parseLatLng('10.0, 185.0'), isNull);
    });
  });

  group('MapWidget.searchClubs', () {
    test('matches by club name, address/city, and partial/full latlng', () {
      final byName = MapWidget.searchClubs(clubs, 'Pebble');
      expect(byName.map((c) => c.id), [2]);

      final byAddress = MapWidget.searchClubs(clubs, 'Washington Rd');
      expect(byAddress.map((c) => c.id), [1]);

      final byCity = MapWidget.searchClubs(clubs, 'Lahore');
      expect(byCity.map((c) => c.id), [3]);

      final byPartialCoord = MapWidget.searchClubs(clubs, '36.568');
      expect(byPartialCoord.map((c) => c.id), [2]);

      final byFullLatLng = MapWidget.searchClubs(clubs, '31.55, 74.34');
      expect(byFullLatLng.first.id, 3);
    });
  });

  testWidgets('MapWidget search bar searches name, address, and latlng',
      (tester) async {
    LatLng? lastFocus;
    int lastFocusVersion = 0;
    LatLng? lastSearchedPin;
    GolfClubsRow? lastSelectedClub;

    await tester.pumpWidget(
      MaterialApp(
        home: MapWidget(
          loadClubs: () async => clubs,
          initialUserLocation: const LatLng(33.5, -82.0),
          onClubSelected: (club) async {
            lastSelectedClub = club;
          },
          mapBuilder: (
            context,
            loadedClubs,
            userLoc,
            focusLoc,
            focusVersion,
            searchedPin,
            onClubTap,
          ) {
            lastFocus = focusLoc;
            lastFocusVersion = focusVersion;
            lastSearchedPin = searchedPin;
            return const SizedBox.expand();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    final searchField = find.byType(TextFormField);
    expect(searchField, findsOneWidget);

    // Search by club name
    await tester.enterText(searchField, 'Pebble');
    await tester.pumpAndSettle();
    expect(find.text('Pebble Beach Golf Links'), findsOneWidget);
    expect(find.text('Augusta National Golf Club'), findsNothing);

    await tester.tap(find.text('Pebble Beach Golf Links'));
    await tester.pumpAndSettle();
    expect(lastSelectedClub?.id, 2);
    expect(lastFocus, const LatLng(36.5681, -121.9506));
    expect(lastFocusVersion, 1);
    expect(lastSearchedPin, isNull);

    // Search by address
    await tester.enterText(searchField, 'Mall Road');
    await tester.pumpAndSettle();
    expect(find.text('Lahore Gymkhana Golf Club'), findsOneWidget);

    // Search by full latlng and jump to coordinates
    await tester.enterText(searchField, '31.5497, 74.3436');
    await tester.pumpAndSettle();
    expect(find.text('Go to coordinates'), findsOneWidget);

    await tester.tap(find.text('Go to coordinates'));
    await tester.pumpAndSettle();
    expect(lastFocus, const LatLng(31.5497, 74.3436));
    expect(lastSearchedPin, const LatLng(31.5497, 74.3436));
    expect(lastFocusVersion, 2);

    // Empty search feedback
    await tester.enterText(searchField, 'Nonexistent Club XYZ');
    await tester.pumpAndSettle();
    expect(find.text('No golf clubs match "Nonexistent Club XYZ"'),
        findsOneWidget);

    // Clear button resets query and searched pin
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(lastSearchedPin, isNull);
    expect(find.text('No golf clubs match "Nonexistent Club XYZ"'),
        findsNothing);
  });
}
