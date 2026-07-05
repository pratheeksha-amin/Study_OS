import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../domain/repositories/session_repository.dart';
import '../models/study_session_model.dart';

class SessionRepositoryImpl implements SessionRepository {
  final DatabaseHelper _dbHelper;

  SessionRepositoryImpl(this._dbHelper);

  @override
  Future<List<StudySessionModel>> getSessions() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('study_sessions');
    return List.generate(maps.length, (i) => StudySessionModel.fromMap(maps[i]));
  }

  @override
  Future<List<StudySessionModel>> getSessionsBySubject(int subjectId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'study_sessions',
      where: 'subjectId = ?',
      whereArgs: [subjectId],
    );
    return List.generate(maps.length, (i) => StudySessionModel.fromMap(maps[i]));
  }

  @override
  Future<int> addSession(StudySessionModel session) async {
    final db = await _dbHelper.database;
    return await db.insert('study_sessions', session.toMap());
  }
}
