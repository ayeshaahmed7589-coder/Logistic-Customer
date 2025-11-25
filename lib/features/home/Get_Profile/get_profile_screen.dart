import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/gap.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'package:logisticscustomer/features/authentication/login/login.dart';
import 'package:logisticscustomer/features/authentication/login/login_controller.dart';
import 'package:logisticscustomer/features/home/Edit_Profile/edit_profile_screen.dart';

import '../../../constants/colors.dart';
import 'get_profile_controller.dart';

class GetProfileScreen extends ConsumerStatefulWidget {
  const GetProfileScreen({super.key});

  @override
  ConsumerState<GetProfileScreen> createState() => _GetProfileScreenState();
}

class _GetProfileScreenState extends ConsumerState<GetProfileScreen> {
  bool _didLoadOnce = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didLoadOnce) {
      _didLoadOnce = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(getProfileControllerProvider.notifier).loadProfile();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(getProfileControllerProvider);

    return profileState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text(err.toString())),
      data: (profile) {
        if (profile == null) {
          return const Center(child: Text("No Profile Data"));
        }

        final user = profile.data.user;

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
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text(
                            "Logout",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          content: const Text(
                            "Are you sure you want to logout?",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          actions: [
                            /// CANCEL BUTTON (bordered)
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.electricTeal,
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 9,
                                ),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: AppColors.electricTeal,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            /// LOGOUT BUTTON (actual API call)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: blueColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                final msg = await ref
                                    .read(logoutControllerProvider.notifier)
                                    .logoutUser();

                                if (msg != null) {
                                  await LocalStorage.clearToken();

                                  // Close dialog
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop();

                                  // Navigate to Login
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (_) => Login()),
                                    (route) => false,
                                  );

                                  // Show logout message
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(SnackBar(content: Text(msg)));
                                }
                              },
                              child: const Text(
                                "Logout",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.logout,
                    color: AppColors.pureWhite,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),

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
                      bottom: 25,
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
                          Text(
                            user.name.isNotEmpty ? user.name : "N/A",
                            style: const TextStyle(
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
      },
    );
  }

  // --- Profile Image Widget ---
  Widget _buildProfileImage(Color primaryBlue) {
    final profileState = ref.watch(getProfileControllerProvider);

    // Loading State
    if (profileState.isLoading) {
      return const CircleAvatar(
        radius: 60,
        backgroundColor: AppColors.subtleGray,
        child: CircularProgressIndicator(),
      );
    }

    // Error State
    if (profileState.hasError) {
      return const CircleAvatar(
        radius: 60,
        backgroundColor: AppColors.subtleGray,
        child: Icon(Icons.error, color: Colors.red),
      );
    }

    // Data Loaded
    final profile = profileState.value;
    final customer = profile!.data.customer;

    final imageUrl = customer.profilePhoto;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: AppColors.subtleGray,
          backgroundImage: imageUrl != null && imageUrl.isNotEmpty
              ? NetworkImage(imageUrl)
              : const AssetImage('assets/profile_pic.png') as ImageProvider,
        ),

        Container(
          decoration: BoxDecoration(
            color: primaryBlue,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.pureWhite, width: 2),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
            icon: Icon(Icons.edit, color: AppColors.pureWhite, size: 25),
          ),
        ),
      ],
    );
  }

  // --- Info Card Widget (Aapka White Container) ---
  Widget _buildInfoCard() {
    final profileState = ref.watch(getProfileControllerProvider);

    // 🔵 Loading State
    if (profileState.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 🔴 Error State
    if (profileState.hasError) {
      return Container(
        padding: const EdgeInsets.all(30),
        child: const Text(
          "Failed to load profile",
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    // 🟢 Data Loaded
    final profile = profileState.value!;
    final user = profile.data.user;
    final customer = profile.data.customer;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(25, 120, 25, 50),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        shrinkWrap: true,

        children: [
          const Text(
            'Personal Info',
            style: TextStyle(
              color: AppColors.electricTeal,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

          // ✅ DOB
          _buildInfoRow(
            label: 'DOB',
            value: customer.dateOfBirth ?? "N/A",
            showVerification: false,
          ),
          const SizedBox(height: 10),

          // ✅ Phone
          _buildInfoRow(
            label: 'Mobile Phone',
            value: user.phone,
            showVerification: true,
          ),
          const SizedBox(height: 10),

          // ✅ Email
          _buildInfoRow(
            label: 'Email',
            value: user.email,
            valueColor: Colors.black,
            showVerification: false,
          ),
          const SizedBox(height: 10),

          // ✅ Employee ID OR Customer ID (Based on API)
          _buildInfoRow(
            label: 'Customer ID',
            value: customer.id.toString(),
            showVerification: false,
          ),
          const SizedBox(height: 10),

          // Optional Data
          _buildInfoRow(
            label: 'City',
            value: customer.city ?? "N/A",
            showVerification: false,
          ),
          const SizedBox(height: 10),

          _buildInfoRow(
            label: 'Country',
            value: customer.country ?? "N/A",
            showVerification: false,
          ),
          gapH32,
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
