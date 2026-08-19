
import 'package:beach_resort_management/admin/presentation/admin_dashboard_screen.dart';
import 'package:beach_resort_management/admin/presentation/screens/admin_login_screen.dart';
import 'package:beach_resort_management/admin/presentation/screens/manage_bookings_screen.dart';
import 'package:beach_resort_management/admin/presentation/screens/manage_payments_screen.dart';
import 'package:beach_resort_management/admin/presentation/screens/manage_resorts_screen.dart';
import 'package:beach_resort_management/admin/presentation/screens/manage_users_screen.dart';
import 'package:beach_resort_management/authentication/models/resort_model.dart';
import 'package:beach_resort_management/authentication/screens/resort_details_screen.dart';
import 'package:beach_resort_management/booking/presentation/screens/booking_screen.dart';
import 'package:beach_resort_management/booking/presentation/screens/my_bookings_screen.dart';
import 'package:beach_resort_management/category/presentation/screens/resort_screen.dart';

import 'package:beach_resort_management/favourite/screens/favourite_screen.dart';
import 'package:beach_resort_management/home/all_resorts_screen.dart';
import 'package:beach_resort_management/home/home_screen.dart';
import 'package:beach_resort_management/onboarding/onboarding_screen.dart';
import 'package:beach_resort_management/presentation/screens/forgot_password_screen.dart';

import 'package:beach_resort_management/presentation/screens/login_screen.dart' show LoginScreen;
import 'package:beach_resort_management/presentation/screens/signup_screen.dart';

import 'package:beach_resort_management/profile/profile_screen.dart';
import 'package:beach_resort_management/rooms/model/room_model.dart';
import 'package:beach_resort_management/routes/route_names.dart';
import 'package:beach_resort_management/search/screens/search_result_screen.dart';

import 'package:beach_resort_management/splash/splash_screen.dart';

import 'package:go_router/go_router.dart';
import 'package:beach_resort_management/rooms/presentation/screens/room_list_screen.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,

  routes: [

    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),



    GoRoute(
      path: RouteNames.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    GoRoute(
  path: RouteNames.login,
  builder: (context, state) => const LoginScreen(),
),

GoRoute(
  path: RouteNames.signup,
  builder: (context, state) => const SignupScreen(),
),

GoRoute(
  path: RouteNames.forgotPassword,
  builder: (context, state) => const ForgotPasswordScreen(),
),

GoRoute(
  path: RouteNames.home,
  builder: (context, state) => const HomeScreen(),
),

GoRoute(
  path: RouteNames.resortDetails,
  builder: (context, state) {
    final resort = state.extra as ResortModel;

    return ResortDetailsScreen(
      resort: resort,
    );
  },
  
),

GoRoute(
  path: RouteNames.roomList,
  builder: (context, state) {
    final resort = state.extra as ResortModel;

    return RoomListScreen(
      resort: resort,
    );
  },
),

GoRoute(
  path: RouteNames.booking,
  builder: (context, state) {
    final room = state.extra as RoomModel;

    return BookingScreen(
      room: room,
    );

    
  },
),

GoRoute(
  path: RouteNames.myBookings,
  builder: (context, state) => const MyBookingsScreen(),
),

GoRoute(
  path: RouteNames.favorites,
  builder: (context, state) => const FavoriteScreen(),
),

GoRoute(
  path: RouteNames.profile,
  builder: (context, state) => const ProfileScreen(),
),


GoRoute(
  path: RouteNames.search,
  builder: (context, state) =>
      const SearchResultScreen(),
),

GoRoute(
  path: RouteNames.categoryResorts,
  builder: (context, state) {

    final category = state.extra as String;

    return CategoryResortScreen(
      category: category,
    );

  },
),

GoRoute(
  path: RouteNames.adminLogin,
  builder: (context, state) {
    return const AdminLoginScreen();
  },
),

GoRoute(
  path: RouteNames.adminDashboard,
  builder: (context, state) {
    return const AdminDashboardScreen();
  },
),

GoRoute(
  path: '/admin-bookings',
  builder: (context, state) {
    return const ManageBookingsScreen();
  },
),

GoRoute(
  path: '/admin-payments',
  builder: (context, state) {
    return const ManagePaymentScreen();
  },
),

GoRoute(
  path: '/admin-resorts',
  builder: (context, state) {
    return const ManageResortsScreen();
  },
),

GoRoute(
  path: '/admin-users',
  builder: (context, state) {
    return const ManageUsersScreen();
  },
),


GoRoute(
  path: RouteNames.allResorts,
  builder: (context, state) {
    return const AllResortsScreen();
  },
),
  ],
);