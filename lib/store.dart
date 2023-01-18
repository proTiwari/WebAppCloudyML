import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/catalogue_screen.dart';
import 'package:cloudyml_app2/combo/combo_store.dart';
import 'package:cloudyml_app2/fun.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:cloudyml_app2/payments_history.dart';
import 'package:cloudyml_app2/privacy_policy.dart';
import 'package:cloudyml_app2/screens/assignment_tab_screen.dart';
import 'package:cloudyml_app2/screens/review_screen/review_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:star_rating/star_rating.dart';

import 'MyAccount/myaccount.dart';
import 'Providers/UserProvider.dart';
import 'aboutus.dart';
import 'authentication/firebase_auth.dart';
import 'models/user_details.dart';
import 'my_Courses.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 14,
    fontFamily: "Semibold",
  );

  @override
  Widget build(BuildContext context) {

    List<CourseDetails> courseList = Provider.of<List<CourseDetails>>(context);

    List<CourseDetails> course = [];
    List<dynamic> courseToRemove = [];
    var cou = [];
    bool everycourseispurchased = false;
    UserDetails? userCourse = Provider.of<UserDetails?>(context, listen: true);
    print("hhhhhhhhhhhhhhhhh");
    print("course list: ${courseList}");

    for (CourseDetails element in courseList) {
      print("show${element.show}");
      print(userCourse);
      print(userCourse?.paidCoursesId);

      // logic for showing if complete courses has been taken or not
      try {
        for (var i in userCourse!.paidCoursesId) {
          if (i == element.courseId) {
            courseToRemove.add(i);
          }
          if (i == element.courseId) {
            if (element.isItComboCourse) {
              courseToRemove = courseToRemove + element.courses;
            }

          }
        }
      } catch (e) {}

    }
    try {
      course = courseList;
      var valuedata = [];
      courseList.forEach((element) {
        courseToRemove.forEach((i) {
          if (element.courseId == i) {
            valuedata.add(element);
          }
        });
      });

      print("startdddddddddddddddd");
      //logic for removing
      var set1 = Set.from(course);
      var set2 = Set.from(valuedata);
      setState(() {
        course = List.from(set1.difference(set2));
        if (course == []) {
          everycourseispurchased = true;
        }
        print("sfjdsdjflsdfls$course");
      });

      //logic for show parameter

      for (var i in course) {
        try {
          if (i.show == true) {
            cou.add(i);
          }
        } catch (e) {
          print("uiooiio${e.toString()}");
        }
      }
    } catch (e) {
      print("tttttttttttttttttt${e.toString()}");
    }



    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;


    return Scaffold(
      key: _scaffoldKey,
      drawer: customDrawer(context),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth >= 515) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: screenWidth,
                    height: 45,
                    color: HexColor("440F87"),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
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
                        SizedBox(
                          width: horizontalScale * 25,
                        ),
                        // SizedBox(
                        //   height: 30,
                        //   width: screenWidth / 3,
                        //   child: TextField(
                        //     style: TextStyle(
                        //         color: HexColor("A7A7A7"), fontSize: 12),
                        //     decoration: InputDecoration(
                        //         contentPadding: EdgeInsets.all(5.0),
                        //         hintText: "Search Courses",
                        //         focusedBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(
                        //                 color: Colors.white, width: 1)),
                        //         disabledBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(
                        //                 color: Colors.white, width: 1)),
                        //         hintStyle: TextStyle(
                        //             color: HexColor("A7A7A7"), fontSize: 12),
                        //         border: OutlineInputBorder(
                        //             borderSide: BorderSide(
                        //                 color: Colors.white, width: 1)),
                        //         enabledBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(
                        //                 color: Colors.white, width: 1)),
                        //         prefixIcon: IconButton(
                        //             onPressed: () {},
                        //             icon: Icon(
                        //               Icons.search_outlined,
                        //               size: 14,
                        //               color: Colors.white,
                        //             ))),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  Container(
                    width: screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 60.0, top: 20, bottom: 20),
                          child: Column(
                            children: [
                              Container(
                                width: horizontalScale * 200,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      "Explore our hands on",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SemiBold',
                                        color: HexColor("000000"),
                                        fontSize: 26,)
                                  ),
                                ),
                              ),
                              Container(
                                width: horizontalScale * 200,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      "Learning courses 🔥🔥🔥",
                                      style: TextStyle(
                                        color: HexColor("000000"),
                                        fontFamily: 'SemiBold',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Container(width: horizontalScale * ,),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            padding: EdgeInsets.only(right: 60),
                            width: horizontalScale * 180,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    "Our Courses comes with Lifetime access, Live",
                                    style: TextStyle(
                                      color: HexColor("000000"),
                                      fontSize: 14,)
                                ),
                                Text(
                                    "chat support & internship opportunity.",
                                    style: TextStyle(
                                      color: HexColor("000000"),
                                      fontSize: 14,)
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0, right: 60),
                    child: Divider(thickness: 2,),
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                    child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: constraints.maxWidth >= 900 ? 4 : 3,
                          childAspectRatio: constraints.maxWidth >= 900 ? 0.80 : 1.05,
                          crossAxisSpacing: constraints.maxWidth >= 900 ? 25 : 15,
                        ),
                      itemCount: cou.length,
                      itemBuilder: (context, index) {
                      if (cou[index].courseName == "null") {
                        return Container(
                          child: Text('This is a container'),
                        );
                      }
                      if (cou[index].show == true)
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              courseId = cou[index]
                                  .courseDocumentId;
                            });
                            print(courseId);
                            if (cou[index].isItComboCourse) {

                              final id = index.toString();
                              final courseName = cou[index].courseName;
                              final courseP = cou[index].coursePrice;
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
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(15),
                                border: Border.all(
                                    width: 0.5,
                                    color: HexColor("440F87")),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: screenWidth,
                                    height: screenHeight / 7,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft:
                                          Radius.circular(15),
                                          topRight:
                                          Radius.circular(15)),
                                      child: Image.network(
                                        cou[index].courseImageUrl,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                                    width: screenWidth,
                                    child: Text(
                                      cou[index].courseName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Medium',
                                        fontSize: 12,
                                        height: 0.95,
                                        fontWeight: FontWeight.bold,),
                                    ),
                                  ),
                                  Container(
                                    height: verticalScale * 130,
                                    width: screenWidth,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          // Align(
                                          //   alignment: Alignment.topLeft,
                                          //   child: Text(
                                          //     course[index].courseName,
                                          //     maxLines: 2,
                                          //     overflow: TextOverflow.ellipsis,
                                          //     style: TextStyle(
                                          //       color: Colors.black,
                                          //       fontFamily: 'Medium',
                                          //       fontSize: 12,
                                          //       height: 0.95,
                                          //       fontWeight: FontWeight.bold,),
                                          //   ),
                                          // ),
                                          SizedBox(
                                            height: verticalScale * 5,
                                          ),
                                          Align(
                                            alignment:
                                            Alignment.topLeft,
                                            child: Text(
                                              "- ${cou[index].numOfVideos} Videos",
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                  color: Colors
                                                      .black,
                                                  fontSize: 10),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                            Alignment.topLeft,
                                            child: Text(
                                              "- Lifetime Access",
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                  color: Colors
                                                      .black,
                                                  fontSize: 10),
                                            ),
                                          ),
                                          SizedBox(
                                            height: verticalScale * 5,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(right: 5.0),
                                                child: StarRating(
                                                  length: 5,
                                                  rating: 5,
                                                  color: Colors.green,
                                                  starSize: 15,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 5.0),
                                                child: Text('5/5',
                                                  style: TextStyle(fontSize: 10),),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Container(
                                      height: verticalScale * 30,
                                      width: screenWidth/8,
                                      child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton
                                              .styleFrom(
                                            backgroundColor:
                                            HexColor(
                                                "8346E1"),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    5)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Enroll Now",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color:
                                                  Colors.white,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                            ),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                      return Container();
                    },)
                  ),
                  // Container(
                  //   padding: const EdgeInsets.only(right: 60.0, left: 60.0),
                  //   width: MediaQuery.of(context).size.width,
                  //   height: MediaQuery.of(context).size.height,
                  //   child: GridView.builder(
                  //       gridDelegate:
                  //       SliverGridDelegateWithFixedCrossAxisCount(
                  //         crossAxisCount: constraints.maxWidth >= 650 ? 3 : 2,
                  //       ),
                  //       scrollDirection: Axis.vertical,
                  //       itemCount: course.length,
                  //       itemBuilder: (BuildContext context, index) {
                  //         if (course[index].courseName == "null") {
                  //           return Container(
                  //             child: Text('This is a container'),
                  //           );
                  //         }
                  //         if (course[index].show == true)
                  //           return GestureDetector(
                  //             onTap: () {
                  //               setState(() {
                  //                 courseId = course[index]
                  //                     .courseDocumentId;
                  //               });
                  //               print(courseId);
                  //               if (course[index].isItComboCourse) {
                  //
                  //                 final id = index.toString();
                  //                 final courseName = course[index].courseName;
                  //                 final courseP = course[index].coursePrice;
                  //                 GoRouter.of(context).pushNamed('comboStore', queryParams: {'courseName': courseName, 'id': id, 'coursePrice': courseP});
                  //
                  //                 // Navigator.push(
                  //                 //   context,
                  //                 //   MaterialPageRoute(
                  //                 //     builder: (context) =>
                  //                 //         ComboStore(
                  //                 //           courses:
                  //                 //           course[index].courses,
                  //                 //         ),
                  //                 //   ),
                  //                 // );
                  //
                  //               } else {
                  //                 final id = index.toString();
                  //                 GoRouter.of(context).pushNamed('catalogue', queryParams: {'id': id});
                  //               }
                  //             },
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(10.0),
                  //               child: Container(
                  //                 width: screenWidth,
                  //                 decoration: BoxDecoration(
                  //                   color: Colors.white,
                  //                   borderRadius:
                  //                   BorderRadius.circular(15),
                  //                   border: Border.all(
                  //                       width: 0.5,
                  //                       color: HexColor("440F87")),
                  //                 ),
                  //                 child: Column(
                  //                   crossAxisAlignment:
                  //                   CrossAxisAlignment.center,
                  //                   children: [
                  //                     Container(
                  //                       width: screenWidth / 3.5,
                  //                       height: screenHeight / 6,
                  //                       child: ClipRRect(
                  //                         borderRadius: BorderRadius.only(
                  //                             topLeft:
                  //                             Radius.circular(15),
                  //                             topRight:
                  //                             Radius.circular(15)),
                  //                         child: Image.network(
                  //                           course[index].courseImageUrl,
                  //                           fit: BoxFit.fill,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     Container(
                  //                       height: 15,
                  //                       color: HexColor('EEE1FF'),
                  //                       child: Row(
                  //                         children: [
                  //                           SizedBox(width: 8,),
                  //                           Image.asset(
                  //                             'assets/Rating.png',
                  //                             fit: BoxFit.fill,
                  //                             height: 10,
                  //                             width: 50,
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                     Container(
                  //                       // height: verticalScale * 130,
                  //                       child: Padding(
                  //                         padding: const EdgeInsets.all(8),
                  //                         child: Column(
                  //                           children: [
                  //                             Align(
                  //                               alignment:
                  //                               Alignment.topLeft,
                  //                               child: Text(
                  //                                 course[index]
                  //                                     .courseName,
                  //                                 overflow: TextOverflow.ellipsis,
                  //                                 style: TextStyle(
                  //                                     color: Colors
                  //                                         .black,
                  //                                     fontFamily:
                  //                                     'Medium',
                  //                                     fontSize: 12,
                  //                                     fontWeight:
                  //                                     FontWeight
                  //                                         .w500),
                  //                               ),
                  //                             ),
                  //                             SizedBox(
                  //                               height: verticalScale * 5,
                  //                             ),
                  //                             Align(
                  //                               alignment:
                  //                               Alignment.topLeft,
                  //                               child: Text(
                  //                                 "- ${course[index].courseLanguage} Language",
                  //                                 style: TextStyle(
                  //                                     fontWeight:
                  //                                     FontWeight
                  //                                         .bold,
                  //                                     color: Colors
                  //                                         .black,
                  //                                     fontSize: 8),
                  //                               ),
                  //                             ),
                  //                             Align(
                  //                               alignment:
                  //                               Alignment.topLeft,
                  //                               child: Text(
                  //                                 "- ${course[index].numOfVideos} Videos",
                  //                                 style: TextStyle(
                  //                                     fontWeight:
                  //                                     FontWeight
                  //                                         .bold,
                  //                                     color: Colors
                  //                                         .black,
                  //                                     fontSize: 8),
                  //                               ),
                  //                             ),
                  //                             Align(
                  //                               alignment:
                  //                               Alignment.topLeft,
                  //                               child: Text(
                  //                                 "- Lifetime Access",
                  //                                 style: TextStyle(
                  //                                     fontWeight:
                  //                                     FontWeight
                  //                                         .bold,
                  //                                     color: Colors
                  //                                         .black,
                  //                                     fontSize: 8),
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     Container(
                  //                       width: horizontalScale * 50,
                  //                       height: 20,
                  //                       child: ElevatedButton(
                  //                           onPressed: () {},
                  //                           style: ElevatedButton
                  //                               .styleFrom(
                  //                             backgroundColor:
                  //                             HexColor(
                  //                                 "8346E1"),
                  //                             shape: RoundedRectangleBorder(
                  //                                 borderRadius:
                  //                                 BorderRadius
                  //                                     .circular(
                  //                                     5)),
                  //                           ),
                  //                           child: Text(
                  //                             "Enroll Now!",
                  //                             style: TextStyle(
                  //                                 fontSize: 10,
                  //                                 color:
                  //                                 Colors.white,
                  //                                 fontWeight:
                  //                                 FontWeight
                  //                                     .bold),
                  //                           )),
                  //                     ),
                  //                     Spacer(),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //           );
                  //         return Container();
                  //       }),
                  // ),
                ],
              ),
            );
          } else {
            return Container(
              color: Colors.deepPurple,
              child: Stack(children: [
                Positioned(
                  // left: -50,
                  // width: 100,
                  // height: 100,
                  top: -98.00000762939453,
                  left: -88.00000762939453,
                  // child: CircleAvatar(
                  //   radius: 70,
                  //   backgroundColor: Color.fromARGB(255, 173, 149, 149),
                  // ),
                  child: Container(
                      width: 161.99998474121094,
                      height: 161.99998474121094,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(55, 126, 106, 228),
                        borderRadius: BorderRadius.all(Radius.elliptical(
                            161.99998474121094, 161.99998474121094)),
                      )),
                ),
                Positioned(
                  // right: MediaQuery.of(context).size.width * (-.16),
                  // bottom: MediaQuery.of(context).size.height * .7,
                  top: 73.00000762939453,
                  left: 309,

                  // child: CircleAvatar(
                  //   radius: 80,
                  //   backgroundColor: Color.fromARGB(255, 173, 149, 149),
                  // ),
                  child: Container(
                      width: 161.99998474121094,
                      height: 161.99998474121094,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(55, 126, 106, 228),
                        borderRadius: BorderRadius.all(Radius.elliptical(
                            161.99998474121094, 161.99998474121094)),
                      )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  //color: Color.fromARGB(214, 83, 109, 254),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomePage()),
                                );
                                // Scaffold.of(context).openDrawer();
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.17,
                            ),
                            Text(
                              'Store',
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                      ),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40)),
                              color: Colors.white),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: GridView.builder(
                                gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent:
                                    MediaQuery.of(context).size.width * .5,
                                    childAspectRatio: 1.15
                                ),
                                itemCount: course.length,
                                itemBuilder: (context, index) {

                                  if(course[index].show == true)
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        courseId = course[index].courseDocumentId;
                                      });

                                      print(courseId);
                                      if (course[index].isItComboCourse) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ComboStore(
                                              courses: course[index].courses,
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.pushNamed(context, '/catalogue');
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Color.fromARGB(192, 255, 255, 255),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromRGBO(
                                                168, 133, 250, 0.7099999785423279),
                                            offset: Offset(2, 2),
                                            blurRadius: 5,
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(08.0),
                                        child: Column(
                                          //mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: Container(
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(15),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                    course[index].courseImageUrl,
                                                    placeholder: (context, url) =>
                                                        Center(child: CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                        Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                    height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        .15,
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        .4,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                height:
                                                MediaQuery.of(context).size.height *
                                                    .06,
                                                child: Text(
                                                  course[index].courseName,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          .035),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                              MediaQuery.of(context).size.height *
                                                  .02,
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Row(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment
                                                //         .center,
                                                children: [
                                                  Text(
                                                    course[index].courseLanguage,
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                            .03),
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        .02,
                                                  ),
                                                  Text(
                                                    '||',
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                            .03),
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        .02,
                                                  ),
                                                  Text(
                                                    course[index].numOfVideos,
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                            .03),
                                                  ),
                                                  // const SizedBox(
                                                  //   height: 10,
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                              MediaQuery.of(context).size.height *
                                                  .015,
                                            ),
                                            // Row(
                                            //   children: [
                                            //     Container(
                                            //       width:
                                            //           MediaQuery.of(context)
                                            //                   .size
                                            //                   .width *
                                            //               0.20,
                                            //       height:
                                            //           MediaQuery.of(context)
                                            //                   .size
                                            //                   .height *
                                            //               0.030,
                                            //       decoration: BoxDecoration(
                                            //           borderRadius:
                                            //               BorderRadius
                                            //                   .circular(10),
                                            //           color: Colors.green),
                                            //       child: const Center(
                                            //         child: Text(
                                            //           'ENROLL NOW',
                                            //           style: TextStyle(
                                            //               fontSize: 10,
                                            //               color:
                                            //                   Colors.white),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //     const SizedBox(
                                            //       width: 15,
                                            //     ),
                                            //     Text(
                                            //       map['Course Price'],
                                            //       style: const TextStyle(
                                            //         fontSize: 13,
                                            //         color: Colors.indigo,
                                            //         fontWeight:
                                            //             FontWeight.bold,
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                            Text(
                                              course[index].coursePrice,
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    .03,
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                  return Container();
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            );
          }
        }
      ),
    );
  }
}
