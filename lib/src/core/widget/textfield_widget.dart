import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_expense_tracker/src/core/widget/text_widget.dart';

class TextFieldWidget extends StatelessWidget {
  final String name;
  final String labelText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool isEnabled;
  final int maxLine;
  final Color? fillColor;
  final double? fontSize;
  final Color borderColor;
  final bool hasLable;
  final Function onChange;
  final TextCapitalization? textCapitalization;

  const TextFieldWidget(
      {super.key,
      this.controller,
      this.maxLine = 1,
      required this.name,
      required this.validator,
      this.suffixIcon,
      this.prefixIcon,
      this.obscureText = false,
      this.keyboardType = TextInputType.emailAddress,
      this.inputFormatters,
      this.isEnabled = true,
      this.hasLable = true,
      this.fillColor,
      this.fontSize,
      this.labelText = "",
      this.borderColor = Colors.white,
      required this.onChange,
      this.textCapitalization});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          !hasLable
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: TextWidget(
                    labelText,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
          FormBuilderTextField(
            enabled: isEnabled,
            maxLines: maxLine,
            controller: controller,
            obscureText: obscureText,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            cursorColor: Theme.of(context).primaryColorDark,
            inputFormatters: inputFormatters,
            enableInteractiveSelection: true,
            decoration: textFieldDecoration(
              suffix: suffixIcon,
              prefix: prefixIcon,
              borderColor: borderColor,
            ),
            validator: validator,
            keyboardType: keyboardType,
            name: name,
            onChanged: (c) {
              onChange(c);
            },
          ),
        ],
      ),
    );
  }
}

textFieldDecoration(
    {String hintText = "", suffix, prefix, required Color borderColor}) {
  return InputDecoration(
    suffixIcon: suffix,
    prefixIcon: prefix,
    hintText: hintText,
    fillColor: Colors.white,
    filled: true,
    counterText: "",
  );
}
