import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../constants/colors.dart';

class RegisterSuccessful extends StatefulWidget {
  const RegisterSuccessful({super.key});

  @override
  State<RegisterSuccessful> createState() => _RegisterSuccessfulState();
}

class _RegisterSuccessfulState extends State<RegisterSuccessful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // vertical center
          crossAxisAlignment: CrossAxisAlignment.center, // horizontal center
          children: [
            // ✅ Centered Lottie Animation
            Lottie.asset(
              "assets/Success.json",
              width: 130,
              height: 130,
              fit: BoxFit.contain,
              repeat: false,
              frameRate: const FrameRate(30), // slower animation
            ),

            const SizedBox(height: 10),

            // ✅ Headings
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

            // ✅ Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
            child:  Text(
              "Your account has been successfully created.",
              style: TextStyle(fontSize: 17, color: AppColors.darkGray),
              textAlign: TextAlign.center,
            ),),

            const SizedBox(height: 10),

            // ✅ Secondary Text with proper horizontal padding
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
