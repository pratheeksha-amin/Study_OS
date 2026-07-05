class StudySessionModel {
  final int? id;
  final int subjectId;
  final int duration; // in minutes
  final DateTime date;
  final bool completed;

  StudySessionModel({
    this.id,
    required this.subjectId,
    required this.duration,
    required this.date,
    this.completed = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subjectId': subjectId,
      'duration': duration,
      'date': date.toIso8601String(),
      'completed': completed ? 1 : 0,
    };
  }

  factory StudySessionModel.fromMap(Map<String, dynamic> map) {
    return StudySessionModel(
      id: map['id'],
      subjectId: map['subjectId'],
      duration: map['duration'],
      date: DateTime.parse(map['date']),
      completed: map['completed'] == 1,
    );
  }
}
