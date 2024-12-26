import 'package:bookstoreapp_eproject/utils/theme/theme_widgets/appbar_theme.dart';
import 'package:bookstoreapp_eproject/utils/theme/theme_widgets/bottom_sheet_theme.dart';
import 'package:bookstoreapp_eproject/utils/theme/theme_widgets/checkbox_theme.dart';
import 'package:bookstoreapp_eproject/utils/theme/theme_widgets/chip_theme.dart';
import 'package:bookstoreapp_eproject/utils/theme/theme_widgets/elevated_button_theme.dart';
import 'package:bookstoreapp_eproject/utils/theme/theme_widgets/outlined_button_theme.dart';
import 'package:bookstoreapp_eproject/utils/theme/theme_widgets/text_field_theme.dart';
import 'package:bookstoreapp_eproject/utils/theme/theme_widgets/text_theme.dart';
import 'package:flutter/material.dart';


class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: AppTextTheme.lightTextTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: AppBarrtheme.lightAppBarTheme,
    bottomSheetTheme: AppBottomSheetTheme.lightBottomSheetTheme,
    checkboxTheme: AppCheckboxTheme.lightCheckboxTheme,
    chipTheme: AppChipTheme.lightChipTheme,
    outlinedButtonTheme: AppOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: AppTextFormFieldTheme.lightInputDecorationTheme
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: AppTextTheme.darkTextTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: AppBarrtheme.darkAppBarTheme,
    bottomSheetTheme: AppBottomSheetTheme.darkBottomSheetTheme,
    checkboxTheme: AppCheckboxTheme.darkCheckboxTheme,
    chipTheme: AppChipTheme.darkChipTheme,
    outlinedButtonTheme: AppOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: AppTextFormFieldTheme.darkInputDecorationTheme
  );
}
