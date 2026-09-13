import 'dart:async';

import 'package:bonus_tracker_app/shared/models/notification_model.dart';
import 'package:bonus_tracker_app/shared/repositories/members/members_repository.dart';
import 'package:bonus_tracker_app/shared/repositories/notifications/notifications_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationsRepository notificationsRepository;
  final MembersRepository memberRepository;

  StreamSubscription<List<NotificationModel>>? _subscription;

  NotificationCubit({
    required this.notificationsRepository,
    required this.memberRepository,
  }) : super(NotificationInitial());

  Future<void> loadNotifications({
    required String committeeId,
    required String uid,
  }) async {
    try {
      emit(NotificationLoading());

      final member = await memberRepository.getMember(
        committeeId: committeeId,
        uid: uid,
      );

      final lastSeenNotificationsAt =
          member?.lastSeenNotificationsAt;

      await memberRepository.markNotificationsSeen(
        committeeId: committeeId,
        uid: uid,
      );

      await _subscription?.cancel();

      _subscription = notificationsRepository
          .watchNotifications(
            committeeId: committeeId,
            uid: uid,
          )
          .listen(
        (notifications) {
          emit(
            NotificationLoaded(
              notifications: notifications,
              lastSeenNotificationsAt:
                  lastSeenNotificationsAt,
            ),
          );
        },
        onError: (error) {
          emit(
            NotificationError(error.toString()),
          );
        },
      );
    } catch (e) {
      emit(
        NotificationError(e.toString()),
      );
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}