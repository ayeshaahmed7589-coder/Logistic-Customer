import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'export.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

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
