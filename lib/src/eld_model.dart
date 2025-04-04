class EldModel {
  final DateTime? startTime;
  final DateTime? endTime;
  final int? dutyType;

  EldModel({required this.startTime, required this.endTime, this.dutyType});

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'dutyType': dutyType,
    };
  }

  factory EldModel.fromJson(Map<String, dynamic> json) {
    return EldModel(
      startTime: DateTime.parse(
        json['startTime'] ?? DateTime.now().toIso8601String(),
      ),
      endTime: DateTime.parse(
        json['endTime'] ?? DateTime.now().toIso8601String(),
      ),
      dutyType: json['dutyType'],
    );
  }

  @override
  String toString() => 'Start: $startTime, End: $endTime, eventType:$dutyType';
}
