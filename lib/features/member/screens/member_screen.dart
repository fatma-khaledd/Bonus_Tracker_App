import 'package:bonus_tracker_app/core/theme/theme.dart';
import 'package:bonus_tracker_app/core/widgets/widgets.dart';
import 'package:bonus_tracker_app/features/member/cubit/member_cubit.dart';
import 'package:bonus_tracker_app/features/member/cubit/member_states.dart';
import 'package:bonus_tracker_app/features/member/screens/member_home_screen.dart';
import 'package:bonus_tracker_app/features/member/screens/member_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberScreen extends StatelessWidget {
  const MemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navItems = [
      NavBarItem(icon: Icons.home_filled, label: 'Home'),
      NavBarItem(icon: Icons.person, label: 'Profile'),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<MemberCubit, MemberState>(
        builder: (context, state) {
          if (state is MemberInitialState || state is MemberLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MemberErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }

          final success = state as MemberSuccessState;
          return IndexedStack(
            index: success.currentBottomNavIndex,
            children: [
              HomeMemberScreen(state: success),
              ProfileScreen(state: success),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<MemberCubit, MemberState>(
        builder: (context, state) {
          final index = state is MemberSuccessState
              ? state.currentBottomNavIndex
              : 0;
          return CustomBottomNavBar(
            items: navItems,
            currentIndex: index,
            onTap: (i) => context.read<MemberCubit>().changeBottomNavIndex(i),
          );
        },
      ),
    );
  }
}
