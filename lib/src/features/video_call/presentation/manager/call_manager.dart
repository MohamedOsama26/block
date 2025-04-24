import 'dart:async';
import 'package:block/src/features/video_call/data/data_sources/signaling_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallManager {
  final String roomId;
  final SignalingService signalingService;
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;


  String status = 'Idle';

  int sent = 0;
  int received = 0;

  CallManager({
    required this.roomId,
    required this.localRenderer,
    required this.remoteRenderer,
  }) : signalingService = SignalingService(roomId);

  void init() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
    await _initMedia();
    await _createPeerConnection();
    _connectSignaling();
    // _statsService = StatsService(peerConnection: peerConnection!);
  }

  Future<void> _initMedia() async {
    localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {
        'facingMode': 'user',
        'width': 640,
        'height': 480,
        'frameRate': {'ideal': 15},
      },
    });
    localRenderer.srcObject = localStream;
  }

  Future<void> _createPeerConnection() async {
    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };

    peerConnection = await createPeerConnection(config);

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    await Future.delayed(Duration(milliseconds: 100)); // optional: wait for sender registration

    final senders = await peerConnection!
        .getSenders();

    final sender = senders
        .firstWhere((s) => s.track?.kind == 'video',);

    var params = sender.parameters;
    params.encodings = [RTCRtpEncoding(maxBitrate: 300000)]; // ~300 kbps
    await sender.setParameters(params);

    peerConnection?.onConnectionState = (state) {
      print("Connection state: $state");
      // serStatus("Connection state: $state");
    };

    peerConnection?.onTrack = (event) {
      print('onTrack: ${event.track.kind}');
      if (event.streams.isNotEmpty) {
        print('Setting remote stream...');
        remoteRenderer.srcObject = event.streams[0];
      }
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      print('Received remote stream');
      remoteRenderer.srcObject = stream;
    };

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      signalingService.sendIceCandidate({
        'roomId': roomId,
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };
  }

  void _connectSignaling() {
    signalingService.connect(
      onOffer: (data) async {
        await peerConnection?.setRemoteDescription(
          RTCSessionDescription(data['sdp'], data['type']),
        );
        final answer = await peerConnection?.createAnswer();
        await peerConnection?.setLocalDescription(answer!);
        signalingService.sendAnswer({
          'roomId': roomId,
          'sdp': answer?.sdp,
          'type': answer?.type,
        });
      },
      onAnswer: (data) async {
        await peerConnection?.setRemoteDescription(
          RTCSessionDescription(data['sdp'], data['type']),
        );
      },
      onIceCandidate: (data) async {
        await peerConnection?.addCandidate(
          RTCIceCandidate(
            data['candidate'],
            data['sdpMid'],
            data['sdpMLineIndex'],
          ),
        );
      },
    );
  }

  Future<void> makeCall() async {
    final offer = await peerConnection!.createOffer();
    await peerConnection?.setLocalDescription(offer);
    signalingService.sendOffer({
      'roomId': roomId,
      'sdp': offer.sdp,
      'type': offer.type,
    });
    // statsService?.startMonitoring(() {
    //   sent = statsService.totalBytesSent;
    //   received = statsService.totalBytesReceived;
    //   print(
    //     'Sent: $sent bytes, Received: $received bytes,\n'
    //         'Cost: ${statsService.estimatedCost} USD,\n'
    //         'Total MB: ${statsService.totalMB} MB.',
    //   );
    // });
  }

  void dispose() {
    signalingService.dispose();
    peerConnection?.dispose();
    localStream?.dispose();
    localRenderer.dispose();
    remoteRenderer.dispose();
    // statsService.stopMonitoring();
  }
}
