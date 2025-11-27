import 'package:flutter/material.dart';
import '../../../../common_widgets/custom_button.dart';
import '../../../../common_widgets/custom_text.dart';
import '../../../../constants/colors.dart';

class SearchProductWidget extends StatefulWidget {
  const SearchProductWidget({super.key});

  @override
  State<SearchProductWidget> createState() => _SearchProductWidgetState();
}

class _SearchProductWidgetState extends State<SearchProductWidget> {
  final TextEditingController searchCtrl = TextEditingController();
  final searchfocus = FocusNode();
  bool isLoading = false;

  int? selectedIndex; // <-- SELECTED PRODUCT INDEX

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
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: demoProducts.length,
              separatorBuilder: (_, __) => SizedBox(height: 16),
              itemBuilder: (context, index) {
                final p = demoProducts[index];
                bool isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.pureWhite
                          : AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(12),

                      border: Border.all(
                        color: isSelected
                            ? AppColors.electricTeal
                            : AppColors.mediumGray.withOpacity(0.2),
                        width: 1.5,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mediumGray.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                txt: p["name"],
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(height: 2),
                              CustomText(txt: "SKU: ${p["sku"]}", fontSize: 13),
                              CustomText(txt: p["price"], fontSize: 13),
                              CustomText(txt: p["weight"], fontSize: 13),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 10),

          // BOTTOM BUTTON OUTSIDE CARD
          
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomButton(
                text: selectedIndex == null
                    ? "Please select your product"
                    : "Add to your product",
                backgroundColor: selectedIndex == null
                    ? AppColors.lightGrayBackground
                    : AppColors.electricTeal,
                borderColor: selectedIndex == null
                    ? AppColors.electricTeal
                    : AppColors.electricTeal,
                textColor: selectedIndex == null
                    ? AppColors.electricTeal
                    : AppColors.pureWhite,
                onPressed: selectedIndex == null
                    ? null
                    : () {
                        // ADD LOGIC HERE
                      },
              ),
            ),
          
        ],
      ),
    );
  }
}
