import 'package:bonus_tracker_app/core/theme/app_colors.dart';
import 'package:bonus_tracker_app/features/member/cubit/member_states.dart';
import 'package:bonus_tracker_app/features/member/member_widgets/action_tile.dart';
import 'package:bonus_tracker_app/features/member/member_widgets/profile_info_tile.dart';
import 'package:bonus_tracker_app/core/widgets/widgets.dart';
import 'package:bonus_tracker_app/features/member/member_widgets/vertical_divider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  final MemberSuccessState state;
  const ProfileScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final user = state.user;
    final member = state.member;
    final stats = member.stats;

    return Scaffold(
      appBar: const AppTopBar(title: 'Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(21),
        child: Column(
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      const AvatarPlaceholder(icon: Icons.person, radius: 50),
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
                  Text(
                    member.displayName.isNotEmpty
                        ? member.displayName
                        : user.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${state.selectedCommitteeId} · ${member.role.value}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Stats Strip
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: StatBox(
                      value: '${stats.mohsensCount}',
                      label: 'Total Mohsens',
                    ),
                  ),
                  const VerticalStatDivider(),
                  Expanded(
                    child: StatBox(
                      value: '${member.traits.activeness}',
                      label: 'Activeness',
                    ),
                  ),
                  const VerticalStatDivider(),
                  Expanded(
                    child: StatBox(
                      value: '${stats.warningsCount}',
                      label: 'Warnings',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const SectionHeader(title: 'Personal Info'),

            ProfileInfoTile(
              icon: Icons.email_outlined,
              title: 'Email',
              value: user.email,
            ),
            ProfileInfoTile(
              icon: Icons.calendar_today_outlined,
              title: 'Joined',
              value: DateFormat('dd MMM yyyy').format(member.joinedAt),
            ),
            ProfileInfoTile(
              icon: Icons.groups_outlined,
              title: 'Committees',
              value: user.committees.isEmpty ? '-' : user.committees.join(', '),
            ),

            const SizedBox(height: 24),

            const SectionHeader(title: 'Account Settings'),

            ActionTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () {},
            ),
            ActionTile(
              icon: Icons.logout,
              title: 'Log Out',
              textColor: Colors.redAccent,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
