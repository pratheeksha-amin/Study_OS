import '../../../../core/database/database_helper.dart';
import '../../domain/repositories/subject_repository.dart';
import '../models/subject_model.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final DatabaseHelper _dbHelper;

  SubjectRepositoryImpl(this._dbHelper);

  @override
  Future<List<SubjectModel>> getSubjects() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('subjects');
    return List.generate(maps.length, (i) => SubjectModel.fromMap(maps[i]));
  }

  @override
  Future<int> addSubject(SubjectModel subject) async {
    final db = await _dbHelper.database;
    return await db.insert('subjects', subject.toMap());
  }

  @override
  Future<void> updateSubject(SubjectModel subject) async {
    final db = await _dbHelper.database;
    await db.update(
      'subjects',
      subject.toMap(),
      where: 'id = ?',
      whereArgs: [subject.id],
    );
  }

  @override
  Future<void> deleteSubject(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'subjects',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> toggleTodaySelection(int id, bool isSelected) async {
    final db = await _dbHelper.database;
    await db.update(
      'subjects',
      {'isSelectedForToday': isSelected ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
