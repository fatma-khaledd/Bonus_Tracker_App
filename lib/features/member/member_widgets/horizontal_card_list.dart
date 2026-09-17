import 'package:bonus_tracker_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class HorizontalCardsList extends StatelessWidget {
  final int count;
  final String emptyText;
  final Widget Function(int index) builder;

  const HorizontalCardsList({
    super.key,
    required this.count,
    required this.emptyText,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return SizedBox(
        height: 130,
        child: Center(child: Text(emptyText, style: AppTextStyles.cardTitle)),
      );
    }
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        itemBuilder: (context, index) => Container(
          width: 150,
          margin: const EdgeInsets.only(right: 12),
          child: builder(index),
        ),
      ),
    );
  }
}
