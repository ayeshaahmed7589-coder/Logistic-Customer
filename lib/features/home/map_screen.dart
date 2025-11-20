import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:logisticscustomer/common_widgets/custom_button.dart';
import 'package:logisticscustomer/common_widgets/custom_text.dart';
import 'package:logisticscustomer/constants/colors.dart';
import 'package:logisticscustomer/constants/gap.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //appbar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.electricTeal,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black26,
                //     blurRadius: 6,
                //     offset: Offset(0, 3),
                //   )
                // ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // --- LEFT SIDE (Close Icon) ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: AppColors.pureWhite),
                    ),
                  ),

                  // --- CENTER TITLE ---
                  CustomText(
                    txt: "Track Order",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pureWhite,
                  ),

                  // --- RIGHT SIDE (Step indicator) ---
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: CustomText(
                  //     txt: "[1/4]",
                  //     fontSize: 14,
                  //     color: AppColors.pureWhite,
                  //   ),
                  // ),
                ],
              ),
            ),
            //appbar end
            // ---------------- MAP VIEW ----------------
            Container(
              height: 300,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(minZoom: 5, maxZoom: 18),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.logisticdriverapp',
                  ),
                ],
              ),
            ),

            // ---------------- STATUS ----------------
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: AppColors.electricTeal,
                        size: 12,
                      ),
                      SizedBox(width: 8),
                      CustomText(
                        txt: "In Transit",
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ],
                  ),
                  gapH12,

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.subtleGray,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TOP COUNTS ROW
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _summaryItem("ETA", "15 minutes"),
                            _verticalDivider(),
                            _summaryItem("Distance", "3.2 km"),
                          ],
                        ),

                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                  gapH12,

                  // ---------------- DRIVER INFO ----------------
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.subtleGray,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _collectionRow(Icons.person, "Driver: John D."),
                        _divider(),
                        _collectionRow(Icons.star, "4.8 rating"),
                        _divider(),
                        _collectionRow(Icons.local_taxi, "ABC-1234"),
                        _divider(),
                        _collectionRow(Icons.phone, "Call Driver"),
                      ],
                    ),
                  ),

                  gapH16,
                  const Divider(color: AppColors.electricTeal),
                  gapH16,

                  // ---------------- DELIVERY ADDRESS ----------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, color: AppColors.electricTeal),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomText(
                          txt:
                              "Delivery Address : 456 XYZ Avenue , Karachi, Pakistan",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // ---------------- SHARE LIVE LOCATION ----------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text: "Share Live Location",
                      backgroundColor: AppColors.lightGrayBackground,
                      borderColor: AppColors.electricTeal,
                      textColor: AppColors.electricTeal,
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => DeliveryDetailScreen(),
                        //   ),
                        // );
                      },
                    ),
                  ),
                  gapH20,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.electricTeal,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.darkText),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(width: 2, height: 32, color: AppColors.electricTeal);
  }

  Widget _collectionRow(IconData icon, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 22, color: AppColors.electricTeal),
          CustomText(
            txt: amount,

            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.darkText,
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: AppColors.subtleGray, thickness: 2, height: 4);
  }
}
