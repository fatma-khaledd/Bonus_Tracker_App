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
      final actionWord = value < 0 ? 'removed' : 'added';
      final formattedVal = value > 0 ? '+$value' : '$value';

      if (mohsensRepo == null || membersRepo == null) {
        final currentMember = state.member;
        final newMohsens = isMohsen
            ? (currentMember != null &&
                    currentMember.stats.mohsensCount + value < 0
                ? 0
                : (currentMember?.stats.mohsensCount ?? 0) + value)
            : (currentMember?.stats.mohsensCount ?? 0);
        final newWarnings = !isMohsen
            ? (currentMember != null &&
                    currentMember.stats.warningsCount + value < 0
                ? 0
                : (currentMember?.stats.warningsCount ?? 0) + value)
            : (currentMember?.stats.warningsCount ?? 0);
        final updatedStats = currentMember?.stats.copyWith(
          mohsensCount: newMohsens,
          warningsCount: newWarnings,
          lastUpdatedAt: DateTime.now(),
        );
        final updatedMember = currentMember?.copyWith(stats: updatedStats);
        emit(state.copyWith(
          status: MemberProfileStatus.success,
          member: updatedMember,
          actionSuccessMessage:
              '${isMohsen ? "Mohsen" : "Warning"} "$title" ($formattedVal) $actionWord',
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
        final newMohsens = isMohsen
            ? (currentMember.stats.mohsensCount + value < 0
                ? 0
                : currentMember.stats.mohsensCount + value)
            : currentMember.stats.mohsensCount;
        final newWarnings = !isMohsen
            ? (currentMember.stats.warningsCount + value < 0
                ? 0
                : currentMember.stats.warningsCount + value)
            : currentMember.stats.warningsCount;
        final updatedStats = currentMember.stats.copyWith(
          mohsensCount: newMohsens,
          warningsCount: newWarnings,
          lastUpdatedAt: DateTime.now(),
        );
        updatedMember = currentMember.copyWith(stats: updatedStats);
      }

      emit(state.copyWith(
        status: MemberProfileStatus.success,
        member: updatedMember ?? state.member,
        actionSuccessMessage:
            '${isMohsen ? "Mohsen" : "Warning"} "$title" ($formattedVal) $actionWord successfully',
      ));
      return true;
    } catch (e) {
      final actionLabel = value < 0 ? 'remove' : 'add';
      emit(state.copyWith(
        status: MemberProfileStatus.failure,
        errorMessage: 'Failed to $actionLabel ${isMohsen ? "Mohsen" : "Warning"}: ${e.toString()}',
      ));
      return false;
    }
  }

  // Updates an existing Mohsen or Warning entry
  Future<bool> updateMohsenOrWarning({
    required String committeeId,
    required String memberId,
    required MohsenEntryModel oldEntry,
    required MohsenEntryModel newEntry,
    String? actorName,
    String? actorRole,
  }) async {
    try {
      emit(state.copyWith(status: MemberProfileStatus.submittingEntry));

      final mohsensRepo = _mohsensRepository;
      final membersRepo = _membersRepository;
      final isMohsen = newEntry.type == MohsenType.mohsen;
      final delta = newEntry.value - oldEntry.value;

      if (mohsensRepo == null || membersRepo == null) {
        final currentMember = state.member;
        final newMohsens = isMohsen
            ? ((currentMember?.stats.mohsensCount ?? 0) + delta < 0
                ? 0
                : (currentMember?.stats.mohsensCount ?? 0) + delta)
            : (currentMember?.stats.mohsensCount ?? 0);
        final newWarnings = !isMohsen
            ? ((currentMember?.stats.warningsCount ?? 0) + delta < 0
                ? 0
                : (currentMember?.stats.warningsCount ?? 0) + delta)
            : (currentMember?.stats.warningsCount ?? 0);
        final updatedStats = currentMember?.stats.copyWith(
          mohsensCount: newMohsens.toInt(),
          warningsCount: newWarnings.toInt(),
          lastUpdatedAt: DateTime.now(),
        );
        final updatedMember = currentMember?.copyWith(stats: updatedStats);
        emit(state.copyWith(
          status: MemberProfileStatus.success,
          member: updatedMember,
          actionSuccessMessage:
              '${isMohsen ? "Mohsen" : "Warning"} updated successfully',
        ));
        return true;
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      final effectiveActorName = actorName ??
          (currentUser?.displayName?.isNotEmpty == true
              ? currentUser!.displayName!
              : 'HR');
      final effectiveActorRole = actorRole ?? 'hr';

      await mohsensRepo.updateMohsenEntry(
        committeeId: committeeId,
        memberId: memberId,
        oldEntry: oldEntry,
        newEntry: newEntry,
        actorName: effectiveActorName,
        actorRole: effectiveActorRole,
      );

      // Re-fetch member from Firestore
      MemberModel? updatedMember;
      try {
        updatedMember = await membersRepo.getMember(
          committeeId: committeeId,
          uid: memberId,
        );
      } catch (_) {}

      if (updatedMember == null && state.member != null) {
        final currentMember = state.member!;
        final newMohsens = isMohsen
            ? (currentMember.stats.mohsensCount + delta < 0
                ? 0
                : currentMember.stats.mohsensCount + delta)
            : currentMember.stats.mohsensCount;
        final newWarnings = !isMohsen
            ? (currentMember.stats.warningsCount + delta < 0
                ? 0
                : currentMember.stats.warningsCount + delta)
            : currentMember.stats.warningsCount;
        final updatedStats = currentMember.stats.copyWith(
          mohsensCount: newMohsens.toInt(),
          warningsCount: newWarnings.toInt(),
          lastUpdatedAt: DateTime.now(),
        );
        updatedMember = currentMember.copyWith(stats: updatedStats);
      }

      emit(state.copyWith(
        status: MemberProfileStatus.success,
        member: updatedMember ?? state.member,
        actionSuccessMessage:
            '${isMohsen ? "Mohsen" : "Warning"} updated successfully',
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(
        status: MemberProfileStatus.failure,
        errorMessage: 'Failed to update entry: ${e.toString()}',
      ));
      return false;
    }
  }

  // Deletes a Mohsen or Warning entry
  Future<bool> deleteMohsenOrWarning({
    required String committeeId,
    required String memberId,
    required MohsenEntryModel entry,
    String? actorName,
    String? actorRole,
  }) async {
    try {
      emit(state.copyWith(status: MemberProfileStatus.submittingEntry));

      final mohsensRepo = _mohsensRepository;
      final membersRepo = _membersRepository;
      final isMohsen = entry.type == MohsenType.mohsen;

      if (mohsensRepo == null || membersRepo == null) {
        final currentMember = state.member;
        final currentCount = isMohsen
            ? (currentMember?.stats.mohsensCount ?? 0)
            : (currentMember?.stats.warningsCount ?? 0);
        if (currentCount - entry.value < 0) {
          emit(state.copyWith(
            status: MemberProfileStatus.failure,
            errorMessage:
                'Cannot delete entry because it would make the total negative.',
          ));
          return false;
        }
        final newMohsens = isMohsen
            ? (currentCount - entry.value)
            : (currentMember?.stats.mohsensCount ?? 0);
        final newWarnings = !isMohsen
            ? (currentCount - entry.value)
            : (currentMember?.stats.warningsCount ?? 0);
        final updatedStats = currentMember?.stats.copyWith(
          mohsensCount: newMohsens.toInt(),
          warningsCount: newWarnings.toInt(),
          lastUpdatedAt: DateTime.now(),
        );
        final updatedMember = currentMember?.copyWith(stats: updatedStats);
        emit(state.copyWith(
          status: MemberProfileStatus.success,
          member: updatedMember,
          actionSuccessMessage:
              '${isMohsen ? "Mohsen" : "Warning"} deleted successfully',
        ));
        return true;
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      final effectiveActorName = actorName ??
          (currentUser?.displayName?.isNotEmpty == true
              ? currentUser!.displayName!
              : 'HR');
      final effectiveActorRole = actorRole ?? 'hr';

      await mohsensRepo.deleteMohsenEntry(
        committeeId: committeeId,
        memberId: memberId,
        entry: entry,
        actorName: effectiveActorName,
        actorRole: effectiveActorRole,
      );

      // Re-fetch member from Firestore
      MemberModel? updatedMember;
      try {
        updatedMember = await membersRepo.getMember(
          committeeId: committeeId,
          uid: memberId,
        );
      } catch (_) {}

      if (updatedMember == null && state.member != null) {
        final currentMember = state.member!;
        final newMohsens = isMohsen
            ? (currentMember.stats.mohsensCount - entry.value < 0
                ? 0
                : currentMember.stats.mohsensCount - entry.value)
            : currentMember.stats.mohsensCount;
        final newWarnings = !isMohsen
            ? (currentMember.stats.warningsCount - entry.value < 0
                ? 0
                : currentMember.stats.warningsCount - entry.value)
            : currentMember.stats.warningsCount;
        final updatedStats = currentMember.stats.copyWith(
          mohsensCount: newMohsens.toInt(),
          warningsCount: newWarnings.toInt(),
          lastUpdatedAt: DateTime.now(),
        );
        updatedMember = currentMember.copyWith(stats: updatedStats);
      }

      emit(state.copyWith(
        status: MemberProfileStatus.success,
        member: updatedMember ?? state.member,
        actionSuccessMessage:
            '${isMohsen ? "Mohsen" : "Warning"} deleted successfully',
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(
        status: MemberProfileStatus.failure,
        errorMessage: 'Failed to delete entry: ${e.toString()}',
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
