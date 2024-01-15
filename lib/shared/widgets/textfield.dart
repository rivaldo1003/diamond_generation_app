import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  String? errorText;
  final bool obscureText;
  final TextEditingController controller;
  String? Function(String?)? validator;
  String? Function(String?)? onChanged;
  void Function(String)? onFieldSubmitted;
  Widget? suffixIcon;
  FocusNode? focusNode;
  void Function()? onTap;
  bool? readOnly;
  Color? textColor;
  int? maxLines;
  TextInputType? keyboardType;
  Color? fillColor;
  BorderSide? borderSide;
  TextStyle? textStyle;

  TextFieldWidget({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.focusNode,
    this.onTap,
    this.errorText,
    this.readOnly,
    this.textColor,
    this.maxLines,
    this.keyboardType,
    this.onFieldSubmitted,
    this.fillColor,
    this.borderSide,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      enableSuggestions: false,
      autocorrect: false,
      readOnly: (readOnly == null) ? false : readOnly!,
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      onChanged: onChanged,
      maxLines: (maxLines == null) ? 1 : maxLines,
      cursorColor: MyColor.primaryColor,
      style: (textStyle == null)
          ? MyFonts.customTextStyle(
              14,
              FontWeight.w500,
              MyColor.blackColor,
            )
          : textStyle,
      decoration: InputDecoration(
        filled: true,
        errorText: errorText,
        hintText: hintText,
        errorStyle: MyFonts.customTextStyle(
          10,
          FontWeight.w500,
          MyColor.colorRed.withOpacity(0.9),
        ),
        hintStyle: (textColor == null)
            ? MyFonts.customTextStyle(
                14,
                FontWeight.w500,
                Colors.grey.shade400,
              )
            : MyFonts.customTextStyle(
                14,
                FontWeight.w500,
                textColor!,
              ),
        suffixIcon: suffixIcon,
        fillColor: (fillColor == null) ? Colors.white : fillColor,
        contentPadding: EdgeInsets.all(10),
        focusedBorder: OutlineInputBorder(
          borderSide: (borderSide == null) ? BorderSide.none : borderSide!,
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: (borderSide == null) ? BorderSide.none : borderSide!,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
    );
  }
}
