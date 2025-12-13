import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/common_widgets/custom_text.dart';
import 'package:logisticscustomer/constants/colors.dart';
import 'package:logisticscustomer/constants/gap.dart';
import 'package:logisticscustomer/features/home/main_screens/home_screen/home_controller.dart';
import 'package:logisticscustomer/features/home/order_conplete.dart';

class ActiveViewAll extends ConsumerStatefulWidget {
  const ActiveViewAll({super.key});

  @override
  ConsumerState<ActiveViewAll> createState() => _ActiveViewAllState();
}

class _ActiveViewAllState extends ConsumerState<ActiveViewAll> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      // AppBar
      appBar: AppBar(
        backgroundColor: AppColors.electricTeal,
        elevation: 0,
        leading: RotatedBox(
          quarterTurns: 2,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_forward_rounded, color: AppColors.pureWhite),
          ),
        ),
        title: CustomText(
          txt: "Active Orders",
          color: AppColors.pureWhite,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),

      // AppBar end
      body: state.when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, st) => Scaffold(body: Center(child: Text("Error: $e"))),

        data: (dashboard) {
          // if (dashboard == null) {
          //   return const Scaffold(
          //     body: Center(child: Text("No Data")),
          //   );
          // }

          return Scaffold(
            backgroundColor: AppColors.lightGrayBackground,

            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ---- Active Orders ----

                            // Active Orders List (API se)
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
                                    children: (dashboard.data.activeOrders).map((
                                      order,
                                    ) {
                                      return GestureDetector(
                                        onTap: () {
                                          // Yahan order details screen par navigate kar sakte hain
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 12),
                                          width: double.infinity,
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: AppColors.pureWhite,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.mediumGray
                                                    // ignore: deprecated_member_use
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
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.electricTeal,
                                                  ),
                                                  CustomText(
                                                    txt:
                                                        order["order_number"]
                                                            ?.toString() ??
                                                        "N/A",
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
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
                                                    color:
                                                        AppColors.electricTeal,
                                                  ),
                                                  SizedBox(width: 6),
                                                  CustomText(
                                                    txt:
                                                        (order["status"]
                                                            ?.toString()
                                                            .toUpperCase() ??
                                                        "PENDING"),
                                                    color: AppColors.mediumGray,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on_outlined,
                                                    size: 14,
                                                    color: AppColors.mediumGray,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Expanded(
                                                    child: CustomText(
                                                      txt:
                                                          "${order["pickup_address"]} to ${order["delivery_address"]}",
                                                      fontSize: 13,
                                                      color:
                                                          AppColors.mediumGray,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                    }).toList(),
                                  ),
                            gapH24,
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

// Recent Orderss

class RecentViewAll extends ConsumerStatefulWidget {
  const RecentViewAll({super.key});

  @override
  ConsumerState<RecentViewAll> createState() => _RecentViewAllState();
}

class _RecentViewAllState extends ConsumerState<RecentViewAll> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      // AppBar
      appBar: AppBar(
        backgroundColor: AppColors.electricTeal,
        elevation: 0,
        leading: RotatedBox(
          quarterTurns: 2,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_forward_rounded, color: AppColors.pureWhite),
          ),
        ),
        title: CustomText(
          txt: "Recent Orders",
          color: AppColors.pureWhite,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),

      // AppBar end
      body: state.when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, st) => Scaffold(body: Center(child: Text("Error: $e"))),

        data: (dashboard) {
          // if (dashboard == null) {
          //   return const Scaffold(
          //     body: Center(child: Text("No Data")),
          //   );
          // }

          return Scaffold(
            backgroundColor: AppColors.lightGrayBackground,

            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ---- Recent Orders ----
                            gapH4,

                            // Recent Orders List (API se)
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
                                    children: (dashboard.data.recentOrders).map(
                                      (order) {
                                        return buildOrderTile(
                                          order["order_number"]?.toString() ??
                                              "N/A",
                                          order["status"]?.toString() ??
                                              "pending",
                                          order["created_at"]?.toString() ?? "",
                                        );
                                      },
                                    ).toList(),
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
