import 'package:intl/intl.dart';

class EmotionRecord {
  final int? id;
  final int emotionId;
  final DateTime date;
  final String? note;

  EmotionRecord({
    this.id,
    required this.emotionId,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emotionId': emotionId,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'note': note,
    };
  }

  factory EmotionRecord.fromMap(Map<String, dynamic> map) {
    return EmotionRecord(
      id: map['id'],
      emotionId: map['emotionId'],
      date: DateFormat('yyyy-MM-dd').parse(map['date']),
      note: map['note'],
    );
  }
}
