import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../common_widgets/custom_text.dart';

class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      appBar: AppBar(
        backgroundColor: AppColors.electricTeal,
        elevation: 0,
        title: const Text(
          "Customer Support",
          style: TextStyle(color: AppColors.pureWhite, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      leading: RotatedBox(
          quarterTurns: 2,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.pureWhite,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Quick Actions Row ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _supportAction(
                  icon: Icons.phone_outlined,
                  label: "Call",
                  color: Colors.green,
                  onTap: () {
                    // Launch phone call
                  },
                ),
                _supportAction(
                  icon: Icons.email_outlined,
                  label: "Email",
                  color: Colors.blue,
                  onTap: () {
                    // Launch email client
                  },
                ),
                _supportAction(
                  icon: Icons.chat_bubble_outline,
                  label: "Chat",
                  color: AppColors.electricTeal,
                  onTap: () {
                    // Open chat screen
                  },
                ),
              ],
            ),
            const SizedBox(height: 25),

            // --- FAQ Section ---
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                txt: "FAQs",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.electricTeal,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _faqTile("How to create an order?", "Learn how to place orders in Drovvi.", context),
                  _faqTile("How to track my shipment?", "Real-time tracking for your packages.", context),
                  _faqTile("Payment methods?", "We support multiple payment options.", context),
                  _faqTile("Change delivery address?", "Easily update your delivery info.", context),
                  _faqTile("Cancel order?", "Cancel orders before they are shipped.", context),
                ],
              ),
            ),

            // --- Raise a Ticket ---
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                txt: "Raise a Query",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.electricTeal,
              ),
            ),
            const SizedBox(height: 10),
        TextField(
  maxLines: 3,
  decoration: InputDecoration(
    hintText: "Describe your issue here...",
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey, width: 1), // Gray border when not focused
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.electricTeal, width: 2), // Teal when focused
    ),
  ),
),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Submit ticket logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.electricTeal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: AppColors.pureWhite),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _supportAction({
    required IconData icon,
    required String label,
    required Color color,
    required void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

Widget _faqTile(String question, String answer, BuildContext context) {
  return Card(
    elevation: 1,
    margin: const EdgeInsets.symmetric(vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: AppColors.electricTeal.withOpacity(0.2)),
    ),
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        iconColor: AppColors.electricTeal,
        collapsedIconColor: AppColors.electricTeal,
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          Text(
            answer,
            style: const TextStyle(color: Colors.black87),
          ),
        ],
      ),
    ),
  );
}

}
