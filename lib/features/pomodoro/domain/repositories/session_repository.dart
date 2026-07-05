import '../../data/models/study_session_model.dart';

abstract class SessionRepository {
  Future<List<StudySessionModel>> getSessions();
  Future<List<StudySessionModel>> getSessionsBySubject(int subjectId);
  Future<int> addSession(StudySessionModel session);
}
