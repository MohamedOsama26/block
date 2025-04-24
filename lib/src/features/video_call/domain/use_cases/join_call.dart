import 'package:block/src/features/video_call/domain/repositories/call_repository.dart';

class JoinCall {
  final CallRepository repo;

  JoinCall(this.repo);

  Future<void> call(String roomId) => repo.joinRoom(roomId);
}
