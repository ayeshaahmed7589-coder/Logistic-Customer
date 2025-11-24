import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../constants/colors.dart';
import '../bottom_navbar/bottom_navbar_screen.dart';

class RegisterSuccessful extends StatefulWidget {
  const RegisterSuccessful({super.key});

  @override
  State<RegisterSuccessful> createState() => _RegisterSuccessfulState();
}

class _RegisterSuccessfulState extends State<RegisterSuccessful> {
  @override
  void initState() {
    super.initState();

    // Ensure widget tree is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Navigate after 3 seconds
      Timer(const Duration(seconds: 3), () {
        if (!mounted) return; // Safety check
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const TripsBottomNavBarScreen(initialIndex: 0),
          ),
          (route) => false,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/Success.json",
              width: 130,
              height: 130,
              fit: BoxFit.contain,
              repeat: false,
              frameRate: const FrameRate(30),
            ),
            const SizedBox(height: 10),
            const Text(
              "Registration",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 25,
                color: AppColors.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              "Successful",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 25,
                color: AppColors.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Your account has been successfully created.",
                style: TextStyle(fontSize: 17, color: AppColors.darkGray),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "After documents approval you can start your Workorders.",
                style: TextStyle(fontSize: 17, color: AppColors.darkGray),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
