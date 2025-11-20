import 'package:flutter/material.dart';
import 'package:logisticscustomer/constants/colors.dart';
import 'package:lottie/lottie.dart';

class ConformOrderSuccessfull extends StatefulWidget {
  const ConformOrderSuccessfull({super.key});

  @override
  State<ConformOrderSuccessfull> createState() =>
      _ConformOrderSuccessfullState();
}

class _ConformOrderSuccessfullState extends State<ConformOrderSuccessfull> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset(
                "assets/Success.json",
                width: 130,
                height: 130,
                fit: BoxFit.contain,
                repeat: false, // optional — play once
                animate: true,
                options: LottieOptions(enableMergePaths: true),
                delegates: LottieDelegates(),
                // 👇 slows down animation
                frameRate: FrameRate(30),
              ),
            ),

            Text(
              "Successful",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 25,
                color: AppColors.darkText,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your Order ",
                  style: TextStyle(fontSize: 17, color: AppColors.darkGray),
                ),
                Text(
                  "Wo# 004-00-1209",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: AppColors.electricTeal,
                  ),
                ),
              ],
            ),
            Text(
              "has been Confirmed.",
              style: TextStyle(fontSize: 17, color: AppColors.darkGray),
            ),
          ],
        ),
      ),
    );
  }
}
