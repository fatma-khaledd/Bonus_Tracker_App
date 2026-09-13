import 'package:bonus_tracker_app/core/theme/theme.dart';
import 'package:bonus_tracker_app/core/widgets/notification_list_tile.dart';
import 'package:bonus_tracker_app/shared/repositories/members/firestore_members_repository.dart';
import 'package:bonus_tracker_app/shared/repositories/notifications/firestore_notifications_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';

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
        notificationsRepository: FirestoreNotificationsRepository(),
        memberRepository: FirestoreMembersRepository(),
      )..loadNotifications(
          committeeId: committeeId,
          uid: uid,
        ),
      child: NotificationView(
        committeeId: committeeId,
        uid: uid,
      ),
    );
  }
}

class NotificationView extends StatelessWidget {
  final String committeeId;
  final String uid;

  const NotificationView({
    super.key,
    required this.committeeId,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading || state is NotificationInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is NotificationError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: AppDimens.md),
                    Text(
                      state.message,
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimens.md),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<NotificationCubit>().loadNotifications(
                              committeeId: committeeId,
                              uid: uid,
                            );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.notifications_none_outlined,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: AppDimens.sm),
                    Text(
                      'No notifications yet',
                      style: AppTextStyles.bodySecondary,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];

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
