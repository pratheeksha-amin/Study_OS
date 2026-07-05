import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_helper.dart';
import '../../data/models/subject_model.dart';
import '../../data/repositories/subject_repository_impl.dart';
import '../../domain/repositories/subject_repository.dart';

final subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  return SubjectRepositoryImpl(DatabaseHelper.instance);
});

final subjectsProvider = StateNotifierProvider<SubjectNotifier, AsyncValue<List<SubjectModel>>>((ref) {
  return SubjectNotifier(ref.watch(subjectRepositoryProvider));
});

class SubjectNotifier extends StateNotifier<AsyncValue<List<SubjectModel>>> {
  final SubjectRepository _repository;

  SubjectNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadSubjects();
  }

  Future<void> loadSubjects() async {
    state = const AsyncValue.loading();
    try {
      final subjects = await _repository.getSubjects();
      state = AsyncValue.data(subjects);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addSubject(SubjectModel subject) async {
    await _repository.addSubject(subject);
    await loadSubjects();
  }

  Future<void> updateSubject(SubjectModel subject) async {
    await _repository.updateSubject(subject);
    await loadSubjects();
  }

  Future<void> deleteSubject(int id) async {
    await _repository.deleteSubject(id);
    await loadSubjects();
  }

  Future<void> toggleTodaySelection(int id, bool isSelected) async {
    await _repository.toggleTodaySelection(id, isSelected);
    await loadSubjects();
  }
}

final selectedSubjectsProvider = Provider<List<SubjectModel>>((ref) {
  final subjectsAsync = ref.watch(subjectsProvider);
  return subjectsAsync.maybeWhen(
    data: (subjects) => subjects.where((s) => s.isSelectedForToday).toList(),
    orElse: () => [],
  );
});
