import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final TextDirection? textDirection;
  final Function() onFieldSubmitted;
  final TextInputAction textInputAction;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.textDirection,
    required this.focusNode,
    required this.onFieldSubmitted,
    required this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          maxLength: maxLength,
          enabled: enabled,
          textInputAction: textInputAction,
          textDirection: textDirection,
          onFieldSubmitted: (_) => onFieldSubmitted(),
          style: TextStyle(fontSize: 16.sp, fontFamily: 'Cairo'),
          decoration: InputDecoration(
            hintText: hint ?? label,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16.sp),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            counterText: maxLength != null ? null : '',
          ),
        ),
      ],
    );
  }
}
