import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logisticscustomer/features/authentication/email_register/email_register_modal.dart';
import 'package:logisticscustomer/features/authentication/otp/verify_otp_controller.dart';
import '../../../export.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  final EmailRegisterModal emailRegisterModal;

  const VerificationScreen({Key? key, required this.emailRegisterModal})
    : super(key: key);

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  int _seconds = 59;
  late Timer _timer;
  bool _isOtpFilled = false;

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    errorController?.close();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.emailRegisterModal.email;
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // App Logo / Title
              CustomText(
                txt: "DROVVI",
                color: AppColors.electricTeal,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 30),

              // Title
              CustomText(
                txt: "Enter Verification Code",

                color: AppColors.electricTeal,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 10),

              // Subtitle
              CustomText(
                txt:
                    "Please enter the 6-digit code we sent\nto your registered email address.",
                align: TextAlign.center,
                color: AppColors.mediumGray,
                fontSize: 14,
                height: 1.5,
              ),

              const SizedBox(height: 16),

              // Email + Edit icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    // txt: "john@example.com",
                    txt: email,

                    color: AppColors.darkText,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.edit_outlined,
                    color: AppColors.electricTeal,
                    size: 18,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // OTP Input Field
              Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  txt: "Verification code",

                  color: AppColors.electricTeal,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
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

              gapH64,
              gapH48,

              // Submit Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  isChecked: _isOtpFilled,
                  text: "Submit",
                  backgroundColor: AppColors.electricTeal,
                  borderColor: AppColors.electricTeal,
                  textColor: AppColors.pureWhite,
                  onPressed: () async {
                    if (!_isOtpFilled) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("OTP 6 digits ka hona chahiye")),
                      );
                      return;
                    }

                    final otp = otpController.text.trim();
                    final email = widget.emailRegisterModal.email;

                    await ref
                        .read(verifyOtpControllerProvider.notifier)
                        .verifyOtp(email, otp);

                    final state = ref.read(verifyOtpControllerProvider);

                    if (state is AsyncData && state.value != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePasswordScreen(
                            token: state.value!.verificationToken,
                          ),
                        ),
                      );
                    } else if (state is AsyncError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Galat OTP. Dobara try karo.")),
                      );
                    }
                  },

                  // onPressed: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => CreatePasswordScreen(),
                  //     ),
                  //   );
                  // },
                ),
              ),
              const SizedBox(height: 20),

              // Resend Timer
              GestureDetector(
                onTap: () async {
                  if (_seconds == 0) {
                    final email = widget.emailRegisterModal.email;

                    await ref
                        .read(resendOtpControllerProvider.notifier)
                        .resendOtp(email);

                    final state = ref.read(resendOtpControllerProvider);

                    if (state is AsyncData && state.value != null) {
                      setState(() {
                        _seconds = 59; // restart timer
                      });
                      startTimer();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("OTP resend hogaya!")),
                      );
                    } else if (state is AsyncError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("OTP resend nahi hua.")),
                      );
                    }
                  }
                },
                child: CustomText(
                  txt: _seconds > 0
                      ? "Resend - 00:${_seconds.toString().padLeft(2, '0')}"
                      : "Resend Code",
                  color: _seconds == 0
                      ? AppColors.electricTeal
                      : AppColors.mediumGray,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
