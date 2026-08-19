
import 'package:beach_resort_management/core/constants/app_strings.dart';
import 'package:beach_resort_management/routes/app_router.dart';
import 'package:beach_resort_management/theme/dark_theme.dart';
import 'package:beach_resort_management/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,

          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,

          routerConfig: appRouter,
        );
      },
    );
  }
}