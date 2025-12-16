import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:logisticscustomer/export.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/main_order_create_screen.dart';
import 'package:logisticscustomer/features/home/main_screens/home_screen/home_controller.dart';
import 'package:logisticscustomer/features/home/main_screens/home_screen/home_modal.dart';
import 'package:logisticscustomer/features/home/main_screens/home_screen/view_all.dart';
import 'package:logisticscustomer/features/home/notification_screen.dart';

// Active Orders

// Ye code apne UI me replace karen
// orderResponse.when(
//   data: (data) {
//     final orders = data.data.orders
//         .where((order) => order.isActive)
//         .toList();

//     return orders.isEmpty
//         ? Container(
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: AppColors.pureWhite,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.mediumGray
//                       .withOpacity(0.1),
//                   blurRadius: 6,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Icon(
//                   Icons.inbox_outlined,
//                   size: 48,
//                   color: AppColors.mediumGray
//                       .withOpacity(0.5),
//                 ),
//                 SizedBox(height: 12),
//                 CustomText(
//                   txt: "No active orders",
//                   color: AppColors.mediumGray,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 SizedBox(height: 8),
//                 CustomText(
//                   txt:
//                       "You don't have any active shipments right now",
//                   color: AppColors.mediumGray,
//                   fontSize: 12,
//                   align: TextAlign.center,
//                 ),
//               ],
//             ),
//           )
//         : Column(
//             children: orders.take(3).map((order) {
//               return GestureDetector(
//                 onTap: () {
//                   // Order details screen pe navigate karen
//                   // Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order)));
//                 },
//                 child: Container(
//                   margin: EdgeInsets.only(bottom: 16),
//                   width: double.infinity,
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: AppColors.pureWhite,
//                     borderRadius:
//                         BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: AppColors.mediumGray
//                             .withOpacity(0.1),
//                         blurRadius: 10,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                     children: [
//                       // Header Row
//                       Row(
//                         mainAxisAlignment:
//                             MainAxisAlignment
//                                 .spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment:
//                                 CrossAxisAlignment
//                                     .start,
//                             children: [
//                               CustomText(
//                                 txt: "ORDER",
//                                 fontSize: 10,
//                                 fontWeight:
//                                     FontWeight.w600,
//                                 color: AppColors
//                                     .mediumGray,

//                                 // letterSpacing: 0.5,
//                               ),
//                               CustomText(
//                                 txt:
//                                     order.orderNumber,
//                                 fontSize: 16,
//                                 fontWeight:
//                                     FontWeight.bold,
//                                 color: AppColors
//                                     .darkText,
//                               ),
//                             ],
//                           ),
//                           // Status Badge
//                           Container(
//                             padding:
//                                 EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 6,
//                                 ),
//                             decoration: BoxDecoration(
//                               color: _getStatusColor(
//                                 order.status,
//                               ).withOpacity(0.1),
//                               borderRadius:
//                                   BorderRadius.circular(
//                                     20,
//                                   ),
//                               border: Border.all(
//                                 color:
//                                     _getStatusColor(
//                                       order.status,
//                                     ).withOpacity(
//                                       0.3,
//                                     ),
//                                 width: 1,
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.circle,
//                                   size: 8,
//                                   color:
//                                       _getStatusColor(
//                                         order.status,
//                                       ),
//                                 ),
//                                 SizedBox(width: 6),
//                                 CustomText(
//                                   txt: order
//                                       .statusText
//                                       .toUpperCase(),
//                                   fontSize: 11,
//                                   fontWeight:
//                                       FontWeight.w600,
//                                   color:
//                                       _getStatusColor(
//                                         order.status,
//                                       ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),

//                       SizedBox(height: 16),

//                       // Route Information
//                       Container(
//                         padding: EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color:
//                               AppColors.lightBorder,
//                           borderRadius:
//                               BorderRadius.circular(
//                                 12,
//                               ),
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                   padding:
//                                       EdgeInsets.all(
//                                         6,
//                                       ),
//                                   decoration: BoxDecoration(
//                                     color: AppColors
//                                         .electricTeal,
//                                     borderRadius:
//                                         BorderRadius.circular(
//                                           8,
//                                         ),
//                                   ),
//                                   child: Icon(
//                                     Icons
//                                         .location_on_outlined,
//                                     size: 16,
//                                     color: AppColors
//                                         .pureWhite,
//                                   ),
//                                 ),
//                                 SizedBox(width: 12),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment
//                                             .start,
//                                     children: [
//                                       CustomText(
//                                         txt: "Pickup",
//                                         fontSize: 10,
//                                         color: AppColors
//                                             .mediumGray,
//                                         fontWeight:
//                                             FontWeight
//                                                 .w500,
//                                       ),
//                                       CustomText(
//                                         txt: order
//                                             .pickupCity,
//                                         fontSize: 14,
//                                         fontWeight:
//                                             FontWeight
//                                                 .w600,
//                                         color: AppColors
//                                             .darkText,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             SizedBox(height: 8),

//                             Padding(
//                               padding:
//                                   EdgeInsets.only(
//                                     left: 24,
//                                   ),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     height: 20,
//                                     width: 2,
//                                     color: AppColors
//                                         .mediumGray
//                                         .withOpacity(
//                                           0.3,
//                                         ),
//                                   ),
//                                   Icon(
//                                     Icons
//                                         .arrow_downward,
//                                     size: 16,
//                                     color: AppColors
//                                         .mediumGray,
//                                   ),
//                                   Container(
//                                     height: 20,
//                                     width: 2,
//                                     color: AppColors
//                                         .mediumGray
//                                         .withOpacity(
//                                           0.3,
//                                         ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             SizedBox(height: 8),

//                             Row(
//                               children: [
//                                 Container(
//                                   padding:
//                                       EdgeInsets.all(
//                                         6,
//                                       ),
//                                   decoration: BoxDecoration(
//                                     color: AppColors
//                                         .limeGreen,
//                                     borderRadius:
//                                         BorderRadius.circular(
//                                           8,
//                                         ),
//                                   ),
//                                   child: Icon(
//                                     Icons.location_on,
//                                     size: 16,
//                                     color: AppColors
//                                         .electricTeal,
//                                   ),
//                                 ),
//                                 SizedBox(width: 12),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment
//                                             .start,
//                                     children: [
//                                       CustomText(
//                                         txt:
//                                             "Delivery",
//                                         fontSize: 10,
//                                         color: AppColors
//                                             .mediumGray,
//                                         fontWeight:
//                                             FontWeight
//                                                 .w500,
//                                       ),
//                                       CustomText(
//                                         txt: order
//                                             .deliveryCity,
//                                         fontSize: 14,
//                                         fontWeight:
//                                             FontWeight
//                                                 .w600,
//                                         color: AppColors
//                                             .darkText,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),

//                       SizedBox(height: 16),

//                       // Order Details Row
//                       Row(
//                         mainAxisAlignment:
//                             MainAxisAlignment
//                                 .spaceBetween,
//                         children: [
//                           // Product Info
//                           if (order.productType !=
//                               null)
//                             _buildDetailItem(
//                               icon: Icons
//                                   .inventory_2_outlined,
//                               label: "Product",
//                               value:
//                                   order.productType!,
//                             ),

//                           // Weight Info
//                           if (order.totalWeightKg !=
//                               null)
//                             _buildDetailItem(
//                               icon: Icons
//                                   .scale_outlined,
//                               label: "Weight",
//                               value:
//                                   "${order.totalWeightKg} kg",
//                             ),

//                           // Cost Info
//                           if (order.finalCost != null)
//                             _buildDetailItem(
//                               icon: Icons
//                                   .attach_money_outlined,
//                               label: "Cost",
//                               value:
//                                   "\$${order.finalCost}",
//                             ),
//                         ],
//                       ),

//                       SizedBox(height: 12),

//                       // Driver & Vehicle Info
//                       Container(
//                         padding: EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: AppColors.skyBlue,
//                           borderRadius:
//                               BorderRadius.circular(
//                                 12,
//                               ),
//                           border: Border.all(
//                             color: AppColors.skyBlue
//                                 .withOpacity(0.3),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             // Driver Info
//                             Expanded(
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       color: AppColors
//                                           .electricTeal
//                                           .withOpacity(
//                                             0.1,
//                                           ),
//                                       borderRadius:
//                                           BorderRadius.circular(
//                                             20,
//                                           ),
//                                     ),
//                                     child: Icon(
//                                       Icons
//                                           .person_outline,
//                                       color: AppColors
//                                           .electricTeal,
//                                       size: 20,
//                                     ),
//                                   ),
//                                   SizedBox(width: 10),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment
//                                             .start,
//                                     children: [
//                                       CustomText(
//                                         txt: "Driver",
//                                         fontSize: 10,
//                                         color: AppColors
//                                             .mediumGray,
//                                       ),
//                                       Row(
//                                         children: [
//                                           CustomText(
//                                             txt: order
//                                                 .driver
//                                                 .name,
//                                             fontSize:
//                                                 13,
//                                             fontWeight:
//                                                 FontWeight
//                                                     .w600,
//                                           ),
//                                           SizedBox(
//                                             width: 4,
//                                           ),
//                                           Row(
//                                             children: [
//                                               Icon(
//                                                 Icons
//                                                     .star,
//                                                 size:
//                                                     12,
//                                                 color:
//                                                     AppColors.skyBlue,
//                                               ),
//                                               SizedBox(
//                                                 width:
//                                                     2,
//                                               ),
//                                               CustomText(
//                                                 txt: order
//                                                     .driver
//                                                     .rating,
//                                                 fontSize:
//                                                     11,
//                                                 fontWeight:
//                                                     FontWeight.w600,
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             // Vehicle Info
//                             Expanded(
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       color: AppColors
//                                           .skyBlue
//                                           .withOpacity(
//                                             0.1,
//                                           ),
//                                       borderRadius:
//                                           BorderRadius.circular(
//                                             20,
//                                           ),
//                                     ),
//                                     child: Icon(
//                                       Icons
//                                           .local_shipping_outlined,
//                                       color: AppColors
//                                           .skyBlue,
//                                       size: 20,
//                                     ),
//                                   ),
//                                   SizedBox(width: 10),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment
//                                             .start,
//                                     children: [
//                                       CustomText(
//                                         txt:
//                                             "Vehicle",
//                                         fontSize: 10,
//                                         color: AppColors
//                                             .mediumGray,
//                                       ),
//                                       CustomText(
//                                         txt: order
//                                             .vehicle
//                                             .vehicleType,
//                                         fontSize: 13,
//                                         fontWeight:
//                                             FontWeight
//                                                 .w600,
//                                         maxLines: 1,
//                                         overflow:
//                                             TextOverflow
//                                                 .ellipsis,
//                                       ),
//                                       CustomText(
//                                         txt: order
//                                             .vehicle
//                                             .registrationNumber,
//                                         fontSize: 11,
//                                         color: AppColors
//                                             .mediumGray,
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       SizedBox(height: 12),

//                       // Track Button
//                       Container(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // Tracking screen pe navigate karen
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors
//                                 .electricTeal
//                                 .withOpacity(0.1),
//                             foregroundColor: AppColors
//                                 .electricTeal,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius:
//                                   BorderRadius.circular(
//                                     12,
//                                   ),
//                               side: BorderSide(
//                                 color: AppColors
//                                     .electricTeal
//                                     .withOpacity(0.3),
//                               ),
//                             ),
//                             padding:
//                                 EdgeInsets.symmetric(
//                                   vertical: 14,
//                                 ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment:
//                                 MainAxisAlignment
//                                     .center,
//                             children: [
//                               Icon(
//                                 Icons.map_outlined,
//                                 size: 18,
//                               ),
//                               SizedBox(width: 8),
//                               CustomText(
//                                 txt: "Track Order",
//                                 fontWeight:
//                                     FontWeight.w600,
//                                 fontSize: 14,
//                               ),
//                               SizedBox(width: 8),
//                               Icon(
//                                 Icons.arrow_forward,
//                                 size: 16,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//   },
//   loading: () =>
//       Center(child: CircularProgressIndicator()),
//   error: (error, stackTrace) => Container(
//     padding: EdgeInsets.all(20),
//     decoration: BoxDecoration(
//       color: AppColors.pureWhite,
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Center(
//       child: Column(
//         children: [
//           Icon(
//             Icons.error_outline,
//             size: 48,
//             color: AppColors.skyBlue,
//           ),
//           SizedBox(height: 12),
//           CustomText(
//             txt: "Failed to load orders",
//             color: AppColors.skyBlue,
//             fontWeight: FontWeight.w500,
//           ),
//         ],
//       ),
//     ),
//   ),
// ),

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

    // final orderResponse = ref.watch(orderControllerProvider);

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

                          // Stats UI
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

                          // Active Orders ke tile me ye changes karein:
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
                                  children: dashboard
                                      .data
                                      .activeOrders // <-- List<ActiveOrder> object
                                      .take(3)
                                      .map((order) {
                                        // <-- 'order' ab ActiveOrder type ka object hai
                                        return GestureDetector(
                                          onTap: () {
                                            // Yahan order.id ya order.trackingCode use kar sakte hain
                                            print("Order ID: ${order.id}");
                                            print(
                                              "Tracking Code: ${order.trackingCode}",
                                            );
                                          },
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
                                                      txt: order
                                                          .orderNumber, // <-- DIRECT ACCESS
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
                                                      txt: order.status
                                                          .toUpperCase(), // <-- DIRECT ACCESS
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
                                                            "${order.pickupCity} to ${order.deliveryCity}", // <-- DIRECT ACCESS
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

                          // Recent Orders
                          // Recent Orders ke tile me ye changes karein:
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
                                  children: dashboard
                                      .data
                                      .recentOrders // <-- List<RecentOrder> object
                                      .take(3)
                                      .map((order) {
                                        // <-- 'order' ab RecentOrder type ka object hai
                                        // Status color set karne ke liye
                                        _getStatusColor(order.status);

                                        // Time format karne ke liye
                                        String formattedTime = DateFormat(
                                          'dd MMM yyyy • hh:mm a',
                                        ).format(order.createdAt);

                                        return buildOrderTile(
                                          order
                                              .orderNumber, // <-- DIRECT ACCESS
                                          order.status, // <-- DIRECT ACCESS
                                          formattedTime, // <-- Formatted time
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

  // Helper method for status colors
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'assigned':
        return AppColors.electricTeal;
      case 'in_transit':
        return AppColors.limeGreen;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.mediumGray;
    }
  }

  // Helper Widget for detail items
  // Widget _buildDetailItem({
  //   required IconData icon,
  //   required String label,
  //   required String value,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         children: [
  //           Icon(icon, size: 14, color: AppColors.mediumGray),
  //           SizedBox(width: 4),
  //           CustomText(txt: label, fontSize: 10, color: AppColors.mediumGray),
  //         ],
  //       ),
  //       SizedBox(height: 4),
  //       CustomText(
  //         txt: value,
  //         fontSize: 13,
  //         fontWeight: FontWeight.w600,
  //         maxLines: 1,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //     ],
  //   );
  // }

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

  // Helper widget for recent orders
  Widget buildOrderTile(String orderNumber, String status, String time) {
    Color statusColor = _getStatusColor(status);
    IconData statusIcon = Icons.pending;
    String statusText = status;

    // Status ke hisaab se icon aur color set karein
    if (status.toLowerCase() == "completed") {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = "Delivered";
    } else if (status.toLowerCase() == "assigned") {
      statusColor = AppColors.electricTeal;
      statusIcon = Icons.local_shipping;
      statusText = "In Transit";
    } else if (status.toLowerCase() == "pending") {
      statusColor = Colors.orange;
      statusIcon = Icons.pending;
      statusText = "Pending";
    } else if (status.toLowerCase() == "cancelled") {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
      statusText = "Cancelled";
    }

    return GestureDetector(
      onTap: () {
        // Yahan order details screen pe navigate karein
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => OrderDetailsScreen(orderId: order.id),
        //   ),
        // );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.mediumGray.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomText(
                      txt: "Order: ",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.electricTeal,
                    ),
                    CustomText(
                      txt: orderNumber,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 16),
                    SizedBox(width: 6),
                    CustomText(
                      txt: statusText.toUpperCase(),
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
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
