import 'package:bonus_tracker_app/shared/models/committee_model.dart';
import 'package:bonus_tracker_app/shared/models/event_model.dart';
import 'package:bonus_tracker_app/shared/models/meeting_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CommitteeModel> committees;
  final List<MeetingModel> meetings;
  final List<EventModel> events;
  HomeLoaded(this.committees, this.meetings, this.events);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
