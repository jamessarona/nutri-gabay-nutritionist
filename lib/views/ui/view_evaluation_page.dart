import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/ui/view_evaluation_question_page.dart';

class ViewEvaluationPage extends StatefulWidget {
  final String appointmentId;
  const ViewEvaluationPage({
    super.key,
    required this.appointmentId,
  });

  @override
  State<ViewEvaluationPage> createState() => _ViewEvaluationPageState();
}

class _ViewEvaluationPageState extends State<ViewEvaluationPage> {
  late Size screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: customColor[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: customColor[70],
          title: Text(
            "Forms",
            style: appstyle(
              25,
              Colors.black,
              FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('appointment')
              .doc(widget.appointmentId)
              .collection('form')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return const Text('No Records');
            }
            return ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                StaggeredGrid.count(
                  axisDirection: AxisDirection.right,
                  crossAxisCount: 8,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        return StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 4,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ViewEvaluationQuestionPage(
                                    appointmentId: widget.appointmentId,
                                    formId: data['uid'],
                                    formName: data['name'],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 15, left: 15, right: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['name'],
                                      style: appstyle(
                                          20, Colors.black, FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.visible,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      DateFormat('MMMM dd, yyyy')
                                          .format(data['date'].toDate()),
                                      style: appstyle(
                                          15, Colors.black, FontWeight.normal),
                                      maxLines: 1,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                      .toList()
                      .cast(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
