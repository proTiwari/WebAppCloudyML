import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/screens/quiz/quizList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:star_rating/star_rating.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Providers/UserProvider.dart';
import '../../authentication/firebase_auth.dart';
import '../../catalogue_screen.dart';
import '../../combo/combo_store.dart';
import '../../fun.dart';
import '../../global_variable.dart' as globals;
import '../../Services/deeplink_service.dart';
import '../../api/firebase_api.dart';
import '../../combo/combo_course.dart';
import '../../homepage.dart';
import '../../models/course_details.dart';
import '../../models/firebase_file.dart';
import '../../module/pdf_course.dart';
import '../../module/video_screen.dart';
import '../../router/login_state_check.dart';
import '../flutter_flow/flutter_flow_util.dart';

class QuizesOfEnrolledCourses extends StatefulWidget {
  QuizesOfEnrolledCourses({Key? key}) : super(key: key);

  @override
  State<QuizesOfEnrolledCourses> createState() =>
      _QuizesOfEnrolledCoursesState();
}

class _QuizesOfEnrolledCoursesState extends State<QuizesOfEnrolledCourses> {
  late Future<List<FirebaseFile>> futureFiles;
  late Future<List<FirebaseFile>> futurefilesComboCourseReviews;
  late Future<List<FirebaseFile>> futurefilesSocialMediaReviews;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> courses = [];
  bool? load = true;
  Map userMap = Map<String, dynamic>();

  String? name = '';

  getCourseName() async {
    try {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .get()
          .then((value) {
        setState(() {
          name = value.data()!['name'];
          print('ufbufb--$name');
          print('ufbufb--$courseId');
        });
      });
    } catch (e) {
      print("llooooooooooooo$e");
    }
  }

  void addCoursetoUser(String id) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'paidCourseNames': FieldValue.arrayUnion([id])
    });
  }

  List<Icon> list = [];

  bool navigateToCatalogueScreen(String id) {
    if (userMap['payInPartsDetails'][id] != null) {
      final daysLeft = (DateTime.parse(
              userMap['payInPartsDetails'][id]['endDateOfLimitedAccess'])
          .difference(DateTime.now())
          .inDays);
      print(daysLeft);
      return daysLeft < 1;
    } else {
      return false;
    }
  }

  bool statusOfPayInParts(String id) {
    if (!(userMap['payInPartsDetails'][id] == null)) {
      if (userMap['payInPartsDetails'][id]['outStandingAmtPaid']) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  void dbCheckerForPayInParts() async {
    try {
      DocumentSnapshot userDocs = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      setState(() {
        userMap = userDocs.data() as Map<String, dynamic>;
      });
    } catch (e) {
      print("ggggggggggg $e");
    }
  }

  late ScrollController _controller;
  final notificationBox = Hive.box('NotificationBox');
  bool menuClicked = false;
  List<CourseDetails> featuredCourse = [];

  setFeaturedCourse(List<CourseDetails> course) {
    featuredCourse.clear();
    course.forEach((element) {
      if (element.FcSerialNumber.isNotEmpty &&
          element.FcSerialNumber != null &&
          element.isItComboCourse == true) {
        featuredCourse.add(element);
      }
    });
    featuredCourse.sort((a, b) {
      return int.parse(a.FcSerialNumber).compareTo(int.parse(b.FcSerialNumber));
    });
  }

  Future fetchCourses() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        setState(() {
          if (value.data()!['paidCourseNames'] == null ||
              value.data()!['paidCourseNames'] == []) {
            courses = [];
          } else {
            courses = value.data()!['paidCourseNames'];
            coursesname = courses;
            getPercentageOfCourse();
          }
          load = false;
        });
      });
      print('user enrolled in number of courses ${courses.length}');
    } catch (e) {
      print("kkkk $e}");
    }
  }

  var coursePercent = {};

  getPercentageOfCourse() async {
    if (courses.length != 0) {
      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) async {
          try {
            courses = value.data()!['paidCourseNames'];
          } catch (e) {
            print('donggg ${e.toString()}');
          }
        });
      } catch (e) {
        print(e.toString());
      }
      var getData;
      try {
        var data = await FirebaseFirestore.instance
            .collection("courseprogress")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) {
          getData = value.data();
        }).catchError((e) => print(e.toString()));

        for (var courseId in courses) {
          print("ID = = ${courseId}");
          int count = 0;
          try {
            await FirebaseFirestore.instance
                .collection("courses")
                .where("id", isEqualTo: courseId)
                .get()
                .then((value) async {
              if (value.docs.first.exists) {
                var coursesName = value.docs.first.data()["courses"];
                if (coursesName != null) {
                  print("name");
                  for (var Id in coursesName) {
                    double num = (getData![Id + "percentage"] != null)
                        ? getData[Id + "percentage"]
                        : 0;
                    count += num.toInt();
                    print("Count = $count");
                    coursePercent[courseId] =
                        count ~/ (value.docs.first.data()["courses"].length);
                  }
                } else {
                  print("yy");
                  print(getData![value.docs.first.data()["id"].toString() +
                          "percentage"]
                      .toString());
                  coursePercent[courseId] = getData[
                              value.docs.first.data()["id"].toString() +
                                  "percentage"] !=
                          null
                      ? getData[value.docs.first.data()["id"].toString() +
                          "percentage"]
                      : 0;
                }
              }
            }).catchError((err) => print("${err.toString()} Error"));
          } catch (err) {
            print(err);
          }
        }
      } catch (e) {
        print('my courses error ${e.toString()}');
      }

      print("done");
      setState(() {
        coursePercent;
      });
      print(coursePercent);
    }
  }

  bool isShow = false;

  var textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 14,
    fontFamily: "Semibold",
  );

  var ref;
  var userDocData;
  userData() async {
    try {
      ref = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      print('uid is ${FirebaseAuth.instance.currentUser!.uid}');

      print(ref.data()!["role"].toString());
      userDocData = ref.data()!;
    } catch (e) {
      print("kkkkkkk${e}");
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
    fromcombo = 'yes';
    futureFiles = FirebaseApi.listAll('reviews/recent_review');
    futurefilesComboCourseReviews =
        FirebaseApi.listAll('reviews/combo_course_review');
    futurefilesSocialMediaReviews =
        FirebaseApi.listAll('reviews/social_media_review');
    getCourseName();
    fetchCourses();
    dbCheckerForPayInParts();
    userData();
  }

  Timer? countDownTimer;
  Duration myDuration = Duration(days: 5);

  @override
  Widget build(BuildContext context) {
    List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    setFeaturedCourse(course);
    return Scaffold(
      key: _scaffoldKey,
      drawer: customDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      "My Quizzes",
                      style: TextStyle(
                          fontFamily: 'Medium',
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
                  courses.length > 0
                      ? Center(
                          child: Container(
                            width: courses.length == 1
                                ? screenWidth / 2.5
                                : screenWidth / 1.2,
                            height: screenHeight,
                            color: Colors.transparent,
                            child: ListView.builder(
                              itemCount: course.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (course[index].courseName == "null") {
                                  return Container();
                                }
                                if (courses.contains(course[index].courseId)) {
                                  return Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: (() async {
                                              await getCourseName();
                                              print('efjowjefoiwje');
                                              if (navigateToCatalogueScreen(
                                                      course[index].courseId) &&
                                                  !(userMap['payInPartsDetails']
                                                          [course[index]
                                                              .courseId]
                                                      ['outStandingAmtPaid'])) {
                                                if (!course[index]
                                                    .isItComboCourse) {
                                                  print("owfoiwjoifejw");
                                                  GoRouter.of(context)
                                                      .pushNamed('quizlist',
                                                          queryParams: {
                                                        'courseName':
                                                            course[index]
                                                                .courseName,
                                                        'cID': course[index]
                                                            .courseDocumentId,
                                                      });
                                                } else {
                                                  print("owfoiwjoifejw1");
                                                  final id = index.toString();
                                                  final courseName =
                                                      course[index].courseName;
                                                  context.goNamed('comboStore',
                                                      queryParams: {
                                                        'courseName':
                                                            courseName,
                                                        'id': id
                                                      });
                                                }
                                              } else {
                                                print('efjowjefoiwje2');
                                                if (!course[index]
                                                    .isItComboCourse) {
                                                  print('efjowjefoiwje3');
                                                  if (course[index]
                                                          .courseContent ==
                                                      'pdf') {
                                                    print('efjowjefoiwje4');
                                                    Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        duration: Duration(
                                                            milliseconds: 400),
                                                        curve:
                                                            Curves.bounceInOut,
                                                        type: PageTransitionType
                                                            .rightToLeftWithFade,
                                                        child: PdfCourseScreen(
                                                          curriculum: course[
                                                                      index]
                                                                  .curriculum
                                                              as Map<String,
                                                                  dynamic>,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    print('efjowjefoiwje5');
                                                    print("wijwioefw");
                                                    fromcombo = 'yes';
                                                    try {
                                                      if (course[index]
                                                          .multiCombo!) {
                                                        GoRouter.of(context)
                                                            .pushNamed(
                                                                'MultiComboModuleScreen',
                                                                queryParams: {
                                                              'courseName':
                                                                  course[index]
                                                                      .courseName
                                                                      .toString(),
                                                              'id':
                                                                  course[index]
                                                                      .courseId,
                                                            });
                                                      } else {
                                                        GoRouter.of(context)
                                                            .pushNamed(
                                                                'quizlist',
                                                                queryParams: {
                                                              'courseName':
                                                                  course[index]
                                                                      .courseName,
                                                              'cID': course[
                                                                      index]
                                                                  .courseDocumentId,
                                                            });
                                                      }
                                                    } catch (e) {
                                                      GoRouter.of(context)
                                                          .pushNamed('quizlist',
                                                              queryParams: {
                                                            'courseName':
                                                                course[index]
                                                                    .courseName,
                                                            'cID': course[index]
                                                                .courseDocumentId,
                                                          });
                                                      print(e);
                                                    }
                                                  }
                                                } else {
                                                  ComboCourse.comboId.value =
                                                      course[index].courseId;

                                                  final id = index.toString();
                                                  final courseName =
                                                      course[index].courseName;
                                                  fromcombo = 'yes';
                                                  GoRouter.of(context).pushNamed(
                                                      'NewComboCourseScreen',
                                                      queryParams: {
                                                        'courseId':
                                                            course[index]
                                                                .courseId,
                                                        'courseName': courseName
                                                      });
                                                }
                                              }
                                              setState(() {
                                                courseId = course[index]
                                                    .courseDocumentId;
                                              });
                                            }),
                                            child: Container(
                                              width: screenWidth / 2.8,
                                              height: screenHeight / 5.5,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: HexColor('440F87'),
                                                  width: 1.5,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 60 *
                                                              horizontalScale,
                                                          height: screenHeight /
                                                              5.5,
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .transparent),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  image: DecorationImage(
                                                                      image: CachedNetworkImageProvider(
                                                                        course[index]
                                                                            .courseImageUrl,
                                                                      ),
                                                                      fit: BoxFit.fill)),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Container(
                                                          width:
                                                              screenWidth / 5.6,
                                                          height: screenHeight /
                                                              5.5,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topCenter,
                                                            child: Column(
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                    course[index]
                                                                        .courseName,
                                                                    maxLines: 2,
                                                                    style:
                                                                        TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'Medium',
                                                                      fontSize:
                                                                          16,
                                                                      height:
                                                                          0.95,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              5.0),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            25,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5.0),
                                                                          color:
                                                                              HexColor('440F87'),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            course[index].reviews.isNotEmpty
                                                                                ? course[index].reviews
                                                                                : '5.0',
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.normal),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              5.0),
                                                                      child:
                                                                          StarRating(
                                                                        length:
                                                                            5,
                                                                        rating: course[index].reviews.isNotEmpty
                                                                            ? double.parse(course[index].reviews)
                                                                            : 5.0,
                                                                        color: HexColor(
                                                                            '440F87'),
                                                                        starSize:
                                                                            20,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                courses.length !=
                                                                            0 &&
                                                                        coursePercent !=
                                                                            {}
                                                                    ? Container(
                                                                        height:
                                                                            15,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Container(
                                                                              height: 5 * horizontalScale,
                                                                              width: 150 * verticalScale,
                                                                              child: LinearProgressIndicator(
                                                                                value: coursePercent[course[index].courseId.toString()] != null ? coursePercent[course[index].courseId] / 100 : 0,
                                                                                color: HexColor("8346E1"),
                                                                                backgroundColor: HexColor('E3E3E3'),
                                                                              ),
                                                                            ),
                                                                            Spacer(),
                                                                            Text(
                                                                              "${coursePercent[course[index].courseId.toString()] != null ? coursePercent[course[index].courseId] : 0}%",
                                                                              style: TextStyle(fontSize: 10),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    : SizedBox(),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 25,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        )
                      : Container(
                          width: screenWidth / 2.5,
                          height: screenHeight / 5.5,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(color: Colors.black, width: 1.0),
                          ),
                          child: Center(child: Text('There are zero courses.')),
                        ),
                  SizedBox(height: verticalScale * 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int numberOfDays = 3;
}
