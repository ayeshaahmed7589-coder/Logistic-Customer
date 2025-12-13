import 'package:flutter/material.dart';
import 'package:logisticscustomer/features/home/conform_order_successfull.dart';

import '../../export.dart';

class EnterOtpFinalScreen extends StatefulWidget {
  const EnterOtpFinalScreen({super.key});

  @override
  State<EnterOtpFinalScreen> createState() => _EnterOtpFinalScreenState();
}

class _EnterOtpFinalScreenState extends State<EnterOtpFinalScreen> {
    TextEditingController otpController = TextEditingController();
     // ignore: unused_field
     bool _isOtpFilled = false;
  bool showConfirmDropdown = false;

  bool isUndelivered = false;
  List<TextEditingController> otp = List.generate(
    6,
    (i) => TextEditingController(),
  );

  List<String> codes = ["FMPMP81935329", "FMPMP81935329"];
  List<bool> selected = [false, false];

  @override
  Widget build(BuildContext context) {
    const Color blueColor = AppColors.electricTeal;
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      appBar: AppBar(
        title: const Text(
          "Enter OTP",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 45,
        leading: IconButton(
          onPressed: () {
            // context.pop();
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 18),
        ),
        backgroundColor: blueColor,
        foregroundColor: AppColors.pureWhite,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity, // FULL WIDTH
                        child: Card(
                          color: AppColors.pureWhite,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // HOW TO GET OTP SECTION — INSIDE CARD
                                CustomText(
                                  txt: "How to get OTP?",
                                  color: blueColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 10),

                                CustomText(
                                  txt: "1. Ask Customer to open App / Website",
                                  fontSize: 16,
                                ),
                                const SizedBox(height: 6),

                                CustomText(
                                  txt: "2. Go to My Orders > Order Details",
                                  fontSize: 16,
                                ),
                                const SizedBox(height: 6),

                                CustomText(
                                  txt: "3. OTP shown on Order Details screen",
                                  fontSize: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      ...List.generate(codes.length, (i) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: AppColors.pureWhite,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.lightBorder,
                                blurRadius: 6,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() => selected[i] = !selected[i]);
                                },
                                child: Container(
                                  height: 26,
                                  width: 26,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: selected[i]
                                        ? blueColor
                                        : AppColors.pureWhite,
                                    border: Border.all(
                                      color: blueColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: selected[i]
                                      ? const Icon(
                                          Icons.check,
                                          size: 18,
                                          color: AppColors.pureWhite,
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              CustomText(
                                txt: codes[i],
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: blueColor,
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 250),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: CustomButton(
                          text: "Enter OTP",
                          backgroundColor: blueColor,
                          borderColor: blueColor,
                          textColor: AppColors.pureWhite,
                          onPressed: () {
                            setState(() => showConfirmDropdown = true);
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: CustomText(
                          txt: "Resend OTP",
                          color: blueColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // DARK OVERLAY
          if (showConfirmDropdown)
            GestureDetector(
              onTap: () => setState(() => showConfirmDropdown = false),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColors.mediumGray,
              ),
            ),

          // BOTTOM DROPDOWN ANIMATION
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
            left: 0,
            right: 0,
            bottom: showConfirmDropdown ? 0 : -500,
            child: confirmOrderDropdown(),
          ),
        ],
      ),
      // bottomNavigationBar: showConfirmDropdown
      //     ? confirmOrderDropdown()
      //     : SizedBox(),
    );
  }

  // DROPDOWN WIDGET
  Widget confirmOrderDropdown() {
    const Color blueColor = AppColors.electricTeal;
    return Container(
      height: 500,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: AppColors.mediumGray,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE + CLOSE BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Confirm Order",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),

              GestureDetector(
                onTap: () => setState(() => showConfirmDropdown = false),
                child: const Icon(Icons.close, size: 26),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // OTP BOXES
             PinCodeTextField(
                appContext: context,
                length: 6,
                controller: otpController,
                obscureText: false,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                autoDismissKeyboard: true,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 50,
                  fieldWidth: 45,
                  // ignore: deprecated_member_use
                  inactiveColor: AppColors.electricTeal.withOpacity(0.3),
                  selectedColor: AppColors.electricTeal,
                  activeColor: AppColors.electricTeal,
                  activeFillColor: AppColors.pureWhite,
                  inactiveFillColor: AppColors.pureWhite,
                  selectedFillColor: AppColors.pureWhite,
                  borderWidth: 1.5,
                ),
                animationDuration: const Duration(milliseconds: 200),
                enableActiveFill: true,
                onChanged: (value) {
                  setState(() {
                    _isOtpFilled = value.length == 6;
                  });
                },
              ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: List.generate(6, (i) {
          //     return Container(
          //       width: 45,
          //       height: 55,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10),
          //         border: Border.all(color: AppColors.electricTeal),
          //       ),
          //       child:
          //        TextField(
          //         controller: otp[i],
          //         maxLength: 1,
          //         textAlign: TextAlign.center,
          //         decoration: const InputDecoration(
          //           counterText: "",
          //           border: InputBorder.none,
          //         ),
          //       ),
          //     );
          //   }),
          // ),

          const SizedBox(height: 22),

          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.electricTeal),
            ),
            child: const Center(child: Text("Click to upload Picture")),
          ),

          const SizedBox(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Doorstep Delivery",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              customToggleSwitch(),
            ],
          ),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: CustomButton(
              text: "Submit",
              backgroundColor: isUndelivered ? blueColor : AppColors.pureWhite,
              borderColor: isUndelivered ? blueColor : blueColor,
              textColor: isUndelivered ? AppColors.pureWhite : blueColor,
              onPressed: isUndelivered
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConformOrderSuccessfull(),
                        ),
                      );
                    }
                  : null, // disables tap when false
            ),
          ),
        ],
      ),
    );
  }

  // YOUR CUSTOM SWITCH
  Widget customToggleSwitch() {
    const Color blueColor = AppColors.electricTeal;
    return Container(
      width: 90,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.lightBorder,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isUndelivered = false),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: !isUndelivered ? blueColor : AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  "OFF",
                  style: TextStyle(
                    color: !isUndelivered ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isUndelivered = true),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: isUndelivered ? blueColor : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  "ON",
                  style: TextStyle(
                    color: isUndelivered ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
