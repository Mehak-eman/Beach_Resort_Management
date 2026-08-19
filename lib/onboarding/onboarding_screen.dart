import 'package:beach_resort_management/config/app_preferences.dart';
import 'package:beach_resort_management/core/constants/app_colors.dart';
import 'package:beach_resort_management/onboarding/onboarding_model.dart';
import 'package:beach_resort_management/onboarding/onboarding_page.dart';
import 'package:beach_resort_management/routes/route_names.dart' show RouteNames;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  final List<OnboardingModel> pages = [
    const OnboardingModel(
      title: "Discover Beach Resorts",
      description:
          "Explore beautiful beach resorts and enjoy unforgettable vacations.",
      icon: Icons.beach_access_rounded,
    ),
    const OnboardingModel(
      title: "Book Rooms & Restaurants",
      description:
          "Reserve luxury rooms, restaurants, beach huts, and much more.",
      icon: Icons.hotel_rounded,
    ),
    const OnboardingModel(
      title: "Enjoy Your Vacation",
      description:
          "Book water sports, events, and make amazing memories with family.",
      icon: Icons.surfing,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

Future<void> nextPage() async {
  if (currentPage < pages.length - 1) {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  } else {
    await AppPreferences.setOnboardingCompleted();

    if (!mounted) return;

    context.go(RouteNames.login);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            /// Skip Button
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                   onPressed: () async {
    await AppPreferences.setOnboardingCompleted();

    if (!mounted) return;

    context.go(RouteNames.login);
  },
                  child: const Text("Skip"),
                ),
              ),
            ),

            /// PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    model: pages[index],
                  );
                },
              ),
            ),

            /// Indicator
            SmoothPageIndicator(
              controller: _pageController,
              count: pages.length,
              effect: ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotColor: Colors.grey.shade300,
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),

            const SizedBox(height: 35),

            /// Next / Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    currentPage == pages.length - 1
                        ? "Get Started"
                        : "Next",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}