class BusLocation {
  final String busId;
  final String busNumber;
  final double lat;
  final double lng;
  final double speedKmh;
  final String? currentStop;
  final String? nextStop;
  final int timestamp;

  BusLocation({
    required this.busId,
    required this.busNumber,
    required this.lat,
    required this.lng,
    required this.speedKmh,
    this.currentStop,
    this.nextStop,
    required this.timestamp,
  });

  factory BusLocation.fromJson(Map<String, dynamic> json) {
    return BusLocation(
      busId: (json['bus_id'] ?? json['id'] ?? '').toString(),
      busNumber: (json['bus_number'] ?? 'Unknown').toString(),
      lat: double.tryParse((json['lat'] ?? 0.0).toString()) ?? 0.0,
      lng: double.tryParse((json['lng'] ?? 0.0).toString()) ?? 0.0,
      speedKmh: double.tryParse((json['speed_kmh'] ?? 0.0).toString()) ?? 0.0,
      currentStop: json['current_stop']?.toString(),
      nextStop: json['next_stop']?.toString(),
      timestamp: json['timestamp'] is int 
          ? json['timestamp'] 
          : int.tryParse(json['timestamp']?.toString() ?? '') ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
}
