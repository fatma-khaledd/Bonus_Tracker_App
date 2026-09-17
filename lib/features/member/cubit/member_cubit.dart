import 'package:bonus_tracker_app/features/member/cubit/member_states.dart';
import 'package:bonus_tracker_app/shared/models/event_model.dart';
import 'package:bonus_tracker_app/shared/models/meeting_model.dart';
import 'package:bonus_tracker_app/shared/models/member_model.dart';
import 'package:bonus_tracker_app/shared/repositories/events/events_repository.dart';
import 'package:bonus_tracker_app/shared/repositories/meetings/meetings_repository.dart';
import 'package:bonus_tracker_app/shared/repositories/members/members_repository.dart';
import 'package:bonus_tracker_app/shared/repositories/user/users_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberCubit extends Cubit<MemberState> {
  final MembersRepository _membersRepository;
  final UsersRepository _usersRepository;
  final MeetingsRepository _meetingsRepository;
  final EventsRepository _eventsRepository;

  MemberCubit({
    required MembersRepository membersRepository,
    required UsersRepository usersRepository,
    required MeetingsRepository meetingsRepository,
    required EventsRepository eventsRepository,
  }) : _membersRepository = membersRepository,
       _usersRepository = usersRepository,
       _meetingsRepository = meetingsRepository,
       _eventsRepository = eventsRepository,
       super(MemberInitialState());

  Future<void> loadMemberData(String uid) async {
    emit(MemberLoadingState());
    try {
      final user = await _usersRepository.getUser(uid);
      if (user == null) {
        emit(const MemberErrorState('User not found'));
        return;
      }

      final activeCommitteeId =
          user.defaultCommitteeId ??
          (user.committees.isNotEmpty ? user.committees.first : '');

      if (activeCommitteeId.isEmpty) {
        emit(const MemberErrorState('No committee assigned to user'));
        return;
      }

      final results = await Future.wait([
        _membersRepository.getMember(committeeId: activeCommitteeId, uid: uid),
        _meetingsRepository.getMeetings(activeCommitteeId),
        _eventsRepository.getEvents(activeCommitteeId),
      ]);

      final member = results[0] as MemberModel?;
      final meetings = results[1] as List<MeetingModel>;
      final events = results[2] as List<EventModel>;

      if (member == null) {
        emit(const MemberErrorState('Member stats not found'));
        return;
      }

      emit(
        MemberSuccessState(
          user: user,
          member: member,
          selectedCommitteeId: activeCommitteeId,
          meetings: meetings,
          events: events,
        ),
      );
    } catch (e) {
      emit(MemberErrorState(e.toString()));
    }
  }

  Future<void> switchCommittee(String newCommitteeId) async {
    if (state is! MemberSuccessState) return;
    final currentState = state as MemberSuccessState;

    if (currentState.selectedCommitteeId == newCommitteeId) return;

    try {
      final results = await Future.wait([
        _membersRepository.getMember(
          committeeId: newCommitteeId,
          uid: currentState.user.uid,
        ),
        _meetingsRepository.getMeetings(newCommitteeId),
        _eventsRepository.getEvents(newCommitteeId),
      ]);

      final updatedMember = results[0] as MemberModel?;
      final meetings = results[1] as List<MeetingModel>;
      final events = results[2] as List<EventModel>;

      if (updatedMember != null) {
        emit(
          currentState.copyWith(
            member: updatedMember,
            selectedCommitteeId: newCommitteeId,
            meetings: meetings,
            events: events,
          ),
        );
      }
    } catch (e) {
      emit(MemberErrorState(e.toString()));
    }
  }

  void changeBottomNavIndex(int index) {
    if (state is MemberSuccessState) {
      final currentState = state as MemberSuccessState;
      emit(currentState.copyWith(currentBottomNavIndex: index));
    }
  }

  Future<void> markNotificationsAsSeen() async {
    if (state is MemberSuccessState) {
      final currentState = state as MemberSuccessState;
      await _membersRepository.markNotificationsSeen(
        committeeId: currentState.selectedCommitteeId,
        uid: currentState.user.uid,
      );
    }
  }
}
