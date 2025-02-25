import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import '../models/emotion.dart';
import '../models/emotion_record.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mindwave.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE emotions(
        id INTEGER PRIMARY KEY,
        name TEXT,
        category TEXT,
        imagePath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE emotion_records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        emotionId INTEGER,
        date TEXT,
        note TEXT,
        FOREIGN KEY(emotionId) REFERENCES emotions(id)
      )
    ''');

    // 미리 정의된 감정 데이터 삽입
    for (var emotion in predefinedEmotions) {
      await db.insert('emotions', emotion.toMap());
    }
  }

  // 감정 기록 추가
  Future<int> insertEmotionRecord(EmotionRecord record) async {
    final db = await database;
    
    // 같은 날짜의 기존 기록이 있는지 확인
    final existingRecord = await getEmotionRecordByDate(record.date);
    
    if (existingRecord != null) {
      // 기존 기록 업데이트
      return await db.update(
        'emotion_records',
        record.toMap(),
        where: 'id = ?',
        whereArgs: [existingRecord.id],
      );
    } else {
      // 새 기록 삽입
      return await db.insert('emotion_records', record.toMap());
    }
  }

  // 특정 날짜의 감정 기록 가져오기
  Future<EmotionRecord?> getEmotionRecordByDate(DateTime date) async {
    final db = await database;
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    
    final List<Map<String, dynamic>> maps = await db.query(
      'emotion_records',
      where: 'date = ?',
      whereArgs: [dateStr],
    );

    if (maps.isNotEmpty) {
      return EmotionRecord.fromMap(maps.first);
    }
    return null;
  }

  // 주별 감정 기록 가져오기
  Future<List<EmotionRecord>> getWeeklyEmotionRecords(DateTime startDate) async {
    final db = await database;
    final endDate = startDate.add(Duration(days: 6));
    
    final startDateStr = DateFormat('yyyy-MM-dd').format(startDate);
    final endDateStr = DateFormat('yyyy-MM-dd').format(endDate);
    
    final List<Map<String, dynamic>> maps = await db.query(
      'emotion_records',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDateStr, endDateStr],
    );

    return List.generate(maps.length, (i) {
      return EmotionRecord.fromMap(maps[i]);
    });
  }

  // 월별 감정 기록 가져오기
  Future<List<EmotionRecord>> getMonthlyEmotionRecords(int year, int month) async {
    final db = await database;
    final startDate = DateTime(year, month, 1);
    final endDate = (month < 12) 
        ? DateTime(year, month + 1, 0)
        : DateTime(year + 1, 1, 0);
    
    final startDateStr = DateFormat('yyyy-MM-dd').format(startDate);
    final endDateStr = DateFormat('yyyy-MM-dd').format(endDate);
    
    final List<Map<String, dynamic>> maps = await db.query(
      'emotion_records',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDateStr, endDateStr],
    );

    return List.generate(maps.length, (i) {
      return EmotionRecord.fromMap(maps[i]);
    });
  }

  // 감정 정보 가져오기
  Future<Emotion> getEmotionById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'emotions',
      where: 'id = ?',
      whereArgs: [id],
    );

    return Emotion.fromMap(maps.first);
  }

  // 모든 감정 가져오기
  Future<List<Emotion>> getAllEmotions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('emotions');

    return List.generate(maps.length, (i) {
      return Emotion.fromMap(maps[i]);
    });
  }
  
  // 특정 기간의 감정 통계 가져오기
  Future<Map<String, int>> getEmotionStats(DateTime startDate, DateTime endDate) async {
    final records = await getRecordsBetweenDates(startDate, endDate);
    Map<String, int> stats = {};
    
    for (var record in records) {
      final emotion = await getEmotionById(record.emotionId);
      if (stats.containsKey(emotion.name)) {
        stats[emotion.name] = stats[emotion.name]! + 1;
      } else {
        stats[emotion.name] = 1;
      }
    }
    
    return stats;
  }
  
  // 특정 기간의 감정 카테고리 통계 가져오기
  Future<Map<String, int>> getEmotionCategoryStats(DateTime startDate, DateTime endDate) async {
    final records = await getRecordsBetweenDates(startDate, endDate);
    Map<String, int> stats = {'긍정': 0, '부정': 0};
    
    for (var record in records) {
      final emotion = await getEmotionById(record.emotionId);
      stats[emotion.category] = stats[emotion.category]! + 1;
    }
    
    return stats;
  }
  
  // 특정 기간의 기록 가져오기
  Future<List<EmotionRecord>> getRecordsBetweenDates(DateTime startDate, DateTime endDate) async {
    final db = await database;
    
    final startDateStr = DateFormat('yyyy-MM-dd').format(startDate);
    final endDateStr = DateFormat('yyyy-MM-dd').format(endDate);
    
    final List<Map<String, dynamic>> maps = await db.query(
      'emotion_records',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDateStr, endDateStr],
    );

    return List.generate(maps.length, (i) {
      return EmotionRecord.fromMap(maps[i]);
    });
  }
}
