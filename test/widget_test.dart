import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:buspi_app/main.dart';
import 'package:provider/provider.dart';
import 'package:buspi_app/services/socket_service.dart';
import 'package:buspi_app/screens/home_screen.dart';
import 'package:buspi_app/screens/digital_ticket_screen.dart';
import 'package:buspi_app/screens/profile_wallet_screen.dart';
import 'package:buspi_app/screens/onboarding_screen.dart';
import 'package:buspi_app/widgets/uber_map_view.dart';
import 'package:buspi_app/widgets/uber_bottom_sheet.dart';

class _MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return Future.value(_MockHttpClientRequest());
  }
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  HttpHeaders get headers => _MockHttpHeaders();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return Future.value(_MockHttpClientResponse());
  }
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #contentType) {
      return ContentType('image', 'png');
    }
    return null;
  }
}

class _MockHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  static const List<int> _transparentPng = <int>[
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
    0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
    0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
    0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
    0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
    0x60, 0x82,
  ];

  @override
  int get statusCode => 200;

  @override
  int get contentLength => _transparentPng.length;

  @override
  HttpHeaders get headers => _MockHttpHeaders();

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.fromIterable([_transparentPng]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _MockHttpOverrides();
  });

  testWidgets('GetMyBus app smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SocketService()),
        ],
        child: const BusPIApp(),
      ),
    );

    // Verify v3 Home Screen elements render
    expect(find.text('Where to?'), findsOneWidget);
    expect(find.text('എവിടേക്ക്?'), findsOneWidget);
    expect(find.text('3 buses near you'), findsOneWidget);
    expect(find.text('Nearby'), findsOneWidget);
    expect(find.text('Live near you'), findsOneWidget);
    expect(find.text('Preview: no buses'), findsOneWidget);
    expect(find.text('2 trips to your free ride'), findsOneWidget);
    expect(find.text('Recent trips'), findsOneWidget);
    expect(find.text('Tickets'), findsWidgets);
  });

  testWidgets('HomeScreen NoBusesState toggle test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Initially shows preview toggle
    expect(find.text('Preview: no buses'), findsOneWidget);
    expect(find.text('No live buses right now'), findsNothing);

    // Tap toggle to trigger NoBusesState
    await tester.tap(find.text('Preview: no buses'));
    await tester.pumpAndSettle();

    expect(find.text('Show live buses'), findsOneWidget);
    expect(find.text('No live buses right now'), findsOneWidget);

    // Tap back
    await tester.tap(find.text('Show live buses'));
    await tester.pumpAndSettle();

    expect(find.text('Preview: no buses'), findsOneWidget);
    expect(find.text('No live buses right now'), findsNothing);
  });

  testWidgets('DigitalTicketScreen QR tap simulation and WhatsApp share test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: DigitalTicketScreen(),
      ),
    );

    // Verify initial ticket state
    expect(find.text('My ticket'), findsOneWidget);
    expect(find.text('Show this code to the conductor'), findsOneWidget);
    expect(find.text('Share to WhatsApp'), findsOneWidget);

    // Tap QR code to simulate conductor scan
    await tester.tap(find.byType(QrImageView));
    await tester.pump();

    // Check confirmation state
    expect(find.text('Boarding confirmed'), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);

    // Fast-forward after 1600ms
    await tester.pump(const Duration(milliseconds: 1700));
    expect(find.text('Show this code to the conductor'), findsOneWidget);
  });

  testWidgets('ProfileWalletScreen CO2 savings pill test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileWalletScreen(),
      ),
    );

    // Verify Leaf icon & CO2 savings text
    expect(find.byIcon(Icons.eco_rounded), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Wallet'), findsOneWidget);
  });

  testWidgets('OnboardingScreen bilingual slides test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(onFinish: () {}),
      ),
    );

    // Verify slide 1
    expect(find.text('Know exactly\nwhen it arrives.'), findsOneWidget);
    expect(find.text('ബസ് എപ്പോൾ എത്തുമെന്ന് കൃത്യമായി അറിയാം'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Tap Next
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Verify slide 2
    expect(find.text('Board without\nthe queue.'), findsOneWidget);
    expect(find.text('ക്യൂ ഇല്ലാതെ ബസിൽ കയറാം'), findsOneWidget);
  });

  testWidgets('UberMapView state changes and controls test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: UberMapView(
            liveBuses: [],
            sheetState: UberSheetState.discovery,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    // Verify Commuter pickup marker rendered
    expect(find.text('Mayyanad Stop • Pickup'), findsOneWidget);

    // Verify Re-center button exists
    expect(find.byIcon(Icons.my_location_rounded), findsOneWidget);

    // Tap Re-center button
    await tester.tap(find.byIcon(Icons.my_location_rounded));
    await tester.pump(const Duration(milliseconds: 100));
  });
}
