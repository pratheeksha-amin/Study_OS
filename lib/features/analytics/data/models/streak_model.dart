class StreakModel {
  final int? id;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastStudyDate;

  StreakModel({
    this.id,
    required this.currentStreak,
    required this.longestStreak,
    this.lastStudyDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastStudyDate': lastStudyDate?.toIso8601String(),
    };
  }

  factory StreakModel.fromMap(Map<String, dynamic> map) {
    return StreakModel(
      id: map['id'],
      currentStreak: map['currentStreak'],
      longestStreak: map['longestStreak'],
      lastStudyDate: map['lastStudyDate'] != null ? DateTime.parse(map['lastStudyDate']) : null,
    );
  }
}
