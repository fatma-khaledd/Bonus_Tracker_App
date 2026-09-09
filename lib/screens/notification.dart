import 'package:bonus_tracker_app/shared/models/notification_model.dart';
import 'package:bonus_tracker_app/shared/repositories/notifications/firestore_notifications_repository.dart';
import 'package:bonus_tracker_app/shared/repositories/notifications/notifications_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:bonus_tracker_app/core/widgets/notification_list_tile.dart';

class Notification extends StatefulWidget {
  final String committeeId;

  const Notification({
    super.key,
    required this.committeeId,
  });

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late final NotificationsRepository notificationsRepository;

  DateTime? lastSeenNotificationsAt;

  @override
  void initState() {
    super.initState();

    notificationsRepository =
        FirestoreNotificationsRepository();

    loadLastSeenAndMarkAsSeen();
  }

  Future<void> loadLastSeenAndMarkAsSeen() async {
    final uid = auth.currentUser?.uid;

    if (uid == null) return;

    final memberDoc = await firestore
        .doc(
          'committees/${widget.committeeId}/members/$uid',
        )
        .get();

    final data = memberDoc.data();

    if (data != null &&
        data['lastSeenNotificationsAt'] != null) {
      final timestamp =
          data['lastSeenNotificationsAt'] as Timestamp;

      if (mounted) {
        setState(() {
          lastSeenNotificationsAt = timestamp.toDate();
        });
      }
    }

    await notificationsRepository.markNotificationsSeen(
      committeeId: widget.committeeId,
      uid: uid,
    );

    if (mounted) {
      setState(() {
        lastSeenNotificationsAt = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = auth.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please login first'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: notificationsRepository.watchNotifications(
          committeeId: widget.committeeId,
          uid: uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return const Center(
              child: Text('No notifications'),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];

              final isUnread =
                  notification.isUnread(lastSeenNotificationsAt);

              return NotificationListTile(
                name: notification.actorName,
                role: notification.actorRole,
                action: notification.message,
                isRead: !isUnread,
                avatarUrl: null,
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}