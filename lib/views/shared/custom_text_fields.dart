import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';

class UserCredentialTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isObscure;
  final TextInputType keyboardType;
  final IconData? icon;
  final FormFieldValidator<String>? validation;
  final void Function()? onTap;
  const UserCredentialTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.isObscure,
    required this.keyboardType,
    this.icon,
    this.validation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validation,
      inputFormatters: keyboardType == TextInputType.number
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
            ]
          : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: customColor),
        ),
        filled: true,
        hintStyle: appstyle(12, Colors.black, FontWeight.bold),
        labelText: label,
        labelStyle: appstyle(12, Colors.black, FontWeight.bold),
        fillColor: Colors.white70,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
        suffixIcon: icon != null
            ? GestureDetector(
                onTap: onTap,
                child: Icon(
                  icon,
                  size: 20,
                ),
              )
            : null,
      ),
      obscureText: isObscure,
    );
  }
}
