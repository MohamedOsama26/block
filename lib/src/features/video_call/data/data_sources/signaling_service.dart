import 'package:block/src/utils/constants/servers_urls.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SignalingService {
  final String roomId;
  late io.Socket socket;

  SignalingService(this.roomId);

  // Method to connect to the signaling server
  void connect({
    required void Function(dynamic data) onOffer,
    required void Function(dynamic data) onAnswer,
    required void Function(dynamic data) onIceCandidate,
  }) {
    socket = io.io(ServersUrls.socketServerUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((_) {
      print('Socket connected: ${socket.id}');
      socket.emit('join_room', roomId);
    });
    socket.on('offer', (data) {
      print('Received offer');
      onOffer(data);
    });
    socket.on('answer', (data) {
      print('Received answer');
      onAnswer(data);
    });
    socket.on('ice-candidate', (data) {
      print('Received ICE candidate: ${data['candidate']}');
      // onIceCandidate();
    });
  }

  void sendOffer(Map<String, dynamic> data) {
    socket.emit('offer', data);
  }

  void sendAnswer(Map<String, dynamic> data) {
    socket.emit('answer', data);
  }

  void sendIceCandidate(Map<String, dynamic> data) {
    socket.emit('ice-candidate', data);
  }

  void callUser(String calleeId, String roomId) {
    socket.emit('call_user', {
      'to': calleeId,
      'roomId': roomId,
    });
  }

  void dispose() {
    socket.dispose();
  }

// // Method to send a message
// void sendMessage(String message) {
//   // Message sending logic here
// }
//
// // Method to receive messages
// void onMessageReceived(Function(String message) callback) {
//   // Message receiving logic here
// }
}
