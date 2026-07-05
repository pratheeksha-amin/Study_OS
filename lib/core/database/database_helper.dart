import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'focus_flow_v2.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Users Table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    // Subjects Table
    await db.execute('''
      CREATE TABLE subjects(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subjectName TEXT NOT NULL,
        totalTopics INTEGER NOT NULL,
        completedTopics INTEGER NOT NULL DEFAULT 0,
        xp INTEGER NOT NULL DEFAULT 0,
        priority TEXT NOT NULL,
        isSelectedForToday INTEGER NOT NULL DEFAULT 0,
        lastUpdated TEXT
      )
    ''');

    // Streaks Table
    await db.execute('''
      CREATE TABLE streaks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        currentStreak INTEGER NOT NULL DEFAULT 0,
        longestStreak INTEGER NOT NULL DEFAULT 0,
        totalXP INTEGER NOT NULL DEFAULT 0,
        lastStudyDate TEXT,
        topicsCompletedToday INTEGER NOT NULL DEFAULT 0
      )
    ''');
    
    // Initial Streak entry
    await db.insert('streaks', {
      'currentStreak': 0, 
      'longestStreak': 0, 
      'totalXP': 0,
      'topicsCompletedToday': 0
    });
  }
}
