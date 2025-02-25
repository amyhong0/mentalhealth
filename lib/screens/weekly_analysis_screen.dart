import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/emotion.dart';
import '../models/emotion_record.dart';
import '../services/database_service.dart';
import '../widgets/emotion_card.dart';

class EmotionSelectionScreen extends StatefulWidget {
  final DateTime? date;

  const EmotionSelectionScreen({
    Key? key,
    this.date,
  }) : super(key: key);

  @override
  _EmotionSelectionScreenState createState() => _EmotionSelectionScreenState();
}

class _EmotionSelectionScreenState extends State<EmotionSelectionScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Emotion> _emotions = [];
  int? _selectedEmotionId;
  bool _isLoading = true;
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  EmotionRecord? _existingRecord;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date ?? DateTime.now();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // 감정 목록 로드
    final emotions = await _databaseService.getAllEmotions();
    
    // 선택한 날짜의 기존 기록 확인
    final record = await _databaseService.getEmotionRecordByDate(_selectedDate);
    
    setState(() {
      _emotions = emotions;
      _existingRecord = record;
      
      if (record != null) {
        _selectedEmotionId = record.emotionId;
        _noteController.text = record.note ?? '';
      }
      
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('감정 선택'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _selectedEmotionId != null ? _saveEmotionRecord : null,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildDateHeader(),
                Expanded(
                  child: _buildEmotionGrid(),
                ),
                _buildNoteInput(),
              ],
            ),
    );
  }

  Widget _buildDateHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Text(
        DateFormat('yyyy년 MM월 dd일 EEEE', 'ko_KR').format(_selectedDate),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmotionGrid() {
    // 긍정적 감정과 부정적 감정 분리
    final positiveEmotions = _emotions.where((e) => e.category == '긍정').toList();
    final negativeEmotions = _emotions.where((e) => e.category == '부정').toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sentiment_satisfied, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      '긍정적 감정',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sentiment_dissatisfied, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      '부정적 감정',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildEmotionGridView(positiveEmotions),
                _buildEmotionGridView(negativeEmotions),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionGridView(List<Emotion> emotions) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: emotions.length,
      itemBuilder: (context, index) {
        final emotion = emotions[index];
        return EmotionCard(
          emotion: emotion,
          isSelected: _selectedEmotionId == emotion.id,
          onSelect: () {
            setState(() {
              _selectedEmotionId = emotion.id;
            });
          },
        );
      },
    );
  }

  Widget _buildNoteInput() {
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        controller: _noteController,
        decoration: InputDecoration(
          labelText: '메모',
          hintText: '오늘의 감정에 대한 메모를 남겨보세요',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
      ),
    );
  }

  Future<void> _saveEmotionRecord() async {
    if (_selectedEmotionId == null) return;

    final record = EmotionRecord(
      id: _existingRecord?.id,
      emotionId: _selectedEmotionId!,
      date: _selectedDate,
      note: _noteController.text,
    );

    await _databaseService.insertEmotionRecord(record);
    Navigator.pop(context);
  }
}
