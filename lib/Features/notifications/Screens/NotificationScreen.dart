
import 'package:bonus_tracker_app/core/widgets/notification_list_tile.dart';
import 'package:bonus_tracker_app/shared/repositories/members/firestore_members_repository.dart';
import 'package:bonus_tracker_app/shared/repositories/notifications/firestore_notifications_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bonus_tracker_app/Features/notifications/cubit/notification_cubit.dart';
import 'package:bonus_tracker_app/Features/notifications/cubit/notification_state.dart';

class NotificationsScreen extends StatelessWidget {
  final String committeeId;
  final String uid;

  const NotificationsScreen({
    super.key,
    required this.committeeId,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationCubit(
        notificationsRepository:
            FirestoreNotificationsRepository(),
        memberRepository:
            FirestoreMembersRepository(),
      )..loadNotifications(
          committeeId: committeeId,
          uid: uid,
        ),
      child: const NotificationView(),
    );
  }
}

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is NotificationError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const Center(
                child: Text('No notifications'),
              );
            }

            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification =
                    state.notifications[index];

                final isUnread = notification.isUnread(
                  state.lastSeenNotificationsAt,
                );

                return NotificationListTile(
                  name: notification.actorName,
                  role: notification.actorRole,
                  title: notification.title,
                  message: notification.message,
                  isRead: !isUnread,
                  avatarUrl: null,
                  onTap: () {},
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
