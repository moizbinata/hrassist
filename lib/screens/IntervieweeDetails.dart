import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:prj1/screens/PlayVideo.dart';
import 'package:prj1/screens/ShowVideos.dart';
import 'package:prj1/screens/SignInUp.dart';
import 'package:prj1/screens/ViewPDF.dart';
import 'package:prj1/utils/bluePainter.dart';
import 'package:prj1/utils/constants.dart';
import 'package:prj1/utils/size_config.dart';
import 'package:prj1/widgets/WidgetQuestionList.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class IntervieweeDetails extends StatefulWidget {
  final String recruiterID;

  IntervieweeDetails(this.recruiterID);
  @override
  _IntervieweeDetailsState createState() => _IntervieweeDetailsState();
}

class _IntervieweeDetailsState extends State<IntervieweeDetails> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('interviewee_details').snapshots();

  @override
  Widget build(BuildContext context) {
    print(_usersStream.toString());

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Interviewee Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.textMultiplier * 2.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseAuth auth = FirebaseAuth.instance;
              auth.signOut().whenComplete(() => {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInUp()),
                    ),
                  });
            },
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: CustomPaint(
        painter: BluePainter(),
        child: Container(
          height: deviceHeight,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: deviceWidth,
              // height: deviceHeight,
              // color: Colors.blue.shade200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          String docID = document.id;

                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          print("moiz");
                          print(data['questionaireID']);
                          print(widget.recruiterID);
                          return (data['questionaireID'] == widget.recruiterID)
                              ? Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: ((int.parse(data['mobileNumber']
                                                  .toString())) %
                                              3 ==
                                          0)
                                      ? blueCardBox(ColorConstants.primaryColor,
                                          Colors.blueGrey, ColorConstants.grey2)
                                      : ((int.parse(data['mobileNumber']
                                                      .toString())) %
                                                  2 ==
                                              0)
                                          ? blueCardBox(
                                              ColorConstants.secondaryColor,
                                              Colors.lightBlueAccent,
                                              ColorConstants.grey2)
                                          : blueCardBox(
                                              ColorConstants.darkBlue,
                                              Colors.lightBlue,
                                              ColorConstants.grey2),
                                  child: InkWell(
                                    onTap: () {
                                      showBarModalBottomSheet(
                                        topControl: CircleAvatar(
                                          radius: 60,
                                          backgroundImage:
                                              NetworkImage(data['imageUrl']),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        context: context,
                                        backgroundColor:
                                            ColorConstants.secondaryColor,
                                        enableDrag: true,
                                        builder: (context) => Container(
                                          padding: EdgeInsets.all(10),
                                          color: ColorConstants.secondaryColor,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "YOUR INFORMATION",
                                                  style: TextStyle(
                                                    color: ColorConstants.white,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  data['username'],
                                                  style: TextStyle(
                                                      color:
                                                          ColorConstants.white,
                                                      fontSize: 20),
                                                ),
                                                Text(
                                                  data['email'],
                                                  style: TextStyle(
                                                      color:
                                                          ColorConstants.white,
                                                      fontSize: 20),
                                                ),
                                                Text(
                                                  "Cell: " +
                                                      data['mobileNumber'],
                                                  style: TextStyle(
                                                      color:
                                                          ColorConstants.white,
                                                      fontSize: 20),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Estimated Confidence Level: " +
                                                      data['totalConf'] +
                                                      ' %',
                                                  style: TextStyle(
                                                      color:
                                                          ColorConstants.white,
                                                      fontSize: 20),
                                                ),
                                                Text(
                                                  "Estimated Correct Answers : " +
                                                      data['totalPer'] +
                                                      ' %',
                                                  style: TextStyle(
                                                      color:
                                                          ColorConstants.white,
                                                      fontSize: 20),
                                                ),
                                                ListTile(
                                                  title: Text("Resume"),
                                                  trailing: ElevatedButton.icon(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: ColorConstants
                                                            .secondaryColor,
                                                        shadowColor:
                                                            ColorConstants
                                                                .secondaryColor,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ViewPDF(
                                                                    data[
                                                                        'mobileNumber'],
                                                                    data[
                                                                        'resumeUrl']),
                                                          ),
                                                        );
                                                      },
                                                      icon: Icon(
                                                        Icons.picture_as_pdf,
                                                        color: ColorConstants
                                                            .white,
                                                      ),
                                                      label: Text(
                                                        "View PDF",
                                                        style: TextStyle(
                                                            color:
                                                                ColorConstants
                                                                    .white),
                                                      )),
                                                ),
                                                ListTile(
                                                  leading:
                                                      Text("Video Answers"),
                                                  trailing: ElevatedButton.icon(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: ColorConstants
                                                            .secondaryColor,
                                                        shadowColor:
                                                            ColorConstants
                                                                .secondaryColor,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ShowVideos(
                                                                        docID),
                                                          ),
                                                        );
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .play_arrow_outlined,
                                                        color: ColorConstants
                                                            .white,
                                                      ),
                                                      label: Text(
                                                        "View Answers",
                                                        style: TextStyle(
                                                            color:
                                                                ColorConstants
                                                                    .white),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      leading: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: data['imageUrl'],
                                          fit: BoxFit.cover,
                                          alignment: Alignment.topCenter,
                                          height:
                                              SizeConfig.heightMultiplier * 8,
                                          width:
                                              SizeConfig.heightMultiplier * 8,
                                          progressIndicatorBuilder:
                                              (context, url, progress) =>
                                                  Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      ColorConstants
                                                          .primaryColor),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              ClipOval(
                                                  child: Icon(Icons.error)),
                                        ),
                                      ),
                                      title: Text(data['username']),
                                      subtitle: Text(data['email']),
                                      trailing: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.chevron_right_outlined,
                                          color: ColorConstants.white,
                                          size: SizeConfig.textMultiplier * 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Text("No data");
                        }).toList(),
                      );
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
