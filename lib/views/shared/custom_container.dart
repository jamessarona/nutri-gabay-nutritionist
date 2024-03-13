import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';

class PatientActionsContainer extends StatelessWidget {
  final String title;
  final String icon;
  final IconData iconData;
  final Color color;
  final bool isSmall;
  final void Function()? onTap;
  const PatientActionsContainer({
    super.key,
    required this.title,
    required this.icon,
    required this.iconData,
    required this.color,
    required this.isSmall,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: isSmall ? 180 : 250,
        width: isSmall ? 100 : 180,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Positioned(
              top: isSmall ? 40 : 60,
              child: Container(
                height: isSmall ? 110 : 190,
                width: isSmall ? 100 : 170,
                padding: EdgeInsets.only(top: isSmall ? 50 : 90),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(),
                ),
                child: Text(
                  title,
                  style: appstyle(isSmall ? 13 : 18, Colors.black,
                      isSmall ? FontWeight.normal : FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(isSmall ? 15 : 25),
              width: isSmall ? 80 : 130,
              height: isSmall ? 80 : 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: color,
              ),
              child: icon != ''
                  ? Image.asset(
                      'assets/icons/$icon.png',
                    )
                  : const Icon(Icons.phone, size: 50),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagnosisDomainContainer extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validation;
  final void Function(String)? onChanged;
  final bool isEdit;
  const DiagnosisDomainContainer({
    super.key,
    required this.controller,
    this.validation,
    this.onChanged,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      padding: const EdgeInsets.only(top: 5),
      color: Colors.grey.shade300,
      child: ListView(
        children: [
          TextFormField(
            controller: controller,
            enabled: isEdit,
            keyboardType: TextInputType.multiline,
            textAlign: TextAlign.center,
            validator: validation,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: false,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              hintText: isEdit ? 'Input a Domain here' : '',
              hintStyle: appstyle(
                17,
                Colors.black,
                FontWeight.normal,
              ),
            ),
            onChanged: onChanged,
            style: appstyle(
              17,
              Colors.black,
              FontWeight.normal,
            ),
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}
