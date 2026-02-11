import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/services/notification_service.dart';

import 'export.dart';

// void main() {
//   runApp(ProviderScope(child: const MyApp()));
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize notifications
  await NotificationService.initialize();
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   // runApp(const MyApp());
//   runApp(ProviderScope(child: const MyApp()));
// }


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Logistic Customer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.electricTeal),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.electricTeal,
          elevation: 0,
        ),
      ),
      // home: TripsHomePage(),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColors.electricTeal,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.pureWhite,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: SplashScreen(),
      ),
      //  routerConfig: router,
    );
  }
}
