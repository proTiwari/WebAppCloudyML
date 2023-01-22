import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/api/firebase_api.dart';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:cloudyml_app2/router/login_state_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloudyml_app2/fun.dart';
import 'package:cloudyml_app2/models/firebase_file.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:star_rating/star_rating.dart';
import 'Services/code_generator.dart';
import 'Services/deeplink_service.dart';
import 'combo/combo_course.dart';
import 'models/referal_model.dart';
import 'module/pdf_course.dart';
import 'package:http/http.dart' as http;
var rewardCount = 0;
String? linkMessage;

class Home extends StatefulWidget {

  const Home({Key? key}) : super(key: key);


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

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
      // print(map['payInPartsDetails'][id]['outStandingAmtPaid']);
      setState(() {
        userMap = userDocs.data() as Map<String, dynamic>;
        // whetherSubScribedToPayInParts =
        //     !(!(map['payInPartsDetails']['outStandingAmtPaid'] == null));
      });
    } catch (e) {
      print("ggggggggggg$e");
    }
  }

  late ScrollController _controller;
  final notificationBox = Hive.box('NotificationBox');
  bool menuClicked = false;

  // showNotification() async {
  //   final provider = Provider.of<UserProvider>(context, listen: false);
  //   if (notificationBox.isEmpty) {
  //     notificationBox.put(1, {"count": 0});
  //     provider
  //         .showNotificationHomeScreen(notificationBox.values.first["count"]);
  //   } else {
  //     provider
  //         .showNotificationHomeScreen(notificationBox.values.first["count"]);
  //   }
  // }




  Future fetchCourses() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        setState(() {
          if(value.data()!['paidCourseNames'] == null || value.data()!['paidCourseNames'] == []){
            courses = [];
          }else{
            courses = value.data()!['paidCourseNames'];
          }
          load = false;
        });
      });
      print('user enrolled in number of courses ${courses.length}');
    } catch (e) {
      print("kkkk$e");
    }
  }

  var coursePercent = {};
  getPercentageOfCourse() async {
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

    try {
      var data = await FirebaseFirestore.instance
          .collection("courseprogress")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      var getData = data.data();

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
              var coursesName = value.docs.first.data()["courses name"];
              if (coursesName != null) {
                print("name");
                for (var name in coursesName) {
                  double num = (getData![name + "percentage"] != null)
                      ? getData[name + "percentage"]
                      : 0;
                  count += num.toInt();
                  print("Count = $count");
                  coursePercent[courseId] =
                      count ~/ (value.docs.first.data()["courses name"].length);
                }
              } else {
                print("yy");
                print(getData![value.docs.first.data()["name"].toString() +
                    "percentage"]
                    .toString());
                coursePercent[courseId] = getData[
                value.docs.first.data()["name"].toString() +
                    "percentage"] !=
                    null
                    ? getData[value.docs.first.data()["name"].toString() +
                    "percentage"]
                    : 0;
              }
            }
          }).catchError((err) => print("Error"));
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

  @override
  void initState() {
    // showNotification();
    _controller = ScrollController();
    super.initState();
    futureFiles = FirebaseApi.listAll('reviews/recent_review');
    futurefilesComboCourseReviews = FirebaseApi.listAll('reviews/combo_course_review');
    futurefilesSocialMediaReviews = FirebaseApi.listAll('reviews/social_media_review');
    getCourseName();
    fetchCourses();
    dbCheckerForPayInParts();
    userData();
    getPercentageOfCourse();
    // startTimer();
    getuserdetails();
    checkrewardexpiry();
  }


  var textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 14,
    fontFamily: "Semibold",
  );

  var ref;

  userData() async {
    try {
      ref = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      print(ref.data()!["role"]);

    } catch (e) {
      print("kkkkkkk${e}");
    }
  }



  void getuserdetails() async {
    final deepLinkRepo = await DeepLinkService.instance;
    var referralCode = await deepLinkRepo?.referrerCode.value;

    print(
        "sddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd $referralCode ddd");
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      print(value.data());
      print(FirebaseAuth.instance.currentUser!.uid);

      try {
        linkMessage = await value.data()!['refer_link'];
        rewardCount = await value.data()!['reward'];
        setState(() {
          rewardCount;
        });
      } catch (e) {
        print(e);
        linkMessage = '';
      }
      print(linkMessage);
      print('1');
      if (linkMessage == '' || linkMessage == null) {
        print('2');
        print(linkMessage);
        updateReferaldata();
      } else {}
      ;
    });
  }

  checkrewardexpiry() async {
    var rewardvalidfrom;
    var rewardexpireindays;
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        rewardvalidfrom = value.data()!['rewardvalidfrom'];
      });
      await FirebaseFirestore.instance
          .collection("Controllers")
          .doc("variables")
          .get()
          .then((value) {
        rewardexpireindays = value.data()!['rewardexpireindays'];
      });
    } catch (e) {
      print(e.toString());
    }
    if (rewardexpireindays == null) {
      rewardexpireindays = 7;
    }
    if (rewardvalidfrom != null) {
      var data = DateTime.now().difference(rewardvalidfrom.toDate());
      if (data.inDays >= rewardexpireindays) {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"reward": 0}).whenComplete(() {
          print('success');
        }).onError((error, stackTrace) => print(error));
      }
    }
  }

  void updateReferaldata() async {
    try {
      print('4');
      final deepLinkRepo = await DeepLinkService.instance;
      var referralCode = await deepLinkRepo?.referrerCode.value;
      print(
          "sddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd ${referralCode}");
      final referCode = await CodeGenerator().generateCode('refer');
      final referLink =
      await DeepLinkService.instance?.createReferLink(referCode);
      setState(() {
        if (referralCode != '') {
          rewardCount = 50;
        } else {
          rewardCount = 0;
        }
        linkMessage = referLink;
        print(linkMessage);
      });

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'refer_link': referLink,
        'refer_code': referCode,
        "referral_code": referralCode,
        'reward': rewardCount,
      }).whenComplete(() =>
          print("send data to firebase uid: ${FirebaseAuth.instance.currentUser!.uid}"));

      Future<ReferalModel> getReferrerUser(String referCode) async {
        print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii ${referCode}");
        final docSnapshots = await FirebaseFirestore.instance
            .collection('Users')
            .where('refer_code', isEqualTo: referCode)
            .get();

        final userSnapshot = docSnapshots.docs.first;
        print(
            "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii ${userSnapshot.exists}");
        if (userSnapshot.exists) {
          print(userSnapshot.data());
          return ReferalModel.fromJson(userSnapshot.data());
        } else {
          return ReferalModel.empty();
        }
      }

      Future<void> rewardUser(
          String currentUserUID, String referrerCode) async {
        try {
          if (referrerCode.toString().substring(0, 11) != "moneyreward") {
            final referer = await getReferrerUser(referrerCode);
            print(
                "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii ${referer.id}");

            final checkIfUserAlreadyExist = await FirebaseFirestore.instance
                .collection('Users')
                .doc(referer.id)
                .collection('referrers')
                .doc(currentUserUID)
                .get();

            if (!checkIfUserAlreadyExist.exists) {
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(referer.id)
                  .collection('referrers')
                  .doc(currentUserUID)
                  .set({
                "uid": currentUserUID,
                "createdAt": DateTime.now(),
              });

              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(referer.id)
                  .update({
                "reward": FieldValue.increment(50),
                "rewardvalidfrom": DateTime.now()
              });
            }
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }

      if (referralCode != "") {
        print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii ${referralCode}");
        await rewardUser(FirebaseAuth.instance.currentUser!.uid, referralCode!);
      }
      ;
    } catch (e) {
      print(
          "................................................................................................................................${e}");
    }
  }

  void startTimer() {
    countDownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setCountDown();
    });
  }

  void stopTimer() {
    setState(() {
      countDownTimer!.cancel();
    });
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      myDuration = Duration(days: 5);
    });
  }

  setCountDown() {
    final reduceSecs = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecs;
      if (seconds < 0) {
        countDownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  String strDigits(int n) => n.toString().padLeft(2, '0');

  void saveLoginOutState(BuildContext context) {
    Provider.of<LoginState>(context, listen: false).loggedIn = false;
  }

  var authorizationToken;
  void insertToken()
  async{
    print("insertToken");
    final token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update(
        {"token":token}
    );
    authorizationToken  = await FirebaseAuth.instance.currentUser!.getIdToken();
  }

  getHello() async {
    var headers = {
      'Access-Control-Allow-Origin': '*',
      'Accept': '*/*',
      'Access-Control-Allow-Methods': 'GET, POST',
      "Access-Control-Allow-Headers": "Origin, X-Requested-With, Content-Type, Accept",
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authorizationToken}'
    };

    try {
      var response =
      await http.post(
        Uri.parse('https://us-central1-cloudyml-app.cloudfunctions.net/helloWorld'),
          headers: headers,);
      var responseData = await jsonDecode(response.body);

      print(response.statusCode);
      print(responseData.toString());
      print(response.toString());
    } catch(e){
      print('that is an error boss ${e.toString()}');
    }

  }


  Timer? countDownTimer;
  Duration myDuration = Duration(days: 5);

  @override
  Widget build(BuildContext context) {
    final days = strDigits(myDuration.inDays);
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    final providerNotification =
    Provider.of<UserProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;

    return Scaffold(
      key: _scaffoldKey,
      drawer: customDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).push('/chat');
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.mark_chat_unread_outlined, color: HexColor('691EC8'),),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth >= 315) {
              try {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: screenWidth,
                        height: screenHeight,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/homepage/newBGImage.png'),
                              fit: BoxFit.fill),
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Scaffold.of(context).openDrawer();
                                      menuClicked = true;
                                    },
                                    icon: Icon(
                                      Icons.menu,
                                      color: Colors.white,
                                    )),
                                SizedBox(
                                  width: horizontalScale * 15,
                                ),
                                Image.asset(
                                  "assets/logo2.png",
                                  width: 30,
                                  height: 30,
                                ),
                                Text(
                                  "CloudyML",
                                  style: textStyle,
                                ),
                                Spacer(),
                                ElevatedButton(
                                    onPressed: () {
                                      logOut(context);
                                      saveLoginOutState(context);
                                      GoRouter.of(context).pushReplacement('/login');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: HexColor("8346E1"),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(50),
                                      ),
                                    ),
                                    child: Text("Log out",
                                        style: textStyle)),
                              ],),
                            Positioned(
                              top: 50,
                              right: 75,
                              child: Container(
                                  height: screenHeight / 1.8,
                                  width: screenWidth / 2.8,
                                  child: Image.asset(
                                    'assets/homepage/Webgraphics21.png',
                                    fit: BoxFit.fill,
                                  )),
                            ),
                            Positioned(
                              top: 125,
                              left: 75,
                              child: Container(
                                  height: screenHeight / 2.5,
                                  width: screenWidth / 2.0,
                                  child: Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FGroup%20162.png?alt=media&token=6e3f0646-61b4-4897-ae9d-9ef3600676e1',
                                    fit: BoxFit.fill,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Text(
                                    "My Enrolled Courses",
                                    style: TextStyle(
                                        fontFamily: 'Medium',
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            courses.length > 0
                                ? Container(
                                  width: courses.length == 1 ? screenWidth / 2.5 : screenWidth/1.2,
                                  height: screenHeight/5,
                              color: Colors.transparent,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    // shrinkWrap: true,
                                    itemCount: course.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (course[index].courseName ==
                                          "null") {
                                        return Container();
                                      }
                                      if (courses.contains(
                                          course[index].courseId)) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: (() async {
                                                // setModuleId(snapshot.data!.docs[index].id);
                                                await getCourseName();
                                                if (navigateToCatalogueScreen(
                                                    course[index]
                                                        .courseId) &&
                                                    !(userMap['payInPartsDetails']
                                                    [course[index]
                                                        .courseId][
                                                    'outStandingAmtPaid'])) {
                                                  if (!course[index]
                                                      .isItComboCourse) {
                                                    GoRouter.of(context).pushNamed('videoScreen',
                                                        queryParams: {
                                                          'courseName': course[index].courseName});

                                                    // Navigator.push(
                                                    //   context,
                                                    //   PageTransition(
                                                    //     duration: Duration(
                                                    //         milliseconds: 400),
                                                    //     curve:
                                                    //     Curves.bounceInOut,
                                                    //     type: PageTransitionType
                                                    //         .rightToLeftWithFade,
                                                    //     child: VideoScreen(
                                                    //       isDemo: true,
                                                    //       courseName:
                                                    //       course[index]
                                                    //           .courseName,
                                                    //       sr: 1,
                                                    //     ),
                                                    //   ),
                                                    // );
                                                  } else {
                                                    final id = index.toString();
                                                    final courseName = course[index].courseName;
                                                    context.goNamed('comboStore', queryParams: {'courseName': courseName,
                                                      'id': id});

                                                    // Navigator.push(
                                                    //   context,
                                                    //   PageTransition(
                                                    //     duration: Duration(
                                                    //         milliseconds: 100),
                                                    //     curve:
                                                    //     Curves.bounceInOut,
                                                    //     type: PageTransitionType
                                                    //         .rightToLeftWithFade,
                                                    //     child: ComboStore(
                                                    //       courses: course[index]
                                                    //           .courses,
                                                    //     ),
                                                    //   ),
                                                    // );
                                                  }
                                                } else {
                                                  if (!course[index]
                                                      .isItComboCourse) {
                                                    if (course[index]
                                                        .courseContent ==
                                                        'pdf') {
                                                      Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          duration: Duration(
                                                              milliseconds:
                                                              400),
                                                          curve: Curves
                                                              .bounceInOut,
                                                          type: PageTransitionType
                                                              .rightToLeftWithFade,
                                                          child:
                                                          PdfCourseScreen(
                                                            curriculum: course[
                                                            index]
                                                                .curriculum
                                                            as Map<String,
                                                                dynamic>,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      GoRouter.of(context).pushNamed('videoScreen',
                                                          queryParams: {
                                                            'courseName': course[index].courseName});
                                                      // Navigator.push(
                                                      //   context,
                                                      //   PageTransition(
                                                      //     duration: Duration(
                                                      //         milliseconds:
                                                      //         400),
                                                      //     curve: Curves
                                                      //         .bounceInOut,
                                                      //     type: PageTransitionType
                                                      //         .rightToLeftWithFade,
                                                      //     child: VideoScreen(
                                                      //       isDemo: true,
                                                      //       courseName:
                                                      //       course[index]
                                                      //           .courseName,
                                                      //       sr: 1,
                                                      //     ),
                                                      //   ),
                                                      // );
                                                    }
                                                  } else {

                                                    ComboCourse.comboId.value =
                                                        course[index].courseId;

                                                    final id = index.toString();
                                                    final courseName = course[index].courseName;

                                                    GoRouter.of(context).pushNamed('comboCourse', queryParams: {'id': id, 'courseName': courseName});
                                                    // Navigator.push(
                                                    //   context,
                                                    //   PageTransition(
                                                    //     duration: Duration(
                                                    //         milliseconds: 400),
                                                    //     curve:
                                                    //     Curves.bounceInOut,
                                                    //     type: PageTransitionType
                                                    //         .rightToLeftWithFade,
                                                    //     child: ComboCourse(
                                                    //       courses: course[index]
                                                    //           .courses,
                                                    //     ),
                                                    //   ),
                                                    // );
                                                  }
                                                }
                                                setState(() {
                                                  courseId = course[index]
                                                      .courseDocumentId;
                                                });
                                              }),
                                              child: Container(
                                                width: screenWidth / 2.8,
                                                height: screenHeight/ 5.5,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //       color: Colors.black26,
                                                  //       offset: Offset(
                                                  //         2, // Move to right 10  horizontally
                                                  //         2.0, // Move to bottom 10 Vertically
                                                  //       ),
                                                  //       blurRadius: 40)
                                                  // ],
                                                  border: Border.all(
                                                    color: HexColor('440F87'),
                                                    width: 1.5,
                                                  ),
                                                  borderRadius: BorderRadius.circular(10),
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
                                                            height:
                                                            screenHeight /
                                                                5.5,
                                                            decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .transparent),
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(5),
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
                                                            width: screenWidth/5.6,
                                                            height: screenHeight / 5.5,
                                                            child: Align(
                                                              alignment: Alignment.topCenter,
                                                              child: Column(
                                                                children: [
                                                                  Align(
                                                                    alignment: Alignment.topLeft,
                                                                    child: Text(
                                                                      course[index].courseName,
                                                                      maxLines: 2,
                                                                      style: TextStyle(
                                                                        overflow: TextOverflow.ellipsis,
                                                                        color: Colors.black,
                                                                          fontFamily: 'Medium',
                                                                          fontSize: 16,
                                                                          height: 0.95,
                                                                          fontWeight: FontWeight.bold,),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  // Align(
                                                                  //   alignment:
                                                                  //   Alignment
                                                                  //       .topLeft,
                                                                  //   child: Text(
                                                                  //     "${course[index].numOfVideos} Videos",
                                                                  //     style: TextStyle(
                                                                  //         color: HexColor(
                                                                  //             "2C2C2C"),
                                                                  //         fontFamily:
                                                                  //         'Medium',
                                                                  //         fontSize:
                                                                  //         12,
                                                                  //         fontWeight: FontWeight
                                                                  //             .w500,
                                                                  //         height:
                                                                  //         1),
                                                                  //   ),
                                                                  // ),
                                                                  SizedBox(height: 10,),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(right: 5.0),
                                                                        child: Container(
                                                                          height: 20,
                                                                          width: 25,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(5.0),
                                                                            color: HexColor('440F87'),
                                                                          ),
                                                                          child: Center(
                                                                            child: Text( course[index].reviews.isNotEmpty ? course[index].reviews : '5.0',
                                                                              style: TextStyle(fontSize: 12, color: Colors.white,
                                                                                  fontWeight: FontWeight.normal),),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                        const EdgeInsets.only(right: 5.0),
                                                                        child: StarRating(
                                                                          length: 5,
                                                                          rating: course[index].reviews.isNotEmpty ? double.parse(course[index].reviews) : 5.0,
                                                                          color: HexColor('440F87'),
                                                                          starSize: 20,
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  Container(
                                                                    height: 15,
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          height: 5,
                                                                          width: 150,
                                                                          child:
                                                                          LinearProgressIndicator(
                                                                            value: coursePercent[course[index].courseId.toString()]!=null ? coursePercent[course[index].courseId]/100 : 0,
                                                                            color: HexColor(
                                                                                "8346E1"),
                                                                            backgroundColor:
                                                                            HexColor(
                                                                                'E3E3E3'),
                                                                          ),
                                                                        ),
                                                                        Spacer(),
                                                                        Text(
                                                                          "${coursePercent[course[index].courseId.toString()]!=null?coursePercent[course[index].courseId]:0}%", style: TextStyle(fontSize: 10),)
                                                                      ],
                                                                    ),
                                                                  ),
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
                                            Container(width: 25,),
                                          ],
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                )
                                : Container(
                              width: screenWidth / 2.5,
                              height: screenHeight / 5.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(color: Colors.black, width: 1.0),
                              ),
                              child: Center(
                                  child: Text('There are zero courses.')),
                            ),
                            SizedBox(height: verticalScale * 40),
                            // Padding(
                            //   padding: const EdgeInsets.all(15.0),
                            //   child: Container(
                            //     child: ElevatedButton(
                            //         onPressed: () {}, child: Text("View More")),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Container(
                        height: screenHeight / 1.8,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [0, 0.4, 0.9],
                            colors: [
                              HexColor("FFFFFF"),
                              HexColor("B079FF"),
                              HexColor("FFFFFF"),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Reviews',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FutureBuilder<List<FirebaseFile>>(
                                  future: futureFiles,
                                  builder: (context, snapshot) {
                                    try {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return Center(
                                              child: CircularProgressIndicator());
                                        default:
                                          if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                  'Some error occurred!',
                                                  textScaleFactor: min(
                                                      horizontalScale, verticalScale),
                                                ));
                                          } else {
                                            final files = snapshot.data!;
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: screenHeight / 2.3,
                                                width: screenWidth/3.5,
                                                child: CarouselSlider.builder(
                                                  options: CarouselOptions(
                                                    autoPlay: true,
                                                    enableInfiniteScroll: true,
                                                    enlargeCenterPage: false,
                                                    viewportFraction: 1,
                                                    aspectRatio: 2.0,
                                                    initialPage: 0,
                                                    autoPlayCurve: Curves.fastOutSlowIn,
                                                    autoPlayAnimationDuration: Duration(
                                                        milliseconds: 1000),
                                                  ),
                                                  itemCount: files.length,
                                                  itemBuilder: (BuildContext context, int index, int pageNo) {
                                                    return
                                                    ClipRRect(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(12),
                                                        child: InkWell(
                                                          onTap: () {
                                                            final file =
                                                            files[index];
                                                            showDialog(
                                                                context: context,
                                                                builder: (context) =>
                                                                    GestureDetector(
                                                                        onTap: () =>
                                                                            Navigator.pop(
                                                                                context),
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          color: Colors.transparent,
                                                                          height: 400,
                                                                          width: 300,
                                                                          child: AlertDialog(
                                                                            shape: RoundedRectangleBorder(
                                                                                borderRadius:
                                                                                BorderRadius
                                                                                    .circular(
                                                                                    15.0),
                                                                                side: BorderSide
                                                                                    .none),
                                                                            scrollable: true,
                                                                            content:
                                                                            Container(height:240,width:320,
                                                                              child: ClipRRect(borderRadius: BorderRadius.circular(20),
                                                                                child: CachedNetworkImage(
                                                                                  errorWidget:
                                                                                      (context, url,
                                                                                      error) =>
                                                                                      Icon(Icons
                                                                                          .error),
                                                                                  imageUrl: file.url,
                                                                                  fit: BoxFit.fill,
                                                                                  placeholder: (context,
                                                                                      url) =>
                                                                                      Center(child: CircularProgressIndicator()),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )));
                                                          },
                                                          child: Image.network(
                                                              files[index].url),
                                                        ));
                                                  }
                                                ),
                                              ),
                                            );
                                          }
                                      }
                                    } catch (e) {
                                      print("jjkkjkjkkkkjkjjjjjjjjkkk${e}");

                                      Fluttertoast.showToast(msg: e.toString());
                                      return Center(
                                          child: Text(
                                            'Some error occurred!',
                                            textScaleFactor:
                                            min(horizontalScale, verticalScale),
                                          ));
                                    }
                                  },
                                ),
                                FutureBuilder<List<FirebaseFile>>(
                                  future: futurefilesComboCourseReviews,
                                  builder: (context, snapshot) {
                                    try {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return Center(
                                              child: CircularProgressIndicator());
                                        default:
                                          if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                  'Some error occurred!',
                                                  textScaleFactor: min(
                                                      horizontalScale, verticalScale),
                                                ));
                                          } else {
                                            final files = snapshot.data!;
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: screenHeight / 2.3,
                                                width: screenWidth/3.5,
                                                child: CarouselSlider.builder(
                                                    options: CarouselOptions(
                                                      autoPlay: true,
                                                      enableInfiniteScroll: true,
                                                      enlargeCenterPage: false,
                                                      viewportFraction: 1,
                                                      aspectRatio: 2.0,
                                                      initialPage: 4,
                                                      autoPlayCurve: Curves.fastOutSlowIn,
                                                      autoPlayAnimationDuration: Duration(
                                                          milliseconds: 2000),
                                                    ),
                                                    itemCount: files.length,
                                                    itemBuilder: (BuildContext context, int index, int pageNo) {
                                                      return
                                                        ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                            child: InkWell(
                                                              onTap: () {
                                                                final file =
                                                                files[index];
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (context) =>
                                                                        GestureDetector(
                                                                            onTap: () =>
                                                                                Navigator.pop(
                                                                                    context),
                                                                            child: Container(
                                                                              alignment:
                                                                              Alignment.center,
                                                                              color:
                                                                              Colors.transparent,
                                                                              height: 400,
                                                                              width: 300,
                                                                              child: AlertDialog(
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                        15.0),
                                                                                    side: BorderSide
                                                                                        .none),
                                                                                scrollable: true,
                                                                                content:
                                                                                Container(height:240,width:320,
                                                                                  child: ClipRRect(borderRadius: BorderRadius.circular(20),
                                                                                    child: CachedNetworkImage(
                                                                                      errorWidget:
                                                                                          (context, url,
                                                                                          error) =>
                                                                                          Icon(Icons
                                                                                              .error),
                                                                                      imageUrl: file.url,
                                                                                      fit: BoxFit.fill,
                                                                                      placeholder: (context,
                                                                                          url) =>
                                                                                          Center(child: CircularProgressIndicator()),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )));
                                                              },
                                                              child: Image.network(
                                                                  files[index].url),
                                                            ));
                                                    }
                                                ),
                                              ),
                                            );
                                          }
                                      }
                                    } catch (e) {
                                      print("jjkkjkjkkkkjkjjjjjjjjkkk${e}");

                                      Fluttertoast.showToast(msg: e.toString());
                                      return Center(
                                          child: Text(
                                            'Some error occurred!',
                                            textScaleFactor:
                                            min(horizontalScale, verticalScale),
                                          ));
                                    }
                                  },
                                ),
                                FutureBuilder<List<FirebaseFile>>(
                                  future: futurefilesSocialMediaReviews,
                                  builder: (context, snapshot) {
                                    try {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return Center(
                                              child: CircularProgressIndicator());
                                        default:
                                          if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                  'Some error occurred!',
                                                  textScaleFactor: min(
                                                      horizontalScale, verticalScale),
                                                ));
                                          } else {
                                            final files = snapshot.data!;
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: screenHeight / 2.3,
                                                width: screenWidth/3.5,
                                                child: CarouselSlider.builder(
                                                    options: CarouselOptions(
                                                      autoPlay: true,
                                                      enableInfiniteScroll: true,
                                                      enlargeCenterPage: false,
                                                      viewportFraction: 1,
                                                      aspectRatio: 2.0,
                                                      initialPage: 7,
                                                      autoPlayCurve: Curves.fastOutSlowIn,
                                                      autoPlayAnimationDuration: Duration(
                                                          milliseconds: 3000),
                                                    ),
                                                    itemCount: files.length,
                                                    itemBuilder: (BuildContext context, int index, int pageNo) {
                                                      return
                                                        ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                            child: InkWell(
                                                              onTap: () {
                                                                final file =
                                                                files[index];
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (context) =>
                                                                        GestureDetector(
                                                                            onTap: () =>
                                                                                Navigator.pop(
                                                                                    context),
                                                                            child: Container(
                                                                              alignment:
                                                                              Alignment.center,
                                                                              color:
                                                                              Colors.transparent,
                                                                              height: 400,
                                                                              width: 300,
                                                                              child: AlertDialog(
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                        15.0),
                                                                                    side: BorderSide
                                                                                        .none),
                                                                                scrollable: true,
                                                                                content:
                                                                                Container(height:240,width:320,
                                                                                  child: ClipRRect(borderRadius: BorderRadius.circular(20),
                                                                                    child: CachedNetworkImage(
                                                                                      errorWidget:
                                                                                          (context, url,
                                                                                          error) =>
                                                                                          Icon(Icons
                                                                                              .error),
                                                                                      imageUrl: file.url,
                                                                                      fit: BoxFit.fill,
                                                                                      placeholder: (context,
                                                                                          url) =>
                                                                                          Center(child: CircularProgressIndicator()),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )));
                                                              },
                                                              child: Image.network(
                                                                  files[index].url),
                                                            ));
                                                    }
                                                ),
                                              ),
                                            );
                                          }
                                      }
                                    } catch (e) {
                                      print("jjkkjkjkkkkjkjjjjjjjjkkk${e}");

                                      Fluttertoast.showToast(msg: e.toString());
                                      return Center(
                                          child: Text(
                                            'Some error occurred!',
                                            textScaleFactor:
                                            min(horizontalScale, verticalScale),
                                          ));
                                    }
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: screenHeight / 1.25,
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FfeatureBG.png?alt=media&token=f350c99d-a928-48b6-9eff-983ad8797de9',
                              fit: BoxFit.fill,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "Feature Courses",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 75, bottom: 50),
                              height: screenHeight / 2,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: course.length,
                                  itemBuilder:
                                      (BuildContext context, index) {
                                    if (course[index].courseName ==
                                        "null") {
                                      return Container();
                                    }
                                    if (course[index].show == true)
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          courseId = course[index]
                                              .courseDocumentId;
                                        });
                                        print(courseId);
                                        if (course[index].isItComboCourse) {

                                          final id = index.toString();
                                          final courseName = course[index].courseName;
                                          final courseP = course[index].coursePrice;
                                          GoRouter.of(context).pushNamed('comboStore', queryParams: {'courseName': courseName, 'id': id, 'coursePrice': courseP});

                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         ComboStore(
                                          //           courses:
                                          //           course[index].courses,
                                          //         ),
                                          //   ),
                                          // );

                                        } else {
                                          final id = index.toString();
                                          GoRouter.of(context).pushNamed('catalogue', queryParams: {'id': id});
                                        }
                                      },
                                      child: course[index].isItComboCourse
                                          ? Padding(
                                        padding: const EdgeInsets.all(
                                            10.0),
                                        child: Container(
                                          height: screenHeight / 2.25,
                                          width: screenWidth / 5,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            // boxShadow: [
                                            //   BoxShadow(
                                            //     color: Colors.black26,
                                            //     offset: Offset(0, 2),
                                            //     blurRadius: 40,
                                            //   ),
                                            // ],
                                            borderRadius:
                                            BorderRadius.circular(
                                                15),
                                            border: Border.all(
                                                width: 0.5,
                                                color: HexColor(
                                                    "440F87")),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                            children: [
                                              Container(
                                                width:
                                                screenWidth / 5,
                                                height: screenHeight / 5.5,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius
                                                          .circular(
                                                          15),
                                                      topRight: Radius
                                                          .circular(
                                                          15)),
                                                  child:
                                                  Image.network(
                                                    course[index]
                                                        .courseImageUrl,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0, right: 5),
                                                child: Container(
                                                  height: screenHeight /
                                                      5.5,
                                                  padding: EdgeInsets.only(left: 5),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 5,),
                                                      Align(
                                                        alignment:
                                                        Alignment
                                                            .topLeft,
                                                        child:
                                                        Text(
                                                          course[index].courseName,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontFamily: 'Medium',
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                              overflow: TextOverflow.ellipsis,
                                                              height: 1),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: verticalScale * 5,
                                                      ),
                                                      Align(
                                                        alignment:
                                                        Alignment
                                                            .topLeft,
                                                        child:
                                                        Text(
                                                          "- ${course[index].numOfVideos} Videos",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: Colors.black,
                                                              fontSize: 10),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                        Alignment
                                                            .topLeft,
                                                        child:
                                                        Text(
                                                          "- Lifetime Access",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: Colors.black,
                                                              fontSize: 10),
                                                        ),
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 5.0),
                                                            child: Container(
                                                              height: 20,
                                                              width: 25,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(5.0),
                                                                color: HexColor('440F87'),
                                                              ),
                                                              child: Center(
                                                                child: Text( course[index].reviews.isNotEmpty ? course[index].reviews : '5.0',
                                                                  style: TextStyle(fontSize: 12, color: Colors.white,
                                                                      fontWeight: FontWeight.normal),),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(right: 5.0),
                                                            child: StarRating(
                                                              length: 5,
                                                              rating: course[index].reviews.isNotEmpty ? double.parse(course[index].reviews) : 5.0,
                                                              color: HexColor('440F87'),
                                                              starSize: 20,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment:MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 10.0, left: 10),
                                                        child: ElevatedButton(
                                                            onPressed:
                                                                () {},
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                              backgroundColor:
                                                              HexColor("8346E1"),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius.circular(5)),
                                                            ),
                                                            child:
                                                            Text(
                                                              "₹${course[index].coursePrice}/-",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                          : Container(),
                                    );
                                    return Container();
                                  }),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   height: screenHeight / 20,
                      //   width: screenWidth,
                      // ),
                      // Container(
                      //   width: screenWidth,
                      //   height: screenHeight / 3,
                      //   color: Colors.white,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Container(
                      //         width: screenWidth / 2.4,
                      //         height: screenHeight / 5.5,
                      //         decoration: BoxDecoration(
                      //             color: HexColor("FFF4CB"),
                      //             border: Border.all(
                      //               color: HexColor('BE9400'),
                      //               width: 1,
                      //             ),
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Row(
                      //           children: [
                      //             Padding(
                      //               padding: const EdgeInsets.only(
                      //                   top: 10, bottom: 10, left: 20, right: 20),
                      //               child: Image.network(
                      //                 "https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FdownloadLogo.png?alt=media&token=031e6f59-cbc4-4c6a-a735-db14da7ec1fd",
                      //                 fit: BoxFit.fill,
                      //               ),
                      //             ),
                      //             Padding(
                      //               padding:
                      //                   const EdgeInsets.only(top: 10.0, right: 20),
                      //               child: Column(
                      //                 crossAxisAlignment: CrossAxisAlignment.start,
                      //                 children: [
                      //                   Text(
                      //                     'Download The App Now!',
                      //                     style: TextStyle(
                      //                         color: HexColor("C19700"),
                      //                         fontFamily: 'Poppins',
                      //                         fontWeight: FontWeight.bold,
                      //                         fontSize: 16),
                      //                   ),
                      //                   SizedBox(height: 8,),
                      //                   Text(
                      //                     'Learn new skill anywhere any time',
                      //                     style: TextStyle(
                      //                         color: HexColor("231F20"),
                      //                         fontFamily: 'Poppins',
                      //                         fontSize: 12),
                      //                   ),
                      //                   SizedBox(height: 10,),
                      //                   Row(
                      //                     children: [
                      //                       Container(
                      //                         child: Image.network(
                      //                           "https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FplaystoreIcon.png?alt=media&token=526c9fc9-0ec4-4b89-b991-cb42e272a1bd",
                      //                           fit: BoxFit.fill,
                      //                         ),
                      //                       ),
                      //                       SizedBox(width: 5,),
                      //                       Container(
                      //                         child: Image.network(
                      //                           "https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FappStoreLogo.png?alt=media&token=bc836ab8-451e-402b-9c48-cb16d02e9861",
                      //                           fit: BoxFit.fill,
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         width: 20,
                      //       ),
                      //       Container(
                      //         width: screenWidth / 2.4,
                      //         height: screenHeight / 5.5,
                      //         decoration: BoxDecoration(
                      //             color: HexColor("CBE9FF"),
                      //             border: Border.all(
                      //               color: HexColor('007EDA'),
                      //               width: 1,
                      //             ),
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Row(
                      //           children: [
                      //             Padding(
                      //               padding: const EdgeInsets.only(
                      //                   top: 10, bottom: 10, left: 20, right: 20),
                      //               child: Image.network(
                      //                 "https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2Freward.png?alt=media&token=4266fe1f-8875-4c52-8e83-42e65a08fb4c",
                      //                 fit: BoxFit.fill,
                      //               ),
                      //             ),
                      //             Padding(
                      //               padding:
                      //               const EdgeInsets.only(top: 10.0, right: 20),
                      //               child: Column(
                      //                 crossAxisAlignment: CrossAxisAlignment.start,
                      //                 children: [
                      //                   Text(
                      //                     'Learn, Sell & Earn',
                      //                     style: TextStyle(
                      //                         color: HexColor("007EDA"),
                      //                         fontFamily: 'Poppins',
                      //                         fontWeight: FontWeight.bold,
                      //                         fontSize: 16),
                      //                   ),
                      //                   SizedBox(height: 8,),
                      //                   Text(
                      //                     'Join our affiliate program and grow with us',
                      //                     style: TextStyle(
                      //                         color: HexColor("231F20"),
                      //                         fontFamily: 'Poppins',
                      //                         fontSize: 10),
                      //                   ),
                      //                   SizedBox(height: 10,),
                      //                   Container(
                      //                     decoration: BoxDecoration(
                      //                       border: Border.all(
                      //                         width: 1.5,
                      //                       ),
                      //                       borderRadius: BorderRadius.circular(25),
                      //                     ),
                      //                     child: ElevatedButton(
                      //                         onPressed: () {},
                      //                         style: ElevatedButton.styleFrom(
                      //                           backgroundColor: HexColor('CBE9FF'),
                      //                           shape: RoundedRectangleBorder(
                      //                             borderRadius: BorderRadius.circular(25),
                      //                           )
                      //                         ),
                      //                         child: Text("Explore More",
                      //                           style:  TextStyle(
                      //                             fontSize: 12,
                      //                       color: HexColor("2C2C2C"),
                      //                     ),)),
                      //                   )
                      //                 ],
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                );
              } catch (e) {
                print(e.toString());
                print("sdjffsifsihsiodf${e}ifsiojfdiiiiiiiiiiiiiiiiiiii$e");
                return Text("Some error $e");
              }
            } else {
              return Container();
            }
          }),
    );
  }
}
