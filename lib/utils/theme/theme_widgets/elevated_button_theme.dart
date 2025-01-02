import 'package:bookstoreapp_eproject/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();

  // light Elevated Button Theme
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.primary,
      disabledForegroundColor: AppColors.darkGrey,
      disabledBackgroundColor: AppColors.buttonDisabled,
      side: const BorderSide(color: AppColors.primary),
      padding: const EdgeInsets.symmetric(vertical: AppSizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: AppColors.white, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.buttonRadius))
    )
  );

  // dark Elevated Button Theme
  static final darktElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.darkGrey,
          disabledBackgroundColor: AppColors.darkerGrey,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(vertical: AppSizes.buttonHeight),
          textStyle: const TextStyle(fontSize: 16, color: AppColors.white, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.buttonRadius))
      )
  );
}