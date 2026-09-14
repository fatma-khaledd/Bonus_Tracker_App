import 'package:bonus_tracker_app/core/theme/theme.dart';
import 'package:bonus_tracker_app/core/widgets/widgets.dart';
import 'package:bonus_tracker_app/screens/member_screens/home_member_screen.dart';
import 'package:bonus_tracker_app/screens/member_screens/profileMember_screen.dart';
import 'package:flutter/material.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {

  int currentIndex =0;

  List<Widget> screens =[
    HomeMemberScreen(),
    ProfileScreen()
  ];
  List<NavBarItem> navigationBarMember=[
    NavBarItem(icon: Icons.home_filled, label: 'Home'),
    NavBarItem(icon: Icons.person, label: 'Profile')
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: screens[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        items: navigationBarMember, 
        currentIndex: currentIndex, 
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        }
      )
      
    );
  }
}