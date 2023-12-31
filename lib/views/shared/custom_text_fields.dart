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
  final IconButton? suffixIcon;
  const UserCredentialTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.isObscure,
    required this.keyboardType,
    this.icon,
    this.validation,
    this.onTap,
    this.suffixIcon,
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
        suffixIcon: suffixIcon ??
            (icon != null
                ? GestureDetector(
                    onTap: onTap,
                    child: Icon(
                      icon,
                      size: 20,
                    ),
                  )
                : null),
      ),
      obscureText: isObscure,
    );
  }
}

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isObscure;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isEditable;
  final IconData? icon;
  final FormFieldValidator<String>? validation;
  final void Function()? onTap;
  const ProfileTextField(
      {super.key,
      required this.controller,
      required this.label,
      required this.isObscure,
      required this.keyboardType,
      required this.maxLines,
      required this.isEditable,
      this.icon,
      this.validation,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validation,
      enabled: isEditable,
      inputFormatters: keyboardType == TextInputType.number
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
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
        label: Text(
          label,
          style: appstyle(13, Colors.black, FontWeight.normal),
        ),
        filled: true,
        focusColor: customColor,
        fillColor: Colors.white70,
        contentPadding: EdgeInsets.symmetric(
            vertical: maxLines > 1 ? 10 : 0, horizontal: 10.0),
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
      maxLines: maxLines,
      obscureText: isObscure,
    );
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObscure;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isEditable;
  final IconData? icon;
  final FormFieldValidator<String>? validation;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  const SearchTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.isObscure,
      required this.keyboardType,
      required this.maxLines,
      required this.isEditable,
      this.icon,
      this.validation,
      this.onTap,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validation,
      enabled: isEditable,
      onChanged: onChanged,
      inputFormatters: keyboardType == TextInputType.number
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
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
        hintText: hintText,
        filled: true,
        focusColor: customColor,
        fillColor: Colors.white70,
        contentPadding: EdgeInsets.symmetric(
            vertical: maxLines > 1 ? 10 : 0, horizontal: 10.0),
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
      maxLines: maxLines,
      obscureText: isObscure,
    );
  }
}

class RegistrationTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isObscure;
  final TextInputType keyboardType;
  final int maxLines;
  final IconData? icon;
  final FormFieldValidator<String>? validation;
  final void Function()? onTap;
  const RegistrationTextField(
      {super.key,
      required this.controller,
      required this.label,
      required this.isObscure,
      required this.keyboardType,
      required this.maxLines,
      this.icon,
      this.validation,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validation,
      inputFormatters: keyboardType == TextInputType.number
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
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
        fillColor: Colors.white70,
        contentPadding: EdgeInsets.symmetric(
            vertical: maxLines > 1 ? 10 : 0, horizontal: 10.0),
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
      maxLines: maxLines,
      obscureText: isObscure,
    );
  }
}
