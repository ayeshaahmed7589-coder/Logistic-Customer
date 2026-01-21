// import 'package:flutter/material.dart';
// import 'package:logisticscustomer/common_widgets/custom_text.dart';
// import 'package:logisticscustomer/constants/colors.dart';
// import 'package:logisticscustomer/constants/gap.dart';

// class FutureScreen extends StatelessWidget {
//   const FutureScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final trips = [
//       {
//         'name': 'John Doe',
//         'address': '6391 Elgin St. Celina, Delaware 10299',
//         'product': '02',
//         'price': '\$52.01',
//         'distance': '14 mi',
//         'workOrder': 'WO# 04-1209',
//         'index': '01',
//       },
//       {
//         'name': 'John Doe',
//         'address': '6391 Elgin St. Celina, Delaware 10299',
//         'product': '02',
//         'price': '\$52.01',
//         'distance': '14 mi',
//         'workOrder': 'WO# 04-1209',
//         'index': '02',
//       },
//       {
//         'name': 'John Doe',
//         'address': '6391 Elgin St. Celina, Delaware 10299',
//         'product': '02',
//         'price': '\$52.01',
//         'distance': '14 mi',
//         'workOrder': 'WO# 04-1209',
//         'index': '03',
//       },
//     ];

//     return Column(
//       children: [
//         gapH12,

//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               CustomText(txt: "Work Order for 26/12/23", fontSize: 16),

//               Icon(
//                 Icons.filter_alt_outlined,
//                 color: AppColors.electricTeal,
//                 size: 30,
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: trips.length,
//             itemBuilder: (context, index) {
//               final trip = trips[index];
//               return Column(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(bottom: 16),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                            color: AppColors.pureWhite,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                            color: AppColors.darkText.withOpacity(0.05),
//                           blurRadius: 6,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               trip['name']!,
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                  color: AppColors.darkText,
//                               ),
//                             ),
//                             Container(
//                               width: 110,
//                               height: 25,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 color: AppColors.electricTeal,
//                                 borderRadius: BorderRadius.circular(2),
//                               ),
//                               child: CustomText(
//                                 txt: trip['workOrder']!,
//                                 fontSize: 13,
//                                      color: AppColors.pureWhite,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.location_on_outlined,
//                               color: AppColors.electricTeal,
//                               size: 18,
//                             ),
//                             const SizedBox(width: 6),
//                             Expanded(
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     trip['address']!,
//                                     style: const TextStyle(
//                                        color: AppColors.mediumGray,
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Icon(
//                                     Icons.directions,
//                                     color: AppColors.electricTeal,
//                                     size: 28,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.shopping_bag_outlined,
//                               color: AppColors.electricTeal,
//                               size: 18,
//                             ),
//                             const SizedBox(width: 6),
//                             Text(
//                               "Product - ",
//                               style: const TextStyle(
//                                  color: AppColors.mediumGray,
//                                 fontSize: 13,
//                               ),
//                             ),
//                             CustomText(
//                               txt: " ${trip['product']!}",
//                               color: AppColors.electricTeal,
//                               fontSize: 13,
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.attach_money,
//                               color: AppColors.electricTeal,
//                               size: 18,
//                             ),
//                             const SizedBox(width: 6),
//                             Text(
//                               "Price - ",
//                               style: const TextStyle(
//                                 color: AppColors.mediumGray,
//                                 fontSize: 13,
//                               ),
//                             ),
//                             CustomText(
//                               txt: " ${trip['price']}",
//                               color: AppColors.electricTeal,
//                               fontSize: 13,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
