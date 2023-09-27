import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';

class CustomPatientTile extends StatelessWidget {
  final String name;
  final String image;
  const CustomPatientTile({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: 300,
      child: Card(
        color: Colors.grey.shade300,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              height: 80,
              width: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  color: Colors.grey.shade200,
                  child: image == ''
                      ? const Icon(
                          Icons.person,
                          size: 30,
                        )
                      : Image.network(image, fit: BoxFit.fill),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  name,
                  style: appstyle(
                    16,
                    Colors.black,
                    FontWeight.bold,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
