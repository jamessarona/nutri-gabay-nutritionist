import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_buttons.dart';

class NutritionInterventionPage extends StatefulWidget {
  final String patientNutritionalId;
  const NutritionInterventionPage(
      {super.key, required this.patientNutritionalId});

  @override
  State<NutritionInterventionPage> createState() =>
      _NutritionInterventionPageState();
}

class _NutritionInterventionPageState extends State<NutritionInterventionPage> {
  late Size screenSize;
  DropzoneViewController? controller;

  String? fileName;
  String? fileMime;
  int? fileBytes;
  String? fileUrl;

  bool isHighlighted = false;

  Future acceptFile(dynamic event) async {
    fileName = event.name;
    fileMime = await controller!.getFileMIME(event);
    fileBytes = await controller!.getFileSize(event);
    fileUrl = await controller!.createFileUrl(event);

    setState(() {
      isHighlighted = false;
    });
  }

  Widget buildFileUploaderWidget() {
    return Container(
      width: screenSize.width > 500 ? screenSize.width * .45 : double.infinity,
      height: screenSize.width > screenSize.height * 0.7
          ? screenSize.height * 0.7
          : screenSize.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.green.shade100 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DottedBorder(
        borderType: BorderType.RRect,
        color: Colors.black38,
        strokeWidth: 1,
        padding: EdgeInsets.zero,
        dashPattern: const [8, 4],
        radius: const Radius.circular(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            DropzoneView(
              onCreated: (controller) => this.controller = controller,
              onHover: () => setState(() => isHighlighted = true),
              onLeave: () => setState(() => isHighlighted = false),
              onDrop: acceptFile,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_upload_outlined,
                  size: 120,
                  color: Colors.black,
                ),
                const SizedBox(height: 5),
                Text(
                  'Drop your file here',
                  style: appstyle(20, Colors.black, FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'or ',
                      style: appstyle(20, Colors.black, FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final events = await controller!.pickFiles();
                        if (events.isEmpty) return;

                        acceptFile(events.first);
                      },
                      child: Text(
                        'Browse',
                        style: appstyle(20, customColor, FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                fileName != null
                    ? Text(
                        fileName!,
                        style: appstyle(15, Colors.black, FontWeight.normal),
                        textAlign: TextAlign.center,
                      )
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFiles() {
    return SizedBox(
      width: screenSize.width > 500 ? screenSize.width * .45 : double.infinity,
    );
  }

  Future<void> uploadFile() async {
    // TODO: Upload selected pdf/image
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: customColor[70],
          title: Text(
            "Files",
            style: appstyle(
              25,
              Colors.black,
              FontWeight.bold,
            ),
          ),
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: ListView(
            children: [
              const SizedBox(height: 60),
              Container(
                margin:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.01),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                constraints: BoxConstraints(minHeight: screenSize.height * 0.8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: 'UPLOAD ',
                                  style: appstyle(
                                      18, customColor, FontWeight.bold)),
                              TextSpan(
                                  text: 'FILES ',
                                  style: appstyle(
                                      18, Colors.black, FontWeight.bold)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: CustomButton(
                            onPress: () {
                              uploadFile().whenComplete(() {
                                fileName = null;
                                fileMime = null;
                                fileBytes = null;
                                fileUrl = null;
                                setState(() {});
                              });
                            },
                            label: 'Upload',
                            labelSize: 15,
                            radius: 5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    screenSize.width > 500
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildFileUploaderWidget(),
                              buildFiles(),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildFileUploaderWidget(),
                              buildFiles(),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
