import 'dart:async';

import 'package:beach_resort_management/config/app_preferences.dart';
import 'package:beach_resort_management/config/auth_service.dart';
import 'package:beach_resort_management/core/constants/app_colors.dart';
import 'package:beach_resort_management/core/constants/app_strings.dart';
import 'package:beach_resort_management/routes/route_names.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

 @override
void initState() {
  super.initState();
  _checkAppState();
}

Future<void> _checkAppState() async {

  debugPrint("Splash started");


  await Future.delayed(
    const Duration(seconds: 2),
  );


  debugPrint("Checking preferences");


  final onboardingCompleted =
      await AppPreferences.isOnboardingCompleted();


  debugPrint(
    "Onboarding: $onboardingCompleted",
  );


  final user = AuthService().currentUser;


  debugPrint(
    "User: $user",
  );


  if (!mounted) return;


  if (user != null) {

    debugPrint("Going Home");

    context.go(
      RouteNames.home,
    );

  } 

  else if (onboardingCompleted) {

    debugPrint("Going Login");

    context.go(
      RouteNames.login,
    );

  } 

  else {

    debugPrint("Going Onboarding");

    context.go(
      RouteNames.onboarding,
    );
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.primary,

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Container(
              height: 120,
              width: 120,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),

              child: const Icon(
                Icons.beach_access_rounded,
                size: 70,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 30),

            Text(
              AppStrings.appName,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Book • Relax • Enjoy",

              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 50),

            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}