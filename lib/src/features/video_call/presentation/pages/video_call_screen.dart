import 'package:block/src/features/video_call/data/services/stats_service.dart';
import 'package:block/src/features/video_call/presentation/manager/call_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final RTCVideoRenderer _local = RTCVideoRenderer();
  final RTCVideoRenderer _remote = RTCVideoRenderer();
  late CallManager _callManager;
  late final StatsService statsService;



  @override
  void initState() {
    super.initState();
    _callManager = CallManager(
      roomId: "room123",
      localRenderer: _local,
      remoteRenderer: _remote,
    );
    _callManager.init();
    statsService = StatsService(); // or inject if you're using DI
    statsService.startMonitoring(peerConnection!);
  }

  @override
  void dispose() {
    _callManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(stream: statsService.costStream,
                builder: (context, snapshot) {
                  return Padding(padding:
                    const EdgeInsets.all(8),
                    child: Text(snapshot.data ?? "Calculating cost...", style: TextStyle(fontSize: 16)),
                  );
                },
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                child: RTCVideoView(_local),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all(color: Colors.green)),
                child: RTCVideoView(_remote),
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: _callManager.makeCall,
                    child: const Text('Call')),
                ElevatedButton(
                  onPressed: () {
                    // Add your button action here
                  },
                  child: const Text('End Call'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
