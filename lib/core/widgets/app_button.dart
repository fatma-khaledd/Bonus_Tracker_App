import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Button visual style hierarchy.
enum AppButtonStyle { primary, secondary }

/// Primary and secondary action button supporting filled, outlined, and loading states.
///
/// ```dart
/// AppButton.primary(
///   text: 'Log In',
///   onPressed: () => handleLogin(),
/// )
///
/// AppButton.outlined(
///   text: 'Cancel',
///   onPressed: () => Navigator.pop(context),
/// )
/// ```
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final bool isLoading;
  final double? width;
  final double? height;
  final bool outlined;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = AppButtonStyle.primary,
    this.isLoading = false,
    this.width,
    this.height,
    this.outlined = false,
  });

  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
  }) : style = AppButtonStyle.primary,
       outlined = false;

  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
  }) : style = AppButtonStyle.secondary,
       outlined = false;

  const AppButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.style = AppButtonStyle.secondary,
  }) : outlined = true;

  Color get _backgroundColor {
    if (outlined) return Colors.transparent;
    return style == AppButtonStyle.primary
        ? AppColors.primary
        : AppColors.secondary;
  }

  Color get _foregroundColor {
    if (outlined) {
      return style == AppButtonStyle.primary
          ? AppColors.primary
          : AppColors.secondary;
    }
    return AppColors.textOnPrimary;
  }

  BorderSide? get _borderSide {
    if (!outlined) return null;
    return BorderSide(
      color: style == AppButtonStyle.primary
          ? AppColors.primary
          : AppColors.secondary,
      width: 1.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? AppDimens.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _backgroundColor,
          foregroundColor: _foregroundColor,
          disabledBackgroundColor: _backgroundColor.withValues(alpha: 0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
            side: _borderSide ?? BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: _foregroundColor,
                ),
              )
            : Text(
                text,
                style: AppTextStyles.button.copyWith(color: _foregroundColor),
              ),
      ),
    );
  }
}
