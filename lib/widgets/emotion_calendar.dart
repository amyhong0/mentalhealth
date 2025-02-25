import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/emotion.dart';
import '../models/emotion_record.dart';

class EmotionCalendar extends StatefulWidget {
  final List<EmotionRecord> records;
  final List<Emotion> emotions;
  final Function(DateTime) onDaySelected;

  const EmotionCalendar({
    Key? key,
    required this.records,
    required this.emotions,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  _EmotionCalendarState createState() => _EmotionCalendarState();
}

class _EmotionCalendarState extends State<EmotionCalendar> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        widget.onDaySelected(selectedDay);
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          // 해당 날짜에 감정 기록이 있는지 확인
          final record = widget.records.firstWhere(
            (record) => isSameDay(record.date, date),
            orElse: () => EmotionRecord(
              emotionId: -1,
              date: date,
            ),
          );

          if (record.emotionId == -1) {
            return null;
          }

          // 감정 정보 가져오기
          final emotion = widget.emotions.firstWhere(
            (emotion) => emotion.id == record.emotionId,
            orElse: () => Emotion(
              id: 0,
              name: '알 수 없음',
              category: '기타',
              imagePath: '',
            ),
          );

          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: emotion.category == '긍정' ? Colors.green[200] : Colors.red[200],
            ),
            width: 8,
            height: 8,
          );
        },
      ),
    );
  }
}
