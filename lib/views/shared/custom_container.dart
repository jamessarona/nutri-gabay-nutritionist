import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';

class PatientActionsContainer extends StatelessWidget {
  final String title;
  final String icon;
  final IconData iconData;
  final void Function()? onTap;
  const PatientActionsContainer({
    super.key,
    required this.title,
    required this.icon,
    required this.iconData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 180,
        width: 100,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Positioned(
              top: 40,
              child: Container(
                height: 110,
                width: 100,
                padding: const EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(),
                ),
                child: Text(
                  title,
                  style: appstyle(13, Colors.black, FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey.shade300,
              ),
              child: icon != ''
                  ? Image.asset(
                      'assets/images/$icon.png',
                    )
                  : const Icon(Icons.phone, size: 50),
            ),
          ],
        ),
      ),
    );
  }
}
