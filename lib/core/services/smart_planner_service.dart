import '../../features/subjects/data/models/subject_model.dart';

class DailyPlan {
  final SubjectModel subject;
  final int targetTopics;
  final int estimatedMinutes;

  DailyPlan({
    required this.subject,
    required this.targetTopics,
    required this.estimatedMinutes,
  });
}

class SmartPlannerService {
  static List<DailyPlan> calculatePlan(List<SubjectModel> selectedSubjects) {
    List<DailyPlan> plan = [];

    for (var subject in selectedSubjects) {
      final remainingTopics = subject.totalTopics - subject.completedTopics;
      if (remainingTopics <= 0) continue;

      // Basic logic: Try to finish in 30 days if no exam date, otherwise use exam date
      int daysRemaining = 30;
      if (subject.examDate != null) {
        daysRemaining = subject.examDate!.difference(DateTime.now()).inDays;
        if (daysRemaining <= 0) daysRemaining = 1;
      }

      double priorityWeight = 1.0;
      switch (subject.priority.toLowerCase()) {
        case 'high':
          priorityWeight = 1.5;
          break;
        case 'low':
          priorityWeight = 0.7;
          break;
        default:
          priorityWeight = 1.0;
      }

      // Calculate base target
      int target = (remainingTopics / daysRemaining * priorityWeight).ceil();
      if (target > remainingTopics) target = remainingTopics;
      if (target == 0 && remainingTopics > 0) target = 1;

      // Estimate time: 45 mins per topic base
      int estimatedTime = target * 45;

      plan.add(DailyPlan(
        subject: subject,
        targetTopics: target,
        estimatedMinutes: estimatedTime,
      ));
    }

    return plan;
  }
}
