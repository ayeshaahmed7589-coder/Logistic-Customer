import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logisticscustomer/constants/gap.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'package:logisticscustomer/constants/session_expired.dart';
import 'package:logisticscustomer/features/authentication/login/login.dart';
import 'package:logisticscustomer/features/authentication/login/login_controller.dart';
import 'package:logisticscustomer/features/home/Edit_Profile/edit_profile_screen.dart';
import 'package:logisticscustomer/features/home/orders_flow/create_orders_screens/pickup_location/pickup_modal.dart';

import '../../../common_widgets/custom_text.dart';
import '../../../constants/colors.dart';
import '../../../constants/gps_location.dart';
import '../orders_flow/create_orders_screens/pickup_location/pickup_controller.dart';
import 'get_profile_controller.dart';

class GetProfileScreen extends ConsumerStatefulWidget {
  const GetProfileScreen({super.key});

  @override
  ConsumerState<GetProfileScreen> createState() => _GetProfileScreenState();
}

class _GetProfileScreenState extends ConsumerState<GetProfileScreen> {
  bool _didLoadOnce = false;
  int? selectedAddressId; // NEW

  AsyncValue<DefaultAddressModel> get defaultAddressState =>
      ref.watch(defaultAddressControllerProvider);

  // void _openAddressModal() {
  //   // Load addresses asynchronously
  //   final allAddressNotifier = ref.read(allAddressControllerProvider.notifier);
  //   allAddressNotifier.loadAllAddress();

  //   showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (context) {
  //       return Center(
  //         child: Consumer(
  //           builder: (context, ref, _) {
  //             final allAddressState = ref.watch(allAddressControllerProvider);
  //             final defaultAddressState = ref.watch(
  //               defaultAddressControllerProvider,
  //             );

  //             return Material(
  //               type: MaterialType.transparency,
  //               child: Container(
  //                 constraints: BoxConstraints(
  //                   maxHeight: MediaQuery.of(context).size.height * 0.65,
  //                   maxWidth: MediaQuery.of(context).size.width * 0.9,
  //                 ),
  //                 padding: const EdgeInsets.all(20),
  //                 decoration: BoxDecoration(
  //                   color: AppColors.pureWhite,
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 child: allAddressState.when(
  //                   loading: () =>
  //                       const Center(child: CircularProgressIndicator()),
  //                   error: (err, _) =>
  //                       Center(child: Text("Error loading addresses")),
  //                   data: (allAddress) {
  //                     if (allAddress == null || allAddress.data.isEmpty) {
  //                       return const Center(child: Text("No addresses found"));
  //                     }

  //                     final backendDefaultId =
  //                         defaultAddressState.value?.data.id;
  //                     final currentDefaultId =
  //                         selectedAddressId ?? backendDefaultId;

  //                     return ListView.builder(
  //                       shrinkWrap: true,
  //                       itemCount: allAddress.data.length,
  //                       itemBuilder: (context, index) {
  //                         final item = allAddress.data[index];
  //                         final isDefault = item.id == currentDefaultId;

  //                         return GestureDetector(
  //                           onTap: () {
  //                             setState(() {
  //                               selectedAddressId = item.id;
  //                             });
  //                             Navigator.pop(context);

  //                             // Reload default address
  //                             ref
  //                                 .read(
  //                                   defaultAddressControllerProvider.notifier,
  //                                 )
  //                                 .loadDefaultAddress();
  //                           },
  //                           child: Container(
  //                             margin: const EdgeInsets.only(bottom: 12),
  //                             padding: const EdgeInsets.all(15),
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(12),
  //                               border: Border.all(
  //                                 color: isDefault
  //                                     ? AppColors.electricTeal
  //                                     : AppColors.subtleGray,
  //                                 width: 2,
  //                               ),
  //                             ),
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Text(
  //                                   "${item.address}, ${item.city}, ${item.state}, ${item.postalCode}",
  //                                   style: const TextStyle(
  //                                     fontSize: 16,
  //                                     color: AppColors.darkText,
  //                                     fontWeight: FontWeight.w600,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                     );
  //                   },
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didLoadOnce) {
      _didLoadOnce = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(getProfileControllerProvider.notifier).loadProfile();
        ref
            .read(defaultAddressControllerProvider.notifier)
            .loadDefaultAddress();
        ref.read(allAddressControllerProvider.notifier).loadAllAddress();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(getProfileControllerProvider);

    return profileState.when(
      loading: () => const Center(child: CircularProgressIndicator()),

      // error: (err, _) => Center(child: Text(err.toString())),
      error: (e, st) {
        // if (e.toString().contains("SESSION_EXPIRED")) {
        return SessionExpiredScreen();
        // }
        // return Scaffold(body: Center(child: Text("Error: $e")));
      },

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
                                    // ignore: use_build_context_synchronously
                                    context,
                                    rootNavigator: true,
                                  ).pop();

                                  // Navigate to Login
                                  Navigator.of(
                                    // ignore: use_build_context_synchronously
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

  // --- Default Address Widget (Clean Row with Edit Icon) ---
  // Widget defaultAddressUI() {
  //   final defaultAddressState = ref.watch(defaultAddressControllerProvider);
  //   final allAddressState = ref.watch(allAddressControllerProvider);

  //   // Show loading if either is loading
  //   if (defaultAddressState.isLoading || allAddressState.isLoading) {
  //     return const Padding(
  //       padding: EdgeInsets.symmetric(vertical: 8.0),
  //       child: Text("Loading...", style: TextStyle(fontSize: 16)),
  //     );
  //   }

  //   // Show error if either has error
  //   if (defaultAddressState.hasError || allAddressState.hasError) {
  //     return Column(
  //       children: [
  //         Text(
  //             "Address",
  //             style: TextStyle(color: Colors.black, fontSize: 16),
  //           ),
  //         const Padding(
  //           padding: EdgeInsets.symmetric(vertical: 8.0),
  //           child: Text(
  //             "N/A",
  //             style: TextStyle(color: Colors.black, fontSize: 16),
  //           ),
  //         ),
  //       ],
  //     );
  //   }

  //   final all = allAddressState.value;
  //   final defaultAddress = defaultAddressState.value?.data;

  //   if (all == null || all.data.isEmpty || defaultAddress == null) {
  //     return const Padding(
  //       padding: EdgeInsets.symmetric(vertical: 8.0),
  //       child: Text("No addresses found", style: TextStyle(fontSize: 16)),
  //     );
  //   }

  //   // Determine which address to show
  //   final currentDefaultId = selectedAddressId ?? defaultAddress.id;
  //   final selected = all.data.firstWhere(
  //     (a) => a.id == currentDefaultId,
  //     orElse: () => all.data.first,
  //   );

  //   return Row(
  //     children: [
  //       // Label + Address
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               children: [
  //                 const Text(
  //                   "Default Address",
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: AppColors.mediumGray,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //                 IconButton(
  //                   onPressed: _openAddressModal,
  //                   icon: const Icon(
  //                     Icons.edit,
  //                     size: 18,
  //                     color: AppColors.electricTeal,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Text(
  //               "${selected.address}, ${selected.city}, ${selected.state}, ${selected.postalCode}",
  //               style: const TextStyle(
  //                 fontSize: 16,
  //                 color: AppColors.darkText,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
    String formatDateOfBirth(String? rawDate) {
      if (rawDate == null || rawDate.isEmpty) return "N/A";

      try {
        final dateTime = DateTime.parse(rawDate);
        return DateFormat('dd MMM yyyy').format(dateTime);
        // Example: 01 Jan 1990
      } catch (e) {
        return "N/A";
      }
    }

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
      padding: const EdgeInsets.fromLTRB(25, 120, 25, 0),
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
            label: 'Date Of Birth',
            value: formatDateOfBirth(customer.dateOfBirth),
            showVerification: false,
          ),

          // _buildInfoRow(
          //   label: 'Date Of Birth',
          //   value: customer.dateOfBirth ?? "N/A",
          //   showVerification: false,
          // ),
          const SizedBox(height: 10),

          // ✅ Phone
          _buildInfoRow(
            label: 'Contact Number',
            value: user.phone,
            showVerification: false,
          ),
          const SizedBox(height: 10),

          // ✅ Email
          _buildInfoRow(
            label: 'Email',
            value: user.email,
            valueColor: Colors.black,
            showVerification: true,
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
          const SizedBox(height: 10),

          /// LOCATION
          profileState.when(
            data: (_) {
              return FutureBuilder<String>(
                future: getCurrentCity(),
                builder: (_, snapshot) {
                  final city = snapshot.data ?? "Loading...";
                  return _locationRow(city);
                },
              );
            },
            loading: () => _loadingText(width: 90),
            error: (_, __) => _loadingText(width: 90),
          ),
          // defaultAddressUI(),
          gapH32,
        ],
      ),
    );
  }

  /// ================= HELPERS =================
  Widget _locationRow(String city) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(txt: "Address", fontSize: 14, color: AppColors.mediumGray),
        const SizedBox(height: 5),
        CustomText(
          txt: city,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _loadingText({double width = 100}) {
    return Container(
      width: width,
      height: 14,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
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
      Row(
        children: [
          Text(label, style: TextStyle(color: labelColor, fontSize: 14)),
          SizedBox(width: 10),
          if (showVerification)
            const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
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
      const SizedBox(height: 5),
      Text(
        value,
        style: TextStyle(
          color: valueColor,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
