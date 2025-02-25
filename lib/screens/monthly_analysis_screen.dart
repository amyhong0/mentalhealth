import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/emotion.dart';
import '../models/emotion_record.dart';
import '../services/database_service.dart';
import '../widgets/emotion_chart.dart';
import '../widgets/emotion_calendar.dart';
import 'emotion_selection_screen.dart';

class MonthlyAnalysisScreen extends StatefulWidget {
  const MonthlyAnalysisScreen({Key? key}) : super(key: key);

  @override
  _MonthlyAnalysisScreenState createState() => _MonthlyAnalysisScreenState();
}

class _MonthlyAnalysisScreenState extends State<MonthlyAnalysisScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<EmotionRecord> _monthlyRecords = [];
  List<Emotion> _emotions = [];
  DateTime _selectedMonth = DateTime.now();
  bool _isLoading = true;
  Map<String, int> _emotionCounts = {};
  Map<String, int> _categoryCounts = {'긍정': 0, '부정': 0};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // 모든 감정 로드
    final emotions = await _databaseService.getAllEmotions();
    
    // 월간 기록 로드
    final monthlyRecords = await _databaseService.getMonthlyEmotionRecords(
      _selectedMonth.year,
      _selectedMonth.month,
    );
    
    // 감정별 카운트 계산
    Map<String, int> emotionCounts = {};
    Map<String, int> categoryCounts = {'긍정': 0, '부정': 0};
    
    for (var record in monthlyRecords) {
      final emotion = emotions.firstWhere((e) => e.id == record.emotionId);
      
      // 감정별 카운트
      if (emotionCounts.containsKey(emotion.name)) {
        emotionCounts[emotion.name] = emotionCounts[emotion.name]! + 1;
      } else {
        emotionCounts[emotion.name] = 1;
      }
      
      // 카테고리별 카운트
      categoryCounts[emotion.category] = categoryCounts[emotion.category]! + 1;
    }
    
    setState(() {
      _emotions = emotions;
      _monthlyRecords = monthlyRecords;
      _emotionCounts = emotionCounts;
      _categoryCounts = categoryCounts;
      _isLoading = false;
    });
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1, 1);
    });
    _loadData();
  }

  void _nextMonth() {
    final now = DateTime.now();
    final nextMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);
    
    if (nextMonth.year < now.year || 
        (nextMonth.year == now.year && nextMonth.month <= now.month)) {
      setState(() {
        _selectedMonth = nextMonth;
      });
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('월간 감정 분석'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMonthSelector(),
                    SizedBox(height: 24),
                    _buildMonthSummary(),
                    SizedBox(height: 24),
                    _buildEmotionCalendar(),
                    SizedBox(height: 24),
                    _buildCategoryChart(),
                    SizedBox(height: 24),
                    _buildEmotionChart(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMonthSelector() {
    final monthStr = DateFormat('yyyy년 MM월').format(_selectedMonth);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: _previousMonth,
        ),
        Text(
          monthStr,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: _nextMonth,
        ),
      ],
    );
  }

  Widget _buildMonthSummary() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '월간 요약',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '기록된 감정: ${_monthlyRecords.length}개',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '긍정적 감정: ${_categoryCounts['긍정']}개',
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
            SizedBox(height: 8),
            Text(
              '부정적 감정: ${_categoryCounts['부정']}개',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            SizedBox(height: 8),
            Text(
              '가장 많이 느낀 감정: ${_getMostFrequentEmotion()}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  String _getMostFrequentEmotion() {
    if (_emotionCounts.isEmpty) {
      return '없음';
    }
    
    String mostFrequent = '';
    int maxCount = 0;
    
    _emotionCounts.forEach((emotion, count) {
      if (count > maxCount) {
        maxCount = count;
        mostFrequent = emotion;
      }
    });
    
    return '$mostFrequent ($maxCount회)';
  }

  Widget _buildEmotionCalendar() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '감정 달력',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            EmotionCalendar(
              records: _monthlyRecords,
              emotions: _emotions,
              onDaySelected: (selectedDay) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmotionSelectionScreen(
                      date: selectedDay,
                    ),
                  ),
                ).then((_) => _loadData());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '감정 카테고리 분포',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            EmotionCategoryChart(
              categoryCounts: _categoryCounts,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '감정별 분포',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _emotionCounts.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('데이터가 없습니다'),
                    ),
                  )
                : EmotionPieChart(
                    emotionCounts: _emotionCounts,
                    emotions: _emotions,
                  ),
          ],
        ),
      ),
    );
  }
}
