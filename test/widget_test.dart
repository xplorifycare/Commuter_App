import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buspi_app/main.dart';
import 'package:provider/provider.dart';
import 'package:buspi_app/services/socket_service.dart';
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
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SocketService()),
        ],
        child: const BusPIApp(),
      ),
    );

    // Verify conversational greeting renders
    expect(find.text('Hello, Jassim 👋'), findsOneWidget);
    // Verify Uber-style 'Where to?' input renders
    expect(find.text('Where to?'), findsOneWidget);
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

    // Verify NH66 corridor telemetry pill rendered
    expect(find.text('NH66 live'), findsOneWidget);

    // Verify map control buttons exist
    expect(find.byTooltip('Switch Map Style'), findsOneWidget);
    expect(find.byTooltip('Re-center Focus'), findsOneWidget);
    expect(find.byTooltip('Fit Full Route'), findsOneWidget);

    // Tap map style switcher
    await tester.tap(find.byTooltip('Switch Map Style'));
    await tester.pump(const Duration(milliseconds: 100));

    // Tap Re-center button
    await tester.tap(find.byTooltip('Re-center Focus'));
    await tester.pump(const Duration(milliseconds: 100));
  });
}
