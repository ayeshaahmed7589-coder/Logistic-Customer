import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/delivery_detail_screen.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/search_screen/search_controller.dart';
import '../../../../common_widgets/custom_button.dart';
import '../../../../common_widgets/custom_text.dart';
import '../../../../constants/colors.dart';
class PackageItem {
  final String name;
  final String qty;
  final String weight;
  final String value;
  final String note;
  final String sku;
  final bool isFromShopify; // New field

  PackageItem({
    required this.name,
    required this.qty,
    required this.weight,
    required this.value,
    required this.note,
    required this.sku,
    this.isFromShopify = false, // Default false
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'qty': qty,
      'weight': weight,
      'value': value,
      'note': note,
      'sku': sku,
      'isFromShopify': isFromShopify,
    };
  }

  factory PackageItem.fromMap(Map<String, dynamic> map) {
    return PackageItem(
      name: map['name'] ?? "",
      qty: map['qty'] ?? "",
      weight: map['weight'] ?? "",
      value: map['value'] ?? "",
      note: map['note'] ?? "",
      sku: map['sku'] ?? "",
      isFromShopify: map['isFromShopify'] ?? false,
    );
  }
}


class SearchProductWidget extends ConsumerStatefulWidget {
  const SearchProductWidget({super.key});

  @override
  ConsumerState<SearchProductWidget> createState() =>
      _SearchProductWidgetState();
}

class _SearchProductWidgetState extends ConsumerState<SearchProductWidget> {
  final TextEditingController searchCtrl = TextEditingController();
  final searchFocus = FocusNode();

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(shopifySearchControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
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

          // SEARCH BAR
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
                Icon(Icons.search_rounded, color: AppColors.electricTeal),
                SizedBox(width: 12),

                Expanded(
                  child: TextField(
                    controller: searchCtrl,
                    onChanged: (value) {
                      ref
                          .read(shopifySearchControllerProvider.notifier)
                          .search(value);
                    },
                    decoration: InputDecoration(
                      hintText: "Search Shopify Products...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // PRODUCT LIST
          Expanded(
            child: searchState.when(
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error loading products")),
              data: (data) {
                final products = data?.products ?? [];

                if (products.isEmpty) {
                  return Center(child: Text("No products found"));
                }

                return ListView.separated(
                  itemCount: products.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16),
                  itemBuilder: (_, index) {
                    final p = products[index];

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
                          color: AppColors.pureWhite,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.electricTeal
                                : AppColors.mediumGray.withOpacity(0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.mediumGray.withOpacity(0.30),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              txt: p.title,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 2),
                            CustomText(
                              txt: "Price: R${p.variants.first.price}",
                              fontSize: 13,
                            ),
                            CustomText(
                              txt:
                                  "Weight: ${p.variants.first.weight} ${p.variants.first.weightUnit}",
                              fontSize: 13,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          SizedBox(height: 10),

          // DONE BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: CustomButton(
              text: selectedIndex == null
                  ? "Please select your product"
                  : "Add to your product",
              backgroundColor: selectedIndex == null
                  ? AppColors.lightGrayBackground
                  : AppColors.electricTeal,
              borderColor: AppColors.electricTeal,
              textColor: selectedIndex == null
                  ? AppColors.electricTeal
                  : AppColors.pureWhite,

// SearchProductWidget mein "Add to your product" button ke onPressed ko update karein

onPressed: selectedIndex == null
    ? null
    : () {
        final product = ref
            .read(shopifySearchControllerProvider)
            .value!
            .products[selectedIndex!];

        final variant = product.variants.first;

        // Create PackageItem with isFromShopify = true
        final shopifyItem = PackageItem(
          name: product.title,
          qty: "1", // Default quantity
          weight: "${variant.weight}",
          value: variant.price,
          note: product.productType, // Product type as note
          sku: variant.sku,
          isFromShopify: true, // Mark as from Shopify
        );

        // Add to provider
        ref.read(packageItemsProvider.notifier).addItem(shopifyItem);

        Navigator.pop(context);
      },
              // onPressed: selectedIndex == null
              //     ? null
              //     : () {
              //         final product = ref
              //             .read(shopifySearchControllerProvider)
              //             .value!
              //             .products[selectedIndex!];

              //         final variant = product.variants.first;

              //         // PACKAGE ITEM ADD
              //         ref
              //             .read(packageItemsProvider.notifier)
              //             .addItem(
              //               PackageItem(
              //                 name: product.title,
              //                 qty: "1",
              //                 weight: "${variant.weight}",
              //                 value: variant.price,
              //                 note: "",
              //                 sku: "",
              //               ),
              //             );

              //         Navigator.pop(context);
              //       },
            ),
          ),
        ],
      ),
    );
  }
}
