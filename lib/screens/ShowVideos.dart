import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prj1/screens/PlayVideo.dart';
import 'package:prj1/utils/bluePainter.dart';
import 'package:prj1/utils/constants.dart';
import 'package:prj1/widgets/WidgetQuestionList.dart';

class ShowVideos extends StatefulWidget {
  final String intervieweeID;
  ShowVideos(this.intervieweeID);
  // const ShowVideos({Key? key}) : super(key: key);

  @override
  _ShowVideosState createState() => _ShowVideosState();
}

class _ShowVideosState extends State<ShowVideos> {
  String q_id = "";
  FirebaseFirestore db = FirebaseFirestore.instance;
  var snapshotUsers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      q_id = FirebaseAuth.instance.currentUser!.uid.toString();
      print("Recr ID: " + q_id);
      print("interviewee ID " + widget.intervieweeID);
    });
    getQuestions();
  }

  void getQuestions() async {
    final DocumentSnapshot snapshotUser = await db
        .collection("interviewee_details")
        .doc(widget.intervieweeID)
        .get();
    if (snapshotUser.exists) {
      setState(() {
        snapshotUsers = snapshotUser;
      });
      print("moizata");
      print(snapshotUsers['email']);
    } else {
      print("moizata");
      print("none");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      appBar: new AppBar(
        title: new Text(
          "Video Answer Player",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: CustomPaint(
        painter: BluePainter2(),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (snapshotUsers != null)
                    ? FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(q_id)
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (snapshot.data == null || !snapshot.data!.exists) {
                            return CircularProgressIndicator(
                              color: ColorConstants.white,
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.none) {
                            return Text("no data");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            print("answerlist");
                            print(data['email']);
                            print(snapshotUsers['email']);
                            if (data.isNotEmpty && snapshotUsers != null)
                              return Container(
                                child: Column(
                                  children: [
                                    for (int i = 1; i < 11; i++)
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        decoration: blueCardBox(
                                            ColorConstants.primaryColor,
                                            Colors.blueGrey,
                                            ColorConstants.primaryColor),
                                        child: ListTile(
                                          // key: ValueKey<Object>(redrawObject),
                                          title: Text("Question Title: " +
                                              '${data['q' + i.toString() + '_title']}'),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Question Detail: " +
                                                  '${data['q' + i.toString() + '_detail']}'),
                                              Text("Interviewee Answer: " +
                                                  snapshotUsers[
                                                      'a' + i.toString()]),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            else
                              return Text("no data");
                          }

                          return Center(
                            child: CircularProgressIndicator(
                              color: ColorConstants.white,
                            ),
                          );
                        },
                      )
                    : CircularProgressIndicator(
                        color: ColorConstants.white,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
