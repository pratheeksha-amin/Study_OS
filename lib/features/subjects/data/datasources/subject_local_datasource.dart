import '../../../../core/database/database_helper.dart';
import '../models/subject_model.dart';

class SubjectLocalDataSource {
  Future<void> insertSubject(SubjectModel subject) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'subjects',
      subject.toMap(),
    );
  }

  Future<List<SubjectModel>> getSubjects() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query('subjects');

    return result
        .map((e) => SubjectModel.fromMap(e))
        .toList();
  }

  Future<void> deleteSubject(int id) async {
    final db = await DatabaseHelper.instance.database;

    await db.delete(
      'subjects',
      where: 'id=?',
      whereArgs: [id],
    );
  }
}