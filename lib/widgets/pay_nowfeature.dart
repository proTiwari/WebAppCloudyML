import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:cloudyml_app2/payment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../globals.dart';

class PayNowBottomSheetfeature extends StatefulWidget {
  ValueListenable<double> currentPosition;
  ValueListenable<double> popBottomSheetAt;
  String coursePrice;
  Map<String, dynamic> map;
  bool isItComboCourse;
  String cID;
  PayNowBottomSheetfeature({
    Key? key,
    required this.currentPosition,
    required this.coursePrice,
    required this.map,
    required this.popBottomSheetAt,
    required this.isItComboCourse,
    required this.cID,
  }) : super(key: key);

  @override
  State<PayNowBottomSheetfeature> createState() =>
      _PayNowBottomSheetfeatureState();
}

class _PayNowBottomSheetfeatureState extends State<PayNowBottomSheetfeature> {
  List<CourseDetails> featuredCourse = [];

  setFeaturedCourse(List<CourseDetails> course) {
    featuredCourse.clear();

    course.forEach((element) {
      print('element is $element ');
      if (element.courseDocumentId == widget.cID) {
        featuredCourse.add(element);
        // featuredCourse.add(element.courses);

        print('element ${featuredCourse[0].courseId} ');
      }
    });
    print('function ');
  }

  Map userMap = Map<String, dynamic>();

  void dbCheckerForPayInParts() async {
    try {
      DocumentSnapshot userDocs = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      // print(map['payInPartsDetails'][id]['outStandingAmtPaid']);
      // setState(() {
      userMap = userDocs.data() as Map<String, dynamic>;
      // whetherSubScribedToPayInParts =
      //     !(!(map['payInPartsDetails']['outStandingAmtPaid'] == null));
      // });
    } catch (e) {
      print("ggggggggggg $e");
    }
  }

  void trialCourse() async {
    print(
        'this is name  : ${userMap['name']} ${widget.cID} ${FirebaseAuth.instance.currentUser!.uid} "abc"');

    try {
      var url = Uri.parse(
          'https://us-central1-cloudyml-app.cloudfunctions.net/exceluser/trial');
      final response = await http.post(url, headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Methods": "GET, POST",
      }, body: {
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "cid": featuredCourse[0].courseId,
        "uname": userMap['name'],
        "cname": "abc",
      });
      // print('this is body ${body.toString()}');

      print(response.statusCode);
    } catch (e) {
      print('this is api error ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();

    // print("vid is===${featuredCourse[int.parse(widget.id!)]}");
    dbCheckerForPayInParts();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;

    List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
    setFeaturedCourse(course);
    return BottomSheet(
      builder: (BuildContext context) {
        return ValueListenableBuilder(
          valueListenable: widget.currentPosition,
          builder: (BuildContext context, double value, Widget? child) {
            return ValueListenableBuilder(
              valueListenable: widget.popBottomSheetAt,
              builder: (BuildContext context, double position, Widget? child) {
                if (value > 0.0 && /*value < 500 && */ value <= position) {
                  return Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    // duration: Duration(milliseconds: 1000),
                    // curve: Curves.easeIn,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            height: 60,
                            // width: 300,
                            color: Color(0xFF7860DC),
                            child: Center(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 200,
                                  ),
                                  userMap['paidCourseNames']
                                          .contains(featuredCourse[0].courseId)
                                      ? InkWell(
                                          onTap: () {
                                            GoRouter.of(context).pushNamed(
                                                'comboCourse',
                                                queryParams: {
                                                  'courseName':
                                                      featuredCourse[0]
                                                          .courseName,
                                                  'id': "25",
                                                });
                                          },
                                          child: Container(
                                            // height: screenHeight * .08,
                                            // width: screenWidth / 2.5,
                                            child: Center(
                                              child: Text(
                                                'Continue Your Course',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Medium',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    backgroundColor: Colors
                                                        .deepPurpleAccent[700],
                                                    title: Text(
                                                      'This course is available for ${featuredCourse[0].trialDays} days trial.',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    content: Container(
                                                      height: screenHeight * .5,
                                                      width: screenWidth / 2.5,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                              height:
                                                                  screenHeight *
                                                                      .4,
                                                              width:
                                                                  screenWidth /
                                                                      3.5,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 0.5),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                                                            child:
                                                                                Image.network(
                                                                              featuredCourse[0].courseImageUrl,
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          child: Text(
                                                                              featuredCourse[0].courseName,
                                                                              style: TextStyle(fontWeight: FontWeight.bold)),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              )),
                                                          SizedBox(height: 25
                                                              // *
                                                              // verticalScale
                                                              ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white,
                                                                      width:
                                                                          0.5),
                                                                ),
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    // print(
                                                                    //     'idd ${widget.id} ${featuredCourse[0].courseName}');
                                                                    // print('this is condition ${userMap['paidCourseNames'].contains(featuredCourse[int.parse(widget.id!)].courseId)}');
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                    'Close',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white,
                                                                      width:
                                                                          0.5),
                                                                ),
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    var paidcourse;
                                                                    print(
                                                                        userMap);

                                                                    if (userMap[
                                                                            'paidCourseNames']
                                                                        .contains(
                                                                            featuredCourse[0].courseId)) {
                                                                      Fluttertoast
                                                                          .showToast(
                                                                              msg: 'You have already enrolled in this course.');
                                                                    } else if (userMap[
                                                                            'paidCourseNames']
                                                                        .contains(
                                                                            featuredCourse[0].courseId)) {
                                                                      // print("this is it====${course[index!].toString()}");
                                                                      Fluttertoast
                                                                          .showToast(
                                                                              msg: 'You have already tried this course... Please purchase the course.');
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        trialCourse();

                                                                        //  print("this is it====${course[index!].toString()}");

                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                'Congrats!! Course is now available in enrolled courses for ${featuredCourse[0].trialDays}...');
                                                                        Timer(
                                                                            Duration(seconds: 1),
                                                                            () => GoRouter.of(context).pushNamed('comboCourse', queryParams: {
                                                                                  'courseName': featuredCourse[0].courseName,
                                                                                  'id': "25",
                                                                                }));
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    'Start your free trial',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Medium',
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Container(
                                            height: screenHeight * .08,
                                            width: screenWidth / 2.5,
                                            child: Center(
                                              child: Text(
                                                'Start your free trial now',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    width: 200,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                GoRouter.of(context).pushNamed(
                                    'comboPaymentPortal',
                                    queryParams: {
                                      'cID': widget.cID,
                                    });
                              },
                              child: Container(
                                height: 60,
                                // width: 300,
                                color: Color(0xFF7860DC),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Pay Now',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Medium',
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        widget.coursePrice,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Medium',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 0.1,
                  );
                }
              },
            );
          },
        );
      },
      onClosing: () {},
      enableDrag: false,
    );
  }
}
