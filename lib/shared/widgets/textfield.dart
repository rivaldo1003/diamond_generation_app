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
  Icon? suffixIcon;
  FocusNode? focusNode;
  void Function()? onTap;
  bool? readOnly;
  Color? textColor;
  int? maxLines;
  TextInputType? keyboardType;

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
      style: MyFonts.customTextStyle(
        14,
        FontWeight.w500,
        MyColor.blackColor,
      ),
      decoration: InputDecoration(
        filled: true,
        errorText: errorText,
        hintText: hintText,
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
        fillColor: Colors.white,
        contentPadding: EdgeInsets.all(10),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
    );
  }
}
