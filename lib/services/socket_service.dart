import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../config/api.dart';
import '../models/bus.dart';

class SocketService extends ChangeNotifier {
  io.Socket? _socket;
  final Map<String, BusLocation> _activeBuses = {};
  bool _isConnected = false;
  bool _initialized = false; // Guard against duplicate connections

  Map<String, BusLocation> get activeBuses => _activeBuses;
  bool get isConnected => _isConnected;

  void init() {
    if (_initialized) return; // Already connected, skip
    _initialized = true;

    _socket = io.io(ApiConfig.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket?.connect();

    _socket?.onConnect((_) {
      _isConnected = true;
      notifyListeners();
      // Subscribe to all routes for demo
      _subscribeToRoutes();
    });

    _socket?.onDisconnect((_) {
      _isConnected = false;
      notifyListeners();
    });

    _socket?.on('bus_location', (data) {
      if (data != null) {
        try {
          final loc = BusLocation.fromJson(data);
          _activeBuses[loc.busId] = loc;
          notifyListeners();
          debugPrint('[WS] Received location for ${loc.busId}: ${loc.lat}, ${loc.lng}');
        } catch (e) {
          debugPrint('[WS] Error parsing bus_location: $e');
        }
      }
    });
  }

  Future<void> _subscribeToRoutes() async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/routes'));
      if (response.statusCode == 200) {
        final List routes = jsonDecode(response.body);
        for (var route in routes) {
          _socket?.emit('subscribe_route', route['id']);
        }
      }
    } catch (e) {
      debugPrint('Error fetching routes: $e');
    }
  }

  @override
  void dispose() {
    _socket?.disconnect();
    super.dispose();
  }
}
