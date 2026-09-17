import 'package:bonus_tracker_app/shared/models/event_model.dart';
import 'package:bonus_tracker_app/shared/models/meeting_model.dart';
import 'package:bonus_tracker_app/shared/models/member_model.dart';
import 'package:bonus_tracker_app/shared/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class MemberState extends Equatable {
  const MemberState();

  @override
  List<Object?> get props => [];
}

class MemberInitialState extends MemberState {}

class MemberLoadingState extends MemberState {}

class MemberSuccessState extends MemberState {
  final UserModel user;
  final MemberModel member;
  final String selectedCommitteeId;
  final List<MeetingModel> meetings;
  final List<EventModel> events;
  final int currentBottomNavIndex; // 0 for Home, 1 for Profile

  const MemberSuccessState({
    required this.user,
    required this.member,
    required this.selectedCommitteeId,
    required this.meetings,
    required this.events,
    this.currentBottomNavIndex = 0,
  });

  MemberSuccessState copyWith({
    UserModel? user,
    MemberModel? member,
    String? selectedCommitteeId,
    List<MeetingModel>? meetings,
    List<EventModel>? events,
    int? currentBottomNavIndex,
  }) {
    return MemberSuccessState(
      user: user ?? this.user,
      member: member ?? this.member,
      selectedCommitteeId: selectedCommitteeId ?? this.selectedCommitteeId,
      meetings: meetings ?? this.meetings,
      events: events ?? this.events,
      currentBottomNavIndex:
          currentBottomNavIndex ?? this.currentBottomNavIndex,
    );
  }

  @override
  List<Object?> get props => [
    user,
    member,
    selectedCommitteeId,
    meetings,
    events,
    currentBottomNavIndex,
  ];
}

class MemberErrorState extends MemberState {
  final String message;
  const MemberErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
