import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../Services/code_generator.dart';
import '../Services/deeplink_service.dart';
import '../catalogue_screen.dart';
import '../combo/combo_course.dart';
import '../combo/combo_store.dart';
import '../models/referal_model.dart';
import '../module/pdf_course.dart';
import '../module/video_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/api/firebase_api.dart';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:cloudyml_app2/router/login_state_check.dart';
import 'package:cloudyml_app2/screens/exlusive_offer/seasons_offer_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloudyml_app2/fun.dart';
import 'package:cloudyml_app2/models/firebase_file.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
import 'package:showcaseview/src/showcase.dart';
import 'package:cloudyml_app2/global_variable.dart' as globals;
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
var rewardCount = 0;
String? linkMessage;

class LandingScreen extends StatefulWidget {

  const LandingScreen({Key? key}) : super(key: key);


  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

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
      // print(map['payInPartsDetails'][id]['outStandingAmtPaid']);
      setState(() {
        userMap = userDocs.data() as Map<String, dynamic>;
        // whetherSubScribedToPayInParts =
        //     !(!(map['payInPartsDetails']['outStandingAmtPaid'] == null));
      });
    } catch (e) {
      print("ggggggggggg $e");
    }
  }

  late ScrollController _controller;
  final notificationBox = Hive.box('NotificationBox');

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


  List<CourseDetails> featuredCourse = [];

  setFeaturedCourse(List<CourseDetails> course){
    featuredCourse.clear();
    course.forEach((element) {
      if(element.FcSerialNumber.isNotEmpty && element.FcSerialNumber != null &&
          element.isItComboCourse == true){
        featuredCourse.add(element);
      }
    });
    featuredCourse.sort((a, b) {
      return int.parse(a.FcSerialNumber).compareTo(int.parse(b.FcSerialNumber));}
    );
  }



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
            .get().then((value) {
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
                  print(getData![
                  value.docs.first.data()["id"].toString() + "percentage"]
                      .toString());
                  coursePercent[courseId] = getData[
                  value.docs.first.data()["id"].toString() +
                      "percentage"] !=
                      null
                      ? getData[
                  value.docs.first.data()["id"].toString() + "percentage"]
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

  bool isShow=false;

  _wpshow() async{

    await FirebaseFirestore.instance
        .collection('Notice')
        .doc('rLwaS5rDufmCQ7Gv5vMI')
        .get().then((value) {
      setState(() {
        isShow= value.data()!['show'];
      });

      print("show is===$isShow");

    });

  }

  _launchWhatsapp() async {


    var note = await FirebaseFirestore.instance
        .collection('Notice')
        .doc('rLwaS5rDufmCQ7Gv5vMI')
        .get().then((value) {
      return value.data()!['msg']; // Access your after your get the data
    });

    print("the msg is====$note");
    print("the show is====$isShow");

    var whatsApp1=await FirebaseFirestore.instance
        .collection('Notice')
        .doc('rLwaS5rDufmCQ7Gv5vMI')
        .get().then((value) {
      return value.data()!['number']; // Access your after your get the data
    });

    print("the number is====$whatsApp1");

    var whatsapp = "+918902530551";
    var whatsappAndroid =Uri.parse("whatsapp://send?phone=$whatsApp1&text=$note");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }






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
      } else {

      }
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
        globals.role = value.data()!["role"];
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


  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void loadCourses(String fID) async {
    await _firestore.collection("courses").doc(fID).get().then((value) {
      print(_auth.currentUser!.displayName);
      Map<String, dynamic> groupData = {
        "name": value.data()!['name'],
        "icon": value.data()!["image_url"],
        "mentors": value.data()!["mentors"],
        "student_id": _auth.currentUser!.uid,
        "student_name": _auth.currentUser!.displayName,
        'groupChatCountNew': {
          'jbG4j36JiihVuZmpoLov2lhrWF02': 0,
          'QVtxxzHyc6az2LPpvH210lUOeXl1': 0,
          "2AS3AK7WVQaAMY999D3xf5ycG3h1": 0,
          'a2WWgtY2ikS8xjCxra0GEfRft5N2': 0,
          'BX9662ZGi4MfO4C9CvJm4u2JFo63': 0,
          '6RsvdRETWmXf1pyVGqCUl0qEDmF2': 0,
          'jeYDhaZCRWW4EC9qZ0YTHKz4PH63': 0,
          'I6uXWtzpimTYxtGqEXcM9AXcoAi2': 0,
          'Kr4pX5EZ6CfigOd5C1xjdIYzMml2': 0,
          'XhcpQzd6cjXF43gCmna1agAfS2A2': 0,
          'fKHHbDBbbySVJZu2NMAVVIYZZpu2': 0,
          'oQQ9CrJ8FkP06OoGdrtcwSwY89q1': 0,
          'rR0oKFMCaOYIlblKzrjYoYMW3Vl1': 0,
          'v66PnlwqWERgcCDA6ZZLbI0mHPF2': 0,
          'TOV5h3ezQhWGTb5cCVvBPca1Iqh1': 0,
          [_auth.currentUser!.uid]: 0
        },
      };
      _firestore.collection("groups").add(groupData);
    });
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

  bool isAnnounceMent = false;
  String announcementMsg = '';
  void getAnnouncement()async{
    await FirebaseFirestore.instance.collection('Notice').get().then((value){
      setState(() {
        announcementMsg = value.docs[2].get('Message');
        isAnnounceMent = value.docs[2].get('show');
      });

    });


  }

  @override
  void initState() {
    // print('this is url ${html.window.location.href}');
    // print('this is path ${Uri.base.path}');
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
    startTimer();
    // getuserdetails();
    checkrewardexpiry();
  }


  Timer? countDownTimer;
  Duration myDuration = Duration(days: 5);


  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    final days = strDigits(myDuration.inDays);
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final providerNotification =
    Provider.of<UserProvider>(context, listen: false);
    List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    setFeaturedCourse(course);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      // drawer: customDrawer(context),
      // floatingActionButton: floatingButton(context),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth >= 650) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: screenWidth,
                          height: screenHeight * 2.5,
                          color: HexColor('F3EBFF'),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: screenWidth,
                            height: screenHeight * 1.2,
                            child: Image.network('https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FGroup%20Lines.png?alt=media&token=19ebd446-f667-492b-96ba-c28c5054718f',
                                fit: BoxFit.fill,
                                height: screenHeight,
                                width: screenWidth),
                          ),
                        ),
                        Container(
                          width: screenWidth,
                          height: screenHeight,
                          child: Image.network('https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FGroup%20282.png?alt=media&token=44e47519-54fd-429c-a23d-261ceebb70d7',
                              fit: BoxFit.fill,
                              height: screenHeight,
                              width: screenWidth),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 5),
                          child: customMenuBar(context),
                        ),
                        Positioned(
                          top: verticalScale * 450,
                          left: 50,
                          child: Row(
                              children: [
                                Stack(
                                  children: [
                                    Positioned.fill(
                                        child: Container(
                                          margin: EdgeInsets.all(6),
                                          color: Colors.white,
                                        )
                                    ),
                                    Icon(Icons.check_circle, color: Colors.deepPurpleAccent, size: 25,),
                                  ],
                                ),
                                SizedBox(width: 5,),
                                Text('Trusted by $numberOfLearners', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white)),
                                SizedBox(width: 15 * horizontalScale,),
                                Stack(
                                  children: [
                                    Positioned.fill(
                                        child: Container(
                                          margin: EdgeInsets.all(6),
                                          color: Colors.white,
                                        )
                                    ),
                                    Icon(Icons.check_circle,
                                      color: Colors.deepPurpleAccent, size: 25,),
                                  ],
                                ),
                                SizedBox(width: 5,),
                                Text('Learn from industry experts', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white) ,),
                              ],
                          ),
                        ),
                        Positioned(
                            top: verticalScale * 540,
                            left: 50,
                            child: SizedBox(
                              height: 75 * verticalScale,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor('8346E1'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12), // <-- Radius
                                  ),
                                ),
                                onPressed: () {
                                  GoRouter.of(context).pushNamed('store');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('View Courses', style: TextStyle(fontSize: 16),),
                                      SizedBox(width: 5 * horizontalScale,),
                                      CircleAvatar(
                                        maxRadius: 12,
                                        backgroundColor: Colors.white,
                                          child: Center(
                                            child: Icon(
                                              Icons.arrow_forward_rounded,
                                              color: Colors.black,
                                            size: 17,),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        Positioned(
                            top: verticalScale * 700,
                            left: 50,
                            child: Container(
                              width: screenWidth * 0.9,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('My Enrolled Courses',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 36 * verticalScale),),
                                  InkWell(
                                    onTap: () {
                                      GoRouter.of(context).pushReplacementNamed('myCourses');
                                    },
                                    child: Row(
                                      children: [
                                        Text('See all', style: TextStyle(color: HexColor('2369F0'),
                                            fontWeight: FontWeight.bold, fontSize: 24 * verticalScale),),
                                        Icon(Icons.arrow_forward_rounded, color: HexColor('2369F0'), size: 30 * verticalScale,)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Positioned(
                          top: verticalScale * 785,
                            child: courses.length > 0
                                ? Stack(
                                  children: [
                                    Container(
                              width: screenWidth,
                              height: screenHeight/4.5,
                              child: Center(
                                child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: 2,
                                      itemBuilder: (BuildContext context, int index) {
                                        if (course[index].courseName ==
                                            "null") {
                                          return Container();
                                        }
                                        if (courses.contains(
                                            course[index].courseId)) {
                                          return Padding(
                                            padding: const EdgeInsets.only(left: 15.0, right: 15),
                                            child: Row(
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
                                                              'courseName': course[index].courseName,
                                                              'cID': course[index].courseDocumentId,
                                                            });

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
                                                                'courseName': course[index].courseName,
                                                                'cID': course[index].courseDocumentId,
                                                              });
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

                                                        GoRouter.of(context).pushNamed('NewScreen', queryParams:
                                                        {'id': id, 'courseName': courseName});
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
                                                    width: screenWidth / 2.5,
                                                    height: screenHeight/ 4.8,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black26,
                                                            offset: Offset(
                                                              2, // Move to right 10  horizontally
                                                              2.0, // Move to bottom 10 Vertically
                                                            ),
                                                            blurRadius: 40)
                                                      ],
                                                      // border: Border.all(
                                                      //   color: HexColor('440F87'),
                                                      //   width: 1.5,
                                                      // ),
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 5.0, left: 10),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 50 * horizontalScale,
                                                                height: 200 * verticalScale,
                                                                decoration:
                                                                BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors.transparent),
                                                                    borderRadius:
                                                                    BorderRadius.circular(10),
                                                                    image: DecorationImage(
                                                                        image: CachedNetworkImageProvider(
                                                                          course[index].courseImageUrl,
                                                                        ),
                                                                        fit: BoxFit.fill)),
                                                              ),
                                                              SizedBox(
                                                                width: 5 * horizontalScale,
                                                              ),
                                                              Container(
                                                                width: screenWidth/4.8,
                                                                // height: screenHeight / 5.5,
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
                                                                            height: 0.90,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            color: HexColor('2C2C2C'),
                                                                            fontFamily: 'SemiBold',
                                                                            fontSize: 18 * verticalScale,
                                                                            fontWeight: FontWeight.bold,),
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 5 * verticalScale,),
                                                                      Align(
                                                                        alignment: Alignment.topLeft,
                                                                        child: Text(
                                                                          course[index].courseDescription,
                                                                          maxLines: 2,
                                                                          style: TextStyle(
                                                                            overflow: TextOverflow.ellipsis,
                                                                            color: Colors.black,
                                                                            fontFamily: 'Medium',
                                                                            fontSize: 12 * verticalScale,
                                                                            fontWeight: FontWeight.normal,),
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 5 * verticalScale,),
                                                                      // Row(
                                                                      //   mainAxisAlignment: MainAxisAlignment.start,
                                                                      //   children: [
                                                                      //     Padding(
                                                                      //       padding: const EdgeInsets.only(right: 5.0),
                                                                      //       child: Container(
                                                                      //         height: 20,
                                                                      //         width: 25,
                                                                      //         decoration: BoxDecoration(
                                                                      //           borderRadius: BorderRadius.circular(5.0),
                                                                      //           color: HexColor('440F87'),
                                                                      //         ),
                                                                      //         child: Center(
                                                                      //           child: Text(course[index].reviews.isNotEmpty ? course[index].reviews : '5.0',
                                                                      //             style: TextStyle(fontSize: 12, color: Colors.white,
                                                                      //                 fontWeight: FontWeight.normal),),
                                                                      //         ),
                                                                      //       ),
                                                                      //     ),
                                                                      //     Padding(
                                                                      //       padding:
                                                                      //       const EdgeInsets.only(right: 5.0),
                                                                      //       child: StarRating(
                                                                      //         length: 5,
                                                                      //         rating: course[index].reviews.isNotEmpty ? double.parse(course[index].reviews) : 5.0,
                                                                      //         color: HexColor('440F87'),
                                                                      //         starSize: 20,
                                                                      //         mainAxisAlignment: MainAxisAlignment.start,
                                                                      //       ),
                                                                      //     ),
                                                                      //   ],
                                                                      // ),
                                                                      if (courses.length != 0 && coursePercent != {}) Container(

                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "English || ${course[index].numOfVideos} Videos",
                                                                                  style: TextStyle(
                                                                                      color: HexColor("2C2C2C"),
                                                                                      fontFamily: 'Medium',
                                                                                      fontSize: 14 * verticalScale,
                                                                                      fontWeight: FontWeight.w400,),
                                                                                ),
                                                                                SizedBox(height: 5 * verticalScale),
                                                                                Container(
                                                                                  width: 50 * horizontalScale,
                                                                                  height: 40 * verticalScale,
                                                                                  child: ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      backgroundColor: HexColor('8346E1'),
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                      ),
                                                                                      padding: EdgeInsets.all(0)
                                                                                    ),
                                                                                      onPressed: (() async {
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
                                                                                                  'courseName': course[index].courseName,
                                                                                                  'cID': course[index].courseDocumentId,
                                                                                                });

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
                                                                                                    'courseName': course[index].courseName,
                                                                                                    'cID': course[index].courseDocumentId,
                                                                                                  });
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

                                                                                            GoRouter.of(context).pushNamed('NewScreen', queryParams:
                                                                                            {'id': id, 'courseName': courseName});
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
                                                                                      child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            Icon(Icons.play_arrow_rounded, size: 25 * verticalScale,),
                                                                                            FittedBox(
                                                                                              fit: BoxFit.fitWidth,
                                                                                                child: Text('Resume Learning',
                                                                                                  style: TextStyle(fontSize: 14 * verticalScale),)),
                                                                                          ],
                                                                                      )),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            CircularPercentIndicator(
                                                                                radius: 20,
                                                                                circularStrokeCap: CircularStrokeCap.round,
                                                                                percent: coursePercent[course[index].courseId.toString()]!=null?coursePercent[course[index].courseId] / 100 :0 / 100,
                                                                                progressColor: HexColor("31D198"),
                                                                                lineWidth: 4,
                                                                                center: Text("${coursePercent[course[index].courseId.toString()]!=null?coursePercent[course[index].courseId]:0}%",
                                                                                              style: TextStyle(fontSize: 8),),
                                                                                  // footer: FittedBox(
                                                                                  // fit: BoxFit.fitWidth,
                                                                                  // child: Text('Progress', style: TextStyle(fontSize: 12 * verticalScale),)),
                                                                            ),


                                                                          ],
                                                                        ),
                                                                      ) else SizedBox(),
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
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                ),
                              ),),
                                  ],
                                )
                                : Container(
                                   width: screenWidth,
                                    height: screenHeight / 4.5,
                                  child: Center(
                                    child: Container(
                              width: screenWidth/2,
                              height: screenHeight / 5.5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(
                                                2, // Move to right 10  horizontally
                                                2.0, // Move to bottom 10 Vertically
                                              ),
                                              blurRadius: 40)
                                        ],
                                        // border: Border.all(
                                        //   color: HexColor('440F87'),
                                        //   width: 1.5,
                                        // ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                              child: Center(
                                      child: Text('There are zero courses. Please enroll',)),
                            ),
                                  ),
                                )),
                        Positioned(
                            bottom: verticalScale * 1150,
                            left: 50,
                            child: Container(
                              width: screenWidth * 0.9,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Reviews',
                                    style: TextStyle(
                                        color: HexColor('231F20'),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 36 * verticalScale),),
                                  Row(
                                    children: [
                                      Text('See all', style: TextStyle(color: HexColor('2369F0'),
                                          fontWeight: FontWeight.bold, fontSize: 24 * verticalScale),),
                                      Icon(Icons.arrow_forward_rounded, color: HexColor('2369F0'), size: 30 * verticalScale,)
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    Container(
                      height: screenHeight,
                      width: screenWidth,
                      color: HexColor('130329'),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: Text('Most Popular Courses',
                              style: TextStyle(
                              fontSize: 42 * verticalScale,
                              color: Colors.white,
                              fontFamily: 'SemiBold',
                              fontWeight: FontWeight.bold
                            ),),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 75, bottom: 50),
                            height: screenHeight / 2,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder:
                                    (BuildContext context, index) {
                                  if (featuredCourse[index].courseName ==
                                      "null") {
                                    return Container();
                                  }
                                  // if (course[index].isItComboCourse == true)

                                  return InkWell(
                                      onTap: () {
                                        setState(() {
                                          courseId = featuredCourse[index]
                                              .courseDocumentId;
                                        });
                                        print(courseId);
                                        if (featuredCourse[index].isItComboCourse) {

                                          print(featuredCourse[index].courses);


                                          final id = index.toString();
                                          final cID = featuredCourse[index].courseDocumentId;
                                          final courseName = featuredCourse[index].courseName;
                                          final courseP = featuredCourse[index].coursePrice;
                                          GoRouter.of(context).pushNamed(
                                              'featuredCourses',
                                              queryParams: {
                                                'cID': cID,
                                                'courseName': courseName,
                                                'id': id,
                                                'coursePrice': courseP});

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
                                      child:  Padding(
                                        padding: const EdgeInsets.all(
                                            10.0),
                                        child: Container(
                                          height: screenHeight / 2,
                                          width: screenWidth / 4.5,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            // boxShadow: [
                                            //   BoxShadow(
                                            //     color: Colors.black26,
                                            //     offset: Offset(0, 2),
                                            //     blurRadius: 40,
                                            //   ),
                                            // ],
                                            borderRadius: BorderRadius.circular(20),
                                            // border: Border.all(
                                            //     width: 0.5,
                                            //     color: HexColor("440F87"),
                                            // ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                            children: [
                                              Container(
                                                // width: screenWidth / 5,
                                                height: screenHeight / 4,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                          15),
                                                      topRight: Radius
                                                          .circular(
                                                          15)),
                                                  child:
                                                  Image.network(
                                                    featuredCourse[index].courseImageUrl,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 100 * verticalScale,
                                                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                child: Center(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(right: 5.0),
                                                            child: StarRating(
                                                              length: 1,
                                                              rating: featuredCourse[index].reviews.isNotEmpty ? double.parse(featuredCourse[index].reviews) : 5.0,
                                                              color: HexColor('31D198'),
                                                              starSize: 20,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 5.0),
                                                            child: Container(
                                                              height: 20,
                                                              width: 25,
                                                              child: Center(
                                                                child: Text( featuredCourse[index].reviews.isNotEmpty ? featuredCourse[index].reviews : '5.0',
                                                                  style: TextStyle(fontSize: 12, color: HexColor('585858'),
                                                                      fontWeight: FontWeight.normal),),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Text(featuredCourse[index].courseName,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            color: HexColor('2C2C2C'),
                                                            fontFamily: 'Medium',
                                                            fontSize: 20 * verticalScale,
                                                            height: 1,
                                                            fontWeight: FontWeight.bold,
                                                            overflow: TextOverflow.ellipsis,),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 45 * verticalScale,
                                                width: 80 * horizontalScale,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment:MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        ElevatedButton(
                                                            onPressed: () {

                                                              setState(() {
                                                                courseId = featuredCourse[index]
                                                                    .courseDocumentId;
                                                              });
                                                              print(courseId);
                                                              if (featuredCourse[index].isItComboCourse) {
                                                                final id = index.toString();
                                                                final courseName = featuredCourse[index].courseName;
                                                                final courseP = featuredCourse[index].coursePrice;
                                                                GoRouter.of(context).pushNamed('comboStore',
                                                                    queryParams: {
                                                                      'courseName': courseName,
                                                                      'id': id,
                                                                      'coursePrice': courseP,
                                                                      'courses': featuredCourse[index].courses});

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
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                              backgroundColor: HexColor("8346E1"),
                                                              padding: EdgeInsets.only(right: 15, left: 15),
                                                              shape: RoundedRectangleBorder(
                                                                side: BorderSide(color: Colors.black, width: 1),
                                                                  borderRadius: BorderRadius.circular(15)),
                                                            ),
                                                            child: Text(
                                                              "Learn More",
                                                              style: TextStyle(
                                                                  fontSize: 18 * verticalScale,
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold),
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                  );
                                  return Container();
                                }),
                          ),
                          Container(
                            width: 60 * horizontalScale,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white, width: 1)
                            ),
                            child: TextButton(
                                onPressed: () {

                                },
                                child: Text('View All',
                                  style: TextStyle(
                                      fontSize: 26 * verticalScale,
                                      color: Colors.white,
                                      fontFamily: 'SemiBold',
                                      fontWeight: FontWeight.bold
                                  ),)),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              );

            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.red
                      ),
                      width: screenWidth,
                      height: 25 * verticalScale,
                    ),
                    Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(
                                0,
                                0,
                                0,
                                0.35,
                              ),
                              offset: Offset(5, 5),
                              blurRadius: 52)
                        ],
                      ),
                      child: Stack(
                        children: [

                          Container(
                            width: 414 * horizontalScale,
                            height: 280 * verticalScale,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Image.network( 'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2Fh1.png?alt=media&token=e51a6697-9b1d-467b-8443-b4251181830e',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Positioned(
                            right: 5,
                            child: IconButton(onPressed: () {
                              logOut(context);
                              saveLoginOutState(context);
                            },
                                icon: Icon(Icons.logout_rounded)),
                          ),
                          Positioned(
                            left: 5,
                            child: IconButton(
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                }, icon: Icon(Icons.menu)),
                          ),
                          Positioned(
                            top: 7,
                            left: 45,
                            child: Row(
                              children: [
                                // Image.asset(
                                //   "assets/logo2.png",
                                //   width: 25,
                                //   height: 20,
                                // ),
                                Text(
                                  "CloudyML",
                                  style: textStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 38,
                      width: screenWidth,
                      color: Colors.deepPurpleAccent[300],
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 4,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                                launch('https://apps.apple.com/app/cloudyml-data-science-course/id6444130328');
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.apple_outlined, color: Colors.white, size: 12,),
                                    Column(
                                      children: [
                                        Text('Download our IOS app from', style: TextStyle(color: Colors.white, fontSize: 4),),
                                        Text('APPLE STORE', style: TextStyle(color: Colors.white, fontSize: 6)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 50,),
                            InkWell(
                              onTap: (){
                                launch('https://play.google.com/store/apps/details?id=com.cloudyml.cloudymlapp');
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.play_arrow, color: Colors.black, size: 12,),
                                    Column(
                                      children: [
                                        Text('Download our Android app from', style: TextStyle(color: Colors.white, fontSize: 4),),
                                        Text('GOOGLE PLAY', style: TextStyle(color: Colors.white, fontSize: 6)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20 * horizontalScale,
                          top: 20 * verticalScale,
                          bottom: 5
                      ),
                      child: Text(
                        'What make us different?',
                        textScaleFactor: min(horizontalScale, verticalScale),
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Poppins',
                          fontSize: 23,
                          letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      height: 130,
                      width: width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/UII.png",)
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            // left: (width-150)/12,
                              left: width * 0.082,
                              top:20,
                              child: Container(
                                alignment: Alignment.center,
                                height:90,
                                // width: (width-150)/4.2,
                                width:width * 0.24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child:   Text("100% paid internship after combo course completion",
                                  style: TextStyle(fontSize: 8,fontFamily: 'Bold',),maxLines: 5,
                                  textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),

                              )
                          ),

                          Positioned(
                            // left: (width-150)/12,
                              left: width * 0.18,
                              top:6.8,
                              child: Container(
                                alignment: Alignment.center,
                                height: 15,
                                // width: (width-150)/4.2,
                                width:15,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: HexColor("#592CA4")
                                ),
                                child:   Text("1",
                                  style: TextStyle(fontSize: 8,fontFamily: 'Bold',color: Colors.white),maxLines: 5,
                                  textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                              )
                          ),
                          Positioned(
                            // left: (width-150)/12,
                              left: width * 0.38,
                              top:20,
                              child: Container(
                                alignment: Alignment.center,
                                height: 90,
                                // width: (width-150)/4.2,
                                width:width * 0.24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child:   Text("We provide \n hands on learning experience",
                                  style: TextStyle(fontSize: 8,fontFamily: 'Bold',),maxLines: 5,
                                  textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),

                              )
                          ),
                          Positioned(
                            // left: (width-150)/12,
                              left: width * 0.48,
                              top:6.8,
                              child: Container(
                                alignment: Alignment.center,
                                height: 15,
                                // width: (width-150)/4.2,
                                width:15,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: HexColor("#592CA4")
                                ),
                                child:   Text("2",
                                  style: TextStyle(fontSize: 8,fontFamily: 'Bold',color: Colors.white),maxLines: 5,
                                  textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),

                              )
                          ),
                          Positioned(
                            // left: (width-150)/12,
                              left: width * 0.68,
                              top:19,
                              // top:height* 0.018,
                              child: Container(
                                alignment: Alignment.center,
                                height: 90,
                                // width: (width-150)/4.2,
                                // height: height * 0.13,
                                width:width * 0.24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child:   Text("1-1 teaching assistants for doubt clearance",
                                  style: TextStyle(fontSize: 8,fontFamily: 'Bold',),maxLines: 5,
                                  textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),

                              )
                          ),

                          Positioned(
                            // left: (width-150)/12,
                              left: width * 0.79,
                              top:6.8,
                              child: Container(
                                alignment: Alignment.center,
                                height: 15,
                                // width: (width-150)/4.2,
                                width:15,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: HexColor("#592CA4")
                                ),
                                child:   Text("3",
                                  style: TextStyle(fontSize: 8,fontFamily: 'Bold',color: Colors.white),maxLines: 5,
                                  textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),

                              )
                          ),

                        ],
                      ),
                    ),

                    isAnnounceMent ?
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20 * horizontalScale,
                          right: 20 * horizontalScale,
                          bottom: 4
                        // top: 20 * verticalScale,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Announcements 📣',
                            textScaleFactor: min(horizontalScale, verticalScale),
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Poppins',
                              fontSize: 23,
                              letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            padding: EdgeInsets.only(
                              left: 10 * horizontalScale,
                              right: 10 * horizontalScale,
                              top:  15 * verticalScale,
                              bottom:  15 * verticalScale,

                              // top: 20 * verticalScale,
                            ),

                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.deepPurple.withOpacity(0.12)

                            ),
                            child: Center(
                              child: Text(announcementMsg,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )  : SizedBox(),

                    SizedBox(height: 10,),
                    courses.length > 0?Padding(
                      padding: EdgeInsets.only(
                          left: 20 * horizontalScale,
                          bottom: 4
                        // top: 20 * verticalScale,
                      ),
                      child: Text(
                        'My Courses',
                        textScaleFactor: min(horizontalScale, verticalScale),
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Poppins',
                          fontSize: 23,
                          letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ):SizedBox(),
                    courses.length>0?Container(
                      width: width,
                      height: 130,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                      margin: EdgeInsets.only(top: 2,bottom: 7,left: 10),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          // shrinkWrap: true,
                          itemCount: course.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (course[index].courseName == "null") {
                              return Container();
                            }
                            if (courses.contains(course[index].courseId)) {
                              return InkWell(
                                onTap: (() {
                                  // setModuleId(snapshot.data!.docs[index].id);
                                  getCourseName();
                                  if (navigateToCatalogueScreen(
                                      course[index].courseId) &&
                                      !(userMap['payInPartsDetails']
                                      [course[index].courseId]
                                      ['outStandingAmtPaid'])) {
                                    if (!course[index].isItComboCourse) {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          duration: Duration(milliseconds: 400),
                                          curve: Curves.bounceInOut,
                                          type:
                                          PageTransitionType.rightToLeftWithFade,
                                          child: VideoScreen(
                                            isDemo: true,
                                            courseName: course[index].courseName,
                                            sr: 1,
                                          ),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          duration: Duration(milliseconds: 100),
                                          curve: Curves.bounceInOut,
                                          type:
                                          PageTransitionType.rightToLeftWithFade,
                                          child: ComboStore(
                                            courses: course[index].courses,
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    if (!course[index].isItComboCourse) {
                                      if (course[index].courseContent == 'pdf') {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            duration: Duration(milliseconds: 400),
                                            curve: Curves.bounceInOut,
                                            type: PageTransitionType
                                                .rightToLeftWithFade,
                                            child: PdfCourseScreen(
                                              curriculum: course[index].curriculum
                                              as Map<String, dynamic>,
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            duration: Duration(milliseconds: 400),
                                            curve: Curves.bounceInOut,
                                            type: PageTransitionType
                                                .rightToLeftWithFade,
                                            child: VideoScreen(
                                              isDemo: true,
                                              courseName: course[index].courseName,
                                              sr: 1,
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      ComboCourse.comboId.value =
                                          course[index].courseId;
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          duration: Duration(milliseconds: 400),
                                          curve: Curves.bounceInOut,
                                          type:
                                          PageTransitionType.rightToLeftWithFade,
                                          child: ComboCourse(
                                            courses: course[index].courses,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                  setState(() {
                                    courseId = course[index].courseDocumentId;
                                  });
                                }),
                                child: Container(height: 150,width: 320,
                                    margin: EdgeInsets.only(right:10),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xFFE9E1FC)),
                                    child: Row(
                                      children: [
                                        Expanded(child:
                                        Container(width: 200,height: 150,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                          child:  Container(
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                              ),
                                              image: DecorationImage(
                                                  image: CachedNetworkImageProvider(
                                                    course[index].courseImageUrl,
                                                  ),
                                                  fit: BoxFit.fitHeight),
                                            ),
                                          ),
                                        ),flex: 1,),
                                        Expanded(child: Container(width: 200,height: 150,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  course[index].isItComboCourse
                                                      ? Row(
                                                    children: [
                                                      Container(
                                                        width: 70,
                                                        height: 37,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                          // gradient: gradient,
                                                          color: Color(0xFF7860DC),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'COMBO',
                                                            style: const TextStyle(
                                                              fontFamily: 'Bold',
                                                              fontSize: 10,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                      : Container(),
                                                  Container(
                                                    child: Text(
                                                      course[index].courseName,
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                            0,
                                                            0,
                                                            0,
                                                            1,
                                                          ),
                                                          fontFamily: 'Poppins',
                                                          fontSize: 13,
                                                          letterSpacing:
                                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                                          fontWeight: FontWeight.w500,
                                                          height: 1,overflow: TextOverflow.ellipsis),
                                                      // overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  course[index].isItComboCourse &&
                                                      statusOfPayInParts(
                                                          course[index].courseId)
                                                      ?  Container(
                                                    child:
                                                    !navigateToCatalogueScreen(
                                                        course[index]
                                                            .courseId)
                                                        ? Container(
                                                      height: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.08 *
                                                          verticalScale,
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                          10,
                                                        ),
                                                        color: Color(
                                                          0xFFC0AAF5,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                        children: [
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            'Access ends in days : ',
                                                            textScaleFactor: min(
                                                                horizontalScale,
                                                                verticalScale),
                                                            style:
                                                            TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize:
                                                              13,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.circular(10),
                                                              color: Colors
                                                                  .grey
                                                                  .shade100,
                                                            ),
                                                            width: 30 *
                                                                min(horizontalScale,
                                                                    verticalScale),
                                                            height: 30 *
                                                                min(horizontalScale,
                                                                    verticalScale),
                                                            // color:
                                                            //     Color(0xFFaefb2a),
                                                            child:
                                                            Center(
                                                              child:
                                                              Text(
                                                                '${(DateTime.parse(userMap['payInPartsDetails'][course[index].courseId]['endDateOfLimitedAccess']).difference(DateTime.now()).inDays)}',
                                                                textScaleFactor: min(
                                                                    horizontalScale,
                                                                    verticalScale),
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold
                                                                  // fontSize: 16,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                        : Container(
                                                      height: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.08,
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            10),
                                                        color: Color(
                                                            0xFFC0AAF5),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'Limited access expired !',
                                                          textScaleFactor: min(
                                                              horizontalScale,
                                                              verticalScale),
                                                          style:
                                                          TextStyle(
                                                            color: Colors
                                                                .deepOrange[
                                                            600],
                                                            fontSize:
                                                            13,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ):SizedBox(),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          course[index].courseLanguage+"  ||",
                                                          style: TextStyle(
                                                              fontFamily: 'Medium',
                                                              color: Colors.black
                                                                  .withOpacity(0.4),
                                                              fontSize: 10,
                                                              fontWeight:
                                                              FontWeight.w500),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                      Container(
                                                        child: Center(
                                                          child: Text(
                                                            '${course[index].numOfVideos} videos',
                                                            style: TextStyle(
                                                                fontFamily: 'Medium',
                                                                color: Colors.black
                                                                    .withOpacity(0.7),
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ]
                                            )))
                                      ],
                                    )
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ):SizedBox(),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20 * horizontalScale,
                        // top: 20 * verticalScale,
                      ),
                      child: Text(
                        'Feature Courses',
                        textScaleFactor: min(horizontalScale, verticalScale),
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Poppins',
                          fontSize: 23,
                          letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth,
                      height: 190,
                      margin: EdgeInsets.only(top: 10,bottom: 5),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        removeBottom: true,
                        removeLeft: true,
                        removeRight: true,
                        child: ListView.builder(
                          // physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: featuredCourse.length,
                          itemBuilder: (BuildContext context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  courseId = featuredCourse[index]
                                      .courseDocumentId;
                                });
                                print(courseId);
                                if (featuredCourse[index].isItComboCourse) {

                                  print(featuredCourse[index].courses);


                                  final id = index.toString();
                                  final cID = featuredCourse[index].courseDocumentId;
                                  final courseName = featuredCourse[index].courseName;
                                  final courseP = featuredCourse[index].coursePrice;
                                  GoRouter.of(context).pushNamed(
                                      'featuredCourses',
                                      queryParams: {
                                        'cID': cID,
                                        'courseName': courseName,
                                        'id': id,
                                        'coursePrice': courseP});

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
                              child:
                              Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          HexColor("#2C004F"),
                                          HexColor("#8024C9")
                                        ]
                                    ),
                                    boxShadow: [
                                      BoxShadow(color: HexColor("#8024C9"),
                                        blurRadius: 1.5,offset: Offset(1,2) ,
                                        // spreadRadius: 0.3
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                margin: EdgeInsets.only(left: 15,top: 5,bottom: 5),
                                padding: EdgeInsets.only(left: 15,right: 5,top: 15,bottom: 15),
                                width: 300,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text("${featuredCourse[index].courseName}",
                                            style: TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontFamily: 'Bold'),
                                            maxLines: 1),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          child:
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              RatingBarIndicator(
                                                                rating: 5.0,
                                                                itemBuilder: (context, index) => Icon(
                                                                  Icons.star,
                                                                  color: HexColor("#31D198"),
                                                                ),
                                                                itemCount: 5,
                                                                itemSize: 15.0,
                                                                direction: Axis.horizontal,
                                                                unratedColor: Colors.purple,
                                                              ),
                                                              SizedBox(width: 10,),
                                                              Text("5.0",style: TextStyle(color: Colors.white,fontSize: 13),)
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(child:   Text("English  ||  ${featuredCourse[index].numOfVideos} Videos",style: TextStyle(fontSize: 13,color: Colors.white),)
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 8,),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                          child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child: RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                    // TextSpan(text:"3599/-  ",style: TextStyle(color: Colors.white,fontSize: 16,overflow: TextOverflow.ellipsis),),
                                                                    TextSpan(text:"₹${featuredCourse[index].coursePrice}/-",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                                                                        fontFamily: 'Poppins',fontSize: 20,
                                                                        overflow: TextOverflow.ellipsis),)
                                                                  ]
                                                              ),
                                                            ),
                                                          )
                                                      ),
                                                      Expanded(
                                                        child: Align(
                                                          alignment: Alignment.bottomLeft,
                                                          child: ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor: MaterialStateProperty.all(HexColor("#2FBF8B")),
                                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(18.0),
                                                                  ),
                                                                )
                                                            ),
                                                            onPressed: ()async{
                                                              print("Curriculum");
                                                              setState(() {
                                                                courseId = featuredCourse[index].courseDocumentId;
                                                              });
                                                              // print(await course[index].curriculum);
                                                              // await Navigator.push(
                                                              //   context,
                                                              //   MaterialPageRoute(
                                                              //     builder: (context) => Curriculam(courseDetail: course[index])
                                                              //   ),
                                                              // );
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                  const CatelogueScreen(),
                                                                ),
                                                              );
                                                            },
                                                            child: Text("Enroll now",style: TextStyle(color: Colors.white,fontFamily: 'Regular',
                                                                fontWeight: FontWeight.bold,fontSize: 14),),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),

                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(15),
                                                    child: CachedNetworkImage(
                                                      imageUrl: course[index].courseImageUrl,
                                                      placeholder: (context, url) =>
                                                          Center(child: CircularProgressIndicator(),
                                                            heightFactor: 30,
                                                            widthFactor: 30,),
                                                      errorWidget: (context, url, error) =>
                                                          Icon(Icons.error),
                                                      fit: BoxFit.fill,
                                                      height: 100 * verticalScale,
                                                      width: 127 * horizontalScale,
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        top: 10,
                      ),
                      child: Text(
                        'Success Stories',
                        textScaleFactor: min(horizontalScale, verticalScale),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Poppins',
                            fontSize: 23,
                            letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.w500,
                            height: 1),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      // height: screenHeight * 0.81 * verticalScale,
                      height: 200,
                      width: screenWidth,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: FutureBuilder<List<FirebaseFile>>(
                        future: futureFiles,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator());
                            default:
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text(
                                      'Some error occurred!',
                                      textScaleFactor: min(horizontalScale, verticalScale),
                                    ));
                              } else {
                                final files = snapshot.data!;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        // physics: NeverScrollableScrollPhysics(),
                                        itemCount: files.length,
                                        itemBuilder: (context, index) {
                                          final file = files[index];
                                          return
                                            Container(

                                                decoration: BoxDecoration(
                                                    color: HexColor("#FFFFFF"),
                                                    borderRadius: BorderRadius.circular(15),
                                                    boxShadow: [
                                                      BoxShadow(color: Colors.grey,blurRadius: 5,offset: Offset(0,1))
                                                    ]
                                                ),
                                                margin: EdgeInsets.only(left: 15,top: 5,bottom: 5),
                                                padding: EdgeInsets.only(left: 15,right: 15,top: 12,bottom: 10),
                                                height: 200,
                                                width: 300,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(20),
                                                  child: CachedNetworkImage(
                                                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                    imageUrl: file.url,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                            );
                                          // buildFile(context, file);
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                          }
                        },
                      ),
                    ),
                    //SizedBox(height: 15,),
                    Container(
                      width: 414 * horizontalScale,
                      height: 250 * verticalScale,
                      child: Image.network('https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2Fhomeimage2.png?alt=media&token=cc13e37f-63d7-4036-a0ad-338becea925e',
                          fit: BoxFit.fill),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        top: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About Me',
                            textScaleFactor: min(horizontalScale, verticalScale),
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'Poppins',
                                fontSize: 25,
                                letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.w500,
                                height: 1),
                          ),
                          Container(
                            width: 60 * horizontalScale,
                            child: Divider(
                                color: Color.fromRGBO(156, 91, 255, 1), thickness: 2),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 10, bottom: 20),
                      child: Text(
                        'I have transitioned my career from Manual Tester to Data Scientist by upskilling myself on my own from various online resources and doing lots of Hands-on practice. For internal switch I sent around 150 mails to different project managers, interviewed in 20 and got selected in 10 projects.\nWhen it came to changing company I put papers with NO offers in hand. And in the notice period I struggled to get a job. First 2 months were very difficult but in the last month things started changing miraculously.\nI attended 40+ interviews in span of 3 months with the help of Naukri and LinkedIn profile Optimizations and got offer by 8 companies.\n Based on my career transition and industrial experience, I have designed this course so anyone from any background can learn Data Science and become Job-Ready at affordable price.',
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}