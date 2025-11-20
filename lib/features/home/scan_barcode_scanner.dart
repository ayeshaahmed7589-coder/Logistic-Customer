import 'package:flutter/material.dart';
import 'package:logisticscustomer/features/home/conform_order_screen.dart';

import '../../export.dart';

class ScanBarCodeScreen extends StatelessWidget {
  const ScanBarCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Scan Bar Code",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Frame
            Container(
              height: 220,
              width: 310,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Center(
                child: Icon(
                  Icons.qr_code_scanner,
                  size: 120,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Place the bar-code inside the frame",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 80),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: StadiumBorder(),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EnterOtpFinalScreen()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                child: Text("Continue", style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
