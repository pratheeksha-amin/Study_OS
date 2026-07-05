class SubjectModel {
  final int? id;
  final String subjectName;
  final int totalTopics;
  final int completedTopics;
  final int xp;
  final String priority;
  final bool isSelectedForToday;
  final DateTime? lastUpdated;

  SubjectModel({
    this.id,
    required this.subjectName,
    required this.totalTopics,
    this.completedTopics = 0,
    this.xp = 0,
    required this.priority,
    this.isSelectedForToday = false,
    this.lastUpdated,
  });

  int get remainingTopics => totalTopics - completedTopics;
  double get progressPercentage => totalTopics == 0 ? 0 : (completedTopics / totalTopics) * 100;

  SubjectModel copyWith({
    int? id,
    String? subjectName,
    int? totalTopics,
    int? completedTopics,
    int? xp,
    String? priority,
    bool? isSelectedForToday,
    DateTime? lastUpdated,
  }) {
    return SubjectModel(
      id: id ?? this.id,
      subjectName: subjectName ?? this.subjectName,
      totalTopics: totalTopics ?? this.totalTopics,
      completedTopics: completedTopics ?? this.completedTopics,
      xp: xp ?? this.xp,
      priority: priority ?? this.priority,
      isSelectedForToday: isSelectedForToday ?? this.isSelectedForToday,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subjectName': subjectName,
      'totalTopics': totalTopics,
      'completedTopics': completedTopics,
      'xp': xp,
      'priority': priority,
      'isSelectedForToday': isSelectedForToday ? 1 : 0,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'],
      subjectName: map['subjectName'],
      totalTopics: map['totalTopics'],
      completedTopics: map['completedTopics'],
      xp: map['xp'] ?? 0,
      priority: map['priority'] ?? 'Medium',
      isSelectedForToday: map['isSelectedForToday'] == 1,
      lastUpdated: map['lastUpdated'] != null ? DateTime.parse(map['lastUpdated']) : null,
    );
  }
}
