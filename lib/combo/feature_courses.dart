// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloudyml_app2/combo/non_trial_course_paynowbtsheet.dart';
// import 'package:cloudyml_app2/models/course_details.dart';
// import 'package:cloudyml_app2/widgets/coupon_code.dart';
// import 'package:cloudyml_app2/fun.dart';
// import 'package:cloudyml_app2/globals.dart';
// import 'package:cloudyml_app2/widgets/pay_now_bottomsheet.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:ribbon_widget/ribbon_widget.dart';
// import 'package:http/http.dart' as http;
// import '../Services/code_generator.dart';
// import '../Services/deeplink_service.dart';
// import '../widgets/pay_nowfeature.dart';
// import 'package:sizer/sizer.dart';
//
// class FeatureCourses extends StatefulWidget {
//   final String? id;
//   final String? cName;
//   final String? courseP;
//   final String? cID;
//
//   static ValueNotifier<String> coursePrice = ValueNotifier('');
//   static ValueNotifier<Map<String, dynamic>>? map = ValueNotifier({});
//   static ValueNotifier<double> _currentPosition = ValueNotifier<double>(0.0);
//   static ValueNotifier<double> _closeBottomSheetAtInCombo =
//       ValueNotifier<double>(0.0);
//
//   FeatureCourses({Key? key, this.id, this.cID, this.cName, this.courseP})
//       : super(key: key);
//
//   @override
//   State<FeatureCourses> createState() => _FeatureCoursesState();
// }
//
// class _FeatureCoursesState extends State<FeatureCourses> with CouponCodeMixin {
//   // var _razorpay = Razorpay();
//   var amountcontroller = TextEditingController();
//   TextEditingController couponCodeController = TextEditingController();
//   String? id;
//   final ScrollController _scrollController = ScrollController();
//
//   String couponAppliedResponse = "";
//
//   String coursePrice = "";
//
//   //If it is false amountpayble showed will be the amount fetched from db
//   //If it is true which will be set to true if when right coupon code is
//   //applied and the amountpayble will be set using appludiscount to the finalamountpayble variable
//   // declared below same for discount
//   bool NoCouponApplied = true;
//
//   bool isPayButtonPressed = false;
//
//   bool isPayInPartsPressed = false;
//
//   bool isMinAmountCheckerPressed = false;
//
//   bool isOutStandingAmountCheckerPressed = false;
//
//   String finalamountToDisplay = "";
//
//   String finalAmountToPay = "";
//
//   String discountedPrice = "";
//
//   String name = "";
//
//   GlobalKey _positionKey = GlobalKey();
//
//   var uid = FirebaseAuth.instance.currentUser!.uid;
//   var moneyrefcode;
//   var moneyreferalcode;
//   var moneyreferallink;
//
//   List<CourseDetails> featuredCourse = [];
//
//   setFeaturedCourse(List<CourseDetails> course) {
//     featuredCourse.clear();
//
//     course.forEach((element) {
//       print(' $element ');
//       if (element.courseDocumentId == widget.cID) {
//         featuredCourse.add(element);
//         // featuredCourse.add(element.courses);
//
//         print('element ${featuredCourse[0].courseId} ');
//       }
//     });
//     print('function ');
//   }
//
//   void lookformoneyref() async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(uid)
//           .get()
//           .then((value) => {moneyrefcode = value.data()!["moneyrefcode"]});
//     } catch (e) {}
//     try {
//       print("moneyrefcode: ${moneyrefcode}");
//       moneyreferalcode = await CodeGenerator()
//           .generateCodeformoneyreward('moneyreward-$courseId');
//       moneyreferallink =
//           await DeepLinkService.instance?.createReferLink(moneyreferalcode);
//       print("this is the kings enargy: ${moneyreferallink}");
//       if (moneyrefcode == null) {
//         FirebaseFirestore.instance.collection("Users").doc(uid).update({
//           "moneyrefcode": "$moneyreferalcode",
//         });
//       }
//     } catch (e) {}
//   }
//
//   Map<String, dynamic> comboMap = {};
//
//   void getCourseName() async {
//     print('this idd ${widget.cID}');
//     await FirebaseFirestore.instance
//         .collection('courses')
//         .doc(widget.cID)
//         .get()
//         .then((value) {
//       comboMap = value.data()!;
//       setState(() {
//         comboMap = value.data()!;
//         print('this is $comboMap');
//         print('cid is ${comboMap['trialCourse']} ${int.parse(widget.id!)}');
//
//         coursePrice = value.data()!['Course Price'];
//         name = value.data()!['name'];
//         print('ufbufb--$name');
//         print('fcc $featuredCourse');
//       });
//     });
//   }
//
//   Map userMap = Map<String, dynamic>();
//
//   void dbCheckerForPayInParts() async {
//     try {
//       DocumentSnapshot userDocs = await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .get();
//       // print(map['payInPartsDetails'][id]['outStandingAmtPaid']);
//       setState(() {
//         userMap = userDocs.data() as Map<String, dynamic>;
//         // whetherSubScribedToPayInParts =
//         //     !(!(map['payInPartsDetails']['outStandingAmtPaid'] == null));
//       });
//     } catch (e) {
//       print("ggggggggggg $e");
//     }
//   }
//
//   void trialCourse() async {
//     print(
//         'this is name  : ${userMap['name']} ${widget.cID} ${FirebaseAuth.instance.currentUser!.uid} "abc"');
//
//     try {
//       var url = Uri.parse(
//           'https://us-central1-cloudyml-app.cloudfunctions.net/exceluser/trial');
//       final response = await http.post(url, headers: {
//         "Access-Control-Allow-Origin": "*", // Required for CORS support to work
//         "Access-Control-Allow-Methods": "GET, POST",
//       }, body: {
//         "uid": FirebaseAuth.instance.currentUser!.uid,
//         "cid": featuredCourse[0].courseId,
//         "uname": userMap['name'],
//         "cname": featuredCourse[0].courseName,
//       });
//       // print('this is body ${body.toString()}');
//
//       print(response.statusCode);
//     } catch (e) {
//       print('this is api error ${e.toString()}');
//     }
//
//     // if (userMap['paidCourseNames'].contains(featuredCourse[int.parse(widget.id!)].courseId)) {
//     //   Fluttertoast.showToast(msg: 'This course already exist in your trial course...');
//     //   Navigator.of(context).pop();
//     // } else {
//     //   print('paidCourseNames before ${userMap['paidCourseNames']}');
//     //
//     //   setState(() async {
//     //
//     //
//     //
//     //     // userMap['paidCourseNames'].add(featuredCourse[int.parse(widget.id!)].courseId);
//     //     // FirebaseFirestore.instance.collection('Users')
//     //     //     .doc(FirebaseAuth.instance.currentUser!.uid)
//     //     //     .update({
//     //     //   'paidCourseNames': userMap['paidCourseNames'],
//     //     //   'trialCourseList': [featuredCourse[int.parse(widget.id!)].courseId],
//     //     // });
//     //     // featuredCourse[int.parse(widget.id!)].courseId
//     //     // loadCourses();
//     //
//     //   });
//     //   print('paidCourseNames ${userMap['paidCourseNames']}');
//     // }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getCourseName();
//     dbCheckerForPayInParts();
//     lookformoneyref();
//     // _scrollController.addListener(_scrollListener);
//   }
//
//   void _scrollListener() {
//     RenderBox? box =
//         _positionKey.currentContext?.findRenderObject() as RenderBox;
//     Offset position = box.localToGlobal(Offset.zero); //this is global position
//     double pixels = position.dy;
//     FeatureCourses._closeBottomSheetAtInCombo.value = pixels;
//     FeatureCourses._currentPosition.value = _scrollController.position.pixels;
//     print(pixels);
//     print(_scrollController.position.pixels);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     couponCodeController.dispose();
//     _scrollController.removeListener(_scrollListener);
//     _scrollController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
//     setFeaturedCourse(course);
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     var verticalScale = screenHeight / mockUpHeight;
//     var horizontalScale = screenWidth / mockUpWidth;
//     return LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//       if (constraints.maxWidth >= 650) {
//         return Scaffold(
//           appBar: AppBar(
//             backgroundColor: Color.fromRGBO(122, 98, 222, 1),
//             title: Center(
//               child: Text(
//                 widget.cName!,
//                 textScaleFactor: min(horizontalScale, verticalScale),
//                 style: TextStyle(
//                     color: Color.fromRGBO(255, 255, 255, 1),
//                     fontFamily: 'Poppins',
//                     fontSize: 44 * verticalScale,
//                     letterSpacing: 0,
//                     fontWeight: FontWeight.normal,
//                     height: 1),
//               ),
//             ),
//           ),
//           bottomSheet:
//               comboMap['trialCourse']! != null && comboMap['trialCourse']!
//                   ? PayNowBottomSheetfeature(
//                       coursePrice: '₹${widget.courseP!}/-',
//                       map: comboMap,
//                       isItComboCourse: true,
//                       cID: widget.cID!,
//                       id: widget.id,
//                     )
//                   : NonTrialCourseBottomSheet(
//                       coursePrice: '₹${widget.courseP!}/-',
//                       map: comboMap,
//                       isItComboCourse: true,
//                       cID: widget.cID!,
//                     ),
//           body: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
//                 child: Align(
//                   alignment: Alignment.topLeft,
//                   child: Text(
//                     'Courses you get(Scroll Down To See More)',
//                     textAlign: TextAlign.left,
//                     style: TextStyle(
//                         color: Color.fromRGBO(48, 48, 49, 1),
//                         fontFamily: 'Poppins',
//                         fontSize: 20,
//                         letterSpacing:
//                             0 /*percentages not used in flutter. defaulting to zero*/,
//                         fontWeight: FontWeight.bold,
//                         height: 1),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: screenWidth,
//                 height: 600 * verticalScale,
//                 child: MediaQuery.removePadding(
//                   context: context,
//                   removeTop: true,
//                   child: ListView.builder(
//                     // controller: _scrollController,
//                     scrollDirection: Axis.vertical,
//                     // physics: NeverScrollableScrollPhysics(),
//                     itemCount: course.length,
//                     itemBuilder: (BuildContext context, index) {
//                       print('Fc courses ');
//
//                       List courseList = [];
//                       for (var i in featuredCourse[0].courses) {
//                         for (var j in course) {
//                           if (i == j.courseId) {
//                             courseList.add(j);
//                           }
//                         }
//                       }
//
//                       if (course[index].courseName == "null") {
//                         return Container();
//                       }
//                       if (courseList.length != 0) {
//                         return Padding(
//                           padding: const EdgeInsets.only(
//                               bottom: 8.0, top: 8, left: 20.0, right: 20.0),
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 courseId = courseList[index].courseDocumentId;
//                               });
//                               final id = index.toString();
//                               GoRouter.of(context).pushNamed('catalogue',
//                                   queryParams: {'id': id, 'cID': courseId});
//                             },
//                             child: Container(
//                               width: 355 * horizontalScale,
//                               height: 250 * verticalScale,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(25),
//                                   topRight: Radius.circular(25),
//                                   bottomLeft: Radius.circular(25),
//                                   bottomRight: Radius.circular(25),
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color: Color.fromRGBO(
//                                         58,
//                                         57,
//                                         60,
//                                         0.57,
//                                       ),
//                                       offset: Offset(2, 2),
//                                       blurRadius: 3)
//                                 ],
//                                 color: Color.fromRGBO(233, 225, 252, 1),
//                               ),
//                               child: Row(
//                                 //card on combopage
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                                 children: [
//                                   Container(
//                                     width: screenWidth / 3,
//                                     height: screenHeight / 5,
//                                     padding: EdgeInsets.all(15),
//                                     // decoration: BoxDecoration(
//                                     //   borderRadius: BorderRadius.circular(25),
//                                     // ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(25),
//                                       child: Image.network(
//                                         courseList[index].courseImageUrl,
//                                         fit: BoxFit.fill,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 10 * verticalScale),
//                                   Padding(
//                                     padding: EdgeInsets.all(10.0),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                           width: 225 * horizontalScale,
//                                           child: Text(
//                                             courseList[index].courseName,
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             textScaleFactor: min(
//                                                 horizontalScale, verticalScale),
//                                             style: TextStyle(
//                                               color: Color.fromRGBO(0, 0, 0, 1),
//                                               fontFamily: 'Poppins',
//                                               fontSize: 38 * verticalScale,
//                                               letterSpacing: 0,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 15 * verticalScale,
//                                         ),
//                                         Container(
//                                           width: 225 * horizontalScale,
//                                           // height: 50 * verticalScale,
//                                           child: Text(
//                                             courseList[index].courseDescription,
//                                             maxLines: 5,
//                                             // overflow: TextOverflow.ellipsis,
//                                             textScaleFactor: min(
//                                                 horizontalScale, verticalScale),
//                                             style: TextStyle(
//                                                 color:
//                                                     Color.fromRGBO(0, 0, 0, 1),
//                                                 fontFamily: 'Poppins',
//                                                 fontSize: 26 * verticalScale,
//                                                 letterSpacing:
//                                                     0 /*percentages not used in flutter. defaulting to zero*/,
//                                                 fontWeight: FontWeight.normal,
//                                                 height: 1),
//                                           ),
//                                         ),
//                                         // Row(
//                                         //   children: [
//                                         //     Text(
//                                         //       course[index].coursePrice,
//                                         //       textAlign: TextAlign.left,
//                                         //       textScaleFactor: min(
//                                         //           horizontalScale,
//                                         //           verticalScale),
//                                         //       style: TextStyle(
//                                         //           color: Color.fromRGBO(
//                                         //               155, 117, 237, 1),
//                                         //           fontFamily: 'Poppins',
//                                         //           fontSize: 20,
//                                         //           letterSpacing:
//                                         //               0 /*percentages not used in flutter. defaulting to zero*/,
//                                         //           fontWeight: FontWeight.bold,
//                                         //           height: 1),
//                                         //     ),
//                                         //     SizedBox(
//                                         //       width: 40 * horizontalScale,
//                                         //     ),
//                                         //     Container(
//                                         //       width: 70 * horizontalScale,
//                                         //       height: 25 * verticalScale,
//                                         //       decoration: BoxDecoration(
//                                         //         borderRadius: BorderRadius.only(
//                                         //           topLeft: Radius.circular(50),
//                                         //           topRight: Radius.circular(50),
//                                         //           bottomLeft:
//                                         //               Radius.circular(50),
//                                         //           bottomRight:
//                                         //               Radius.circular(50),
//                                         //         ),
//                                         //         boxShadow: [
//                                         //           BoxShadow(
//                                         //               color: Color.fromRGBO(
//                                         //                   48,
//                                         //                   209,
//                                         //                   151,
//                                         //                   0.44999998807907104),
//                                         //               offset: Offset(0, 10),
//                                         //               blurRadius: 25)
//                                         //         ],
//                                         //         color: Color.fromRGBO(
//                                         //             48, 209, 151, 1),
//                                         //       ),
//                                         //       child: Center(
//                                         //         child: Text(
//                                         //           'Enroll now',
//                                         //           textAlign: TextAlign.left,
//                                         //           textScaleFactor: min(
//                                         //               horizontalScale,
//                                         //               verticalScale),
//                                         //           style: TextStyle(
//                                         //               color: Color.fromRGBO(
//                                         //                   255, 255, 255, 1),
//                                         //               fontFamily: 'Poppins',
//                                         //               fontSize: 10,
//                                         //               letterSpacing:
//                                         //                   0 /*percentages not used in flutter. defaulting to zero*/,
//                                         //               fontWeight:
//                                         //                   FontWeight.normal,
//                                         //               height: 1),
//                                         //         ),
//                                         //       ),
//                                         //     )
//                                         //   ],
//                                         // )
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       } else {
//                         return Container();
//                       }
//                     },
//                   ),
//                 ),
//               ),
//
//               // SizedBox(
//               //   height: 20,
//               // ),
//               // includes(context),
//               // SizedBox(
//               //   key: _positionKey,
//               //   height: 20,
//               // ),
//
//               // Container(
//               //   key: _positionKey,
//               // ),
//               // Ribbon(
//               //   nearLength: 1,
//               //   farLength: .5,
//               //   title: ' ',
//               //   titleStyle: TextStyle(
//               //       color: Colors.black,
//               //       // Colors.white,
//               //       fontSize: 18,
//               //       fontWeight: FontWeight.bold),
//               //   color: Color.fromARGB(255, 11, 139, 244),
//               //   location: RibbonLocation.topStart,
//               //   child:
//               //   Padding(
//               //     padding: const EdgeInsets.only(left: 50.0, right: 50),
//               //     child: Container(
//               //       //  key:key,
//               //       // width: width * .9,
//               //       // height: height * .5,
//               //       color: Color.fromARGB(255, 24, 4, 104),
//               //       child: Column(
//               //         //  key:Gkey,
//               //         children: [
//               //           // SizedBox(
//               //           //   height: screenHeight * .03,
//               //           // ),
//               //           // Text(
//               //           //   'Complete Course Fee',
//               //           //   style: TextStyle(
//               //           //       fontFamily: 'Bold',
//               //           //       fontSize: 21,
//               //           //       color: Colors.white),
//               //           // ),
//               //           // SizedBox(
//               //           //   height: 5,
//               //           // ),
//               //           // Text(
//               //           //   '( Everything with Lifetime Access )',
//               //           //   style: TextStyle(
//               //           //       fontFamily: 'Bold',
//               //           //       fontSize: 11,
//               //           //       color: Colors.white),
//               //           // ),
//               //           // SizedBox(
//               //           //   height: 30,
//               //           // ),
//               //           // Text(
//               //           //   '₹${widget.courseP!}/-',
//               //           //   style: TextStyle(
//               //           //       fontFamily: 'Medium',
//               //           //       fontSize: 30,
//               //           //       color: Colors.white),
//               //           // ),
//               //           // SizedBox(height: 35),
//               //           comboMap['trialCourse'] != null && comboMap['trialCourse'] ?
//               //           Container(
//               //             child: Row(
//               //               mainAxisAlignment: MainAxisAlignment.center,
//               //               children: [
//               //                 userMap['trialCourseList']
//               //                     .contains(featuredCourse[0].courseId) ?
//               //             InkWell(
//               //               onTap: () {
//               //                 GoRouter.of(context).pushReplacementNamed('myCourses');
//               //               },
//               //               child: Container(
//               //                 decoration: BoxDecoration(
//               //                     borderRadius: BorderRadius.circular(30),
//               //                     // boxShadow: [
//               //                     //   BoxShadow(
//               //                     //     color: Color.fromARGB(255, 176, 224, 250)
//               //                     //         .withOpacity(0.3),
//               //                     //     spreadRadius: 2,
//               //                     //     blurRadius: 3,
//               //                     //     offset: Offset(3,
//               //                     //         6), // changes position of shadow
//               //                     //   ),
//               //                     // ],
//               //                     color: Color.fromARGB(255, 119, 191, 249),
//               //                     gradient: gradient),
//               //                 height: screenHeight * .08,
//               //                 width: screenWidth / 2.5,
//               //                 child: Center(
//               //                   child: Text(
//               //                     'Continue Your Course',
//               //                     textAlign: TextAlign.center,
//               //                     style: TextStyle(
//               //                         color: Colors.white, fontSize: 20 * verticalScale),
//               //                   ),
//               //                 ),
//               //               ),
//               //             )
//               //                   :
//               //                 InkWell(
//               //                   onTap: () {
//               //                     showDialog(
//               //                         context: context,
//               //                         builder: (context) {
//               //                           return AlertDialog(
//               //                             backgroundColor: Colors
//               //                                 .deepPurpleAccent[
//               //                             700],
//               //                             title: Center(
//               //                               child: Text(
//               //                                 'Start Your ${featuredCourse[0].trialDays} Days Free Trial',
//               //                                 style: TextStyle(
//               //                                     color: Colors
//               //                                         .white),
//               //                               ),
//               //                             ),
//               //                             content: Container(
//               //                               height:
//               //                               screenHeight * .5,
//               //                               width:
//               //                               screenWidth / 2.5,
//               //                               child: Column(
//               //                                 mainAxisAlignment:
//               //                                 MainAxisAlignment
//               //                                     .center,
//               //                                 children: [
//               //                                   featureCPopup(
//               //                                     Icons.video_file,
//               //                                     'Get Complete Access to videos and assignments',
//               //                                     horizontalScale,
//               //                                     verticalScale,
//               //                                   ),
//               //                                   featureCPopup(
//               //                                     Icons.mobile_screen_share,
//               //                                     'Watch tutorial videos from any module',
//               //                                     horizontalScale,
//               //                                     verticalScale,
//               //                                   ),
//               //                                   featureCPopup(
//               //                                     Icons.assistant,
//               //                                     'Connect with Teaching Assistant for Doubt Clearance',
//               //                                     horizontalScale,
//               //                                     verticalScale,
//               //                                   ),featureCPopup(
//               //                                     Icons.mobile_friendly,
//               //                                     'Access videos and chat support over our Mobile App.',
//               //                                     horizontalScale,
//               //                                     verticalScale,
//               //                                   ),
//               //                                   SizedBox(height: 17,),
//               //                                   Container(
//               //                                       height:
//               //                                       screenHeight /8,
//               //                                       width:
//               //                                       screenWidth /
//               //                                           3.5,
//               //                                       decoration:
//               //                                       BoxDecoration(
//               //                                         borderRadius:
//               //                                         BorderRadius.circular(
//               //                                             10),
//               //                                         border: Border.all(
//               //                                             color: Colors
//               //                                                 .white,
//               //                                             width:
//               //                                             0.5),
//               //                                         color: Colors
//               //                                             .white,
//               //                                       ),
//               //                                       child: Column(
//               //                                         mainAxisAlignment:
//               //                                         MainAxisAlignment
//               //                                             .center,
//               //                                         children: [
//               //                                           Row(
//               //                                             children: [
//               //                                               Expanded(
//               //                                                 flex:
//               //                                                 1,
//               //                                                 child:
//               //                                                 Container(
//               //                                                   child: CircleAvatar(
//               //                                                     radius: 35,
//               //                                                     // borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
//               //                                                     child: Image.network(
//               //                                                       featuredCourse[0].courseImageUrl,
//               //                                                       fit: BoxFit.fill,
//               //                                                     ),
//               //                                                   ),
//               //                                                 ),
//               //                                               ),
//               //                                               Expanded(
//               //                                                 child:
//               //                                                 Container(
//               //                                                   child: Text(featuredCourse[0].courseName, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
//               //                                                 ),
//               //                                               ),
//               //                                             ],
//               //                                           )
//               //                                         ],
//               //                                       )),
//               //                                   SizedBox(
//               //                                       height: 29 *
//               //                                           verticalScale),
//               //                                   Row(
//               //                                     mainAxisAlignment:
//               //                                     MainAxisAlignment
//               //                                         .spaceBetween,
//               //                                     children: [
//               //                                       Container(
//               //                                         width: screenWidth/7,
//               //                                         decoration:
//               //                                         BoxDecoration(
//               //                                           borderRadius:
//               //                                           BorderRadius.circular(
//               //                                               10),
//               //                                           border: Border.all(
//               //                                               color: Colors
//               //                                                   .white,
//               //                                               width:
//               //                                               0.5),
//               //                                         ),
//               //                                         child:
//               //                                         ElevatedButton(
//               //                                           onPressed:
//               //                                               () {
//               //                                             // print(
//               //                                             //     'idd ${widget.id} ${featuredCourse[0].courseName}');
//               //                                             // print('this is condition ${userMap['paidCourseNames'].contains(featuredCourse[int.parse(widget.id!)].courseId)}');
//               //                                             Navigator.of(context)
//               //                                                 .pop();
//               //                                           },
//               //                                           child:
//               //                                           Text(
//               //                                             'Close',
//               //                                             style: TextStyle(
//               //                                                 color:
//               //                                                 Colors.white),
//               //                                           ),
//               //                                         ),
//               //                                       ),
//               //                                       Container(
//               //                                         decoration:
//               //                                         BoxDecoration(
//               //                                           borderRadius:
//               //                                           BorderRadius.circular(
//               //                                               10),
//               //                                           border: Border.all(
//               //                                               color: Colors
//               //                                                   .white,
//               //                                               width:
//               //                                               0.5),
//               //                                         ),
//               //                                         child:
//               //                                         ElevatedButton(
//               //                                           onPressed:
//               //                                               () {
//               //                                             var paidcourse;
//               //                                             print(
//               //                                                 userMap);
//               //
//               //                                             if(userMap['paidCourseNames'].contains(featuredCourse[0].courseId)) {
//               //                                               Fluttertoast.showToast(msg: 'You have already enrolled in this course.');
//               //                                             } else if (userMap['trialCourseList'] != null && userMap['trialCourseList'].contains(featuredCourse[0].courseId)) {
//               //                                               Fluttertoast.showToast(msg: 'You have already tried this course... Please purchase the course.');
//               //                                             } else {
//               //                                               setState(() {
//               //                                                 trialCourse();
//               //                                                 Fluttertoast.showToast(msg: 'Congrats!! Course is now available in enrolled courses for ${featuredCourse[0].trialDays}...');
//               //                                                 Timer(
//               //                                                     Duration(seconds: 2),
//               //                                                         () => GoRouter.of(context).pushReplacementNamed('myCourses')
//               //                                                 );
//               //                                               });
//               //                                             }
//               //                                           },
//               //                                           child:
//               //                                           Center(
//               //                                             child: Text(
//               //                                               'Start your free trial',
//               //                                               style: TextStyle(
//               //                                                   color:
//               //                                                   Colors.white),
//               //                                             ),
//               //                                           ),
//               //                                         ),
//               //                                       ),
//               //                                     ],
//               //                                   ),
//               //                                 ],
//               //                               ),
//               //                             ),
//               //                           );
//               //                         });
//               //
//               //                   },
//               //                   child: Container(
//               //                     decoration: BoxDecoration(
//               //                         borderRadius: BorderRadius.circular(30),
//               //                         // boxShadow: [
//               //                         //   BoxShadow(
//               //                         //     color: Color.fromARGB(255, 176, 224, 250)
//               //                         //         .withOpacity(0.3),
//               //                         //     spreadRadius: 2,
//               //                         //     blurRadius: 3,
//               //                         //     offset: Offset(3,
//               //                         //         6), // changes position of shadow
//               //                         //   ),
//               //                         // ],
//               //                         color: Color.fromARGB(255, 119, 191, 249),
//               //                         gradient: gradient),
//               //                     height: screenHeight * .08,
//               //                     width: screenWidth / 2.5,
//               //                     child: Center(
//               //                       child: Text(
//               //                         'Start your free trial now',
//               //                         textAlign: TextAlign.center,
//               //                         style: TextStyle(
//               //                             color: Colors.white, fontSize: 20),
//               //                       ),
//               //                     ),
//               //                   ),
//               //                 ),
//               //                 SizedBox(width: 20),
//               //                 InkWell(
//               //                   onTap: () {
//               //
//               //                     // GoRouter.of(context)
//               //                     //     .pushNamed(
//               //                     //     'paymentScreen',
//               //                     //     queryParams: {
//               //                     //       'isItComboCourse': true,
//               //                     //       'courseMap': comboMap,
//               //                     //     }
//               //                     // );
//               //
//               //                     GoRouter.of(context)
//               //                         .pushNamed('comboPaymentPortal',
//               //                         queryParams: {
//               //                           'cID': widget.cID,
//               //                         }
//               //                     );
//               //
//               //
//               //                     // Navigator.push(
//               //                     //   context,
//               //                     //   MaterialPageRoute(
//               //                     //     builder: (context) => PaymentScreen(
//               //                     //       map: comboMap,
//               //                     //       isItComboCourse: true,
//               //                     //       cID: widget.cID,
//               //                     //     ),
//               //                     //   ),
//               //                     // );
//               //
//               //                   },
//               //                   child: Container(
//               //                     decoration: BoxDecoration(
//               //                         borderRadius: BorderRadius.circular(30),
//               //                         // boxShadow: [
//               //                         //   BoxShadow(
//               //                         //     color: Color.fromARGB(255, 176, 224, 250)
//               //                         //         .withOpacity(0.3),
//               //                         //     spreadRadius: 2,
//               //                         //     blurRadius: 3,
//               //                         //     offset: Offset(3,
//               //                         //         6), // changes position of shadow
//               //                         //   ),
//               //                         // ],
//               //                         color: Color.fromARGB(255, 119, 191, 249),
//               //                         gradient: gradient),
//               //                     height: screenHeight * .08,
//               //                     width: screenWidth / 3,
//               //                     child: Center(
//               //                       child: Text(
//               //                         'Buy Now',
//               //                         textAlign: TextAlign.center,
//               //                         style: TextStyle(
//               //                             color: Colors.white, fontSize: 20 * verticalScale),
//               //                       ),
//               //                     ),
//               //                   ),
//               //                 ),
//               //               ],
//               //             ),
//               //           )
//               //            :
//               //           InkWell(
//               //             onTap: () {
//               //
//               //               GoRouter.of(context)
//               //                   .pushNamed('comboPaymentPortal',
//               //                   queryParams: {
//               //                     'cID': widget.cID,
//               //                   }
//               //               );
//               //
//               //
//               //               // Navigator.push(
//               //               //   context,
//               //               //   MaterialPageRoute(
//               //               //     builder: (context) => PaymentScreen(
//               //               //       map: comboMap,
//               //               //       isItComboCourse: true,
//               //               //       cID: widget.cID,
//               //               //     ),
//               //               //   ),
//               //               // );
//               //
//               //             },
//               //             child: Container(
//               //               decoration: BoxDecoration(
//               //                   borderRadius: BorderRadius.circular(30),
//               //                   // boxShadow: [
//               //                   //   BoxShadow(
//               //                   //     color: Color.fromARGB(255, 176, 224, 250)
//               //                   //         .withOpacity(0.3),
//               //                   //     spreadRadius: 2,
//               //                   //     blurRadius: 3,
//               //                   //     offset: Offset(3,
//               //                   //         6), // changes position of shadow
//               //                   //   ),
//               //                   // ],
//               //                   color: Color.fromARGB(255, 119, 191, 249),
//               //                   gradient: gradient),
//               //               height: screenHeight * .08,
//               //               width: screenWidth * .6,
//               //               child: Center(
//               //                 child: Text(
//               //                   'Buy Now',
//               //                   textAlign: TextAlign.center,
//               //                   style: TextStyle(
//               //                       color: Colors.white, fontSize: 20),
//               //                 ),
//               //               ),
//               //             ),
//               //           ),
//               //         ],
//               //       ),
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         );
//       } else {
//         return Scaffold(
//           // appBar: AppBar(
//           //   backgroundColor: Color.fromRGBO(122, 98, 222, 1),
//           //   title: Center(
//           //     child: Text(
//           //       widget.cName!,
//           //       textScaleFactor: min(horizontalScale, verticalScale),
//           //       style: TextStyle(
//           //           color: Color.fromRGBO(255, 255, 255, 1),
//           //           fontFamily: 'Poppins',
//           //           fontSize: 16 * verticalScale,
//           //           letterSpacing: 0,
//           //           fontWeight: FontWeight.normal,
//           //           height: 1),
//           //     ),
//           //   ),
//           // ),
//           bottomSheet:
//               comboMap['trialCourse']! != null && comboMap['trialCourse']!
//                   ? PayNowBottomSheetfeature(
//                       coursePrice: '₹${widget.courseP!}/-',
//                       map: comboMap,
//                       isItComboCourse: true,
//                       cID: widget.cID!,
//                       id: widget.id,
//                     )
//                   : NonTrialCourseBottomSheet(
//                       coursePrice: '₹${widget.courseP!}/-',
//                       map: comboMap,
//                       isItComboCourse: true,
//                       cID: widget.cID!,
//                     ),
//           body: Column(
//             children: [
//               Container(
//                 height: 80 * verticalScale,
//                 decoration: BoxDecoration(
//                   color: Color.fromRGBO(122, 98, 222, 1),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       child: IconButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         icon: Icon(Icons.arrow_back_rounded, color: Colors.white,),
//                       ),
//                     ),
//                     Container(
//                       height: 40 * verticalScale,
//                       width: screenWidth/1.25,
//                       child: Center(
//                         child: Text(
//                           widget.cName!,
//                           textScaleFactor: min(horizontalScale, verticalScale),
//                           maxLines: 2,
//                           style: TextStyle(
//                               color: Color.fromRGBO(255, 255, 255, 1),
//                               fontFamily: 'Poppins',
//                               overflow: TextOverflow.ellipsis,
//                               fontSize: 18 * verticalScale,
//                               letterSpacing: 0,
//                               fontWeight: FontWeight.normal,
//                               height: 1),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
//                 child: Align(
//                   alignment: Alignment.topLeft,
//                   child: Text(
//                     'Courses you get(Scroll Down To See More)',
//                     textAlign: TextAlign.left,
//                     style: TextStyle(
//                         color: Color.fromRGBO(48, 48, 49, 1),
//                         fontFamily: 'Poppins',
//                         fontSize: 16 * verticalScale,
//                         letterSpacing:
//                             0 /*percentages not used in flutter. defaulting to zero*/,
//                         fontWeight: FontWeight.bold,
//                         height: 1),
//                   ),
//                 ),
//               ),
//               Container(
//                 // width: screenWidth,
//                 height: 750 * verticalScale,
//                 child: ListView.builder(
//                   // controller: _scrollController,
//                   scrollDirection: Axis.vertical,
//                   // physics: NeverScrollableScrollPhysics(),
//                   itemCount: course.length,
//                   itemBuilder: (BuildContext context, index) {
//                     print('Fc courses ');
//
//                     List courseList = [];
//                     for (var i in featuredCourse[0].courses) {
//                       for (var j in course) {
//                         if (i == j.courseId) {
//                           courseList.add(j);
//                         }
//                       }
//                     }
//
//                     if (course[index].courseName == "null") {
//                       return Container();
//                     }
//                     if (courseList.length != 0) {
//                       return Padding(
//                         padding: const EdgeInsets.only(
//                             bottom: 8.0, top: 10, left: 5, right: 5),
//                         child: InkWell(
//                           onTap: () {
//                             setState(() {
//                               courseId = courseList[index].courseDocumentId;
//                             });
//                             final id = index.toString();
//                             GoRouter.of(context).pushNamed('catalogue',
//                                 queryParams: {'id': id, 'cID': courseId});
//                           },
//                           child: Container(
//                             // width: screenWidth,
//                             height: 175 * verticalScale,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(25),
//                                 topRight: Radius.circular(25),
//                                 bottomLeft: Radius.circular(25),
//                                 bottomRight: Radius.circular(25),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                     color: Color.fromRGBO(
//                                       58,
//                                       57,
//                                       60,
//                                       0.57,
//                                     ),
//                                     offset: Offset(2, 2),
//                                     blurRadius: 3)
//                               ],
//                               color: Color.fromRGBO(233, 225, 252, 1),
//                             ),
//                             child: Row(
//                               //card on combopage
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   width: screenWidth / 3,
//                                   height: screenHeight / 5,
//                                   padding: EdgeInsets.only(top: 10, bottom: 10),
//                                   // decoration: BoxDecoration(
//                                   //   borderRadius: BorderRadius.circular(25),
//                                   // ),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(15),
//                                     child: Image.network(
//                                       courseList[index].courseImageUrl,
//                                       fit: BoxFit.fill,
//                                     ),
//                                   ),
//                                 ),
//                                 // SizedBox(width: 5 * verticalScale),
//                                 Padding(
//                                   padding: EdgeInsets.all(10.0),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Container(
//                                         width: 225 * horizontalScale,
//                                         child: Text(
//                                           courseList[index].courseName,
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                           textScaleFactor: min(
//                                               horizontalScale, verticalScale),
//                                           style: TextStyle(
//                                             color: Color.fromRGBO(0, 0, 0, 1),
//                                             fontFamily: 'Poppins',
//                                             fontSize: 24 * verticalScale,
//                                             letterSpacing: 0,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 15 * verticalScale,
//                                       ),
//                                       Container(
//                                         width: 200 * horizontalScale,
//                                         // height: 50 * verticalScale,
//                                         child: Text(
//                                           courseList[index].courseDescription,
//                                           maxLines: 5,
//                                           // overflow: TextOverflow.ellipsis,
//                                           textScaleFactor: min(
//                                               horizontalScale, verticalScale),
//                                           style: TextStyle(
//                                               color: Color.fromRGBO(0, 0, 0, 1),
//                                               fontFamily: 'Poppins',
//                                               fontSize: 16 * verticalScale,
//                                               letterSpacing:
//                                                   0 /*percentages not used in flutter. defaulting to zero*/,
//                                               fontWeight: FontWeight.normal,
//                                               height: 1),
//                                         ),
//                                       ),
//                                       // Row(
//                                       //   children: [
//                                       //     Text(
//                                       //       course[index].coursePrice,
//                                       //       textAlign: TextAlign.left,
//                                       //       textScaleFactor: min(
//                                       //           horizontalScale,
//                                       //           verticalScale),
//                                       //       style: TextStyle(
//                                       //           color: Color.fromRGBO(
//                                       //               155, 117, 237, 1),
//                                       //           fontFamily: 'Poppins',
//                                       //           fontSize: 20,
//                                       //           letterSpacing:
//                                       //               0 /*percentages not used in flutter. defaulting to zero*/,
//                                       //           fontWeight: FontWeight.bold,
//                                       //           height: 1),
//                                       //     ),
//                                       //     SizedBox(
//                                       //       width: 40 * horizontalScale,
//                                       //     ),
//                                       //     Container(
//                                       //       width: 70 * horizontalScale,
//                                       //       height: 25 * verticalScale,
//                                       //       decoration: BoxDecoration(
//                                       //         borderRadius: BorderRadius.only(
//                                       //           topLeft: Radius.circular(50),
//                                       //           topRight: Radius.circular(50),
//                                       //           bottomLeft:
//                                       //               Radius.circular(50),
//                                       //           bottomRight:
//                                       //               Radius.circular(50),
//                                       //         ),
//                                       //         boxShadow: [
//                                       //           BoxShadow(
//                                       //               color: Color.fromRGBO(
//                                       //                   48,
//                                       //                   209,
//                                       //                   151,
//                                       //                   0.44999998807907104),
//                                       //               offset: Offset(0, 10),
//                                       //               blurRadius: 25)
//                                       //         ],
//                                       //         color: Color.fromRGBO(
//                                       //             48, 209, 151, 1),
//                                       //       ),
//                                       //       child: Center(
//                                       //         child: Text(
//                                       //           'Enroll now',
//                                       //           textAlign: TextAlign.left,
//                                       //           textScaleFactor: min(
//                                       //               horizontalScale,
//                                       //               verticalScale),
//                                       //           style: TextStyle(
//                                       //               color: Color.fromRGBO(
//                                       //                   255, 255, 255, 1),
//                                       //               fontFamily: 'Poppins',
//                                       //               fontSize: 10,
//                                       //               letterSpacing:
//                                       //                   0 /*percentages not used in flutter. defaulting to zero*/,
//                                       //               fontWeight:
//                                       //                   FontWeight.normal,
//                                       //               height: 1),
//                                       //         ),
//                                       //       ),
//                                       //     )
//                                       //   ],
//                                       // )
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     } else {
//                       return Container();
//                     }
//                   },
//                 ),
//               ),
//
//               // SizedBox(
//               //   height: 20,
//               // ),
//               // includes(context),
//               // SizedBox(
//               //   key: _positionKey,
//               //   height: 20,
//               // ),
//
//               // Container(
//               //   key: _positionKey,
//               // ),
//               // Ribbon(
//               //   nearLength: 1,
//               //   farLength: .5,
//               //   title: ' ',
//               //   titleStyle: TextStyle(
//               //       color: Colors.black,
//               //       // Colors.white,
//               //       fontSize: 18,
//               //       fontWeight: FontWeight.bold),
//               //   color: Color.fromARGB(255, 11, 139, 244),
//               //   location: RibbonLocation.topStart,
//               //   child:
//               //   Padding(
//               //     padding: const EdgeInsets.only(left: 50.0, right: 50),
//               //     child: Container(
//               //       //  key:key,
//               //       // width: width * .9,
//               //       // height: height * .5,
//               //       color: Color.fromARGB(255, 24, 4, 104),
//               //       child: Column(
//               //         //  key:Gkey,
//               //         children: [
//               //           // SizedBox(
//               //           //   height: screenHeight * .03,
//               //           // ),
//               //           // Text(
//               //           //   'Complete Course Fee',
//               //           //   style: TextStyle(
//               //           //       fontFamily: 'Bold',
//               //           //       fontSize: 21,
//               //           //       color: Colors.white),
//               //           // ),
//               //           // SizedBox(
//               //           //   height: 5,
//               //           // ),
//               //           // Text(
//               //           //   '( Everything with Lifetime Access )',
//               //           //   style: TextStyle(
//               //           //       fontFamily: 'Bold',
//               //           //       fontSize: 11,
//               //           //       color: Colors.white),
//               //           // ),
//               //           // SizedBox(
//               //           //   height: 30,
//               //           // ),
//               //           // Text(
//               //           //   '₹${widget.courseP!}/-',
//               //           //   style: TextStyle(
//               //           //       fontFamily: 'Medium',
//               //           //       fontSize: 30,
//               //           //       color: Colors.white),
//               //           // ),
//               //           // SizedBox(height: 35),
//               //           comboMap['trialCourse'] != null && comboMap['trialCourse'] ?
//               //           Container(
//               //             child: Row(
//               //               mainAxisAlignment: MainAxisAlignment.center,
//               //               children: [
//               //                 userMap['trialCourseList']
//               //                     .contains(featuredCourse[0].courseId) ?
//               //             InkWell(
//               //               onTap: () {
//               //                 GoRouter.of(context).pushReplacementNamed('myCourses');
//               //               },
//               //               child: Container(
//               //                 decoration: BoxDecoration(
//               //                     borderRadius: BorderRadius.circular(30),
//               //                     // boxShadow: [
//               //                     //   BoxShadow(
//               //                     //     color: Color.fromARGB(255, 176, 224, 250)
//               //                     //         .withOpacity(0.3),
//               //                     //     spreadRadius: 2,
//               //                     //     blurRadius: 3,
//               //                     //     offset: Offset(3,
//               //                     //         6), // changes position of shadow
//               //                     //   ),
//               //                     // ],
//               //                     color: Color.fromARGB(255, 119, 191, 249),
//               //                     gradient: gradient),
//               //                 height: screenHeight * .08,
//               //                 width: screenWidth / 2.5,
//               //                 child: Center(
//               //                   child: Text(
//               //                     'Continue Your Course',
//               //                     textAlign: TextAlign.center,
//               //                     style: TextStyle(
//               //                         color: Colors.white, fontSize: 20 * verticalScale),
//               //                   ),
//               //                 ),
//               //               ),
//               //             )
//               //                   :
//               //                 InkWell(
//               //                   onTap: () {
//               //                     showDialog(
//               //                         context: context,
//               //                         builder: (context) {
//               //                           return AlertDialog(
//               //                             backgroundColor: Colors
//               //                                 .deepPurpleAccent[
//               //                             700],
//               //                             title: Center(
//               //                               child: Text(
//               //                                 'Start Your ${featuredCourse[0].trialDays} Days Free Trial',
//               //                                 style: TextStyle(
//               //                                     color: Colors
//               //                                         .white),
//               //                               ),
//               //                             ),
//               //                             content: Container(
//               //                               height:
//               //                               screenHeight * .5,
//               //                               width:
//               //                               screenWidth / 2.5,
//               //                               child: Column(
//               //                                 mainAxisAlignment:
//               //                                 MainAxisAlignment
//               //                                     .center,
//               //                                 children: [
//               //                                   featureCPopup(
//               //                                     Icons.video_file,
//               //                                     'Get Complete Access to videos and assignments',
//               //                                     horizontalScale,
//               //                                     verticalScale,
//               //                                   ),
//               //                                   featureCPopup(
//               //                                     Icons.mobile_screen_share,
//               //                                     'Watch tutorial videos from any module',
//               //                                     horizontalScale,
//               //                                     verticalScale,
//               //                                   ),
//               //                                   featureCPopup(
//               //                                     Icons.assistant,
//               //                                     'Connect with Teaching Assistant for Doubt Clearance',
//               //                                     horizontalScale,
//               //                                     verticalScale,
//               //                                   ),featureCPopup(
//               //                                     Icons.mobile_friendly,
//               //                                     'Access videos and chat support over our Mobile App.',
//               //                                     horizontalScale,
//               //                                     verticalScale,
//               //                                   ),
//               //                                   SizedBox(height: 17,),
//               //                                   Container(
//               //                                       height:
//               //                                       screenHeight /8,
//               //                                       width:
//               //                                       screenWidth /
//               //                                           3.5,
//               //                                       decoration:
//               //                                       BoxDecoration(
//               //                                         borderRadius:
//               //                                         BorderRadius.circular(
//               //                                             10),
//               //                                         border: Border.all(
//               //                                             color: Colors
//               //                                                 .white,
//               //                                             width:
//               //                                             0.5),
//               //                                         color: Colors
//               //                                             .white,
//               //                                       ),
//               //                                       child: Column(
//               //                                         mainAxisAlignment:
//               //                                         MainAxisAlignment
//               //                                             .center,
//               //                                         children: [
//               //                                           Row(
//               //                                             children: [
//               //                                               Expanded(
//               //                                                 flex:
//               //                                                 1,
//               //                                                 child:
//               //                                                 Container(
//               //                                                   child: CircleAvatar(
//               //                                                     radius: 35,
//               //                                                     // borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
//               //                                                     child: Image.network(
//               //                                                       featuredCourse[0].courseImageUrl,
//               //                                                       fit: BoxFit.fill,
//               //                                                     ),
//               //                                                   ),
//               //                                                 ),
//               //                                               ),
//               //                                               Expanded(
//               //                                                 child:
//               //                                                 Container(
//               //                                                   child: Text(featuredCourse[0].courseName, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
//               //                                                 ),
//               //                                               ),
//               //                                             ],
//               //                                           )
//               //                                         ],
//               //                                       )),
//               //                                   SizedBox(
//               //                                       height: 29 *
//               //                                           verticalScale),
//               //                                   Row(
//               //                                     mainAxisAlignment:
//               //                                     MainAxisAlignment
//               //                                         .spaceBetween,
//               //                                     children: [
//               //                                       Container(
//               //                                         width: screenWidth/7,
//               //                                         decoration:
//               //                                         BoxDecoration(
//               //                                           borderRadius:
//               //                                           BorderRadius.circular(
//               //                                               10),
//               //                                           border: Border.all(
//               //                                               color: Colors
//               //                                                   .white,
//               //                                               width:
//               //                                               0.5),
//               //                                         ),
//               //                                         child:
//               //                                         ElevatedButton(
//               //                                           onPressed:
//               //                                               () {
//               //                                             // print(
//               //                                             //     'idd ${widget.id} ${featuredCourse[0].courseName}');
//               //                                             // print('this is condition ${userMap['paidCourseNames'].contains(featuredCourse[int.parse(widget.id!)].courseId)}');
//               //                                             Navigator.of(context)
//               //                                                 .pop();
//               //                                           },
//               //                                           child:
//               //                                           Text(
//               //                                             'Close',
//               //                                             style: TextStyle(
//               //                                                 color:
//               //                                                 Colors.white),
//               //                                           ),
//               //                                         ),
//               //                                       ),
//               //                                       Container(
//               //                                         decoration:
//               //                                         BoxDecoration(
//               //                                           borderRadius:
//               //                                           BorderRadius.circular(
//               //                                               10),
//               //                                           border: Border.all(
//               //                                               color: Colors
//               //                                                   .white,
//               //                                               width:
//               //                                               0.5),
//               //                                         ),
//               //                                         child:
//               //                                         ElevatedButton(
//               //                                           onPressed:
//               //                                               () {
//               //                                             var paidcourse;
//               //                                             print(
//               //                                                 userMap);
//               //
//               //                                             if(userMap['paidCourseNames'].contains(featuredCourse[0].courseId)) {
//               //                                               Fluttertoast.showToast(msg: 'You have already enrolled in this course.');
//               //                                             } else if (userMap['trialCourseList'] != null && userMap['trialCourseList'].contains(featuredCourse[0].courseId)) {
//               //                                               Fluttertoast.showToast(msg: 'You have already tried this course... Please purchase the course.');
//               //                                             } else {
//               //                                               setState(() {
//               //                                                 trialCourse();
//               //                                                 Fluttertoast.showToast(msg: 'Congrats!! Course is now available in enrolled courses for ${featuredCourse[0].trialDays}...');
//               //                                                 Timer(
//               //                                                     Duration(seconds: 2),
//               //                                                         () => GoRouter.of(context).pushReplacementNamed('myCourses')
//               //                                                 );
//               //                                               });
//               //                                             }
//               //                                           },
//               //                                           child:
//               //                                           Center(
//               //                                             child: Text(
//               //                                               'Start your free trial',
//               //                                               style: TextStyle(
//               //                                                   color:
//               //                                                   Colors.white),
//               //                                             ),
//               //                                           ),
//               //                                         ),
//               //                                       ),
//               //                                     ],
//               //                                   ),
//               //                                 ],
//               //                               ),
//               //                             ),
//               //                           );
//               //                         });
//               //
//               //                   },
//               //                   child: Container(
//               //                     decoration: BoxDecoration(
//               //                         borderRadius: BorderRadius.circular(30),
//               //                         // boxShadow: [
//               //                         //   BoxShadow(
//               //                         //     color: Color.fromARGB(255, 176, 224, 250)
//               //                         //         .withOpacity(0.3),
//               //                         //     spreadRadius: 2,
//               //                         //     blurRadius: 3,
//               //                         //     offset: Offset(3,
//               //                         //         6), // changes position of shadow
//               //                         //   ),
//               //                         // ],
//               //                         color: Color.fromARGB(255, 119, 191, 249),
//               //                         gradient: gradient),
//               //                     height: screenHeight * .08,
//               //                     width: screenWidth / 2.5,
//               //                     child: Center(
//               //                       child: Text(
//               //                         'Start your free trial now',
//               //                         textAlign: TextAlign.center,
//               //                         style: TextStyle(
//               //                             color: Colors.white, fontSize: 20),
//               //                       ),
//               //                     ),
//               //                   ),
//               //                 ),
//               //                 SizedBox(width: 20),
//               //                 InkWell(
//               //                   onTap: () {
//               //
//               //                     // GoRouter.of(context)
//               //                     //     .pushNamed(
//               //                     //     'paymentScreen',
//               //                     //     queryParams: {
//               //                     //       'isItComboCourse': true,
//               //                     //       'courseMap': comboMap,
//               //                     //     }
//               //                     // );
//               //
//               //                     GoRouter.of(context)
//               //                         .pushNamed('comboPaymentPortal',
//               //                         queryParams: {
//               //                           'cID': widget.cID,
//               //                         }
//               //                     );
//               //
//               //
//               //                     // Navigator.push(
//               //                     //   context,
//               //                     //   MaterialPageRoute(
//               //                     //     builder: (context) => PaymentScreen(
//               //                     //       map: comboMap,
//               //                     //       isItComboCourse: true,
//               //                     //       cID: widget.cID,
//               //                     //     ),
//               //                     //   ),
//               //                     // );
//               //
//               //                   },
//               //                   child: Container(
//               //                     decoration: BoxDecoration(
//               //                         borderRadius: BorderRadius.circular(30),
//               //                         // boxShadow: [
//               //                         //   BoxShadow(
//               //                         //     color: Color.fromARGB(255, 176, 224, 250)
//               //                         //         .withOpacity(0.3),
//               //                         //     spreadRadius: 2,
//               //                         //     blurRadius: 3,
//               //                         //     offset: Offset(3,
//               //                         //         6), // changes position of shadow
//               //                         //   ),
//               //                         // ],
//               //                         color: Color.fromARGB(255, 119, 191, 249),
//               //                         gradient: gradient),
//               //                     height: screenHeight * .08,
//               //                     width: screenWidth / 3,
//               //                     child: Center(
//               //                       child: Text(
//               //                         'Buy Now',
//               //                         textAlign: TextAlign.center,
//               //                         style: TextStyle(
//               //                             color: Colors.white, fontSize: 20 * verticalScale),
//               //                       ),
//               //                     ),
//               //                   ),
//               //                 ),
//               //               ],
//               //             ),
//               //           )
//               //            :
//               //           InkWell(
//               //             onTap: () {
//               //
//               //               GoRouter.of(context)
//               //                   .pushNamed('comboPaymentPortal',
//               //                   queryParams: {
//               //                     'cID': widget.cID,
//               //                   }
//               //               );
//               //
//               //
//               //               // Navigator.push(
//               //               //   context,
//               //               //   MaterialPageRoute(
//               //               //     builder: (context) => PaymentScreen(
//               //               //       map: comboMap,
//               //               //       isItComboCourse: true,
//               //               //       cID: widget.cID,
//               //               //     ),
//               //               //   ),
//               //               // );
//               //
//               //             },
//               //             child: Container(
//               //               decoration: BoxDecoration(
//               //                   borderRadius: BorderRadius.circular(30),
//               //                   // boxShadow: [
//               //                   //   BoxShadow(
//               //                   //     color: Color.fromARGB(255, 176, 224, 250)
//               //                   //         .withOpacity(0.3),
//               //                   //     spreadRadius: 2,
//               //                   //     blurRadius: 3,
//               //                   //     offset: Offset(3,
//               //                   //         6), // changes position of shadow
//               //                   //   ),
//               //                   // ],
//               //                   color: Color.fromARGB(255, 119, 191, 249),
//               //                   gradient: gradient),
//               //               height: screenHeight * .08,
//               //               width: screenWidth * .6,
//               //               child: Center(
//               //                 child: Text(
//               //                   'Buy Now',
//               //                   textAlign: TextAlign.center,
//               //                   style: TextStyle(
//               //                       color: Colors.white, fontSize: 20),
//               //                 ),
//               //               ),
//               //             ),
//               //           ),
//               //         ],
//               //       ),
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         );
//       }
//     });
//   }
// }
