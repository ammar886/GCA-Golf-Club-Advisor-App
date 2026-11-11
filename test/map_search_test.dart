import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golf_club_advisor/backend/api_requests/region_geocoding_service.dart';
import 'package:golf_club_advisor/backend/supabase/supabase.dart';
import 'package:golf_club_advisor/pages/map/map_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

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
    makeClub(
      id: 4,
      name: 'St Andrews Links Old Course',
      address: 'Pilmour House',
      city: 'St Andrews',
      country: 'UK',
      lat: 56.3433,
      lng: -2.8024,
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

  group('RegionGeocodingService', () {
    test('detects numeric zipcodes and international/UK postcodes', () {
      expect(RegionGeocodingService.isLikelyPostalCode('30904'), isTrue);
      expect(RegionGeocodingService.isLikelyPostalCode('90210-1234'), isTrue);
      expect(RegionGeocodingService.isLikelyPostalCode('54000'), isTrue);
      expect(RegionGeocodingService.isLikelyPostalCode('SW1A 1AA'), isTrue);
      expect(RegionGeocodingService.isLikelyPostalCode('ky16 9sf'), isTrue);
      expect(RegionGeocodingService.isLikelyPostalCode('KY16'), isTrue);
      expect(RegionGeocodingService.isLikelyPostalCode('K1A 0B1'), isTrue);

      expect(
        RegionGeocodingService.isLikelyPostalCode('1700 17 Mile Dr'),
        isFalse,
      );
      expect(
        RegionGeocodingService.isLikelyPostalCode('Augusta National'),
        isFalse,
      );
    });

    test('queries Nominatim, caches results, and prefers regions near clubs',
        () async {
      int callCount = 0;
      final mockClient = MockClient((request) async {
        callCount++;
        expect(request.url.host, 'nominatim.openstreetmap.org');
        if (request.url.queryParameters['postalcode'] == '30904') {
          return http.Response(
            jsonEncode([
              {
                'lat': '52.5333',
                'lon': '9.7167',
                'display_name': '30904 Wedemark, Germany',
                'boundingbox': ['52.45', '52.60', '9.65', '9.80'],
              },
              {
                'lat': '33.5020',
                'lon': '-82.0200',
                'display_name': '30904, Augusta, Georgia, United States',
                'boundingbox': ['33.47', '33.53', '-82.06', '-81.98'],
              },
            ]),
            200,
          );
        }
        return http.Response('[]', 200);
      });

      final service = RegionGeocodingService(client: mockClient);
      final first = await service.searchRegion('30904', clubs: clubs);
      final second = await service.searchRegion('30904', clubs: clubs);

      expect(callCount, 1);
      expect(first, isNotNull);
      expect(first!.displayName, '30904, Augusta, Georgia, United States');
      expect(first.center, const LatLng(33.5020, -82.0200));
      expect(second, first);
    });

    test('falls back to q= when postalcode= yields no hits', () async {
      final queries = <Map<String, String>>[];
      final mockClient = MockClient((request) async {
        queries.add(request.url.queryParameters);
        if (request.url.queryParameters.containsKey('postalcode')) {
          return http.Response('[]', 200);
        }
        return http.Response(
          jsonEncode([
            {
              'lat': '56.3398',
              'lon': '-2.7967',
              'display_name': 'KY16, St Andrews, Fife, Scotland',
              'boundingbox': ['56.33', '56.35', '-2.81', '-2.78'],
            },
          ]),
          200,
        );
      });

      final service = RegionGeocodingService(client: mockClient);
      final region = await service.searchRegion('KY16', clubs: clubs);

      expect(queries.length, 2);
      expect(queries[0]['postalcode'], 'KY16');
      expect(queries[1]['q'], 'KY16');
      expect(region?.displayName, 'KY16, St Andrews, Fife, Scotland');
    });

    test('computeRegionBounds expands tiny postcode boxes to cover minRadiusKm',
        () {
      const tinyUkPostcode = GeocodedRegion(
        displayName: 'KY16 9SF, St Andrews',
        center: LatLng(56.3400, -2.8000),
        southwest: LatLng(56.3399, -2.8001),
        northeast: LatLng(56.3401, -2.7999),
      );

      final bounds = RegionGeocodingService.computeRegionBounds(
        tinyUkPostcode,
        minRadiusKm: 25.0,
      );

      expect(bounds.$1.latitude, lessThan(56.2));
      expect(bounds.$2.latitude, greaterThan(56.4));
      expect(bounds.$1.longitude, lessThan(-3.0));
      expect(bounds.$2.longitude, greaterThan(-2.6));
    });
  });

  group('MapWidget.searchClubs and findNearbyClubs', () {
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

    test('findNearbyClubs filters within radius and falls back when empty', () {
      final nearAugusta = MapWidget.findNearbyClubs(
        clubs,
        const LatLng(33.50, -82.02),
        radiusKm: 25.0,
      );
      expect(nearAugusta.withinRadius, isTrue);
      expect(nearAugusta.clubs.map((c) => c.id), [1]);

      final remoteCenter = MapWidget.findNearbyClubs(
        clubs,
        const LatLng(40.7128, -74.0060),
        radiusKm: 25.0,
        fallbackLimit: 2,
      );
      expect(remoteCenter.withinRadius, isFalse);
      expect(remoteCenter.clubs.length, 2);
      expect(remoteCenter.clubs.first.id, 1);
    });
  });

  testWidgets('MapWidget search bar searches name, address, latlng, and zipcodes',
      (tester) async {
    LatLng? lastFocus;
    LatLng? lastFocusSw;
    LatLng? lastFocusNe;
    double? lastRadiusKm;
    int lastFocusVersion = 0;
    LatLng? lastSearchedPin;
    GolfClubsRow? lastSelectedClub;

    final mockClient = MockClient((request) async {
      final postcode = request.url.queryParameters['postalcode'] ??
          request.url.queryParameters['q'];
      if (postcode == 'KY16 9SF') {
        return http.Response(
          jsonEncode([
            {
              'lat': '56.3400',
              'lon': '-2.8000',
              'display_name': 'KY16 9SF, St Andrews, Fife, Scotland',
              'boundingbox': ['56.339', '56.341', '-2.802', '-2.798'],
            },
          ]),
          200,
        );
      }
      return http.Response('[]', 200);
    });

    await tester.pumpWidget(
      MaterialApp(
        home: MapWidget(
          loadClubs: () async => clubs,
          initialUserLocation: const LatLng(33.5, -82.0),
          geocodingService: RegionGeocodingService(client: mockClient),
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
            focusSw,
            focusNe,
            searchRadiusKm,
          ) {
            lastFocus = focusLoc;
            lastFocusVersion = focusVersion;
            lastSearchedPin = searchedPin;
            lastFocusSw = focusSw;
            lastFocusNe = focusNe;
            lastRadiusKm = searchRadiusKm;
            return const SizedBox.expand();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    final searchField = find.byType(TextFormField);
    expect(searchField, findsOneWidget);

    // 1. Search by club name
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
    expect(lastRadiusKm, isNull);

    // 2. Search by address
    await tester.enterText(searchField, 'Mall Road');
    await tester.pumpAndSettle();
    expect(find.text('Lahore Gymkhana Golf Club'), findsOneWidget);

    // 3. Search by full latlng and jump to coordinates
    await tester.enterText(searchField, '31.5497, 74.3436');
    await tester.pumpAndSettle();
    expect(find.text('Go to coordinates'), findsOneWidget);

    await tester.tap(find.text('Go to coordinates'));
    await tester.pumpAndSettle();
    expect(lastFocus, const LatLng(31.5497, 74.3436));
    expect(lastSearchedPin, const LatLng(31.5497, 74.3436));
    expect(lastFocusVersion, 2);
    expect(lastRadiusKm, isNull);

    // 4. Search by UK postcode -> moves map to region, sets radius & shows nearby panel
    await tester.enterText(searchField, 'KY16 9SF');
    await tester.pumpAndSettle();
    expect(find.text('Search zipcode "KY16 9SF"'), findsOneWidget);

    await tester.tap(find.text('Search zipcode "KY16 9SF"'));
    await tester.pumpAndSettle();

    expect(lastFocus, const LatLng(56.3400, -2.8000));
    expect(lastSearchedPin, const LatLng(56.3400, -2.8000));
    expect(lastFocusSw, isNotNull);
    expect(lastFocusNe, isNotNull);
    expect(lastRadiusKm, MapWidget.defaultRegionRadiusKm);
    expect(lastFocusVersion, 3);

    expect(find.text('KY16 9SF, St Andrews, Fife, Scotland'), findsOneWidget);
    expect(find.text('1 club within 25 km'), findsOneWidget);
    expect(find.text('St Andrews Links Old Course'), findsOneWidget);

    // Selecting a nearby club from the region panel preserves region context
    await tester.tap(find.text('St Andrews Links Old Course'));
    await tester.pumpAndSettle();
    expect(lastSelectedClub?.id, 4);
    expect(find.text('KY16 9SF, St Andrews, Fife, Scotland'), findsOneWidget);

    // 5. Unknown zipcode/location submission shows not-found message
    await tester.enterText(searchField, '00000');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(
      find.text('No location or zipcode found for "00000".'),
      findsOneWidget,
    );

    // 6. Clear button resets query, searched pin, radius, and region panel
    await tester.tap(find.byIcon(Icons.close_rounded).first);
    await tester.pumpAndSettle();
    expect(lastSearchedPin, isNull);
    expect(lastRadiusKm, isNull);
    expect(find.text('KY16 9SF, St Andrews, Fife, Scotland'), findsNothing);
    expect(
      find.text('No location or zipcode found for "00000".'),
      findsNothing,
    );
  });
}
