import 'package:bonus_tracker_app/core/theme/app_colors.dart';
import 'package:bonus_tracker_app/core/widgets/memmber_widgets/action_tile.dart';
import 'package:bonus_tracker_app/core/widgets/memmber_widgets/profileInfo_tile.dart';
import 'package:bonus_tracker_app/core/widgets/memmber_widgets/section_tile.dart';
import 'package:bonus_tracker_app/core/widgets/widgets.dart';
import 'package:bonus_tracker_app/screens/member_screens/summary_box.dart';
import 'package:flutter/material.dart' hide Divider;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(21),
        child: Column(
          children: [
            //Profile Avatar & Basic Info Header
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assests/images/user.png'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.iconDefault,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: AppColors.background,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Sara Ahmed',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Flutter Committee Member',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Summary Performance Strip
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  StatItem(title: 'Total Mohsens', value: '32'),
                  Divider(),
                  StatItem(title: 'Attendance', value: '88%'),
                  Divider(),
                  StatItem(title: 'Warnings', value: '0'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Member Personal Details Section
            const SectionTitle(title: 'Personal Info'),
            const SizedBox(height: 12),
            ProfileInfoTile(
              icon: Icons.email_outlined,
              title: 'Email',
              value: 'sara.ahmed@email.com',
            ),
            ProfileInfoTile(
              icon: Icons.phone_outlined,
              title: 'Phone',
              value: '+20 101 234 5678',
            ),
            ProfileInfoTile(
              icon: Icons.groups_outlined,
              title: 'Committees',
              value: 'Flutter Team, PR Team',
            ),

            const SizedBox(height: 24),

            // 4. Account Settings & Security Section
            const SectionTitle(title: 'Account Settings'),
            const SizedBox(height: 12),
            ActionTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () {
                // Open Change Password Dialog/Screen
              },
            ),
            ActionTile(
              icon: Icons.logout,
              title: 'Log Out',
              textColor: Colors.redAccent,
              onTap: () {
                // Handle Log out
              },
            ),
          ],
        ),
      ),
    );
  }
}