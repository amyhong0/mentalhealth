import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
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
    final endDate = startDate
