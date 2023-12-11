import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nutri_gabay_nutritionist/models/form.dart';
import 'package:nutri_gabay_nutritionist/models/question.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_buttons.dart';

class CreateEvaluationPage extends StatefulWidget {
  final String appointmentId;
  const CreateEvaluationPage({
    super.key,
    required this.appointmentId,
  });

  @override
  State<CreateEvaluationPage> createState() => _CreateEvaluationPageState();
}

class _CreateEvaluationPageState extends State<CreateEvaluationPage> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _formController = TextEditingController();
  final List<TextEditingController> _questionController = [];
  final List<TextEditingController> _typeController = [];

  void saveForm() async {
    if (_formKey.currentState!.validate()) {
      await saveToFirebase().whenComplete(() {
        final snackBar = SnackBar(
          content: Text(
            'Form has been saved',
            style: appstyle(12, Colors.white, FontWeight.normal),
          ),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
      });
    }
  }

  Future<void> saveToFirebase() async {
    if (_questionController.isNotEmpty) {
      final docForm = FirebaseFirestore.instance
          .collection('appointment')
          .doc(widget.appointmentId)
          .collection('form')
          .doc();

      FormQuestion formQuestion = FormQuestion(
        uid: docForm.id,
        name: _formController.text,
        date: DateTime.now(),
      );

      final formJson = formQuestion.toJson();
      await docForm.set(formJson);
      for (int i = 0; i < _questionController.length; i++) {
        final docForm = FirebaseFirestore.instance
            .collection('appointment')
            .doc(widget.appointmentId)
            .collection('form')
            .doc(formQuestion.uid)
            .collection('questions')
            .doc();
        Question questions = Question(
          uid: docForm.id,
          formId: formQuestion.uid,
          number: i + 1,
          question: _questionController[i].text,
          type: _typeController[i].text,
          required: true,
        );
        final questionsJson = questions.toJson();
        await docForm.set(questionsJson);
      }
    }
  }

  @override
  void initState() {
    _questionController.add(TextEditingController());
    _typeController.add(TextEditingController());
    _typeController.last.text = 'Short answer text';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: customColor[10],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: customColor[70],
          title: Text(
            "Create a Form",
            style: appstyle(
              25,
              Colors.black,
              FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 300,
                margin: const EdgeInsets.only(top: 20, left: 20),
                child: TextFormField(
                  controller: _formController,
                  validator: (value) {
                    if (value == '') {
                      return 'Please enter the form name';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  style: appstyle(20, Colors.black, FontWeight.bold),
                  decoration: InputDecoration(
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: customColor),
                    ),
                    hintText: 'Input Name for Form',
                    hintStyle: appstyle(20, Colors.black, FontWeight.bold),
                    fillColor: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: double.infinity,
                  width: double.infinity,
                  child: ListView(
                    children: [
                      StaggeredGrid.count(
                        axisDirection: AxisDirection.down,
                        crossAxisCount: screenSize.width > 600 ? 2 : 1,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 1,
                        children:
                            List.generate(_questionController.length, (index) {
                          return SizedBox(
                            height: 200,
                            child: Card(
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    width: double.infinity,
                                    child: TextFormField(
                                      controller: _questionController[index],
                                      keyboardType: TextInputType.text,
                                      style: appstyle(
                                          14, Colors.black, FontWeight.normal),
                                      validator: (value) {
                                        if (value == '') {
                                          return 'Please enter the question';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        hintText: 'Question ${index + 1}',
                                        hintStyle: appstyle(14, Colors.black,
                                            FontWeight.normal),
                                        fillColor: Colors.grey.shade200,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 5),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    width: double.infinity,
                                    child: TextFormField(
                                      controller: _typeController[index],
                                      keyboardType: TextInputType.none,
                                      style: appstyle(
                                          14, Colors.black, FontWeight.normal),
                                      validator: (value) {
                                        if (value == '') {
                                          return 'Select the question type';
                                        }
                                        return null;
                                      },
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        suffixIcon: PopupMenuButton<String>(
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          onSelected: (String value) {
                                            _typeController[index].text = value;
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return [
                                              "Short answer text",
                                              "Image"
                                            ].map<PopupMenuItem<String>>(
                                                (String value) {
                                              return PopupMenuItem(
                                                  value: value,
                                                  child: Text(value));
                                            }).toList();
                                          },
                                        ),
                                        filled: true,
                                        hintStyle: appstyle(14, Colors.black,
                                            FontWeight.normal),
                                        fillColor: Colors.grey.shade200,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 5),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      alignment: Alignment.centerRight,
                                      onPressed: () {
                                        setState(() {
                                          _questionController.removeAt(index);
                                          _typeController.removeAt(index);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 30,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 100,
                width: double.infinity,
                margin: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      child: CustomButton(
                        onPress: () {
                          setState(() {
                            _questionController.add(TextEditingController());
                            _typeController.add(TextEditingController());
                            _typeController.last.text = 'Short answer text';
                          });
                        },
                        label: 'Add Question',
                        labelSize: 15,
                        radius: 5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      child: CustomButton(
                        onPress: () {
                          saveForm();
                        },
                        label: 'Save Form',
                        labelSize: 15,
                        radius: 5,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
