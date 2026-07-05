import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_helper.dart';
import '../../data/models/study_session_model.dart';
import '../../data/repositories/session_repository_impl.dart';
import '../../domain/repositories/session_repository.dart';

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepositoryImpl(DatabaseHelper.instance);
});

enum PomodoroStatus { idle, studying, shortBreak, longBreak }

class PomodoroState {
  final int timeLeft;
  final PomodoroStatus status;
  final int? activeSubjectId;

  PomodoroState({
    required this.timeLeft,
    required this.status,
    this.activeSubjectId,
  });

  PomodoroState copyWith({
    int? timeLeft,
    PomodoroStatus? status,
    int? activeSubjectId,
  }) {
    return PomodoroState(
      timeLeft: timeLeft ?? this.timeLeft,
      status: status ?? this.status,
      activeSubjectId: activeSubjectId ?? this.activeSubjectId,
    );
  }
}

final pomodoroProvider = StateNotifierProvider<PomodoroNotifier, PomodoroState>((ref) {
  return PomodoroNotifier(ref.read(sessionRepositoryProvider));
});

class PomodoroNotifier extends StateNotifier<PomodoroState> {
  final SessionRepository _repository;
  Timer? _timer;

  PomodoroNotifier(this._repository)
      : super(PomodoroState(timeLeft: 25 * 60, status: PomodoroStatus.idle));

  void startStudy(int subjectId) {
    _timer?.cancel();
    state = state.copyWith(
      status: PomodoroStatus.studying,
      timeLeft: 25 * 60,
      activeSubjectId: subjectId,
    );
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft > 0) {
        state = state.copyWith(timeLeft: state.timeLeft - 1);
      } else {
        _timer?.cancel();
        _onWorkComplete();
      }
    });
  }

  void _onWorkComplete() async {
    if (state.status == PomodoroStatus.studying && state.activeSubjectId != null) {
      await _repository.addSession(StudySessionModel(
        subjectId: state.activeSubjectId!,
        duration: 25,
        date: DateTime.now(),
      ));
      
      state = state.copyWith(
        status: PomodoroStatus.shortBreak,
        timeLeft: 5 * 60,
      );
      _startTimer();
    } else {
      state = state.copyWith(
        status: PomodoroStatus.idle,
        timeLeft: 25 * 60,
      );
    }
  }

  void reset() {
    _timer?.cancel();
    state = PomodoroState(timeLeft: 25 * 60, status: PomodoroStatus.idle);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
