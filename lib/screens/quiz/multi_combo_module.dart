import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/combo/controller/multi_combo_course_controller.dart';
import 'package:cloudyml_app2/module/pdf_course.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../combo/combo_course.dart';
import '../../combo/controller/combo_course_controller.dart';
import '../../globals.dart';

class MultiComboModule extends StatelessWidget {
  final String? id;
  final String? courseName;
  const MultiComboModule({Key? key, this.id, this.courseName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FbackGroundImage.jpg?alt=media&token=c7282af8-222d-4761-89b0-35fa206f0ac1"),
                    fit: BoxFit.fill),
                color: HexColor("#fef0ff"),
              ),
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        GoRouter.of(context).pushReplacementNamed('home');
                      },
                      child: Container(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                              child: Icon(Icons.arrow_back_rounded),
                            ),
                            Text(
                              'Back',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Welcome to ",
                            style: TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: width < 850
                                    ? width < 430
                                        ? 25
                                        : 30
                                    : 40,
                                color: Colors.black)),
                        TextSpan(
                            text: courseName,
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
                    GetX<MultiComboCourseController>(
                      init: MultiComboCourseController(courseId: id),
                      builder: (controller) => controller.courseList.isEmpty
                          ? Center(
                              child: SizedBox(
                                child: CircularProgressIndicator(
                                    color: Colors.deepPurpleAccent,
                                    strokeWidth: 3),
                              ),
                            )
                          : Padding(
                              padding: constraints.maxWidth >= 630
                                  ? EdgeInsets.fromLTRB(160, 0, 160, 0)
                                  : EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height - 150,
                                child: GetX<ComboModuleController>(
                                    init: ComboModuleController(
                                        courseId: controller.courseList),
                                    builder: (controllers) {
                                      return controllers.courseList.isEmpty
                                          ? Center(
                                              child: SizedBox(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: Colors
                                                            .deepPurpleAccent,
                                                        strokeWidth: 3),
                                              ),
                                            )
                                          : Obx(
                                              () => SingleChildScrollView(
                                                child: ListView.builder(
                                                    itemCount: controllers
                                                        .courseList.length,
                                                    shrinkWrap: true,
                                                    scrollDirection: Axis
                                                        .vertical,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                width > 700
                                                                    ? width /
                                                                        7
                                                                    : width /
                                                                        50),
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        margin:
                                                            EdgeInsets.only(
                                                                bottom: 15),
                                                        width: width < 1700
                                                            ? width < 1300
                                                                ? width < 850
                                                                    ? constraints
                                                                            .maxWidth -
                                                                        20
                                                                    : constraints
                                                                            .maxWidth -
                                                                        200
                                                                : constraints
                                                                        .maxWidth -
                                                                    400
                                                            : constraints
                                                                    .maxWidth -
                                                                700,
                                                        height: width > 700
                                                            ? 230
                                                            : width < 300
                                                                ? 190
                                                                : 210,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color:
                                                                Colors.white),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: 50,
                                                            ),

                                                            Expanded(
                                                                flex: width <
                                                                        600
                                                                    ? 6
                                                                    : 4,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          controllers.courseList[index]['name'],
                                                                          style: TextStyle(
                                                                              height: 1,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: width > 700
                                                                                  ? 25
                                                                                  : width < 540
                                                                                      ? 15
                                                                                      : 16),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                                child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text("Estimates learning time : ${controllers.courseList[index]['duration']}",
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyle(
                                                                                        fontSize: width < 540
                                                                                            ? width < 420
                                                                                                ? 11
                                                                                                : 13
                                                                                            : 14)),
                                                                                SizedBox(
                                                                                  height: 3,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 15,
                                                                                ),
                                                                                width < 450
                                                                                    ? Column(
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            width: width < 400 ? 160 : 190,
                                                                                            child: MaterialButton(
                                                                                              height: width > 700 ? 50 : 40,
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(20),
                                                                                              ),
                                                                                              padding: EdgeInsets.all(8),
                                                                                              minWidth: width > 700 ? 100 : 60,
                                                                                              onPressed: () {
                                                                                                courseId = controllers.courseList[index]['docid'];
                                                                                                print('iejfoiwjeof');
                                                                                                if (fromcombo == 'yes') {
                                                                                                  GoRouter.of(context).pushNamed('quizList', queryParams: {
                                                                                                    'courseName': controllers.courseList[index]['curriculum1'].keys.toList().first.toString(),
                                                                                                    'cID': controllers.courseList[index]['docid'],
                                                                                                  });
                                                                                                } else {
                                                                                                  GoRouter.of(context).pushNamed('comboVideoScreen', queryParams: {
                                                                                                    'courseName': controllers.courseList[index]['curriculum1'].keys.toList().first.toString(),
                                                                                                    'cID': controllers.courseList[index]['docid'],
                                                                                                  });
                                                                                                }
                                                                                              },
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  SizedBox(
                                                                                                    width: 5,
                                                                                                  ),
                                                                                                  Expanded(
                                                                                                      flex: 1,
                                                                                                      child: Icon(
                                                                                                        Icons.play_arrow,
                                                                                                        color: Colors.white,
                                                                                                        size: width < 200 ? 2 : null,
                                                                                                      )),
                                                                                                  Expanded(
                                                                                                      flex: 3,
                                                                                                      child: Text(
                                                                                                        "Resume learning",
                                                                                                        style: TextStyle(color: Colors.white, fontSize: width < 500 ? 10 : null),
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                      ))
                                                                                                ],
                                                                                              ),
                                                                                              color: Colors.purple,
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 10,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 130,
                                                                                            child: MaterialButton(
                                                                                              onPressed: () {
                                                                                                GoRouter.of(context).pushNamed('LiveDoubtSession');
                                                                                              },
                                                                                              color: Colors.blue,
                                                                                              height: 40,
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(20),
                                                                                              ),
                                                                                              minWidth: 60,
                                                                                              child: Center(
                                                                                                child: Text(
                                                                                                  'Live Doubt Support',
                                                                                                  style: TextStyle(color: Colors.white, fontSize: width < 500 ? 10 : null),
                                                                                                  overflow: TextOverflow.ellipsis,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    : Row(
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            width: 190,
                                                                                            child: MaterialButton(
                                                                                              height: 50,
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(20),
                                                                                              ),
                                                                                              padding: EdgeInsets.all(8),
                                                                                              minWidth: 100,
                                                                                              onPressed: () {
                                                                                                courseId = controllers.courseList[index]['docid'];
                                                                                                print("eijfowjowjeo");
                                                                                                if (fromcombo == 'yes') {
                                                                                                  GoRouter.of(context).pushNamed('quizList', queryParams: {
                                                                                                    'courseName': controllers.courseList[index]['curriculum1'].keys.toList().first.toString(),
                                                                                                    'cID': controllers.courseList[index]['docid'],
                                                                                                  });
                                                                                                } else {
                                                                                                  GoRouter.of(context).pushNamed('comboVideoScreen', queryParams: {
                                                                                                    'courseName': controllers.courseList[index]['curriculum1'].keys.toList().first.toString(),
                                                                                                    'cID': controllers.courseList[index]['docid'],
                                                                                                  });
                                                                                                }
                                                                                              },
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  SizedBox(
                                                                                                    width: 5,
                                                                                                  ),
                                                                                                  Expanded(
                                                                                                      flex: 1,
                                                                                                      child: Icon(
                                                                                                        Icons.play_arrow,
                                                                                                        color: Colors.white,
                                                                                                        size: width < 200 ? 2 : null,
                                                                                                      )),
                                                                                                  Expanded(
                                                                                                      flex: 3,
                                                                                                      child: Text(
                                                                                                        "Resume learning",
                                                                                                        style: TextStyle(color: Colors.white, fontSize: width < 500 ? 10 : null),
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                      ))
                                                                                                ],
                                                                                              ),
                                                                                              color: Colors.purple,
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 15,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 190,
                                                                                            child: MaterialButton(
                                                                                              onPressed: () {
                                                                                                GoRouter.of(context).pushNamed('LiveDoubtSession');
                                                                                              },
                                                                                              color: Colors.blue,
                                                                                              height: 50,
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(20),
                                                                                              ),
                                                                                              minWidth: 100,
                                                                                              child: Center(
                                                                                                child: Text(
                                                                                                  'Live Doubt Support',
                                                                                                  style: TextStyle(color: Colors.white, fontSize: width < 500 ? 10 : null),
                                                                                                  overflow: TextOverflow.ellipsis,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                              ],
                                                                            )),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            width < 700
                                                                                ? Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        height: 25,
                                                                                      ),
                                                                                      GetX<ComboModuleController>(
                                                                                        init: ComboModuleController(courseId: controller.courseList),
                                                                                        builder: (controllers) => CircularPercentIndicator(
                                                                                          radius: width < 700
                                                                                              ? width < 500
                                                                                                  ? 55
                                                                                                  : 65
                                                                                              : 90,
                                                                                          lineWidth: 4.0,
                                                                                          animation: true,
                                                                                          percent: controllers.courseData[controllers.courses[index] + "percentage"] == null ? 0 : controllers.courseData[controllers.courses[index] + "percentage"] / 100,
                                                                                          center: Text(
                                                                                            controllers.courseData[controllers.courses[index] + "percentage"] == null ? "0%" : '${controllers.courseData[controllers.courses[index] + "percentage"]}%',
                                                                                            style: TextStyle(fontSize: width < 500 ? 12 : 14, fontWeight: FontWeight.w600, color: Colors.black),
                                                                                          ),
                                                                                          backgroundColor: Colors.black12,
                                                                                          circularStrokeCap: CircularStrokeCap.round,
                                                                                          progressColor: Colors.green,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: width < 500 ? 3 : 5,
                                                                                      ),
                                                                                      Text(
                                                                                        "Progress",
                                                                                        // controller.courseData[controller.courses[index] + "percentage"] ==
                                                                                        //         null
                                                                                        //     ? "0%"
                                                                                        //     : '${controller.courseData[controller.courses[index] + "percentage"]}%',
                                                                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                                                      )
                                                                                    ],
                                                                                  )
                                                                                : SizedBox(),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
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
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.center,
                                                                      children: [
                                                                        GetX<
                                                                            ComboModuleController>(
                                                                          init:
                                                                              ComboModuleController(courseId: controller.courseList),
                                                                          builder: (controllerp) =>
                                                                              CircularPercentIndicator(
                                                                            radius: 110.0,
                                                                            lineWidth: 10.0,
                                                                            animation: true,
                                                                            percent: controllerp.courseData[controllerp.courses[index] + "percentage"] == null ? 0 : controllerp.courseData[controllerp.courses[index] + "percentage"] / 100,
                                                                            center: Text(controllerp.courseData[controllerp.courses[index] + "percentage"] == null ? "0%" : '${controllerp.courseData[controllerp.courses[index] + "percentage"]}%', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black)),
                                                                            backgroundColor: Colors.black12,
                                                                            circularStrokeCap: CircularStrokeCap.round,
                                                                            progressColor: Colors.green,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        Text(
                                                                            "Progress"
                                                                            //                                 controller.courseData[controller.courses[
                                                                            // index] +
                                                                            //     "percentage"] == null ?
                                                                            //     "0%" :

                                                                            // '${controller.courseData[controller.courses[
                                                                            // index] +
                                                                            //     "percentage"]}%'
                                                                            )
                                                                      ],
                                                                    ),
                                                                  )
                                                                : SizedBox()
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            );
                                    }),
                              ),
                            ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
