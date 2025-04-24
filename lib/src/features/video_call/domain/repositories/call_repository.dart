import 'package:block/src/features/video_call/domain/entities/participant.dart';

abstract class CallRepository {
  Future<void> joinRoom(String roomId);
  Future<void> leaveRoom(String roomId);
  Future<void> sendOffer(String peerId);
  Future<void> sendAnswer(String peerId);
  Future<void> muteAudio(String roomId);
  Future<void> unMuteAudio(String roomId);
  Future<void> muteVideo(String roomId);
  Future<void> unMuteVideo(String roomId);
  Future<void> switchCamera(String roomId);
  Future<void> endCall(String roomId);
  Future<void> sendMessage(String roomId, String message);
  Stream<List<Participant>> get participantStream;
}