# 📞 Flutter WebRTC Group Video Calling App

This project is a modular, scalable video calling app built using **Flutter WebRTC**, **Socket.IO**, and a **clean architecture** structure. It supports **dynamic group calls**, real-time media streaming, bandwidth monitoring, and peer-to-peer WebRTC communication.

---

## 🚀 Features

- ✅ One-to-one and group video calls
- ✅ Join/leave rooms dynamically without ending the call
- ✅ Clean Architecture: Feature-first and layer-based
- ✅ Socket.IO signaling server integration
- ✅ Data cost estimation with bandwidth tracking
- ✅ WebRTC stats monitoring (bytes sent/received)
- ✅ Device orientation fixes for better camera rendering

---

## 🧱 Project Structure (Clean Architecture)

```
lib/
├── core/
│   └── utils/               # Constants, helpers
├── features/
│   └── call/
│       ├── data/
│       │   ├── data_sources/  # WebRTC, Socket, Stats services
│       │   ├── models/        # DTOs, signaling payloads
│       │   └── repositories/  # Implement interfaces
│       ├── domain/
│       │   ├── entities/      # Core business models
│       │   ├── repositories/  # Abstract interfaces
│       │   └── use_cases/     # Application logic
│       └── presentation/
│           ├── manager/       # CallManager or Controller
│           ├── pages/         # UI Screens
│           └── widgets/       # Reusable UI
└── main.dart
```

---

## ⚙️ Getting Started

### Prerequisites

- Flutter (3.13 or later)
- A working Socket.IO server (see `/server`)
- Android/iOS/Web emulator or device

### Installation

1. **Clone the repository:**

```bash
git clone https://github.com/yourusername/flutter-webrtc-video-call.git
cd flutter-webrtc-video-call
```

2. **Install dependencies:**

```bash
flutter pub get
```

3. **Run the app:**

```bash
flutter run
```

---

## 📡 Signaling Server

Ensure you have a signaling server running using **Socket.IO**. The default server URL is defined in:

```
lib/core/utils/constants/servers_urls.dart
```

### Example Server Events Supported

| Event           | Description                     |
|-----------------|---------------------------------|
| `join_room`     | User joins a call room          |
| `call_user`     | Initiate a call to user         |
| `incoming_call` | Notify callee of a call         |
| `accept_call`   | Callee accepts the call         |
| `reject_call`   | Callee rejects the call         |
| `offer`         | SDP Offer                       |
| `answer`        | SDP Answer                      |
| `ice-candidate` | ICE candidate exchange          |

---

## 📊 Bandwidth Tracking & Cost Estimation

This project includes real-time bandwidth monitoring and estimates data cost per call using `StatsService`.

```
📤 Sent: 2.45 MB  
📥 Received: 3.12 MB  
💰 Estimated Cost: $0.05
```

---

## 🤝 Contributing

Pull requests are welcome! If you have improvements, bug fixes, or feature suggestions, feel free to open an issue or PR.

---

## 📄 License

[MIT](LICENSE)

---

## 💡 Credits

- [flutter_webrtc](https://pub.dev/packages/flutter_webrtc)
- [Socket.IO](https://socket.io/)
- [Clean Architecture in Flutter](https://medium.com/flutter-community/clean-code-architecture-in-flutter-9ae6b2c5f7b0)