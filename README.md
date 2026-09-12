# GetMyBus - Next-Gen Transit Commuter App 🚌📍

> **"Know before you go."**  
> Premium Uber/Swiggy-inspired real-time commuter bus tracking, corridor navigation, and cashless ticketing app built for public and private bus commuters in Kerala.

---

## ✨ Features

- **🗺️ Uber-Grade Retina Map Canvas**:
  - Crisp 512×512 high-definition vector map rendering with English typography.
  - Uber Minimalist desaturated theme for clean, distraction-free transit navigation.
  - Multi-style switcher: Uber Minimal, Google Maps Transit, Terrain, and Satellite Hybrid.
- **🛣️ Real Road-Snapped Corridor Navigation**:
  - High-precision turn-by-turn road geometry along NH66 and arterial roads (*Kollam Chinnakkada ➔ Polayathode ➔ Eravipuram ➔ Mayyanad ➔ Kottiyam ➔ Chathannoor ➔ Parippally ➔ Attingal ➔ Technopark TVM*).
  - 4-layer electric navigation polyline ribbon with ambient under-glow and contrast casing.
- **🎯 Dynamic Auto-Adjusting Camera**:
  - **Discovery Mode**: Auto-frames commuter pickup stop (*Mayyanad Stop*) above the sliding bottom sheet.
  - **Bus Selection Mode**: Smoothly glides to frame the entire 75 km corridor route to the chosen destination.
  - **Active Tracking Mode**: Intelligently auto-zooms to frame both the commuter's pickup stop and the approaching bus with comfortable margins.
  - **Interactive Re-center**: Floating `Re-center View` pill appears when panning away.
- **⚡ Sliding Cockpit Bottom Sheet**:
  - **Stage 1 (Discovery)**: "Where to?" search, quick destination chips (*Technopark, Kollam Stand, Parippally*), curated commuter pass cards.
  - **Stage 2 (Ride Chooser)**: Real-time bus cards with HSRP number plates, occupancy meters, AC/Fast tags, and ETAs.
  - **Stage 3 (Active Telematics)**: Live approaching bus cockpit, driver/conductor contact, and Instant UPI cashless booking.
- **🎫 Digital Wallet & Dynamic QR Boarding Pass**:
  - Instant cashless bus booking modal with dynamic encrypted QR pass.
  - Digital wallet with balance top-up and commuter transit pass cards.

---

## 🛠️ Tech Stack

- **Framework**: [Flutter 3.x](https://flutter.dev) (Dart 3.5+)
- **Map & GIS**: [`flutter_map: ^7.0.2`](https://pub.dev/packages/flutter_map), [`latlong2: ^0.9.1`](https://pub.dev/packages/latlong2)
- **State Management**: [`provider: ^6.1.5+1`](https://pub.dev/packages/provider)
- **Real-Time Telematics**: [`socket_io_client: ^3.1.4`](https://pub.dev/packages/socket_io_client), [`http: ^1.6.0`](https://pub.dev/packages/http)
- **Ticketing & QR**: [`qr_flutter: ^4.1.0`](https://pub.dev/packages/qr_flutter)
- **Platforms Supported**: Web, Android, iOS

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>=3.5.4`)
- Chrome / Edge (for Web preview) or an Android/iOS device/emulator

### Installation & Run

```bash
# Clone repository
git clone https://github.com/xplorifycare/Commuter_App.git
cd Commuter_App

# Install Flutter dependencies
flutter pub get

# Run on Web (Chrome)
flutter run -d chrome

# Or build release web bundle
flutter build web --release
```

---

## 🎨 Official Branding
Official logos, wordmarks, and location pins are located in `assets/images/` and registered in `pubspec.yaml`.

---

© 2026 GetMyBus. All rights reserved.
