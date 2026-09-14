import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/models/models.dart';
import '../../../shared/repositories/members/firestore_members_repository.dart';
import '../../../shared/repositories/members/members_repository.dart';
import '../../../shared/repositories/mohsens/firestore_mohsens_repository.dart';
import '../../../shared/repositories/mohsens/mohsens_repository.dart';
import '../../../shared/repositories/stats/firestore_stats_repository.dart';
import '../../../shared/repositories/stats/stats_repository.dart';
import 'member_profile_state.dart';

class MemberProfileCubit extends Cubit<MemberProfileState> {
  final MembersRepository? _membersRepository;
  final MohsensRepository? _mohsensRepository;
  final StatsRepository? _statsRepository;

  MemberProfileCubit({
    MembersRepository? membersRepository,
    MohsensRepository? mohsensRepository,
    StatsRepository? statsRepository,
  })  : _membersRepository = membersRepository ??
            (Firebase.apps.isNotEmpty ? FirestoreMembersRepository() : null),
        _mohsensRepository = mohsensRepository ??
            (Firebase.apps.isNotEmpty ? FirestoreMohsensRepository() : null),
        _statsRepository = statsRepository ??
            (Firebase.apps.isNotEmpty ? FirestoreStatsRepository() : null),
        super(const MemberProfileState());

  // Loads member data, monthly stats, and session records
  Future<void> loadMemberProfile({
    required String committeeId,
    required String memberId,
    MemberModel? initialMember,
  }) async {
    try {
      if (initialMember != null) {
        emit(state.copyWith(
          status: MemberProfileStatus.loading,
          member: initialMember,
        ));
      } else {
        emit(state.copyWith(status: MemberProfileStatus.loading));
      }

      MemberModel? member = initialMember;
      final membersRepo = _membersRepository;
      if (membersRepo != null) {
        try {
          final fetched = await membersRepo.getMember(
            committeeId: committeeId,
            uid: memberId,
          );
          if (fetched != null) {
            member = fetched;
          }
        } catch (e) {
          debugPrint('Could not fetch member from Firestore: $e');
        }
      }

      if (member == null) {
        emit(state.copyWith(
          status: MemberProfileStatus.failure,
          errorMessage: 'Member not found',
        ));
        return;
      }

      // Monthly stats for current month
      final now = DateTime.now();
      final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      MonthlyStatsModel? monthlyStats;
      final statsRepo = _statsRepository;
      if (statsRepo != null) {
        try {
          monthlyStats = await statsRepo.getMemberMonthlyStats(
            committeeId: committeeId,
            uid: memberId,
            monthKey: monthKey,
          );
        } catch (_) {}
      }

      // Session records for attendance and tasks
      List<SessionRecordModel> sessionRecords = const [];
      if (statsRepo != null) {
        try {
          sessionRecords = await statsRepo.getSessionRecords(
            committeeId: committeeId,
            uid: memberId,
          );
        } catch (_) {}
      }

      emit(state.copyWith(
        status: MemberProfileStatus.success,
        member: member,
        monthlyStats: monthlyStats,
        sessionRecords: sessionRecords,
      ));
    } catch (e) {
      if (state.member != null || initialMember != null) {
        emit(state.copyWith(
          status: MemberProfileStatus.success,
          member: state.member ?? initialMember,
        ));
      } else {
        emit(state.copyWith(
          status: MemberProfileStatus.failure,
          errorMessage: 'Failed to load member profile: ${e.toString()}',
        ));
      }
    }
  }

  // Adds a Mohsen or Warning entry
  Future<bool> addMohsenOrWarning({
    required String committeeId,
    required String memberId,
    required String title,
    required int value,
    required String reason,
    required bool isMohsen,
    String? actorName,
    String? actorRole,
  }) async {
    try {
      emit(state.copyWith(status: MemberProfileStatus.submittingEntry));

      final mohsensRepo = _mohsensRepository;
      final membersRepo = _membersRepository;
      if (mohsensRepo == null || membersRepo == null) {
        final currentMember = state.member;
        final updatedStats = currentMember?.stats.copyWith(
          mohsensCount: isMohsen
              ? (currentMember.stats.mohsensCount + value)
              : currentMember.stats.mohsensCount,
          warningsCount: !isMohsen
              ? (currentMember.stats.warningsCount + value)
              : currentMember.stats.warningsCount,
          lastUpdatedAt: DateTime.now(),
        );
        final updatedMember = currentMember?.copyWith(stats: updatedStats);
        emit(state.copyWith(
          status: MemberProfileStatus.success,
          member: updatedMember,
          actionSuccessMessage:
              '${isMohsen ? "Mohsen" : "Warning"} "$title" (+$value) added',
        ));
        return true;
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      final effectiveActorId = currentUser?.uid ?? 'hr_user';
      final effectiveActorName = actorName ??
          (currentUser?.displayName?.isNotEmpty == true
              ? currentUser!.displayName!
              : 'HR');
      final effectiveActorRole = actorRole ?? 'hr';

      final entry = MohsenEntryModel(
        id: '',
        memberId: memberId,
        committeeId: committeeId,
        type: isMohsen ? MohsenType.mohsen : MohsenType.warning,
        title: title,
        value: value,
        reason: reason,
        addedBy: effectiveActorId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await mohsensRepo.addMohsenEntry(
        committeeId: committeeId,
        memberId: memberId,
        entry: entry,
        actorName: effectiveActorName,
        actorRole: effectiveActorRole,
        notificationTitle: title.isNotEmpty
            ? title
            : (isMohsen ? 'New Mohsen' : 'New Warning'),
        notificationMessage: reason.isNotEmpty ? reason : null,
      );

      // Re-fetch member from Firestore to get updated count
      MemberModel? updatedMember;
      try {
        updatedMember = await membersRepo.getMember(
          committeeId: committeeId,
          uid: memberId,
        );
      } catch (_) {}

      // Fallback for local update if document is not in Firestore yet
      if (updatedMember == null && state.member != null) {
        final currentMember = state.member!;
        final updatedStats = currentMember.stats.copyWith(
          mohsensCount: isMohsen
              ? (currentMember.stats.mohsensCount + value)
              : currentMember.stats.mohsensCount,
          warningsCount: !isMohsen
              ? (currentMember.stats.warningsCount + value)
              : currentMember.stats.warningsCount,
          lastUpdatedAt: DateTime.now(),
        );
        updatedMember = currentMember.copyWith(stats: updatedStats);
      }

      emit(state.copyWith(
        status: MemberProfileStatus.success,
        member: updatedMember ?? state.member,
        actionSuccessMessage:
            '${isMohsen ? "Mohsen" : "Warning"} "$title" (+$value) added successfully',
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(
        status: MemberProfileStatus.failure,
        errorMessage: 'Failed to add ${isMohsen ? "Mohsen" : "Warning"}: ${e.toString()}',
      ));
      return false;
    }
  }

  static List<SessionRecordModel> _createDefaultSessionRecords() {
    final now = DateTime.now();
    return List.generate(
      4,
      (i) => SessionRecordModel(
        sessionId: 'session_${i + 1}',
        sessionRef: 'Session ${i + 1}',
        sessionType: SessionType.meeting,
        attendanceStatus: AttendanceStatus.onTime,
        taskStatus: TaskStatus.none,
        recordedBy: 'system',
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  // Updates task status for a session
  void updateTaskStatus(int index, String newStatus) {
    List<SessionRecordModel> records = state.sessionRecords.isNotEmpty
        ? List<SessionRecordModel>.from(state.sessionRecords)
        : _createDefaultSessionRecords();

    if (index >= 0 && index < records.length) {
      records[index] = records[index].copyWith(
        taskStatus: MemberProfileState.displayToTaskStatus(newStatus),
        updatedAt: DateTime.now(),
      );
      emit(state.copyWith(sessionRecords: records));
    }
  }

  // Updates attendance status for a session
  void updateAttendanceStatus(int index, String newStatus) {
    List<SessionRecordModel> records = state.sessionRecords.isNotEmpty
        ? List<SessionRecordModel>.from(state.sessionRecords)
        : _createDefaultSessionRecords();

    if (index >= 0 && index < records.length) {
      records[index] = records[index].copyWith(
        attendanceStatus:
            MemberProfileState.displayToAttendanceStatus(newStatus),
        updatedAt: DateTime.now(),
      );
      emit(state.copyWith(sessionRecords: records));
    }
  }

  void clearActionMessage() {
    emit(state.copyWith(clearActionMessage: true));
  }

  void clearErrorMessage() {
    emit(state.copyWith(clearErrorMessage: true));
  }
}
