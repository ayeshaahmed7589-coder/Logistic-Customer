import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logisticscustomer/export.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/main_order_create_screen.dart';
import 'package:logisticscustomer/features/home/main_screens/home_screen/home_controller.dart';
import 'package:logisticscustomer/features/home/main_screens/home_screen/home_modal.dart';
import 'package:logisticscustomer/features/home/main_screens/home_screen/view_all.dart';
import 'package:logisticscustomer/features/home/notification_screen.dart';
import 'package:logisticscustomer/features/home/order_conplete.dart';

class CurrentScreen extends ConsumerStatefulWidget {
  const CurrentScreen({super.key});

  @override
  ConsumerState<CurrentScreen> createState() => _CurrentScreenState();
}

class _CurrentScreenState extends ConsumerState<CurrentScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(dashboardControllerProvider.notifier).loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardControllerProvider);

    return state.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(body: Center(child: Text("Error: $e"))),

      data: (dashboard) {
        // if (dashboard == null) {
        //   return const Scaffold(
        //     body: Center(child: Text("No Data")),
        //   );
        // }

        final user = dashboard.data.customerInfo;
        final stats = dashboard.data.stats;
        final profile = user.profilePhoto.trim();
        final hasPhoto = profile.isNotEmpty && profile.toLowerCase() != "null";

        return Scaffold(
          backgroundColor: AppColors.lightGrayBackground,
          appBar: DashboardAppBar(
            user: user,
            hasPhoto: hasPhoto,
            profile: profile,
          ),

          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- Create New Order Button ----
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainOrderCreateScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: AppColors.pureWhite,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.electricTeal),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2,
                                color: AppColors.electricTeal,
                                size: 28,
                              ),
                              SizedBox(width: 10),
                              CustomText(
                                txt: "Create New Order",
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkText,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Quick Stats
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            txt: "Quick Stats",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.electricTeal,
                          ),

                          gapH4,

                          // Stats UI (values API se bharna)
                          // Stats UI (values API se bharna)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.pureWhite,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.mediumGray.withValues(
                                    alpha: 0.10,
                                  ),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Pehli row
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatItem(
                                        value: stats.totalOrders.toString(),
                                        label: "Total Orders",
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: _buildStatItem(
                                        value: stats.activeOrders.toString(),
                                        label: "Active Orders",
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                // Doosri row
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatItem(
                                        value: stats.completedOrders.toString(),
                                        label: "Complete Orders",
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: _buildStatItem(
                                        value: "${stats.totalSpent}",
                                        label: "Spent",
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          gapH24,

                          // ---- Active Orders ----
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                txt: "Active Orders",
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.electricTeal,
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ActiveViewAll(),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    CustomText(
                                      txt: "View All",
                                      color: AppColors.electricTeal,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 16,
                                      color: AppColors.electricTeal,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          gapH4,

                          // Active Orders List (API se)
                          // Active Orders List (API se) - Only show latest 3
                          dashboard.data.activeOrders.isEmpty
                              ? Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColors.pureWhite,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: CustomText(
                                      txt: "No active orders",
                                      color: AppColors.mediumGray,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: (dashboard.data.activeOrders)
                                      .take(3)
                                      .map((order) {
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 12),
                                            width: double.infinity,
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: AppColors.pureWhite,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.mediumGray
                                                      .withOpacity(0.1),
                                                  blurRadius: 6,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    CustomText(
                                                      txt: "Order: ",
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors
                                                          .electricTeal,
                                                    ),
                                                    CustomText(
                                                      txt:
                                                          order["order_number"]
                                                              ?.toString() ??
                                                          "N/A",
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors.darkText,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      size: 12,
                                                      color: AppColors
                                                          .electricTeal,
                                                    ),
                                                    SizedBox(width: 6),
                                                    CustomText(
                                                      txt:
                                                          (order["status"]
                                                              ?.toString()
                                                              .toUpperCase() ??
                                                          "PENDING"),
                                                      color:
                                                          AppColors.mediumGray,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      size: 14,
                                                      color:
                                                          AppColors.mediumGray,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Expanded(
                                                      child: CustomText(
                                                        txt:
                                                            "${order["pickup_address"]} to ${order["delivery_address"]}",
                                                        fontSize: 13,
                                                        color: AppColors
                                                            .mediumGray,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        CustomText(
                                                          txt: "Track Order",
                                                          color: AppColors
                                                              .electricTeal,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Icon(
                                                          Icons.arrow_forward,
                                                          size: 12,
                                                          color: AppColors
                                                              .electricTeal,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                      .toList(),
                                ),
                          gapH24,

                          // ---- Recent Orders ----
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                txt: "Recent Orders",
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.electricTeal,
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecentViewAll(),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    CustomText(
                                      txt: "View All",
                                      color: AppColors.electricTeal,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 16,
                                      color: AppColors.electricTeal,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          gapH4,

                          // Recent Orders List (API se)
                          // Recent Orders List (API se) - Only show latest 3
                          dashboard.data.recentOrders.isEmpty
                              ? Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColors.pureWhite,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: CustomText(
                                      txt: "No recent orders",
                                      color: AppColors.mediumGray,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: (dashboard.data.recentOrders)
                                      .take(3) // <-- Yahi line add karo
                                      .map((order) {
                                        return buildOrderTile(
                                          order["order_number"]?.toString() ??
                                              "N/A",
                                          order["status"]?.toString() ??
                                              "pending",
                                          order["created_at"]?.toString() ?? "",
                                        );
                                      })
                                      .toList(),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper widget
  Widget _buildStatItem({required String value, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.subtleGray,
        // color: AppColors.mediumGray.withOpacity(0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            txt: value,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
          gapH4,
          CustomText(
            txt: label,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.electricTeal,
          ),
        ],
      ),
    );
  }

  //   // Helper widget for recent orders
  Widget buildOrderTile(String id, String status, String time) {
    Color statusColor = AppColors.mediumGray;
    IconData statusIcon = Icons.pending;

    if (status.toLowerCase() == "delivered") {
      statusColor = Colors.green;
      statusIcon = Icons.check;
    } else if (status.toLowerCase() == "pending") {
      statusColor = Colors.orange;
      statusIcon = Icons.pending;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderCompleteScreen()),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(
                  txt: id,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
                SizedBox(width: 8),
                Icon(statusIcon, color: statusColor, size: 18),
                CustomText(
                  txt: " ${status.toUpperCase()}",
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            SizedBox(height: 6),
            CustomText(txt: time, fontSize: 12, color: AppColors.mediumGray),
          ],
        ),
      ),
    );
  }
}

// ================ SEPARATE APP BAR WIDGET ================
class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CustomerInfo user;
  final bool hasPhoto;
  final String profile;

  const DashboardAppBar({
    Key? key,
    required this.user,
    required this.hasPhoto,
    required this.profile,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(70); // AppBar ki height

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.electricTeal),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.mediumGray.withValues(alpha: 0.4),
                backgroundImage: hasPhoto ? NetworkImage(profile) : null,
                child: hasPhoto
                    ? null
                    : const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    txt: "Hi, ${user.name}",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pureWhite,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_pin,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        txt: "${user.city}, ${user.state}",
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
