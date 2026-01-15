import 'package:flutter/material.dart';

import '../../export.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailFocus = FocusNode();
  // final FocusNode _focusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  // ignore: non_constant_identifier_names
  final TextEditingController PasswordController = TextEditingController();
  final passwordFocus = FocusNode();

  bool _showNewPassEye = false;
  bool _isFormFilled = false;

  @override
  void initState() {
    super.initState();
    PasswordController.addListener(_passwordListener);
    emailController.addListener(_checkFormFilled);
    PasswordController.addListener(_checkFormFilled);
  }

  void _passwordListener() {
    final shouldShow = PasswordController.text.isNotEmpty;
    if (shouldShow != _showNewPassEye) {
      setState(() => _showNewPassEye = shouldShow);
    }
  }

  ///  check karega ki dono fields filled hain ya nahi
  void _checkFormFilled() {
    final isFilled =
        emailController.text.isNotEmpty && PasswordController.text.isNotEmpty;

    if (isFilled != _isFormFilled) {
      setState(() => _isFormFilled = isFilled);
    }
  }

  // bool isChecked = false;

  @override
  void dispose() {
    emailFocus.dispose();
    passwordFocus.dispose();
    emailController.dispose();
    PasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color inactiveColor = AppColors.mediumGray;
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔙 Back Text
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Back",
                    style: TextStyle(
                      color: AppColors.electricTeal,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Text(
                "Drovvi",
                style: TextStyle(
                  color: AppColors.electricTeal,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              gapH32,
              Text(
                "Forgot Password",
                style: TextStyle(
                  //031509018                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.electricTeal,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please enter your Register email\naddress to reset your password",
                style: TextStyle(color: AppColors.mediumGray, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              gapH20,

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
              gapH64,

              // SizedBox(height: 300),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  isChecked: _isFormFilled,
                  text: "Submit",
                  backgroundColor: _isFormFilled
                      ? AppColors.electricTeal
                      : inactiveColor,
                  borderColor: AppColors.electricTeal,
                  textColor: AppColors.lightGrayBackground,
                  onPressed: _isFormFilled
                      ? () {
                          debugPrint("Submit");
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
