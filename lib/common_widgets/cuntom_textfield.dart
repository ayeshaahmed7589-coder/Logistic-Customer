import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:logisticscustomer/export.dart';

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
  final bool readOnly; // ✅ new
  final VoidCallback? onTap; // ✅ new
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;

  const CustomAnimatedTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.inputFormatters,
    this.iconColor = Colors.blue,
    this.borderColor = Colors.blue,
    this.textColor = Colors.black54,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false, // default false
    this.onTap, // optional
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<CustomAnimatedTextField> createState() =>
      _CustomAnimatedTextFieldState();
}

class _CustomAnimatedTextFieldState extends State<CustomAnimatedTextField> {
  bool _isFocused = false;
  bool _hasText = false;
  String? _errorText; // store manually

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChange);
    widget.controller.addListener(_handleTextChange);
  }

  void _handleFocusChange() {
    setState(() => _isFocused = widget.focusNode.hasFocus);
  }

  void _handleTextChange() {
    setState(() {
      _hasText = widget.controller.text.isNotEmpty;
      if (widget.validator != null) {
        _errorText = widget.validator!(widget.controller.text);
      }
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
    bool shouldFloat = _isFocused || _hasText;
    final borderRadius = BorderRadius.circular(12);

    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: borderRadius,
            child: TextFormField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              readOnly: widget.readOnly, // ✅ support readOnly
              onTap: widget.onTap, // ✅ support optional onTap

              validator: (value) => null, // suppress default error
              autovalidateMode: AutovalidateMode.onUserInteraction,

              onChanged: (val) {
                if (widget.validator != null) {
                  final err = widget.validator!(val);
                  setState(() => _errorText = err);
                }
              },

              decoration: InputDecoration(
                isDense: true,
                prefixIcon: Icon(
                  widget.prefixIcon,
                  color: _errorText != null ? Colors.red : widget.iconColor,
                ),
                suffixIcon: widget.suffixIcon,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: widget.textColor.withOpacity(0.5),
                  fontSize: 13,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.25),

                enabledBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    color: _errorText != null
                        ? Colors.red
                        : widget.borderColor.withOpacity(0.7),
                    width: 1.4,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    color: _errorText != null ? Colors.red : widget.borderColor,
                    width: 1.4,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
              ),
            ),
          ),
          // ----------------------- FLOATING LABEL ---------------------------
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            left: 12,
            top: shouldFloat ? -20 : 18,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: shouldFloat ? 1 : 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  widget.labelText,
                  style: TextStyle(
                    color: _errorText != null ? Colors.red : widget.borderColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          // ----------------------- RIGHT SIDE ERROR BADGE -------------------
          if (_errorText != null)
            Align(
              alignment: Alignment.bottomRight, // ❌ move to right
              child: Text(
                _errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
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