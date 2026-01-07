import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/authentication/email_register/email_register_controller.dart';

import '../../../constants/validation_regx.dart';
import '../../../export.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final emailFocus = FocusNode();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;

  @override
  void dispose() {
    _focusNode.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emailRegisterState = ref.watch(authControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
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
                  validator: AppValidators.email,
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
                    // text: "Sign Up",
                    text: emailRegisterState.isLoading
                        ? "Processing..."
                        : "Sign Up",
                    backgroundColor: AppColors.electricTeal,
                    borderColor: AppColors.electricTeal,
                    textColor: AppColors.pureWhite,
                    onPressed: () async {
                      // Form validate karo
                      if (_formKey.currentState!.validate()) {
                        // Agar form valid hai to process continue karo
                        final email = emailController.text.trim();

                        await ref
                            .read(authControllerProvider.notifier)
                            .sendOtpToEmail(email);

                        final state = ref.read(authControllerProvider);

                        if (state is AsyncData && state.value != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerificationScreen(
                                emailRegisterModal: state.value!,
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),

                const SizedBox(height: 30),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already a Drovvi Member? ",
                      style: TextStyle(
                        color: AppColors.mediumGray,
                        fontSize: 14,
                      ),
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
      ),
    );
  }
}

// import 'dart:ui';
// import 'package:flutter/material.dart';

// class CustomAnimatedTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String labelText;
//   final String hintText;
//   final IconData prefixIcon;
//   final Color iconColor;
//   final Color borderColor;
//   final Color textColor;
//   final String? Function(String?)? validator;
//   final TextInputType keyboardType;
//   final bool obscureText;
//   final Widget? suffixIcon;

//   const CustomAnimatedTextField({
//     Key? key,
//     required this.controller,
//     required this.focusNode,
//     required this.labelText,
//     required this.hintText,
//     required this.prefixIcon,
//     this.iconColor = Colors.blue,
//     this.borderColor = Colors.blue,
//     this.textColor = Colors.black54,
//     this.validator,
//     this.keyboardType = TextInputType.text,
//     this.obscureText = false,
//     this.suffixIcon,
//   }) : super(key: key);

//   @override
//   State<CustomAnimatedTextField> createState() =>
//       _CustomAnimatedTextFieldState();
// }

// class _CustomAnimatedTextFieldState extends State<CustomAnimatedTextField> {
//   bool _isFocused = false;
//   bool _hasText = false;
//   String? _errorText; // Error text store karne ke liye

//   @override
//   void initState() {
//     super.initState();
//     widget.focusNode.addListener(_handleFocusChange);
//     widget.controller.addListener(_handleTextChange);
//   }

//   void _handleFocusChange() {
//     setState(() {
//       _isFocused = widget.focusNode.hasFocus;
//     });
//   }

//   void _handleTextChange() {
//     setState(() {
//       _hasText = widget.controller.text.isNotEmpty;
//       // Text change pe error check karo
//       if (_errorText != null && widget.validator != null) {
//         _errorText = widget.validator!(widget.controller.text);
//       }
//     });
//   }

//   // Error set karne ka method
//   void _setError(String? error) {
//     setState(() {
//       _errorText = error;
//     });
//   }

//   @override
//   void dispose() {
//     widget.focusNode.removeListener(_handleFocusChange);
//     widget.controller.removeListener(_handleTextChange);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool shouldFloat = _isFocused || _hasText;
//     final bool hasError = _errorText != null; // Error check

//     return SizedBox(
//       height: 80,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           // Input Field
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: hasError
//                           ? Colors
//                                 .red // Error mein red border
//                           : Colors.white.withOpacity(0.4),
//                       // width: 1.2,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 6,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: TextFormField(
//                     controller: widget.controller,
//                     focusNode: widget.focusNode,
//                     keyboardType: widget.keyboardType,
//                     obscureText: widget.obscureText,
//                     validator: (value) {
//                       final error = widget.validator?.call(value);
//                       _setError(error);
//                       return error; // <-- FORM KO VALID / INVALID MARK KAREGA
//                     },

//                     style: TextStyle(
//                       color: widget.textColor, // Error mein red text
//                     ),
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(
//                         widget.prefixIcon,
//                         color: hasError
//                             ? Colors.red
//                             : widget.iconColor, // Error mein red icon
//                       ),
//                       suffixIcon: widget.suffixIcon,
//                       hintText: widget.hintText,
//                       hintStyle: TextStyle(
//                         color: widget.textColor.withOpacity(0.5),
//                         fontSize: 15,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: hasError
//                               ? Colors.red
//                               : widget.borderColor, // Error mein red
//                           // width: 1,
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: hasError
//                               ? Colors.red
//                               : widget.borderColor.withOpacity(0.6),
//                           // width: 1,
//                         ),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         vertical: 18,
//                         horizontal: 16,
//                       ),
//                       filled: true,
//                       fillColor: Colors.white.withOpacity(0.3),
//                       errorStyle: const TextStyle(
//                         height: 0,
//                         fontSize: 0,
//                       ), // Default error hide
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // Animated Label
//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 250),
//             left: 6,
//             top: shouldFloat ? -2 : 20,
//             child: AnimatedOpacity(
//               duration: const Duration(milliseconds: 250),
//               opacity: shouldFloat ? 1 : 0,
//               child: Container(
//                 color: const Color(0xFFF8F9FD),
//                 padding: const EdgeInsets.symmetric(horizontal: 2),
//                 child: Text(
//                   widget.labelText,
//                   style: TextStyle(
//                     color: hasError
//                         ? Colors.red
//                         : widget.borderColor, // Error mein red label
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // Error Text (Neeche show hoga)
//           if (hasError)
//             Positioned(
//               left: 10,
//               bottom: -18, // Text field ke neeche
//               child: Text(
//                 _errorText!,
//                 style: const TextStyle(
//                   color: Colors.red,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
