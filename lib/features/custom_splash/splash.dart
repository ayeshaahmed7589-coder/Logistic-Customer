import 'package:flutter/material.dart';
import 'package:logisticscustomer/constants/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/login/login.dart';
import '../../features/bottom_navbar/bottom_navbar_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();

    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      // USER ALREADY LOGGED IN → GO TO HOME
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const TripsBottomNavBarScreen(initialIndex: 0),
        ),
      );
    } else {
      // NO LOGIN → GO TO LOGIN
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F9),
      body: Center(
        child: SlideTransition(
          position: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "DROVVI",
                style: TextStyle(
                  color: const Color(0xff10CFCF),
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
              gapH4,
              Text(
                "Customer",
                style: TextStyle(
                  color: const Color(0xff10CFCF),
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
