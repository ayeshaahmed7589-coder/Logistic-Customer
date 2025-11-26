import 'package:flutter/material.dart';

import '../../../../common_widgets/cuntom_textfield.dart';
import '../../../../common_widgets/custom_text.dart';
import '../../../../constants/colors.dart';

class SearchProductWidget extends StatefulWidget {
  @override
  State<SearchProductWidget> createState() => _SearchProductWidgetState();
}

class _SearchProductWidgetState extends State<SearchProductWidget> {
  final TextEditingController searchCtrl = TextEditingController();
  final searchfocus = FocusNode();
  bool isLoading = false;

  List<Map<String, dynamic>> demoProducts = [
    {
      "name": "MacBook Pro 14-inch",
      "sku": "MBP-14-001",
      "price": "R15,000",
      "weight": "1.6 kg",
      "icon": Icons.laptop_mac,
    },
    {
      "name": "Dell Inspiron 15",
      "sku": "DELL-15-001",
      "price": "R8,500",
      "weight": "2.1 kg",
      "icon": Icons.computer,
    },
    {
      "name": "HP Pavilion Desktop",
      "sku": "HP-DT-001",
      "price": "R12,000",
      "weight": "5.0 kg",
      "icon": Icons.desktop_windows,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SEARCH BAR + CLOSE ICON
          Row(
            children: [
              CustomText(
                txt: "Search Product",
                fontSize: 18,
                color: AppColors.darkText,
                fontWeight: FontWeight.w600,
              ),
              Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: AppColors.mediumGray),
              ),
            ],
          ),

          SizedBox(height: 10),

          Container(
            height: 52,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppColors.electricTeal.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: AppColors.electricTeal,
                  size: 24,
                ),
                SizedBox(width: 12),

                // Yahan TextField ko readOnly kar diya — taake click sirf modal khole
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search Shopify Products...",
                      hintStyle: TextStyle(
                        color: AppColors.mediumGray,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(
                      color: AppColors.darkText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // PRODUCT LIST
          Expanded(
            child: ListView.separated(
              itemCount: demoProducts.length,
              separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
              itemBuilder: (context, index) {
                final p = demoProducts[index];

                return Row(
                  children: [
                    Icon(p["icon"], size: 30, color: AppColors.electricTeal),

                    SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            txt: p["name"],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(txt: "SKU: ${p["sku"]}"),
                          CustomText(txt: p["price"]),
                          CustomText(txt: p["weight"]),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.electricTeal),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomText(
                          txt: "Add",
                          color: AppColors.electricTeal,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
