import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logisticscustomer/export.dart';
import 'package:logisticscustomer/features/home/main_screens/home_screen/home_controller.dart';


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
  loading: () => const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  ),
    error: (e, st) => Scaffold(
    body: Center(child: Text("Error: $e")),
  ),

      data: (dashboard) {
        // if (dashboard == null) {
        //   return const Scaffold(
        //     body: Center(child: Text("No Data")),
        //   );
        // }

      final user = dashboard.data.customerInfo;
    final stats = dashboard.data.stats;

        return Scaffold(
          backgroundColor: AppColors.lightGrayBackground,

          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------------------- APP BAR -------------------
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.electricTeal,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor:
                                AppColors.mediumGray.withValues(alpha: 0.4),
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: 12),

                          // NAME + CITY
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
                                  const Icon(Icons.location_pin,
                                      size: 16, color: Colors.white),
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
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none,
                            color: Colors.white, size: 25),
                      )
                    ],
                  ),
                ),

                // ------------------- REST OF YOUR UI SAME AS IT IS -------------------
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
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.pureWhite,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.mediumGray.withValues(alpha: 0.10),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Total Orders
                            Column(
                              children: [
                                CustomText(
                                  txt: stats.totalOrders.toString(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkText,
                                ),
                                gapH4,
                                CustomText(
                                  txt: "Total Orders",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.electricTeal,
                                ),
                              ],
                            ),

                            // Active Orders
                            Column(
                              children: [
                                CustomText(
                                  txt: stats.activeOrders.toString(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkText,
                                ),
                                gapH4,
                                CustomText(
                                  txt: "Active Orders",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.electricTeal,
                                ),
                              ],
                            ),

                            // Completed
                            Column(
                              children: [
                                CustomText(
                                  txt: stats.completedOrders.toString(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkText,
                                ),
                                gapH4,
                                CustomText(
                                  txt: "Complete Orders",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.electricTeal,
                                ),
                              ],
                            ),

                            // Spent
                            Column(
                              children: [
                                CustomText(
                                  txt: "\$${stats.totalSpent}",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkText,
                                ),
                                gapH4,
                                CustomText(
                                  txt: "Spent",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.electricTeal,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Baaqi tumhara UI jaisa ka taisa rahega
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}


// class CurrentScreen extends StatefulWidget {
//   const CurrentScreen({super.key});

//   @override
//   State<CurrentScreen> createState() => _CurrentScreenState();
// }

// class _CurrentScreenState extends State<CurrentScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.lightGrayBackground,

//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             //appbar
//             Container(
//               padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: AppColors.electricTeal,
//                 // boxShadow: [
//                 //   BoxShadow(
//                 //     color: Colors.black26,
//                 //     blurRadius: 6,
//                 //     offset: Offset(0, 3),
//                 //   )
//                 // ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 22,
//                         backgroundColor: AppColors.mediumGray.withValues(
//                           alpha: 0.4,
//                         ),
//                         child: Icon(Icons.person, color: Colors.white),
//                       ),
//                       const SizedBox(width: 12),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CustomText(
//                             txt: "Hi, Alice!",
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.pureWhite,
//                           ),
//                           SizedBox(height: 4),
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.location_pin,
//                                 size: 16,
//                                 color: AppColors.pureWhite,
//                               ),
//                               SizedBox(width: 4),
//                               CustomText(
//                                 txt: "Karachi, Pakistan",
//                                 color: AppColors.pureWhite,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => NotificationScreen(),
//                         ),
//                       );
//                     },
//                     icon: Icon(
//                       Icons.notifications_none,
//                       color: Colors.white,
//                       size: 25,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             //appbar end

//             // ---- Create New Order Button ----
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PickupDetailScreen(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                       decoration: BoxDecoration(
//                         color: AppColors.pureWhite,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: AppColors.electricTeal),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.inventory_2,
//                             color: AppColors.electricTeal,
//                             size: 28,
//                           ),
//                           SizedBox(width: 10),
//                           CustomText(
//                             txt: "Create New Order",
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.darkText,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   gapH24,

//                   // ---- Quick Stats ----
//                   CustomText(
//                     txt: "Quick Stats",
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.electricTeal,
//                   ),

//                   gapH4,
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: AppColors.pureWhite,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.mediumGray.withValues(alpha: 0.10),
//                           blurRadius: 6,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisAlignment:
//                           MainAxisAlignment.spaceBetween, // Yeh line add ki hai
//                       children: [
//                         Column(
//                           mainAxisAlignment:
//                               MainAxisAlignment.center, // Center align kiya
//                           children: [
//                             CustomText(
//                               txt: "45",
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.darkText,
//                             ),
//                             gapH4,
//                             CustomText(
//                               txt: "Total Orders",
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.electricTeal,
//                             ),
//                           ],
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CustomText(
//                               txt: "45",
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.darkText,
//                             ),
//                             gapH4,
//                             CustomText(
//                               txt: "Active Orders",
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.electricTeal,
//                             ),
//                           ],
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CustomText(
//                               txt: "45",
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.darkText,
//                             ),
//                             gapH4,
//                             CustomText(
//                               txt: "Complete Orders",
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.electricTeal,
//                             ),
//                           ],
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CustomText(
//                               txt: "\$2,340",
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.darkText,
//                             ),
//                             gapH4,
//                             CustomText(
//                               txt: "Spent",
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.electricTeal,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   gapH24,

//                   // ---- Active Deliveries ----
//                   CustomText(
//                     txt: "Active Orders",
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.electricTeal,
//                   ),
//                   gapH4,

//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => OrderHistory()),
//                       );
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: AppColors.pureWhite,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: AppColors.mediumGray.withValues(alpha: 0.10),
//                             blurRadius: 6,
//                             offset: Offset(0, 3),
//                           ),
//                         ],
//                       ),

//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               CustomText(
//                                 txt: "Order: ",
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.electricTeal,
//                               ),
//                               CustomText(
//                                 txt: "12345",
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                                 color: AppColors.darkText,
//                               ),
//                             ],
//                           ),
//                           gapH8,
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.circle,
//                                 size: 12,
//                                 color: AppColors.electricTeal,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               SizedBox(width: 6),
//                               CustomText(
//                                 txt: "In Transit",
//                                 color: AppColors.mediumGray,
//                               ),
//                             ],
//                           ),

//                           const SizedBox(height: 6),
//                           Row(
//                             children: [
//                               CustomText(
//                                 txt: "ETA: ",
//                                 color: AppColors.electricTeal,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                               CustomText(
//                                 txt: "15 minutes",
//                                 color: AppColors.mediumGray,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 14,
//                               ),
//                             ],
//                           ),
//                           gapH8,
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Row(
//                                 children: [
//                                   CustomText(
//                                     txt: "Track Order",
//                                     color: AppColors.electricTeal,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 14,
//                                   ),
//                                   gapW4,
//                                   Icon(
//                                     Icons.arrow_forward,
//                                     size: 12,
//                                     color: AppColors.electricTeal,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   gapH24,

//                   // ---- Recent Orders ----
//                   CustomText(
//                     txt: "Recent Orders",
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.electricTeal,
//                   ),

//                   gapH4,

//                   buildOrderTile("12344", "Delivered", "Jan 14, 3:20 PM"),
//                   gapH12,
//                   buildOrderTile("12343", "Delivered", "Jan 13, 11:15 AM"),
//                   gapH12,
//                   buildOrderTile("12343", "Delivered", "Jan 13, 11:15 AM"),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper widget for recent orders
//   Widget buildOrderTile(String id, String status, String time) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => OrderCompleteScreen()),
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppColors.pureWhite,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CustomText(
//                   txt: id,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.darkText,
//                 ),
//                 gapW8,
//                 const Icon(Icons.check, color: Colors.green, size: 18),
//                 CustomText(txt: " $status", color: Colors.green),
//               ],
//             ),
//             const SizedBox(height: 6),
//             CustomText(txt: time, fontSize: 12),
//           ],
//         ),
//       ),
//     );
//   }
// }
