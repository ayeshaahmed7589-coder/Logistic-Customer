import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final bool? isChecked;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final String text;

  const CustomButton({
    Key? key,
    this.isChecked, // optional
    required this.onPressed,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    this.text = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool active = isChecked ?? true; // agar null ho to true

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: active ? onPressed : null,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            active ? backgroundColor : Colors.white,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(color: borderColor, width: 2),
            ),
          ),
          elevation: MaterialStateProperty.all(0),
          overlayColor: MaterialStateProperty.all(
            backgroundColor.withOpacity(0.1),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? textColor : borderColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}




    // Sign Up Button
              // SizedBox(
              //   width: double.infinity,
              //   height: 52,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       if (isChecked) {}
              //     },
              //     style: ButtonStyle(
              //       backgroundColor: MaterialStateProperty.all(
              //         isChecked ? blueColor : Colors.white,
              //       ),
              //       shape: MaterialStateProperty.all(
              //         RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(25),
              //           side: BorderSide(color: blueColor, width: 2),
              //         ),
              //       ),
              //       elevation: MaterialStateProperty.all(0),
              //       overlayColor: MaterialStateProperty.all(
              //         blueColor.withOpacity(0.1),
              //       ),
              //     ),
              //     child: Text(
              //       "Sign Up",
              //       style: TextStyle(
              //         color: isChecked ? Colors.white : blueColor,
              //         fontSize: 16,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
          