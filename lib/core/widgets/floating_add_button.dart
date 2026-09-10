import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Floating circular add button with primary orange background and white plus icon.
/// Used in Notes grid and Mohsen/Warning history screens.
///
/// ```dart
/// FloatingAddButton(
///   onPressed: () => print('Add item'),
/// )
/// ```
class FloatingAddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;

  const FloatingAddButton({super.key, required this.onPressed, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
