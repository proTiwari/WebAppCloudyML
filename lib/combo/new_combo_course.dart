import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../models/course_details.dart';

class NewComboCourse extends StatefulWidget {
  final List<dynamic>? courses;
  final String? courseName;
  final id;
  const NewComboCourse({Key? key, this.courses, this.courseName, this.id}) : super(key: key);

  @override
  State<NewComboCourse> createState() => _NewComboCourseState();
}

class _NewComboCourseState extends State<NewComboCourse> {
  var courseData = null;
  static final _stateStreamController = StreamController<List>.broadcast();
  static StreamSink<List> get counterSink => _stateStreamController.sink;
  static Stream<List> get counterStream => _stateStreamController.stream;

  @override
  void initState() {
    getAllPaidCourses();
    getPercentageOfCourse();
    getTheStreamData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/BG.png"),
                    fit: BoxFit.fill
                ),
                color: HexColor("#fef0ff"),
              ),
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "welcome to ",
                            style: TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: width < 850
                                    ? width < 430
                                    ? 25
                                    : 30
                                    : 40,
                                color: Colors.black)),
                        TextSpan(
                            text: "${widget.courseName}",
                            style: TextStyle(
                                fontSize: width < 850
                                    ? width < 430
                                    ? 25
                                    : 30
                                    : 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.black))
                      ]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    StreamBuilder(
                        stream: counterStream,
                        builder: (context, snapshot) {
                          print('thata ${widget.courses!} $course');
                          if (snapshot.hasData && widget.courses != null) {
                            List courseList = [];
                            for (var i in widget.courses!) {
                              for (var j in course) {
                                if (i == j.courseId) {
                                  courseList.add(j);
                                }
                              }
                            }
                            print("listoooo $courseList");
                            return Column(
                              children: List.generate(
                                courseList.length,
                                    (index) {
                                  print("snapdatassss");
                                  print(
                                      "the data is==${snapshot.data.toString()}");
                                  // print("Courses list ${courseList}");
                                  if (courseList.length > index) {
                                    print(
                                        "Duration ${courseList[index].duration}");
                                    return Container(
                                      padding: EdgeInsets.all(8),
                                      margin: EdgeInsets.only(bottom: 15),
                                      width: width < 1700
                                          ? width < 1300
                                          ? width < 850
                                          ? constraints.maxWidth - 20
                                          : constraints.maxWidth - 200
                                          : constraints.maxWidth - 400
                                          : constraints.maxWidth - 700,
                                      height: width > 700
                                          ? 230
                                          : width < 300
                                          ? 190
                                          : 210,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          color: Colors.white),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            courseId = courseList[index]
                                                .courseDocumentId;
                                          });
                                          GoRouter.of(context).pushNamed(
                                              'comboVideoScreen',
                                              queryParams: {
                                                'courseName': courseList[index]
                                                    .courseName,
                                                'cID': courseList[index]
                                                    .courseDocumentId,
                                              });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                flex: width < 600 ? 4 : 3,
                                                child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        25),
                                                    child: Container(
                                                      // width: 130,
                                                      // height: 95,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.only(
                                                            topLeft:
                                                            Radius.circular(15),
                                                            topRight:
                                                            Radius.circular(15),
                                                            bottomLeft:
                                                            Radius.circular(15),
                                                            bottomRight:
                                                            Radius.circular(15),
                                                          )),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                        courseList[index]
                                                            .courseImageUrl,
                                                        placeholder: (context,
                                                            url) =>
                                                            Center(
                                                                child:
                                                                CircularProgressIndicator()),
                                                        errorWidget: (context,
                                                            url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                )),

                                            Expanded(
                                                flex: width < 600 ? 6 : 4,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  // width>700?
                                                  MainAxisAlignment
                                                      .spaceAround,
                                                  // :MainAxisAlignment.start,
                                                  children: [
                                                    // SizedBox(height: width>750?0:10,),
                                                    Container(
                                                      // margin: EdgeInsets.only(top: 3),
                                                      padding:
                                                      EdgeInsets.all(7),
                                                      decoration: BoxDecoration(
                                                          color: Colors.purple,
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              10)),
                                                      child: Text(
                                                        "Module 1",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    // SizedBox(height: width>750?0:10,),
                                                    // SizedBox(height: 8,),
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          courseList[index]
                                                              .courseName,
                                                          style: TextStyle(
                                                              height: 1,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: width >
                                                                  700
                                                                  ? 25
                                                                  : width < 540
                                                                  ? 15
                                                                  : 16),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        // SizedBox(height: width>750?0:10,),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(
                                                                        "Estimates learning time: ${courseList[index].duration == null ? "0" : courseList[index].duration}",
                                                                        overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                        style: TextStyle(
                                                                            fontSize: width < 540
                                                                                ? width < 420
                                                                                ? 11
                                                                                : 13
                                                                                : 14)),
                                                                    SizedBox(
                                                                      height: 3,
                                                                    ),
                                                                    Text(
                                                                        "Started on: Jan 01,2023",
                                                                        overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                        style: TextStyle(
                                                                            fontSize: width < 540
                                                                                ? width < 420
                                                                                ? 11
                                                                                : 13
                                                                                : 14)),
                                                                    SizedBox(
                                                                      height: 3,
                                                                    ),
                                                                    Text(
                                                                        "Completed on: Jan 01,2023",
                                                                        overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                        style: TextStyle(
                                                                            fontSize: width < 540
                                                                                ? width < 420
                                                                                ? 11
                                                                                : 13
                                                                                : 14)),
                                                                    SizedBox(
                                                                      height: 15,
                                                                    ),
                                                                    SizedBox(
                                                                      width: width <
                                                                          400
                                                                          ? 160
                                                                          : 190,
                                                                      child:
                                                                      MaterialButton(
                                                                        height: width >
                                                                            700
                                                                            ? 50
                                                                            : 40,
                                                                        shape:
                                                                        RoundedRectangleBorder(
                                                                          borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                        ),
                                                                        padding:
                                                                        EdgeInsets
                                                                            .all(8),
                                                                        minWidth:
                                                                        width > 700
                                                                            ? 100
                                                                            : 60,
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                                  () {
                                                                                courseId =
                                                                                    courseList[index].courseDocumentId;
                                                                              });
                                                                          GoRouter.of(context).pushNamed(
                                                                              'comboVideoScreen',
                                                                              queryParams: {
                                                                                'courseName':
                                                                                courseList[index].courseName,
                                                                                'cID':
                                                                                courseList[index].courseDocumentId,
                                                                              });
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            SizedBox(
                                                                              width:
                                                                              5,
                                                                            ),
                                                                            Expanded(
                                                                                flex:
                                                                                1,
                                                                                child:
                                                                                Icon(
                                                                                  Icons.play_arrow,
                                                                                  color: Colors.white,
                                                                                  size: width < 200 ? 2 : null,
                                                                                )),
                                                                            Expanded(
                                                                                flex:
                                                                                3,
                                                                                child:
                                                                                Text(
                                                                                  "Resume learning",
                                                                                  style: TextStyle(color: Colors.white, fontSize: width < 500 ? 10 : null),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        color: Colors
                                                                            .purple,
                                                                      ),
                                                                    )
                                                                  ],
                                                                )),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            width < 700
                                                                ?
                                                            // Expanded(
                                                            //   child:
                                                            Column(
                                                              mainAxisAlignment: width > 700
                                                                  ? MainAxisAlignment
                                                                  .center
                                                                  : MainAxisAlignment
                                                                  .end,
                                                              children: [
                                                                SizedBox(
                                                                  height:
                                                                  25,
                                                                ),
                                                                CircularPercentIndicator(
                                                                  radius: width <
                                                                      700
                                                                      ? width < 500
                                                                      ? 20
                                                                      : 30
                                                                      : 70,
                                                                  lineWidth: width >
                                                                      700
                                                                      ? 10.0
                                                                      : 4.0,
                                                                  animation:
                                                                  true,
                                                                  percent: courseData !=
                                                                      null
                                                                      ? courseData[widget.courses![index] + "percentage"] != null
                                                                      ? courseData[widget.courses![index] + "percentage"] / 100
                                                                      : 0 / 100
                                                                      : 0,
                                                                  center: courseData !=
                                                                      null
                                                                      ? courseData[widget.courses![index] + "percentage"] != null
                                                                      ? Text(
                                                                    courseData[widget.courses![index] + "percentage"].toString() + "%",
                                                                    style: TextStyle(
                                                                        fontSize: width > 700
                                                                            ? 20.0
                                                                            : width < 500
                                                                            ? 8
                                                                            : 14,
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors.black),
                                                                  )
                                                                      : Text(
                                                                    0.toString() + "%",
                                                                    style: TextStyle(
                                                                        fontSize: width > 700
                                                                            ? 20.0
                                                                            : width < 500
                                                                            ? 8
                                                                            : 14,
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors.black),
                                                                  )
                                                                      : SizedBox(),
                                                                  backgroundColor:
                                                                  Colors.black12,
                                                                  circularStrokeCap:
                                                                  CircularStrokeCap.round,
                                                                  progressColor:
                                                                  Colors.green,
                                                                ),
                                                                SizedBox(
                                                                  height: width <
                                                                      500
                                                                      ? 3
                                                                      : 5,
                                                                ),
                                                                courseData !=
                                                                    null
                                                                    ? Text(
                                                                  courseData[widget.courses![index] + "percentage"] != null ? courseData[widget.courses![index] + "percentage"].toString() + "%" : "0%",
                                                                  style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold),
                                                                )
                                                                    : SizedBox()
                                                                // SizedBox(height: 15,),
                                                                // Text("10%")
                                                              ],
                                                            )
                                                            // ,
                                                            // )
                                                                : SizedBox(),
                                                            SizedBox(
                                                              width: 5,
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )),
                                            // SizedBox(width: 10,),
                                            width > 700
                                                ? Expanded(
                                              flex: 2,
                                              // color: Colors.green,
                                              child: Column(
                                                mainAxisAlignment:
                                                width > 700
                                                    ? MainAxisAlignment
                                                    .center
                                                    : MainAxisAlignment
                                                    .end,
                                                children: [
                                                  CircularPercentIndicator(
                                                    radius: width > 700
                                                        ? 70.0
                                                        : 40.0,
                                                    lineWidth: 10.0,
                                                    animation: true,
                                                    percent: courseData !=
                                                        null
                                                        ? courseData[widget.courses![
                                                    index] +
                                                        "percentage"] !=
                                                        null
                                                        ? courseData[widget
                                                        .courses![index] +
                                                        "percentage"] /
                                                        100
                                                        : 0 / 100
                                                        : 0,
                                                    center: courseData !=
                                                        null
                                                        ? courseData[widget.courses![
                                                    index] +
                                                        "percentage"] !=
                                                        null
                                                        ? Text(
                                                      courseData[widget.courses![index] + "percentage"]
                                                          .toString() +
                                                          "%",
                                                      style: TextStyle(
                                                          fontSize:
                                                          20.0,
                                                          fontWeight: FontWeight
                                                              .w600,
                                                          color:
                                                          Colors.black),
                                                    )
                                                        : Text(
                                                        0.toString() +
                                                            '%',
                                                        style: TextStyle(
                                                            fontSize:
                                                            20.0,
                                                            fontWeight: FontWeight
                                                                .w600,
                                                            color:
                                                            Colors.black))
                                                        : SizedBox(),
                                                    backgroundColor:
                                                    Colors.black12,
                                                    circularStrokeCap:
                                                    CircularStrokeCap
                                                        .round,
                                                    progressColor:
                                                    Colors.green,
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  courseData != null
                                                      ? Text(courseData[widget.courses![
                                                  index] +
                                                      "percentage"] !=
                                                      null
                                                      ? courseData[widget.courses![index] +
                                                      "percentage"]
                                                      .toString() +
                                                      "%"
                                                      : "0%")
                                                      : SizedBox()
                                                ],
                                              ),
                                            )
                                                : SizedBox()
                                            // Column(
                                            //   mainAxisAlignment: width>700?MainAxisAlignment.center:MainAxisAlignment.end,
                                            //   children: [
                                            //     CircularPercentIndicator(
                                            //       radius: width>700?70.0:30.0,
                                            //       lineWidth: width>700?10.0:5.0,
                                            //       animation: true,
                                            //       percent: 10/100,
                                            //       center: Text(
                                            //         10.toString() + "%",
                                            //         style: TextStyle(
                                            //             fontSize: width>700?20.0:14,
                                            //             fontWeight: FontWeight.w600,
                                            //             color: Colors.black),
                                            //       ),
                                            //       backgroundColor: Colors.black12,
                                            //       circularStrokeCap: CircularStrokeCap.round,
                                            //       progressColor: Colors.green,
                                            //     ),
                                            //     SizedBox(height: 15,),
                                            //     Text("10%")
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            );
                          } else {
                            return Container();
                          }
                        })
                  ],
                ),
              ),
          );
        },
      ),
    );
  }

  getAllPaidCourses() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc()
        .get()
        .then((value) {
      print(value);
    });
  }
  getPercentageOfCourse() async {
    var data = await FirebaseFirestore.instance
        .collection("courseprogress")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      courseData = data.data();
    });
    print("GETDATA $courseData");
    print(widget.courses);
    print(courseData![widget.courses![2] + "percentage"]);
  }
  getTheStreamData() async {
    print("calling...");
    await FirebaseFirestore.instance.collection("courses").get().then((value) {
      print("0000000 $value");
      counterSink.add(value.docs);
    });
  }
}
