import 'package:beach_resort_management/admin/viewmodels/admin_booking_view_model.dart';
import 'package:beach_resort_management/admin/viewmodels/admin_payment_view_model.dart';
import 'package:beach_resort_management/admin/viewmodels/admin_resort_view_model.dart';
import 'package:beach_resort_management/admin/viewmodels/admin_user_view_model.dart';
import 'package:beach_resort_management/admin/viewmodels/admin_view_model.dart';
import 'package:beach_resort_management/app.dart';
import 'package:beach_resort_management/authentication/models/resort_view_model.dart';
import 'package:beach_resort_management/booking/presentation/viewmodels/booking_view_model.dart';
import 'package:beach_resort_management/category/presentation/viewmodels/category_view_model.dart';
import 'package:beach_resort_management/config/supabase_config.dart';
import 'package:beach_resort_management/favourite/viewmodels/favourite_view_model.dart';
import 'package:beach_resort_management/home/viewmodel/home_view_model.dart';
import 'package:beach_resort_management/payment/presentation/viewmodels/payment_view_model.dart';
import 'package:beach_resort_management/profile/viewmodels/profile_view_model.dart';
import 'package:beach_resort_management/rooms/presentation/viewmodels/room_view_model.dart';
import 'package:beach_resort_management/search/presenntation/viewmodels/search_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  debugPrint(
    "Current User: ${Supabase.instance.client.auth.currentUser}",
  );

  runApp(
    MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) => ResortViewModel(),
    ),

    ChangeNotifierProvider(
      create: (_) => RoomViewModel(),
    ),

    ChangeNotifierProvider(
  create: (_) => BookingViewModel(),
),

ChangeNotifierProvider(
 create: (_) => PaymentViewModel(),
),

ChangeNotifierProvider(
create:(_)=>FavoriteViewModel(),
),

ChangeNotifierProvider(

create:(_)=>ProfileViewModel(),

),

ChangeNotifierProvider(
  create: (_) => SearchViewModel(),
),

ChangeNotifierProvider(
  create: (_) => CategoryViewModel(),
),

ChangeNotifierProvider(
  create: (_) => FavoriteViewModel(),
),

ChangeNotifierProvider(
  create: (_) => AdminViewModel(),
),

ChangeNotifierProvider(
  create: (_) => AdminBookingViewModel(),
),

ChangeNotifierProvider(
  create: (_) => AdminPaymentViewModel(),
),

ChangeNotifierProvider(
  create: (_) => AdminResortViewModel(),
),

ChangeNotifierProvider(
  create: (_) => AdminUserViewModel(),
),

ChangeNotifierProvider(
  create: (_) => HomeViewModel(),
),
  ],
      child: const MyApp(),
    ),
  );
}

