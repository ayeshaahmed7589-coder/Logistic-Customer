import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logisticscustomer/features/authentication/register_successful.dart';

import '../../../constants/validation_regx.dart';
import '../../../export.dart';
import 'set_up_profile_controller.dart';
import 'set_up_profile_modal.dart';

class SetUpProfile extends ConsumerStatefulWidget {
  final String verificationToken;
  const SetUpProfile({super.key, required this.verificationToken});

  @override
  ConsumerState<SetUpProfile> createState() => _SetUpProfileState();
}

class _SetUpProfileState extends ConsumerState<SetUpProfile> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  final FocusNode fullNameFocus = FocusNode();
  final FocusNode mobileFocus = FocusNode();
  final FocusNode dobFocus = FocusNode();

  XFile? profileImage;
  final ImagePicker _picker = ImagePicker();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    fullNameController.addListener(_validateForm);
    mobileController.addListener(_validateForm);
    dobController.addListener(_validateForm);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    mobileController.dispose();
    dobController.dispose();
    fullNameFocus.dispose();
    mobileFocus.dispose();
    dobFocus.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isValid =
        fullNameController.text.isNotEmpty &&
        mobileController.text.isNotEmpty &&
        dobController.text.isNotEmpty &&
        AppValidators.name(fullNameController.text) == null &&
        AppValidators.phone(mobileController.text) == null &&
        AppValidators.dob(dobController.text) == null;

    if (isValid != isButtonEnabled) {
      setState(() {
        isButtonEnabled = isValid;
      });
    }
  }

  Future<void> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        profileImage = image;
      });
    }
  }

  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dobController.text =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(setUpProfileControllerProvider);

    ref.listen<AsyncValue<SetUpProfileModel?>>(setUpProfileControllerProvider, (
      previous,
      next,
    ) {
      if (next is AsyncLoading) return;

      if (next is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
      print("VERIFICATION TOKEN => ${widget.verificationToken}");

      if (next is AsyncData) {
        final data = next.value;

        if (data != null && data.success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const RegisterSuccessful()),
          );
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 35,
        title: const Text(
          "Set Up Profile",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        foregroundColor: AppColors.pureWhite,
        backgroundColor: AppColors.electricTeal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              // Profile Image
              GestureDetector(
                onTap: pickProfileImage,
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: AppColors.electricTeal.withOpacity(0.4),
                  backgroundImage: profileImage != null
                      ? FileImage(File(profileImage!.path))
                      : null,
                  child: profileImage == null
                      ? const Icon(
                          Icons.person_outline,
                          size: 50,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Profile Picture",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Full Name
              CustomAnimatedTextField(
                controller: fullNameController,
                focusNode: fullNameFocus,
                labelText: "Full Name",
                hintText: "Full Name",
                prefixIcon: Icons.person_outline,
                iconColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: AppColors.mediumGray,
                validator: (value) =>
                    AppValidators.name(value, fieldName: "Full Name"),
              ),
              const SizedBox(height: 10),

              // Mobile
              CustomAnimatedTextField(
                controller: mobileController,
                focusNode: mobileFocus,
                labelText: "Mobile Number",
                hintText: "Mobile Number",
                prefixIcon: Icons.phone_outlined,
                iconColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: AppColors.mediumGray,
                keyboardType: TextInputType.phone,
                validator: AppValidators.phone,
              ),
              const SizedBox(height: 10),

              // DOB
              CustomAnimatedTextField(
                controller: dobController,
                focusNode: dobFocus,
                labelText: "Date of Birth",
                hintText: "YYYY-MM-DD",
                prefixIcon: Icons.calendar_today_outlined,
                iconColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: Colors.black87,
                keyboardType: TextInputType.datetime,
                validator: AppValidators.dob,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  color: AppColors.electricTeal,
                  onPressed: selectDate,
                ),
              ),
              const SizedBox(height: 30),

              // Next Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomButton(
                  isChecked: isButtonEnabled && state is! AsyncLoading,
                  text: state is AsyncLoading ? "Submitting..." : "Next",
                  backgroundColor: AppColors.electricTeal,
                  borderColor: AppColors.electricTeal,
                  textColor: AppColors.pureWhite,
                  onPressed: isButtonEnabled && state is! AsyncLoading
                      ? () async {
                          if (!_formKey.currentState!.validate()) return;

                          await ref
                              .read(setUpProfileControllerProvider.notifier)
                              .completeProfile(
                                verificationToken: widget.verificationToken,
                                name: fullNameController.text.trim(),
                                phone: mobileController.text.trim(),
                                dob: dobController.text.trim(),
                                profilePhoto: profileImage != null
                                    ? File(profileImage!.path)
                                    : null,
                              );
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
