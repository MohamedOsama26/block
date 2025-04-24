class ParticipantModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? streamId;

  ParticipantModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.streamId,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      streamId: json['streamId'] as String?,
    );
  }
}
