import 'dart:ui';
import 'package:flutter/material.dart';

class CustomAnimatedTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final Color iconColor;
  final Color borderColor;
  final Color textColor;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomAnimatedTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.iconColor = Colors.blue,
    this.borderColor = Colors.blue,
    this.textColor = Colors.black54,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<CustomAnimatedTextField> createState() =>
      _CustomAnimatedTextFieldState();
}

class _CustomAnimatedTextFieldState extends State<CustomAnimatedTextField> {
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChange);
    widget.controller.addListener(_handleTextChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = widget.focusNode.hasFocus;
    });
  }

  void _handleTextChange() {
    setState(() {
      _hasText = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool shouldFloat = _isFocused || _hasText;
    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Input Field
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    keyboardType: widget.keyboardType,
                    obscureText: widget.obscureText,
                    validator: widget.validator,
                    style: TextStyle(color: widget.textColor),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        widget.prefixIcon,
                        color: widget.iconColor,
                      ),
                      suffixIcon: widget.suffixIcon,

                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        color: widget.textColor.withOpacity(0.5),
                        fontSize: 15,
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: widget.borderColor,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: widget.borderColor.withOpacity(0.6),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 16,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Animated Label
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            left: 6,
            top: shouldFloat ? -2 : 20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: shouldFloat ? 1 : 0,
              child: Container(
                color: const Color(0xFFF8F9FD),
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  widget.labelText,
                  style: TextStyle(
                    color: widget.borderColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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



 // SizedBox(
              //   height: 80,
              //   child: Stack(
              //     clipBehavior: Clip.none,
              //     children: [
              //       // Input Field
              //       Positioned(
              //         bottom: 0,
              //         left: 0,
              //         right: 0,
              //         child: ClipRRect(
              //           borderRadius: BorderRadius.circular(12),
              //           child: BackdropFilter(
              //             filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              //             child: Container(
              //               decoration: BoxDecoration(
              //                 color: Colors.white.withOpacity(0.3),
              //                 borderRadius: BorderRadius.circular(12),
              //                 border: Border.all(
              //                   color: Colors.white.withOpacity(0.4),
              //                   width: 1.2,
              //                 ),
              //                 boxShadow: [
              //                   BoxShadow(
              //                     color: Colors.black.withOpacity(0.05),
              //                     blurRadius: 6,
              //                     offset: const Offset(0, 3),
              //                   ),
              //                 ],
              //               ),
              //               child: TextFormField(
              //                 controller: emailController,
              //                 focusNode: _focusNode,
              //                 keyboardType: TextInputType.emailAddress,
              //                 style: const TextStyle(color: Colors.black54),
              //                 decoration: InputDecoration(
              //                   prefixIcon: Icon(
              //                     Icons.email_outlined,
              //                     color: blueColor,
              //                   ),
              //                   hintText: "Email ID",
              //                   hintStyle: const TextStyle(
              //                     color: Colors.black45,
              //                     fontSize: 15,
              //                   ),
              //                   border: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(12),
              //                     borderSide: BorderSide.none,
              //                   ),
              //                   focusedBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(12),
              //                     borderSide: BorderSide(
              //                       color: blueColor,
              //                       width: 2,
              //                     ),
              //                   ),
              //                   enabledBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(12),
              //                     borderSide: BorderSide(
              //                       color: blueColor.withOpacity(0.6),
              //                       width: 1.5,
              //                     ),
              //                   ),
              //                   contentPadding: const EdgeInsets.symmetric(
              //                     vertical: 18,
              //                     horizontal: 16,
              //                   ),
              //                   filled: true,
              //                   fillColor: Colors.white.withOpacity(0.3),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),

              //       AnimatedPositioned(
              //         duration: const Duration(milliseconds: 250),
              //         left: 6,
              //         top: _isFocused ? -2 : 20,
              //         child: AnimatedOpacity(
              //           duration: const Duration(milliseconds: 250),
              //           opacity: _isFocused ? 1 : 0,
              //           child: Container(
              //             color: const Color(0xFFF8F9FD),
              //             padding: const EdgeInsets.symmetric(horizontal: 2),
              //             child: Text(
              //               "Email ID",
              //               style: TextStyle(
              //                 color: blueColor,
              //                 fontSize: 13,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),