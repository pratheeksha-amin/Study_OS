import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/smart_planner_service.dart';
import '../../../../features/subjects/presentation/providers/subject_provider.dart';

final dailyPlanProvider = Provider<List<DailyPlan>>((ref) {
  final selectedSubjects = ref.watch(selectedSubjectsProvider);
  return SmartPlannerService.calculatePlan(selectedSubjects);
});
