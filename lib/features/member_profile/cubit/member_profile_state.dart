import '../../../shared/models/models.dart';
import '../widgets/attendance_section.dart';
import '../widgets/tasks_section.dart';

enum MemberProfileStatus {
  initial,
  loading,
  success,
  failure,
  submittingEntry,
}

class MemberProfileState {
  final MemberProfileStatus status;
  final MemberModel? member;
  final MonthlyStatsModel? monthlyStats;
  final List<SessionRecordModel> sessionRecords;
  final String? errorMessage;
  final String? actionSuccessMessage;

  const MemberProfileState({
    this.status = MemberProfileStatus.initial,
    this.member,
    this.monthlyStats,
    this.sessionRecords = const [],
    this.errorMessage,
    this.actionSuccessMessage,
  });

  bool get isLoading => status == MemberProfileStatus.loading;
  bool get isSubmitting => status == MemberProfileStatus.submittingEntry;

  String get displayName => member?.displayName ?? '';
  int get mohsensCount => member?.stats.mohsensCount ?? 0;
  int get warningsCount => member?.stats.warningsCount ?? 0;
  double get scorePercent =>
      (monthlyStats?.scorePercent.toDouble() ?? 0.0).clamp(0.0, 1.0);

  List<TaskSessionItem> get taskSessionItems {
    if (sessionRecords.isEmpty) {
      return const [
        TaskSessionItem(sessionName: 'Session1', status: 'None'),
        TaskSessionItem(sessionName: 'Session2', status: 'None'),
        TaskSessionItem(sessionName: 'Session3', status: 'None'),
        TaskSessionItem(sessionName: 'Session4', status: 'None'),
      ];
    }
    return List.generate(sessionRecords.length, (index) {
      final record = sessionRecords[index];
      final name = record.sessionRef.isNotEmpty
          ? record.sessionRef
          : 'Session ${index + 1}';
      return TaskSessionItem(
        sessionName: name,
        status: _taskStatusToDisplay(record.taskStatus),
      );
    });
  }

  List<AttendanceSessionItem> get attendanceSessionItems {
    if (sessionRecords.isEmpty) {
      return const [
        AttendanceSessionItem(sessionName: 'Session1', status: 'On time'),
        AttendanceSessionItem(sessionName: 'Session2', status: 'On time'),
        AttendanceSessionItem(sessionName: 'Session3', status: 'On time'),
        AttendanceSessionItem(sessionName: 'Session4', status: 'On time'),
      ];
    }
    return List.generate(sessionRecords.length, (index) {
      final record = sessionRecords[index];
      final name = record.sessionRef.isNotEmpty
          ? record.sessionRef
          : 'Session ${index + 1}';
      return AttendanceSessionItem(
        sessionName: name,
        status: _attendanceStatusToDisplay(record.attendanceStatus),
      );
    });
  }

  Map<String, bool> get sessionTraitsChecked {
    final traits = member?.traits ?? const MemberTraits();
    return {
      'Activeness': traits.activeness > 0,
      'Teamwork': traits.teamwork > 0,
      'Flexibility': traits.flexibility > 0,
      'Good attitude': traits.goodAttitude > 0,
      'Bad attitude': traits.badAttitude > 0,
    };
  }

  static String _taskStatusToDisplay(TaskStatus status) {
    switch (status) {
      case TaskStatus.completedEarly:
        return 'Completed early';
      case TaskStatus.lateExcused:
        return 'Late excused';
      case TaskStatus.notDelivered:
        return 'Not delivered';
      case TaskStatus.none:
        return 'None';
    }
  }

  static TaskStatus displayToTaskStatus(String status) {
    switch (status) {
      case 'Completed early':
        return TaskStatus.completedEarly;
      case 'Late excused':
        return TaskStatus.lateExcused;
      case 'Not delivered':
        return TaskStatus.notDelivered;
      case 'None':
      default:
        return TaskStatus.none;
    }
  }

  static String _attendanceStatusToDisplay(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.onTime:
        return 'On time';
      case AttendanceStatus.lateExcused:
        return 'Late excused';
      case AttendanceStatus.lateUnexcused:
        return 'Late unexcused';
      case AttendanceStatus.absentExcused:
        return 'Absent excused';
    }
  }

  static AttendanceStatus displayToAttendanceStatus(String status) {
    switch (status) {
      case 'On time':
        return AttendanceStatus.onTime;
      case 'Late excused':
        return AttendanceStatus.lateExcused;
      case 'Late unexcused':
        return AttendanceStatus.lateUnexcused;
      case 'Absent excused':
      default:
        return AttendanceStatus.absentExcused;
    }
  }

  MemberProfileState copyWith({
    MemberProfileStatus? status,
    MemberModel? member,
    MonthlyStatsModel? monthlyStats,
    List<SessionRecordModel>? sessionRecords,
    String? errorMessage,
    String? actionSuccessMessage,
    bool clearActionMessage = false,
    bool clearErrorMessage = false,
  }) {
    return MemberProfileState(
      status: status ?? this.status,
      member: member ?? this.member,
      monthlyStats: monthlyStats ?? this.monthlyStats,
      sessionRecords: sessionRecords ?? this.sessionRecords,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      actionSuccessMessage: clearActionMessage
          ? null
          : (actionSuccessMessage ?? this.actionSuccessMessage),
    );
  }
}
