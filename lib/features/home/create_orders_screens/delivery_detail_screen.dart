import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/export.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/search_screen/search_controller.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/service_payment_screen.dart';
import 'add_product_manualy_screen/add_product_manualy_screen.dart';
import 'search_screen/search_screen.dart';

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

class PackageDetailsScreen extends StatelessWidget {
  const PackageDetailsScreen({super.key});

  void showSearchProductsModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(vertical: 30),
          backgroundColor: AppColors.lightGrayBackground,
          child: Container(
            width: double.infinity,
            height:
                MediaQuery.of(context).size.height *
                0.73, // center modal height
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SearchProductWidget(), // tumhara UI
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("PACKAGE DETAILS"),

                  const SizedBox(height: 15),

                  //Search
                  GestureDetector(
                    onTap: () {
                      showSearchProductsModal(context);
                    },
                    child: Container(
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
                              readOnly: true,
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
                              onTap: () {
                                showSearchProductsModal(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //Search end
                  const SizedBox(height: 10),
                  Center(
                    child: CustomText(
                      txt: "OR",
                      color: AppColors.darkText,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Item
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mediumGray.withValues(alpha: 0.10),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              txt: "Add Item Manually",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor:
                                      AppColors.lightGrayBackground,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(22),
                                    ),
                                  ),
                                  transitionAnimationController:
                                      AnimationController(
                                        duration: Duration(
                                          milliseconds: 450,
                                        ), // Slow & Smooth
                                        vsync: Navigator.of(context),
                                      ),

                                  // --------------------------------------------------------
                                  builder: (_) => const AddManualItemModal(),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 20,
                                    color: AppColors.electricTeal,
                                  ),
                                  CustomText(
                                    txt: "Add",
                                    fontSize: 15,
                                    color: AppColors.darkText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        gapH8,
                        // Items
                        Consumer(
                          builder: (context, ref, _) {
                            final items = ref.watch(packageItemsProvider);

                            if (items.isEmpty) {
                              return Center(
                                child: CustomText(txt: "No items added yet"),
                              );
                            }

                            return Column(
                              children: List.generate(items.length, (i) {
                                final item = items[i];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: _boxStyle,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              txt: item.name,
                                              color: AppColors.electricTeal,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(height: 4),
                                            _infoRow(
                                              label: "Qty",
                                              value: item.qty,
                                            ),
                                            SizedBox(height: 4),
                                            _infoRow(
                                              label: "Weight",
                                              value: item.weight,
                                            ),
                                            SizedBox(height: 4),
                                            _infoRow(
                                              label: "Value",
                                              value: "R${item.value}",
                                            ),
                                            SizedBox(height: 4),
                                            _infoRow(
                                              label: "Note",
                                              value: item.note,
                                            ),
                                          ],
                                        ),

                                        GestureDetector(
                                          onTap: () {
                                            ref
                                                .read(
                                                  packageItemsProvider.notifier,
                                                )
                                                .removeItem(i);
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 20,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Item end
                  gapH20,

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Consumer(
                          builder: (context, ref, _) {
                            final items = ref.watch(packageItemsProvider);

                            double totalWeight = 0;
                            for (var i in items) {
                              totalWeight += double.tryParse(i.weight) ?? 0;
                            }

                            return Column(
                              children: [
                                _buildInfoRow(
                                  "Total Weight:",
                                  "${totalWeight.toStringAsFixed(1)} kg",
                                ),
                                SizedBox(height: 8),
                                _buildInfoRow(
                                  "Total Items:",
                                  "${items.length}",
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  gapH12,
                  // ---------- Continue Button ----------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text: "Next",
                      backgroundColor: AppColors.electricTeal,
                      borderColor: AppColors.electricTeal,
                      textColor: AppColors.lightGrayBackground,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ServicePaymentScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          txt: label,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.mediumGray,
        ),
        CustomText(
          txt: value,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.electricTeal,
        ),
      ],
    );
  }

  Widget _infoRow({
    required String label,
    required String value,
    Color labelColor = AppColors.mediumGray,
    Color valueColor = AppColors.darkText,
  }) {
    return Row(
      children: [
        CustomText(
          txt: "$label:",
          color: labelColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(width: 8),
        CustomText(
          txt: value,
          color: valueColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.darkText,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

const _boxStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(12)),
  border: Border.fromBorderSide(BorderSide(color: AppColors.electricTeal)),
);
