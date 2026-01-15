// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:logisticscustomer/common_widgets/custom_button.dart';
// import 'package:logisticscustomer/common_widgets/custom_text.dart';
// import 'package:logisticscustomer/constants/colors.dart';
// import 'package:logisticscustomer/constants/gap.dart';
// import 'package:logisticscustomer/features/authentication/create_password/create_pass_controller.dart';
// import 'package:logisticscustomer/features/authentication/set_up_profile/set_up_profile.dart';

// class Option extends ConsumerStatefulWidget {
//   const Option({super.key});

//   @override
//   ConsumerState<Option> createState() => _OptionState();
// }

// class _OptionState extends ConsumerState<Option> {
//   int selectedIndex = -1; // -1 = nothing selected

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.sizeOf(context).height;

//     return Scaffold(
//       backgroundColor: AppColors.pureWhite,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             RotatedBox(
//               quarterTurns: 2,
//               child: IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: Transform(
//                   alignment: Alignment.center,
//                   transform: Matrix4.rotationY(3.1416),
//                   child: const Icon(Icons.arrow_back, color: Colors.black),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 10,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(
//                       txt: "Almost Done!",
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                     gapH8,
//                     CustomText(
//                       txt: "Where would you like to start?",
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.black,
//                     ),
//                     gapH24,

//                     /// 🔹 Individual
//                     OnboardingImageContainer(
//                       isShadow: true,
//                       height: height,
//                       heading: "Individual",
//                       text:
//                           "Join to discover new and trending excess Individual.",
//                       index: 0,
//                       isSelected: selectedIndex == 0,
//                       onTap: () {
//                         setState(() {
//                           selectedIndex = 0;
//                         });
//                       },
//                     ),

//                     gapH24,

//                     /// 🔹 Company
//                     OnboardingImageContainer(
//                       isShadow: true,
//                       height: height,
//                       heading: "Company",
//                       text: "Sell and grow your Company",
//                       index: 1,
//                       isSelected: selectedIndex == 1,
//                       onTap: () {
//                         setState(() {
//                           selectedIndex = 1;
//                         });
//                       },
//                     ),

//                     const Spacer(),

//                     ///  Continue Button
//                     Padding(
//                       padding: const EdgeInsets.all(22),
//                       child: CustomButton(
//                         text: "Continue",
//                         backgroundColor: selectedIndex == -1
//                             ? AppColors.pureWhite
//                             : AppColors.electricTeal,
//                         borderColor: selectedIndex == -1
//                             ? AppColors.electricTeal
//                             : AppColors.electricTeal,
//                         textColor: selectedIndex == -1
//                             ? AppColors.electricTeal
//                             : AppColors.pureWhite,
//                    onPressed: selectedIndex == -1
//     ? null
//     : () {
//         final state = ref.read(createPasswordControllerProvider);

//         if (state is AsyncData && state.value != null) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => SetUpProfile(
//                 verificationToken:
//                     state.value!.data.verificationToken,
//                 isCompany: selectedIndex == 1, // 👈 IMPORTANT
//               ),
//             ),
//           );
//         }
//       },

//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OnboardingImageContainer extends StatelessWidget {
//   final String heading;
//   final String text;
//   final double height;
//   final int index;
//   final bool isSelected;
//   final VoidCallback onTap;
//   final bool isShadow;

//   const OnboardingImageContainer({
//     super.key,
//     required this.height,
//     required this.heading,
//     required this.text,
//     required this.index,
//     required this.isSelected,
//     required this.onTap,
//     this.isShadow = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         height: height * 0.28,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? AppColors.electricTeal : AppColors.pureWhite,
//             width: 3,
//           ),
//           color: Colors.black.withOpacity(0.2),
//         ),
//         child: Stack(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: isShadow
//                     ? [
//                         BoxShadow(
//                           // color: Colors.black.withOpacity(0.4),
//                           color: AppColors.electricTeal.withOpacity(0.3),
//                           offset: const Offset(0, 4),
//                           blurRadius: 8,
//                         ),
//                       ]
//                     : [],
//               ),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CustomText(
//                       txt: heading,
//                       fontSize: 22,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                     gapH12,
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: CustomText(
//                         txt: text,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                         color: Colors.white,
//                         align: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
