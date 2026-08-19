import 'package:beach_resort_management/core/constants/app_colors.dart';
import 'package:flutter/material.dart';



final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  scaffoldBackgroundColor: AppColors.scaffoldBackground,

  primaryColor: AppColors.primary,

  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  ),

  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.textPrimary,
  ),
);