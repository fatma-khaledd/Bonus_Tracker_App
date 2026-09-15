import 'package:bonus_tracker_app/core/theme/app_colors.dart';
import 'package:bonus_tracker_app/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeMemberScreen extends StatefulWidget {
  const HomeMemberScreen({super.key});

  @override
  State<HomeMemberScreen> createState() => _HomeMemberScreenState();
}

class _HomeMemberScreenState extends State<HomeMemberScreen> {
  int selectedIndex = 0;

  final List<String> committees = [
    'Committee 1',
    'Committee 2',
    'Committee 3',
  ];

  final List<ListEntryCard> sessions = [
    const ListEntryCard(title: 'Session 1', date: 'Sun - 08/16', time: '07:00 pm'),
    const ListEntryCard(title: 'Session 2', date: 'Mon - 08/17', time: '06:00 pm'),
    const ListEntryCard(title: 'Session 3', date: 'Wed - 08/19', time: '08:00 pm'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Welcome'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Committees Selector Horizontal List
            SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: committees.length,
                itemBuilder: (context, index) {
                  final isSelected = (index == selectedIndex);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.iconDefault : AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.iconDefault,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          committees[index],
                          style: TextStyle(
                            color: isSelected ? AppColors.background : AppColors.iconDefault,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            //Mohsens & Warnings Cards
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    color: AppColors.surfaceDark,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: const [
                          Text(
                            'Mohsens',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '8',
                            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppCard(
                    color: AppColors.surfaceDark,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: const [
                          Text(
                            'Warnings',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '0',
                            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            //Meetings Section
            const Text(
              'Meetings',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    child: sessions[index],
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            //Events Section
            const Text(
              'Events',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    child: sessions[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


