import 'package:flutter/material.dart';
import 'package:logisticscustomer/constants/colors.dart';
import 'package:logisticscustomer/features/authentication/login/login.dart';

class SessionExpiredScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
               Icon(Icons.error_outline, size: 60, color: AppColors.mediumGray),
            Text("Session Expired",style: TextStyle(color: AppColors.electricTeal),),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                  (route) => false,
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.electricTeal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.login_outlined, size: 20, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Login Again", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     // Navigator.pushReplacementNamed(context, "/login");
            //     Navigator.pushAndRemoveUntil(
            //       context,
            //       MaterialPageRoute(builder: (_) => const Login()),
            //       (route) => false,
            //     );
            //   },
            //   child: Text("Login Again"),
            // ),
          ],
        ),
      ),
    );
  }
}
