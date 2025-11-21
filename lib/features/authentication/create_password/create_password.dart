import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/authentication/create_password/create_pass_controller.dart';

import '../../../export.dart';

class CreatePasswordScreen extends ConsumerStatefulWidget {
  final String token;
  const CreatePasswordScreen({
    Key? key,
    required this.token, // <-- assign here
  }) : super(key: key);

  @override
  ConsumerState<CreatePasswordScreen> createState() =>
      _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends ConsumerState<CreatePasswordScreen> {
  final passwordFocus = FocusNode();
  final confrompasswordFocus = FocusNode();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscureNewPass = true;
  bool _obscureConPass = true;

  bool _showNewPassEye = false;
  bool _showConPassEye = false;

  @override
  void initState() {
    super.initState();
    newPasswordController.addListener(_newPasswordListener);
    confirmPasswordController.addListener(_confirmPasswordListener);
  }

  void _newPasswordListener() {
    final shouldShow = newPasswordController.text.isNotEmpty;
    if (shouldShow != _showNewPassEye) {
      setState(() => _showNewPassEye = shouldShow);
    }
  }

  void _confirmPasswordListener() {
    final shouldShow = confirmPasswordController.text.isNotEmpty;
    if (shouldShow != _showConPassEye) {
      setState(() => _showConPassEye = shouldShow);
    }
  }

  @override
  void dispose() {
    newPasswordController.removeListener(_newPasswordListener);
    confirmPasswordController.removeListener(_confirmPasswordListener);
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    passwordFocus.dispose();
    confrompasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              /// App Title
              CustomText(
                txt: "DROVVI",
                color: AppColors.electricTeal,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 40),

              /// Page Heading
              CustomText(
                txt: "Create New Password",
                color: AppColors.electricTeal,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 10),

              /// Subtitle
              CustomText(
                txt:
                    "Set your new password so you can Log In\nand access Resolve",
                align: TextAlign.center,
                color: AppColors.mediumGray,
                fontSize: 14,
                height: 1.5,
              ),

              const SizedBox(height: 35),

              /// New Password Field
              CustomAnimatedTextField(
                controller: newPasswordController,
                focusNode: passwordFocus,
                labelText: "New Password",
                hintText: "New Password",
                prefixIcon: Icons.lock_outline,
                iconColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: AppColors.darkText,
                obscureText: _obscureNewPass,
                suffixIcon: _showNewPassEye
                    ? IconButton(
                        icon: Icon(
                          _obscureNewPass
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.darkText,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPass = !_obscureNewPass;
                          });
                        },
                      )
                    : null,
              ),

              const SizedBox(height: 20),

              CustomAnimatedTextField(
                controller: confirmPasswordController,
                focusNode: confrompasswordFocus,
                labelText: "Confirm Password",
                hintText: "Confirm Password",
                prefixIcon: Icons.lock_outline,
                iconColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: AppColors.darkText,
                obscureText: _obscureConPass,
                suffixIcon: _showConPassEye
                    ? IconButton(
                        icon: Icon(
                          _obscureConPass
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.darkText,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConPass = !_obscureConPass;
                          });
                        },
                      )
                    : null,
              ),

              gapH64,

              /// Sign Up Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  text: "Sign Up",
                  backgroundColor: AppColors.electricTeal,
                  borderColor: AppColors.electricTeal,
                  textColor: AppColors.pureWhite,
                  onPressed: () async {
                    final password = newPasswordController.text.trim();
                    final confirmPassword = confirmPasswordController.text
                        .trim();

                    if (password.isEmpty || confirmPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter password")),
                      );
                      return;
                    }

                    if (password != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Passwords do not match")),
                      );
                      return;
                    }

                    // TOKEN tumne screen me pass kiya hai → widget.token hi use hoga
                    await ref
                        .read(createPasswordControllerProvider.notifier)
                        .createPassword(
                          token: widget.token,
                          password: password,
                          confirmPassword: confirmPassword,
                        );

                    final state = ref.read(createPasswordControllerProvider);

                    if (state is AsyncData && state.value != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SetUpProfile()),
                      );
                    }
                  },

                  // onPressed: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => SetUpProfile()),
                  //   );
                  // },
                ),
              ),

              const SizedBox(height: 35),

              /// Password Policy
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Password Policy:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.darkText,
                      ),
                    ),
                    SizedBox(height: 10),
                    _PolicyItem(text: "Length must between 8 to 20 character"),
                    _PolicyItem(
                      text: "A combination of upper and lower case letters.",
                    ),
                    _PolicyItem(text: "Contain letters and numbers"),
                    _PolicyItem(
                      text: "A special character such as @, #, !, * and \$",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable Policy Item Widget
class _PolicyItem extends StatelessWidget {
  final String text;
  const _PolicyItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.electricTeal,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CustomText(
              txt: text,
              color: AppColors.mediumGray,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
