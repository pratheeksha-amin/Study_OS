import '../../data/models/subject_model.dart';

abstract class SubjectRepository {
  Future<List<SubjectModel>> getSubjects();
  Future<int> addSubject(SubjectModel subject);
  Future<void> updateSubject(SubjectModel subject);
  Future<void> deleteSubject(int id);
  Future<void> toggleTodaySelection(int id, bool isSelected);
}
