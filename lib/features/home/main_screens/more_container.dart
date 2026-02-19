import 'package:flutter/material.dart';
import 'package:logisticscustomer/common_widgets/custom_text.dart';
import 'package:logisticscustomer/constants/colors.dart';

class MoreOptionsContainer extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function()? onTap;
  final bool showDot;

  const MoreOptionsContainer({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppColors.electricTeal;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        width: 122,
        decoration: BoxDecoration(
          color: AppColors.electricTeal.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.electricTeal),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10, top: 15),
              height: 28,
              width: 28,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: Icon(icon, size: 28, color: AppColors.electricTeal),
                  ),

                  if (showDot)
                    Positioned(
                      right: -3,
                      top: -3,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.electricTeal,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: 110,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: CustomText(
                txt: text,
                fontSize: 13,
                color: textColor,
                align: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
