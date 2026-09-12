import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import '../config/theme.dart';
import '../data/corridor_route.dart';
import '../models/bus.dart';
import 'uber_bottom_sheet.dart';

enum MapStyle {
  uberMinimal, // Sleek Uber-style desaturated retina canvas
  googleMaps, // Official Google Maps Standard Retina
  googleTerrain, // Official Google Maps Terrain Retina
  googleHybrid, // Official Google Maps Satellite Hybrid Retina
}

class UberMapView extends StatefulWidget {
  final List<BusLocation> liveBuses;
  final String? selectedBusName;
  final String? selectedDestination;
  final UberSheetState sheetState;
  final VoidCallback? onRecenter;
  final ValueChanged<String>? onBusSelected;

  const UberMapView({
    super.key,
    required this.liveBuses,
    this.selectedBusName,
    this.selectedDestination,
    this.sheetState = UberSheetState.discovery,
    this.onRecenter,
    this.onBusSelected,
  });

  @override
  State<UberMapView> createState() => _UberMapViewState();
}

class _UberMapViewState extends State<UberMapView>
    with TickerProviderStateMixin {
  late final MapController _mapController;
  late final AnimationController _pulseController;
  late final AnimationController _simController;
  AnimationController? _cameraAnimController;

  MapStyle _currentMapStyle = MapStyle.uberMinimal;
  bool _userInteracted = false;
  bool _initialFramed = false;

  // Real NH66 Kerala Commuter Corridor (Kollam ➔ Mayyanad ➔ Technopark ➔ TVM)
  late final List<LatLng> _routePoints;

  // Major corridor stops along Kerala Commuter Route
  final List<Map<String, dynamic>> _corridorStops = [
    {
      'name': 'Kollam Stand',
      'point': const LatLng(8.8932, 76.6141),
      'isTerminal': true
    },
    {
      'name': 'Mayyanad Stop',
      'point': const LatLng(8.835489, 76.643381),
      'isUserStop': true
    },
    {
      'name': 'Kottiyam Jn',
      'point': const LatLng(8.8660, 76.6709),
      'isTerminal': false
    },
    {
      'name': 'Chathannoor Stand',
      'point': const LatLng(8.8576, 76.7235),
      'isTerminal': false
    },
    {
      'name': 'Parippally Jn',
      'point': const LatLng(8.8091, 76.7628),
      'isTerminal': false
    },
    {
      'name': 'Attingal Stand',
      'point': const LatLng(8.6965, 76.8143),
      'isTerminal': false
    },
    {
      'name': 'Technopark TVM',
      'point': const LatLng(8.5686, 76.8731),
      'isTerminal': true
    },
  ];

  // Default commuter stop (Mayyanad Junction, Kollam - snapped to road network)
  final LatLng _commuterStop = const LatLng(8.835489, 76.643381);
  final LatLng _destinationStop = const LatLng(8.5686, 76.8731);

  // Uber clean desaturation matrix: softens aggressive saturated roads & labels into sleek airy tones
  static const List<double> _uberMinimalColorMatrix = <double>[
    0.65,
    0.25,
    0.10,
    0,
    14,
    0.20,
    0.70,
    0.10,
    0,
    14,
    0.12,
    0.22,
    0.66,
    0,
    18,
    0,
    0,
    0,
    1,
    0,
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Pulse animation for user GPS dot
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // Continuous simulation ticker for real-time bus progression
    _simController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();

    // Snapped directly to real road network
    _routePoints = kRealCorridorRoute;

    // Auto-adjust camera after first frame measurement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_initialFramed) {
        _initialFramed = true;
        _autoAdjustCamera(animated: false);
      }
    });
  }

  @override
  void didUpdateWidget(covariant UberMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sheetState != oldWidget.sheetState ||
        widget.selectedBusName != oldWidget.selectedBusName ||
        widget.selectedDestination != oldWidget.selectedDestination) {
      _userInteracted = false;
      _autoAdjustCamera(animated: true);
    }
  }

  @override
  void dispose() {
    _cameraAnimController?.dispose();
    _pulseController.dispose();
    _simController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  /// Smoothly animates camera to target coordinates and zoom level (Uber-style glide)
  void _animatedCameraMove({
    required LatLng destCenter,
    required double destZoom,
    Duration duration = const Duration(milliseconds: 650),
  }) {
    _cameraAnimController?.stop();
    _cameraAnimController?.dispose();

    final startCenter = _mapController.camera.center;
    final startZoom = _mapController.camera.zoom;

    final latTween =
        Tween<double>(begin: startCenter.latitude, end: destCenter.latitude);
    final lngTween =
        Tween<double>(begin: startCenter.longitude, end: destCenter.longitude);
    final zoomTween = Tween<double>(begin: startZoom, end: destZoom);

    final controller = AnimationController(vsync: this, duration: duration);
    _cameraAnimController = controller;

    final curved =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(curved), lngTween.evaluate(curved)),
        zoomTween.evaluate(curved),
      );
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        controller.dispose();
        if (_cameraAnimController == controller) {
          _cameraAnimController = null;
        }
      }
    });

    controller.forward();
  }

  /// Automatically frames the camera based on sheet state, selected destination, and active bus,
  /// compensating for the sliding bottom sheet so markers sit in the visible upper half of the screen.
  void _autoAdjustCamera({bool animated = true}) {
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      try {
        final cam = _mapController.camera;
        if (cam.nonRotatedSize.x <= 0 || cam.nonRotatedSize.y <= 0) {
          Future.delayed(const Duration(milliseconds: 120), () {
            if (mounted) _autoAdjustCamera(animated: animated);
          });
          return;
        }

        final size = MediaQuery.of(context).size;
        final topBarHeight = MediaQuery.of(context).padding.top + 76.0;

        // Calculate bottom sheet height dynamically by state
        final double sheetRatio = switch (widget.sheetState) {
          UberSheetState.discovery => 0.46,
          UberSheetState.busSelection => 0.54,
          UberSheetState.activeTracking => 0.58,
        };
        final bottomSheetHeight = size.height * sheetRatio;

        final padding = EdgeInsets.fromLTRB(
          36,
          topBarHeight + 20,
          36,
          bottomSheetHeight + 20,
        );

        // ── Case 1: Active Tracking Mode (Frame Commuter Stop + Approaching Bus) ──
        if (widget.sheetState == UberSheetState.activeTracking) {
          final buses = widget.liveBuses.isNotEmpty
              ? widget.liveBuses
              : _generateCorridorBuses();

          BusLocation? targetBus;
          if (widget.selectedBusName != null) {
            targetBus = buses.cast<BusLocation?>().firstWhere(
                  (b) =>
                      b != null &&
                      (b.busNumber == widget.selectedBusName ||
                          widget.selectedBusName!.contains(b.busNumber)),
                  orElse: () => buses.isNotEmpty ? buses.first : null,
                );
          } else if (buses.isNotEmpty) {
            targetBus = buses.first;
          }

          if (targetBus != null) {
            final targetPoints = [
              _commuterStop,
              LatLng(targetBus.lat, targetBus.lng),
            ];

            final fitted = CameraFit.coordinates(
              coordinates: targetPoints,
              padding: padding,
              maxZoom: 15.8,
              minZoom: 12.0,
            ).fit(cam);

            if (animated) {
              _animatedCameraMove(
                  destCenter: fitted.center, destZoom: fitted.zoom);
            } else {
              _mapController.move(fitted.center, fitted.zoom);
            }
            return;
          }
        }

        // ── Case 2: Bus Selection Mode (Destination Selected: Frame Corridor Route) ──
        if (widget.sheetState == UberSheetState.busSelection ||
            widget.selectedDestination != null) {
          final targetPoints = [
            _commuterStop,
            const LatLng(8.8091, 76.7628), // Parippally
            const LatLng(8.6965, 76.8143), // Attingal
            _destinationStop, // Technopark TVM
          ];

          final fitted = CameraFit.coordinates(
            coordinates: targetPoints,
            padding: padding,
            maxZoom: 13.5,
            minZoom: 9.8,
          ).fit(cam);

          if (animated) {
            _animatedCameraMove(
                destCenter: fitted.center, destZoom: fitted.zoom);
          } else {
            _mapController.move(fitted.center, fitted.zoom);
          }
          return;
        }

        // ── Case 3: Discovery Mode (Center on Commuter Pickup Stop with Bottom Sheet Offset) ──
        final fitted = CameraFit.coordinates(
          coordinates: [_commuterStop],
          padding: padding,
          maxZoom: 15.2,
          minZoom: 13.5,
        ).fit(cam);

        if (animated) {
          _animatedCameraMove(destCenter: fitted.center, destZoom: fitted.zoom);
        } else {
          _mapController.move(fitted.center, fitted.zoom);
        }
      } catch (e) {
        _mapController.move(_commuterStop, 14.5);
      }
    });
  }

  void _recenter() {
    setState(() {
      _userInteracted = false;
    });
    _autoAdjustCamera(animated: true);
    widget.onRecenter?.call();
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(
        _mapController.camera.center, (currentZoom + 1).clamp(6.0, 19.0));
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(
        _mapController.camera.center, (currentZoom - 1).clamp(6.0, 19.0));
  }

  void _fitFullRoute() {
    if (_routePoints.isNotEmpty) {
      final size = MediaQuery.of(context).size;
      final bottomSheetHeight = size.height * 0.46;
      final topBarHeight = MediaQuery.of(context).padding.top + 76.0;

      final fitted = CameraFit.coordinates(
        coordinates: _routePoints,
        padding: EdgeInsets.fromLTRB(
            36, topBarHeight + 10, 36, bottomSheetHeight + 20),
        maxZoom: 13.0,
        minZoom: 9.0,
      ).fit(_mapController.camera);

      setState(() {
        _userInteracted = true;
      });
      _animatedCameraMove(destCenter: fitted.center, destZoom: fitted.zoom);
    }
  }

  void _cycleMapStyle() {
    setState(() {
      switch (_currentMapStyle) {
        case MapStyle.uberMinimal:
          _currentMapStyle = MapStyle.googleMaps;
          break;
        case MapStyle.googleMaps:
          _currentMapStyle = MapStyle.googleTerrain;
          break;
        case MapStyle.googleTerrain:
          _currentMapStyle = MapStyle.googleHybrid;
          break;
        case MapStyle.googleHybrid:
          _currentMapStyle = MapStyle.uberMinimal;
          break;
      }
    });

    final name = switch (_currentMapStyle) {
      MapStyle.uberMinimal => 'Uber Minimalist (Crisp Vector Canvas)',
      MapStyle.googleMaps => 'Google Maps (Standard Retina)',
      MapStyle.googleTerrain => 'Google Maps (Terrain Retina)',
      MapStyle.googleHybrid => 'Google Satellite (Hybrid Retina)',
    };

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Map Style: $name'),
        duration: const Duration(milliseconds: 1400),
        backgroundColor: AppColors.uberBlack,
      ),
    );
  }

  String get _tileUrlTemplate {
    switch (_currentMapStyle) {
      case MapStyle.uberMinimal:
      case MapStyle.googleMaps:
        return 'https://mt{s}.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}&scale=2';
      case MapStyle.googleTerrain:
        return 'https://mt{s}.google.com/vt/lyrs=p&hl=en&x={x}&y={y}&z={z}&scale=2';
      case MapStyle.googleHybrid:
        return 'https://mt{s}.google.com/vt/lyrs=y&hl=en&x={x}&y={y}&z={z}&scale=2';
    }
  }

  List<String> get _tileSubdomains => const ['0', '1', '2', '3'];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── 1. REAL HIGH-DEFINITION RETINA MAP (UBER MINIMAL / GMAP RETINA) ──
        AnimatedBuilder(
          animation: Listenable.merge([_pulseController, _simController]),
          builder: (context, _) {
            final activeBusMarkers = _buildLiveBusMarkers();

            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _commuterStop,
                initialZoom: 14.5,
                minZoom: 6.0,
                maxZoom: 19.5,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
                onPositionChanged: (camera, hasGesture) {
                  if (hasGesture && !_userInteracted) {
                    setState(() {
                      _userInteracted = true;
                    });
                  }
                },
              ),
              children: [
                // Crisp 512x512 Retina Tiles with optional Uber Minimal Desaturation
                TileLayer(
                  key: ValueKey(_currentMapStyle),
                  urlTemplate: _tileUrlTemplate,
                  subdomains: _tileSubdomains,
                  userAgentPackageName: 'in.getmybus.app',
                  maxZoom: 20,
                  tileBuilder: _currentMapStyle == MapStyle.uberMinimal
                      ? (context, tileWidget, tile) => ColorFiltered(
                            colorFilter: const ColorFilter.matrix(
                                _uberMinimalColorMatrix),
                            child: tileWidget,
                          )
                      : null,
                ),

                // ── Google Maps / Uber Elevated Navigation Route Ribbon ──
                PolylineLayer(
                  polylines: [
                    // Layer 1: Ambient Under-Glow (Luminous Soft Spread)
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 8,
                      color: AppColors.primary.withOpacity(0.12),
                      strokeCap: StrokeCap.round,
                      strokeJoin: StrokeJoin.round,
                    ),
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 4.8,
                      color: AppColors.primaryDark.withOpacity(0.88),
                      strokeCap: StrokeCap.round,
                      strokeJoin: StrokeJoin.round,
                    ),
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 2,
                      color: AppColors.accent.withOpacity(0.95),
                      strokeCap: StrokeCap.round,
                      strokeJoin: StrokeJoin.round,
                    ),
                  ],
                ),

                // Stop Pins & Bus Markers
                MarkerLayer(
                  markers: [
                    // Intermediate stop dots along corridor
                    ..._corridorStops.map((stop) {
                      final isUser = stop['isUserStop'] == true;
                      final isTerminal = stop['isTerminal'] == true;
                      if (isUser) {
                        return null; // Handled separately with pulsing radar
                      }

                      return Marker(
                        point: stop['point'] as LatLng,
                        width: 140,
                        height: 38,
                        child: _buildCorridorStopDot(
                            stop['name'] as String, isTerminal),
                      );
                    }).whereType<Marker>(),

                    // Destination Marker (Uber Checkered / Black Pin)
                    Marker(
                      point: _destinationStop,
                      width: 150,
                      height: 52,
                      child: _buildDestinationPin('Technopark TVM'),
                    ),

                    // Commuter Location Pin (Apple Maps / Uber Radar Dot at Mayyanad)
                    Marker(
                      point: _commuterStop,
                      width: 160,
                      height: 76,
                      child: _buildCommuterLocationMarker(),
                    ),

                    // Live Approaching Buses
                    ...activeBusMarkers,
                  ],
                ),
              ],
            );
          },
        ),

        // ── 2. TOP TELEMETRY STATUS PILL (UBER STYLE) ──
        Positioned(
          top: MediaQuery.of(context).padding.top + 62,
          left: 18,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.82),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.9)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.5,
                  height: 6.5,
                  decoration: const BoxDecoration(
                    color: AppColors.statusLive,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'NH66 live',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── 3. FLOATING RE-CENTER BANNER (WHEN USER PAN AWAY) ──
        if (_userInteracted)
          Positioned(
            top: MediaQuery.of(context).padding.top + 62,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _recenter,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.uberBlack,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.20),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.my_location_rounded,
                          size: 14, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'Re-center View',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // ── 4. FLOATING MAP ACTION BUTTONS (UBER / SWIGGY STYLE) ──
        Positioned(
          right: 18,
          top: MediaQuery.of(context).padding.top + 70,
          child: Column(
            children: [
              // Map Style Switcher (Uber Minimal ⟷ GMap ⟷ Terrain ⟷ Satellite)
              _buildFloatingButton(
                icon: Icons.layers_rounded,
                tooltip: 'Switch Map Style',
                onTap: _cycleMapStyle,
              ),
              const SizedBox(height: 8),

              // Re-center on commuter stop / tracking focus
              _buildFloatingButton(
                icon: Icons.my_location_rounded,
                tooltip: 'Re-center Focus',
                onTap: _recenter,
                isPrimary: true,
              ),
              const SizedBox(height: 8),

              // Fit whole corridor route
              _buildFloatingButton(
                icon: Icons.alt_route_rounded,
                tooltip: 'Fit Full Route',
                onTap: _fitFullRoute,
              ),
              const SizedBox(height: 8),

              // Zoom In
              _buildFloatingButton(
                icon: Icons.add_rounded,
                tooltip: 'Zoom In',
                onTap: _zoomIn,
              ),
              const SizedBox(height: 8),

              // Zoom Out
              _buildFloatingButton(
                icon: Icons.remove_rounded,
                tooltip: 'Zoom Out',
                onTap: _zoomOut,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Pulsing User Location Marker (Apple Maps / Uber Style) ──
  Widget _buildCommuterLocationMarker() {
    final scale = 1.0 + (_pulseController.value * 0.45);
    final opacity = (1.0 - _pulseController.value * 0.75).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Concentric Radar Halo
            Transform.scale(
              scale: scale,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.25 * opacity),
                ),
              ),
            ),
            // Solid Outer White Disc + GMB Brand Pin Center
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.40),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/gmb_icon_pin.png',
                  width: 16,
                  height: 16,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            'Mayyanad Stop • Pickup',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // ── Uber Destination Pin (Technopark / TVM) ──
  Widget _buildDestinationPin(String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.uberBlack,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.28),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
          decoration: BoxDecoration(
            color: AppColors.uberBlack,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.flag_rounded, size: 9, color: Colors.white),
              const SizedBox(width: 3.5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Transit Stop Dot along corridor ──
  Widget _buildCorridorStopDot(String name, bool isTerminal) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.94),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 4.5,
              height: 4.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isTerminal ? AppColors.uberBlack : AppColors.primary,
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Live Bus Markers with Uber-Style Vehicle Puck & ETA Capsule ──
  List<Marker> _buildLiveBusMarkers() {
    final markers = <Marker>[];

    final buses = widget.liveBuses.isNotEmpty
        ? widget.liveBuses
        : _generateCorridorBuses();

    for (int i = 0; i < buses.length; i++) {
      final bus = buses[i];
      final isSelected = widget.selectedBusName != null &&
          (widget.selectedBusName!.contains(bus.busNumber) ||
              widget.selectedBusName!.toLowerCase().contains('venad') &&
                  i == 0);

      final etaMins = i == 0 ? 3 : (i == 1 ? 7 : 12);

      markers.add(
        Marker(
          point: LatLng(bus.lat, bus.lng),
          width: 136,
          height: 72,
          child: GestureDetector(
            onTap: () => widget.onBusSelected?.call(bus.busNumber),
            child: _buildUberBusPuck(bus, isSelected, etaMins),
          ),
        ),
      );
    }

    return markers;
  }

  Widget _buildUberBusPuck(BusLocation bus, bool isSelected, int etaMins) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Floating ETA Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.uberBlack : Colors.white,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.35)
                    : Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: AppColors.statusLive,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  '${bus.busNumber} • ${etaMins}m',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 3),

        // Uber Circular Vehicle Puck
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.40)
                    : Colors.black.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/bus_3d.jpg',
                width: 28,
                height: 28,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Generate realistic live buses along NH66 between Kollam & Technopark
  List<BusLocation> _generateCorridorBuses() {
    if (_routePoints.isEmpty) return [];

    final progress = _simController.value;
    final total = _routePoints.length;

    // Bus 1: Venad Fast (Approaching Mayyanad Stop ~ 3 min away, stop is at index 218)
    final idx1 = ((progress * 55 + 160) % total).toInt();
    final p1 = _routePoints[idx1];

    // Bus 2: Royal King Electric AC (~ 7 min away near Kottiyam NH66)
    final idx2 = ((progress * 55 + 320) % total).toInt();
    final p2 = _routePoints[idx2];

    // Bus 3: St. Jude Superfast (~ 12 min away near Chathannoor/Parippally)
    final idx3 = ((progress * 55 + 560) % total).toInt();
    final p3 = _routePoints[idx3];

    return [
      BusLocation(
        busId: 'bus-001',
        busNumber: 'KL 02 BB 4521',
        lat: p1.latitude,
        lng: p1.longitude,
        speedKmh: 42.0,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
      BusLocation(
        busId: 'bus-002',
        busNumber: 'KL 01 CZ 8819',
        lat: p2.latitude,
        lng: p2.longitude,
        speedKmh: 38.0,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
      BusLocation(
        busId: 'bus-003',
        busNumber: 'KL 02 AK 3302',
        lat: p3.latitude,
        lng: p3.longitude,
        speedKmh: 48.0,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    ];
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isPrimary
                    ? AppColors.primary.withOpacity(0.94)
                    : Colors.white.withOpacity(0.82),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.9)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark
                        .withOpacity(isPrimary ? 0.16 : 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 19,
                  color: isPrimary ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
