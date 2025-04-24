import 'package:flutter_webrtc/flutter_webrtc.dart';

class Participant {
  final String id;
  final MediaStream? stream;
  final String? name;
  final String? imageUrl;

  Participant({
    required this.id,
    this.stream,
    this.name,
    this.imageUrl,
  });
}