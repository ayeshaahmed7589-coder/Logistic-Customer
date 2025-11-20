import 'package:flutter/material.dart';
import 'package:logisticscustomer/common_widgets/cuntom_textfield.dart';
import 'package:logisticscustomer/common_widgets/custom_button.dart';
import 'package:logisticscustomer/constants/colors.dart';
import 'package:logisticscustomer/constants/gap.dart';
import 'package:logisticscustomer/features/authentication/login.dart';
import 'package:logisticscustomer/features/authentication/otp.dart';

import '../../export.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailFocus = FocusNode();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  bool isChecked = false;

  @override
  void dispose() {
    _focusNode.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "DROVVI",
                style: TextStyle(
                  color: AppColors.electricTeal,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.electricTeal,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please enter your Email ID to Sign Up.",
                style: TextStyle(color: AppColors.mediumGray, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),

              CustomAnimatedTextField(
                controller: emailController,
                focusNode: emailFocus,
                labelText: "Email ID",
                hintText: "Email ID",
                prefixIcon: Icons.email_outlined,
                iconColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: AppColors.mediumGray,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email required";
                  }
                  if (!value.contains('@')) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 40),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (val) =>
                        setState(() => isChecked = val ?? false),
                    activeColor: AppColors.electricTeal,
                    side: BorderSide(color: AppColors.electricTeal, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  Expanded(
                    child: Wrap(
                      children: [
                        const Text(
                          "By continuing, I confirm that I have read the ",
                          style: TextStyle(
                            color: AppColors.mediumGray,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "Terms of Use",
                          style: TextStyle(
                            color: AppColors.electricTeal,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const Text(
                          " and ",
                          style: TextStyle(
                            color: AppColors.mediumGray,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "Privacy Policy",
                          style: TextStyle(
                            color: AppColors.electricTeal,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              gapH64,
              gapH48,

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  isChecked: isChecked,
                  text: "Sign Up",
                  backgroundColor: AppColors.electricTeal,
                  borderColor: AppColors.electricTeal,
                  textColor: AppColors.pureWhite,
                  onPressed: () {
                         
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VerificationScreen()),
                      );
                    
                  },
                ),
              ),

              const SizedBox(height: 30),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already a Koovs Member? ",
                    style: TextStyle(color: AppColors.mediumGray, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: AppColors.electricTeal,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
