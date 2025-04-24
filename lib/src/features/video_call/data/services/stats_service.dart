// import 'dart:async';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
//
// class StatsService {
//   final RTCPeerConnection peerConnection;
//   int totalBytesSent = 0;
//   int totalBytesReceived = 0;
//   double costPerMB = 0.01;
//
//   Timer? _statsTimer;
//
//   StatsService({required this.peerConnection, this.costPerMB = 0.01});
//
//   void startMonitoring(void Function()? onUpdate) {
//     _statsTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
//       var stats = await peerConnection.getStats();
//
//       for (var report in stats) {
//         if (report.type == 'outbound-rtp') {
//           final sentVal = report.values['bytesSent'];
//           totalBytesSent += _parseBytes(sentVal);
//         } else if (report.type == 'inbound-rtp') {
//           final recvVal = report.values['bytesReceived'];
//           totalBytesReceived += _parseBytes(recvVal);
//         }
//       }
//
//       if (onUpdate != null) onUpdate();
//     });
//   }
//
//   int _parseBytes(dynamic value) {
//     if (value is String) return int.tryParse(value) ?? 0;
//     if (value is int) return value;
//     return 0;
//   }
//
//   void stopMonitoring() {
//     _statsTimer?.cancel();
//   }
//
//   double get totalMB => (totalBytesSent + totalBytesReceived) / 1000000;
//
//   double get estimatedCost => totalMB * costPerMB;
// }


import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';

class StatsService {
  int totalBytesSent = 0;
  int totalBytesReceived = 0;
  double costPerMB = 0.01;
  Timer? _timer;

  final _costStreamController = StreamController<String>.broadcast();
  Stream<String> get costStream => _costStreamController.stream;

  void startMonitoring(RTCPeerConnection peerConnection) {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      var stats = await peerConnection.getStats();
      for (var report in stats) {
        if (report.type == 'outbound-rtp') {
          var val = report.values['bytesSent'];
          totalBytesSent += _parse(val);
        } else if (report.type == 'inbound-rtp') {
          var val = report.values['bytesReceived'];
          totalBytesReceived += _parse(val);
        }
      }

      double cost = ((totalBytesSent + totalBytesReceived) / 1000000) * costPerMB;
      _costStreamController.add("📤 Sent: ${(totalBytesSent / 1000000).toStringAsFixed(2)} MB, "
          "📥 Received: ${(totalBytesReceived / 1000000).toStringAsFixed(2)} MB, "
          "💰 Cost: \$${cost.toStringAsFixed(2)}");
    });
  }

  int _parse(dynamic val) {
    if (val is String) return int.tryParse(val) ?? 0;
    if (val is int) return val;
    return 0;
  }

  void stopMonitoring() {
    _timer?.cancel();
    _costStreamController.close();
  }
}