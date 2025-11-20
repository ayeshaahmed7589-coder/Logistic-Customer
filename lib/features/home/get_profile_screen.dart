import 'package:flutter/material.dart';
import 'package:logisticscustomer/constants/gap.dart';

import '../../constants/colors.dart';

class GetProfileScreen extends StatelessWidget {
  const GetProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color blueColor = AppColors.electricTeal;
    // Screen height ka hisaab lagana zaroori hai is layout ke liye
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.pureWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: blueColor,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Icon(Icons.logout, color: AppColors.pureWhite, size: 28),
          ),
        ],
      ),
      // *** Yahan Body Structure Change Kiya Hai ***
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(height: 150, color: blueColor),

                Positioned(
                  top: screenHeight * 0.1,
                  left: 20,
                  right: 20,
                  bottom: 95,
                  child: _buildInfoCard(),
                ),

                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      _buildProfileImage(AppColors.electricTeal),
                      const SizedBox(height: 15),
                      const Text(
                        'John Doe',
                        style: TextStyle(
                          color: AppColors.darkText,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        width: 300,
                        margin: const EdgeInsets.only(top: 8),
                        height: 1,
                        color: AppColors.electricTeal,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Profile Image Widget ---
  Widget _buildProfileImage(Color primaryBlue) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        const CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage('assets/profile_pic.png'),
          backgroundColor: AppColors.subtleGray,
        ),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: primaryBlue,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.pureWhite, width: 2),
          ),
          child: const Icon(Icons.edit, color: AppColors.pureWhite, size: 18),
        ),
      ],
    );
  }

  // --- Info Card Widget (Aapka White Container) ---
  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      // Card ka top rounded corner yahan define kiya
      decoration: const BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),

          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(25, 60, 25, 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          gapH64,
          const Text(
            'Personal Info',
            style: TextStyle(
              color: AppColors.electricTeal,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),

          // Data Rows... (Yeh pehle jaisa hi rahega)
          _buildInfoRow(
            label: 'DOB',
            value: '12/04/1990',
            showVerification: false,
          ),
          const SizedBox(height: 20),

          _buildInfoRow(
            label: 'Mobile Phone',
            value: '(629) 555-0129',
            showVerification: true,
          ),
          const SizedBox(height: 20),

          _buildInfoRow(
            label: 'Email',
            value: 'John@example.com',
            showVerification: false,
            valueColor: Colors.black,
          ),
          const SizedBox(height: 20),

          _buildInfoRow(
            label: 'Employee ID',
            value: '06/06/2021',
            showVerification: false,
          ),
        ],
      ),
    );
  }

  // --- Reusable Info Row Widget (Yeh pehle jaisa hi rahega) ---
  Widget _buildInfoRow({
    required String label,
    required String value,
    required bool showVerification,
    Color labelColor = AppColors.mediumGray,
    Color valueColor = AppColors.darkText,
  }) {
    // ... (same implementation as before)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: labelColor, fontSize: 14)),
        const SizedBox(height: 5),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 10),
            if (showVerification)
              const Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 18,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Verified',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
