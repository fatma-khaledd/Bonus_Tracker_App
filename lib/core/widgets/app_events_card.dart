import 'package:flutter/material.dart';

class AppEventsCard extends StatelessWidget {
  const AppEventsCard({super.key, required this.title, required this.date});

  final String title;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0D2AC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Color(0xFF8B4513),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            date.toString().split(' ')[0],
            style: TextStyle(fontSize: 12, color: const Color(0xFF8B4513)),
          ),
          const SizedBox(height: 4),
          const Text(
            '07:00 pm',
            style: TextStyle(fontSize: 12, color: Color(0xFF8B4513)),
          ),
        ],
      ),
    );
    ;
  }
}
