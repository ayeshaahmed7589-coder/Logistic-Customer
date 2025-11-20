import 'package:flutter/material.dart';
import 'package:logisticscustomer/common_widgets/custom_button.dart';
import 'package:logisticscustomer/common_widgets/custom_text.dart';
import 'package:logisticscustomer/constants/colors.dart';
import 'package:logisticscustomer/constants/gap.dart';

class OrderCompleteScreen extends StatelessWidget {
  const OrderCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------- CLOSE ICON -------------------
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                  child: Icon(Icons.close, size: 22, color: AppColors.darkText),
                ),
              ),

              const SizedBox(height: 20),

              // ------------------- TITLE -------------------
              CustomText(
                txt: "Order Delivered!",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),

              const SizedBox(height: 8),

              CustomText(
                txt: "Your package has been delivered successfully",
                fontSize: 14,
                color: AppColors.mediumGray,
              ),

              const SizedBox(height: 20),

              // ------------------- ORDER DETAILS -------------------
              CustomText(
                txt: "Order #12345",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
              const SizedBox(height: 4),
              CustomText(
                txt: "Delivered: Jan 15, 3PM",
                fontSize: 14,
                color: AppColors.mediumGray,
              ),

              const SizedBox(height: 16),

              // ------------------- PAID -------------------
              Row(
                children: [
                  const Icon(
                    Icons.payments_outlined,
                    size: 22,
                    color: AppColors.electricTeal,
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    txt: "Paid: \$70.00",
                    fontSize: 14,
                    color: AppColors.darkText,
                  ),
                ],
              ),

              gapH24,

              // ------------------- RATE DRIVER -------------------
              Row(
                children: [
                  CustomText(
                    txt: "Rate Your Driver",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),

              gapH12,

              // Stars Row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                  5,
                  (index) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(Icons.star, size: 25, color: Colors.amber),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ------------------- WRITE REVIEW -------------------
              CustomText(
                txt: "Write a review",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.darkText,
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.electricTeal, width: 1),
                ),
                child: TextField(
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "(Optional)",
                    border: InputBorder.none,
                  ),
                ),
              ),

              // ------------------- SUBMIT BUTTON -------------------
              Padding(
                padding: const EdgeInsets.all(16),
                child: CustomButton(
                  isChecked: true,
                  text: "Submit Review",
                  backgroundColor: AppColors.pureWhite,
                  borderColor: AppColors.electricTeal,
                  textColor: AppColors.electricTeal,
                  onPressed: () {},
                ),
              ),

              // ------------------- VIEW RECEIPT -------------------
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: CustomText(
                    txt: "View Receipt",
                    fontSize: 14,
                    color: AppColors.electricTeal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
