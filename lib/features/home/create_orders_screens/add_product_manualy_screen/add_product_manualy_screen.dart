import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/search_screen/search_controller.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/search_screen/search_screen.dart';
import '../../../../common_widgets/cuntom_textfield.dart';
import '../../../../common_widgets/custom_button.dart';
import '../../../../common_widgets/custom_text.dart';
import '../../../../constants/colors.dart';

class AddManualItemModal extends ConsumerStatefulWidget {
  const AddManualItemModal({super.key});

  @override
  ConsumerState<AddManualItemModal> createState() => _AddManualItemModalState();
}

class _AddManualItemModalState extends ConsumerState<AddManualItemModal> {
  final TextEditingController packageController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController decvalueController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController skuController = TextEditingController();
  final FocusNode packageFocus = FocusNode();
  final FocusNode quantityFocus = FocusNode();
  final FocusNode weightFocus = FocusNode();
  final FocusNode decvalueFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  final FocusNode skuFocus = FocusNode();

  @override
  void dispose() {
    packageController.dispose();
    quantityController.dispose();
    weightController.dispose();
    decvalueController.dispose();
    descriptionController.dispose();
    skuController.dispose();
    packageFocus.dispose();
    quantityFocus.dispose();
    weightFocus.dispose();
    decvalueFocus.dispose();
    descriptionFocus.dispose();
    skuFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                txt: "Add Item Manually",
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkText,
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: AppColors.darkText),
              ),
            ],
          ),

          SizedBox(height: 16),

          // package Field
          CustomAnimatedTextField(
            controller: packageController,
            focusNode: packageFocus,
            labelText: "Package Name",
            hintText: "Package Name",
            prefixIcon: Icons.add_shopping_cart_outlined,
            iconColor: AppColors.electricTeal,
            borderColor: AppColors.electricTeal,
            textColor: AppColors.darkText,
          ),

          SizedBox(height: 8),

          CustomAnimatedTextField(
            controller: quantityController,
            focusNode: quantityFocus,
            labelText: "Quantity",
            hintText: "Quantity",
            prefixIcon: Icons.add_shopping_cart_outlined,
            iconColor: AppColors.electricTeal,
            borderColor: AppColors.electricTeal,
            textColor: AppColors.darkText,
          ),

          SizedBox(height: 8),

          CustomAnimatedTextField(
            controller: weightController,
            focusNode: weightFocus,
            labelText: "Weight",
            hintText: "Weight",
            prefixIcon: Icons.add_shopping_cart_outlined,
            iconColor: AppColors.electricTeal,
            borderColor: AppColors.electricTeal,
            textColor: AppColors.darkText,
          ),

          SizedBox(height: 8),

          CustomAnimatedTextField(
            controller: decvalueController,
            focusNode: decvalueFocus,
            labelText: "Declared Value",
            hintText: "Declared Value",
            prefixIcon: Icons.add_shopping_cart_outlined,
            iconColor: AppColors.electricTeal,
            borderColor: AppColors.electricTeal,
            textColor: AppColors.darkText,
          ),

          SizedBox(height: 8),

          CustomAnimatedTextField(
            controller: descriptionController,
            focusNode: descriptionFocus,
            labelText: "Description",
            hintText: "Description",
            prefixIcon: Icons.add_shopping_cart_outlined,
            iconColor: AppColors.electricTeal,
            borderColor: AppColors.electricTeal,
            textColor: AppColors.darkText,
          ),

          SizedBox(height: 8),

          CustomAnimatedTextField(
            controller: skuController,
            focusNode: skuFocus,
            labelText: "SKU (optional)",
            hintText: "SKU (optional)",
            prefixIcon: Icons.add_shopping_cart_outlined,
            iconColor: AppColors.electricTeal,
            borderColor: AppColors.electricTeal,
            textColor: AppColors.darkText,
          ),

          SizedBox(height: 22),

          // BUTTONS
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: "Cancel",
                  backgroundColor: Colors.transparent,
                  borderColor: AppColors.electricTeal,
                  textColor: AppColors.electricTeal,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: "Add",
                  backgroundColor: AppColors.electricTeal,
                  borderColor: AppColors.electricTeal,
                  textColor: AppColors.lightGrayBackground,
                  onPressed: () {
                    final item = PackageItem(
                      name: packageController.text.trim(),
                      qty: quantityController.text.trim(),
                      weight: weightController.text.trim(),
                      value: decvalueController.text.trim(),
                      note: descriptionController.text.trim(),
                      sku: skuController.text.trim(),
                    );

                    ref.read(packageItemsProvider.notifier).addItem(item);

                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}
