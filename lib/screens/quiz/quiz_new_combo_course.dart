import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudyml_app2/combo/controller/combo_course_controller.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class QuizNewComboCourse extends StatelessWidget {
  final String? courseName;
  final String? courseIdd;
  const QuizNewComboCourse(
      {Key? key, required this.courseName, required this.courseIdd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (Get.isRegistered<ComboCourseController>()) {
      Get.find<ComboCourseController>().getPercentageOfCourse();
    }
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/BG.png"), fit: BoxFit.fill),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                  height: 20,
                ),
                GetX<ComboCourseController>(
                    init: ComboCourseController(courseId: courseIdd),
                    builder: (controller) {
                      return controller.courseList.isEmpty
                          ? Center(
                              child: SizedBox(
                                child: CircularProgressIndicator(
                                    color: Colors.deepPurpleAccent,
                                    strokeWidth: 3),
                              ),
                            )
                          : Obx(
                              () => SizedBox(
                                child: ListView.builder(
                                    itemCount: controller.courseList.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width > 700
                                            ? width / 7
                                            : width / 50),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return coursenamewithoutquiz.contains(
                                              controller.courseList[index]
                                                  ['name'])
                                          ? Container()
                                          : Container(
                                              padding: EdgeInsets.all(8),
                                              margin:
                                                  EdgeInsets.only(bottom: 15),
                                              width: width < 1700
                                                  ? width < 1300
                                                      ? width < 850
                                                          ? constraints
                                                                  .maxWidth -
                                                              20
                                                          : constraints
                                                                  .maxWidth -
                                                              200
                                                      : constraints.maxWidth -
                                                          400
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 50,
                                                  ),
                                                  Expanded(
                                                      flex: width < 600 ? 6 : 4,
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
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                controller.courseList[
                                                                        index]
                                                                    ['name'],
                                                                style: TextStyle(
                                                                    height: 1,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: width > 700
                                                                        ? 25
                                                                        : width < 540
                                                                            ? 15
                                                                            : 16),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                      child:
                                                                          Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          "Estimates learning time : ${controller.courseList[index]['duration']}",
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              fontSize: width < 540
                                                                                  ? width < 420
                                                                                      ? 11
                                                                                      : 13
                                                                                  : 14)),
                                                                      SizedBox(
                                                                        height:
                                                                            3,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            15,
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
                                                                                      courseId = controller.courseList[index]['docid'];
                                                                                      print('iejfoiwjeof');
                                                                                      if (fromcombo == 'yes') {
                                                                                        GoRouter.of(context).pushNamed('quizList', queryParams: {
                                                                                          'courseName': controller.courseList[index]['curriculum1'].keys.toList().first.toString(),
                                                                                          'cID': controller.courseList[index]['docid'],
                                                                                        });
                                                                                      } else {
                                                                                        GoRouter.of(context).pushNamed('comboVideoScreen', queryParams: {
                                                                                          'courseName': controller.courseList[index]['curriculum1'].keys.toList().first.toString(),
                                                                                          'cID': controller.courseList[index]['docid'],
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Text(
                                                                                          "Attempt Quiz",
                                                                                          style: TextStyle(color: Colors.white, fontSize: width < 500 ? 10 : null),
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    color: Colors.purple,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10,
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
                                                                                      courseId = controller.courseList[index]['docid'];
                                                                                      print("eijfowjowjeo");
                                                                                      if (fromcombo == 'yes') {
                                                                                        GoRouter.of(context).pushNamed('quizList', queryParams: {
                                                                                          'courseName': controller.courseList[index]['curriculum1'].keys.toList().first.toString(),
                                                                                          'cID': controller.courseList[index]['docid'],
                                                                                        });
                                                                                      } else {
                                                                                        GoRouter.of(context).pushNamed('comboVideoScreen', queryParams: {
                                                                                          'courseName': controller.courseList[index]['curriculum1'].keys.toList().first.toString(),
                                                                                          'cID': controller.courseList[index]['docid'],
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Center(
                                                                                          child: Text(
                                                                                            "Attempt Quiz",
                                                                                            style: TextStyle(color: Colors.white, fontSize: width < 500 ? 10 : null),
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    color: Colors.purple,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 15,
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
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 25,
                                                                            ),
                                                                            GetX<ComboCourseController>(
                                                                              init: ComboCourseController(courseId: courseId),
                                                                              builder: (controller) => CircularPercentIndicator(
                                                                                radius: width < 700
                                                                                    ? width < 500
                                                                                        ? 55
                                                                                        : 65
                                                                                    : 90,
                                                                                lineWidth: 4.0,
                                                                                animation: true,
                                                                                percent: controller.courseData[controller.courses[index] + "percentage"] == null ? 0 : controller.courseData[controller.courses[index] + "percentage"] / 100,
                                                                                center: Text(
                                                                                  controller.courseData[controller.courses[index] + "percentage"] == null ? "0%" : '${controller.courseData[controller.courses[index] + "percentage"]}%',
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
                                                  width > 700
                                                      ? Expanded(
                                                          flex: 2,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              GetX<
                                                                  ComboCourseController>(
                                                                init: ComboCourseController(
                                                                    courseId:
                                                                        courseId),
                                                                builder:
                                                                    (controller) =>
                                                                        CircularPercentIndicator(
                                                                  radius: 110.0,
                                                                  lineWidth:
                                                                      10.0,
                                                                  animation:
                                                                      true,
                                                                  percent: controller.courseData[controller.courses[index] +
                                                                              "percentage"] ==
                                                                          null
                                                                      ? 0
                                                                      : controller.courseData[controller.courses[index] +
                                                                              "percentage"] /
                                                                          100,
                                                                  center: Text(
                                                                      controller.courseData[controller.courses[index] +
                                                                                  "percentage"] ==
                                                                              null
                                                                          ? "0%"
                                                                          : '${controller.courseData[controller.courses[index] + "percentage"]}%',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20.0,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              Colors.black)),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black12,
                                                                  circularStrokeCap:
                                                                      CircularStrokeCap
                                                                          .round,
                                                                  progressColor:
                                                                      Colors
                                                                          .green,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text("Progress")
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
                    })
              ],
            )),
          );
        },
      ),
    );
  }
}
