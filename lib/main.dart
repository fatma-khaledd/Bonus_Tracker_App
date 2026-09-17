import 'package:bonus_tracker_app/features/member/cubit/member_cubit.dart';
import 'package:bonus_tracker_app/features/member/screens/member_screen.dart';
import 'package:bonus_tracker_app/firebase_options.dart';
import 'package:bonus_tracker_app/shared/repositories/events/firestore_events_repository.dart';
import 'package:bonus_tracker_app/shared/repositories/meetings/firestore_meetings_repository.dart';
import 'package:bonus_tracker_app/shared/repositories/members/firestore_members_repository.dart';
import 'package:bonus_tracker_app/shared/repositories/user/firestore_users_repository.dart';
import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/theme.dart';
import 'features/auth/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mohsens Tracker',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: BlocProvider(
        create: (_) => MemberCubit(
          membersRepository: FirestoreMembersRepository(),
          usersRepository: FirestoreUsersRepository(),
          meetingsRepository: FirestoreMeetingsRepository(),
          eventsRepository: FirestoreEventsRepository(),
        )..loadMemberData('test_uid_2'),
        child: const MemberScreen(),
      ),
    );
  }
}
