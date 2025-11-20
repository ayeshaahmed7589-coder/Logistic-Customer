import 'package:flutter/material.dart';
import 'package:logisticscustomer/common_widgets/cuntom_textfield.dart';
import 'package:logisticscustomer/common_widgets/custom_button.dart';
import 'package:logisticscustomer/constants/colors.dart';
import 'package:logisticscustomer/features/authentication/register_successful.dart';

import '../../export.dart';
export '../../common_widgets/cuntom_textfield.dart';
export '../../common_widgets/custom_button.dart';

class SetUpProfile extends StatefulWidget {
  const SetUpProfile({super.key});

  @override
  State<SetUpProfile> createState() => _SetUpProfileState();
}

class _SetUpProfileState extends State<SetUpProfile> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode mobileFocus = FocusNode();
  final FocusNode dobFocus = FocusNode();

  bool isChecked = false;
  XFile? profileImage;

  final ImagePicker _picker = ImagePicker();

  void checkFields() {
    setState(() {
      isChecked =
          firstNameController.text.isNotEmpty &&
          lastNameController.text.isNotEmpty &&
          mobileController.text.isNotEmpty &&
          dobController.text.isNotEmpty;
    });
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
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dobController.text =
          "${pickedDate.day.toString().padLeft(2, '0')}/"
          "${pickedDate.month.toString().padLeft(2, '0')}/"
          "${pickedDate.year}";
    }
  }

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(checkFields);
    lastNameController.addListener(checkFields);
    mobileController.addListener(checkFields);
    dobController.addListener(checkFields);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    dobController.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    mobileFocus.dispose();
    dobFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            // Profile Picture Section
            GestureDetector(
              onTap: pickProfileImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Circle (border + image)
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.electricTeal,
                        width: 2.5,
                      ),
                      color: profileImage == null
                          ? AppColors.electricTeal.withOpacity(0.4)
                          : Colors.transparent,
                      image: profileImage != null
                          ? DecorationImage(
                              image: FileImage(File(profileImage!.path)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: profileImage == null
                        ? Icon(
                            Icons.person,
                            size: 0,
                            color: AppColors.electricTeal,
                          )
                        : null,
                  ),

                  //  Blue overlay icon (only visible when no image is selected)
                  if (profileImage == null)
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: AppColors.electricTeal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outlined,
                        color: AppColors.pureWhite,
                        size: 28,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              "Profile Picture",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 20),

            //  First Name
            CustomAnimatedTextField(
              controller: firstNameController,
              focusNode: firstNameFocus,
              labelText: "First Name",
              hintText: "First Name",
              prefixIcon: Icons.person_outline,
              iconColor: AppColors.electricTeal,
              borderColor: AppColors.electricTeal,
              textColor:AppColors.mediumGray,
            ),
            const SizedBox(height: 10),

            // Last Name
            CustomAnimatedTextField(
              controller: lastNameController,
              focusNode: lastNameFocus,
              labelText: "Last Name",
              hintText: "Last Name",
              prefixIcon: Icons.person_outline,
              iconColor: AppColors.electricTeal,
              borderColor: AppColors.electricTeal,
              textColor: AppColors.mediumGray,
            ),
            const SizedBox(height: 10),

            //  Mobile Number
            CustomAnimatedTextField(
              controller: mobileController,
              focusNode: mobileFocus,
              labelText: "Mobile Number",
              hintText: "Mobile Number",
              prefixIcon: Icons.phone_outlined,
              iconColor: AppColors.electricTeal,
              borderColor: AppColors.electricTeal,
              textColor:AppColors.mediumGray,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),

            // Date of Birth
            CustomAnimatedTextField(
              controller: dobController,
              focusNode: dobFocus,
              labelText: "Date of Birth",
              hintText: "DD/MM/YYYY",
              prefixIcon: Icons.calendar_today_outlined,
              iconColor: AppColors.electricTeal,
              borderColor: AppColors.electricTeal,
              textColor: Colors.black87,
              keyboardType: TextInputType.datetime,
              suffixIcon: IconButton(
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                color: AppColors.electricTeal,
                onPressed: selectDate,
              ),
            ),

            const SizedBox(height: 30),

            //  Next Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomButton(
                isChecked: isChecked,
                text: "Next",
                backgroundColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: AppColors.pureWhite,
                onPressed: () {
                  if (isChecked) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterSuccessful()),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
