import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/MyAccount/myaccount.dart';

import '../models/quiz_model.dart';
import './flutter_flow/flutter_flow_theme.dart';
import './flutter_flow/flutter_flow_util.dart';
import './flutter_flow/flutter_flow_widgets.dart';
import './flutter_flow/random_data_util.dart' as random_data;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ReWidget extends StatefulWidget {
  const ReWidget({Key? key}) : super(key: key);

  @override
  _ReWidgetState createState() => _ReWidgetState();
}

class _ReWidgetState extends State<ReWidget> {
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  List quizdata = [];
  String timer = "00:00:00";

  @override
  void initState() {
    super.initState();
    print("uuuiiioookljlk");
    getQuiz();
  }

  countDownTimer(quiztiming) async {
    int timerCount = int.parse("1") * 60;

    for (int x = timerCount; x > 0; x--) {
      await Future.delayed(Duration(seconds: 1)).then((_) {
        if (timerCount == 1) {
          submit();
          print("stop timing now");
        }
        setState(() {
          timerCount -= 1;
        });
        final now = Duration(seconds: timerCount);
        setState(() {
          timer = _printDuration(now);
        });
        print("${_printDuration(now)}");
      });
    }
  }

  bool submitvalue = false;

  submit() {
    setState(() {
      submitvalue = true;
    });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String quiztiming = '';
  int questionindex = 0;
  bool markreview = false;
  int savedcount = 0;

  int lengthofquizquestion = 0;

  bool A = false;
  bool B = false;
  bool C = false;
  bool D = false;

  int answeredM = 0;
  int notAnsweredM = 0;
  int notVisitedM = 0;
  int MFR_M = 0;
  int AMFR_M = 0;

  saveNext() {
    setState(() {
      if (true) {
        // logic for visited
        if (questionindex != quizdata.length - 1) {
          quizdata[questionindex + 1]["visited"] = true;
        }

        // logic for keeping not answered value
        if (A == false &&
            B == false &&
            C == false &&
            D == false &&
            quizdata[questionindex]["answeredValue"] != 'A' &&
            quizdata[questionindex]["answeredValue"] != 'B' &&
            quizdata[questionindex]["answeredValue"] != 'C' &&
            quizdata[questionindex]["answeredValue"] != 'D') {
          quizdata[questionindex]["notAnswered"] = true;
          if (markreview) {
            quizdata[questionindex]["MFR"] = true;
            markreview = false;
          }
        } else {
          if (markreview) {
            quizdata[questionindex]["AMFR"] = true;
            markreview = false;
          }
        }

        // logic for keeping answered value
        if (A == true) {
          quizdata[questionindex]["answeredValue"] = "A";
          quizdata[questionindex]["Answered"] = true;
          quizdata[questionindex]["notAnswered"] = false;
          setState(() {
            A = false;
          });
        }
        if (B == true) {
          quizdata[questionindex]["answeredValue"] = "B";
          quizdata[questionindex]["Answered"] = true;
          quizdata[questionindex]["notAnswered"] = false;
          setState(() {
            B = false;
          });
        }
        if (C == true) {
          quizdata[questionindex]["answeredValue"] = "C";
          quizdata[questionindex]["Answered"] = true;
          quizdata[questionindex]["notAnswered"] = false;
          setState(() {
            C = false;
          });
        }
        if (D == true) {
          quizdata[questionindex]["answeredValue"] = "D";
          quizdata[questionindex]["Answered"] = true;
          quizdata[questionindex]["notAnswered"] = false;
          setState(() {
            D = false;
          });
        }
        if (quizdata.length != questionindex + 1) {
          questionindex += 1;
        }
      }
    });
    countParameter('saveNext');
  }

  save() {
    setState(() {
      if (true) {
        // logic for visited
        if (questionindex != quizdata.length - 1) {
          quizdata[questionindex + 1]["visited"] = true;
        }

        // logic for keeping not answered value
        if (A == false &&
            quizdata[questionindex]["answeredValue"] != 'A' &&
            quizdata[questionindex]["answeredValue"] != 'B' &&
            quizdata[questionindex]["answeredValue"] != 'C' &&
            quizdata[questionindex]["answeredValue"] != 'D' &&
            B == false &&
            C == false &&
            D == false) {
          quizdata[questionindex]["notAnswered"] = true;
        }

        // logic for keeping answered value
        if (A == true) {
          quizdata[questionindex]["answeredValue"] = "A";
          quizdata[questionindex]["Answered"] = true;
          quizdata[questionindex]["notAnswered"] = false;
          setState(() {
            A = false;
          });
        }
        if (B == true) {
          quizdata[questionindex]["answeredValue"] = "B";
          quizdata[questionindex]["Answered"] = true;
          quizdata[questionindex]["notAnswered"] = false;
          setState(() {
            B = false;
          });
        }
        if (C == true) {
          quizdata[questionindex]["answeredValue"] = "C";
          quizdata[questionindex]["Answered"] = true;
          quizdata[questionindex]["notAnswered"] = false;
          setState(() {
            C = false;
          });
        }
        if (D == true) {
          quizdata[questionindex]["answeredValue"] = "D";
          quizdata[questionindex]["Answered"] = true;
          quizdata[questionindex]["notAnswered"] = false;
          setState(() {
            D = false;
          });
        }

        // logic for MFR

      }
    });
    countParameter("save");
  }

  countParameter(fun) async {
    answeredM = 0;
    notAnsweredM = 0;
    if (fun == 'saveNext') {
      notVisitedM = lengthofquizquestion;
    }

    MFR_M = 0;
    AMFR_M = 0;
    // counting answeredM
    for (var i in quizdata) {
      try {
        if (i["Answered"] == true) {
          setState(() {
            answeredM += 1;
          });
        }
      } catch (e) {
        print("answeredM error: $e");
      }
    }
    // counting notAnsweredM
    for (var j in quizdata) {
      try {
        if (j["notAnswered"] == true) {
          setState(() {
            notAnsweredM += 1;
          });
        }
      } catch (e) {
        print("notAnsweredM error: $e");
      }
    }
    // counting notVisitedM
    if (fun == 'saveNext') {
      for (var k in quizdata) {
        try {
          if (k["visited"] == true) {
            setState(() {
              notVisitedM -= 1;
            });
            print("notvisitedm $notVisitedM");
          }
        } catch (e) {
          print("notVisitedM error: $e");
        }
      }
    }

    // counting MFR_M
    for (var l in quizdata) {
      try {
        if (l["MFR"] == true) {
          setState(() {
            MFR_M += 1;
          });
        }
      } catch (e) {
        print("MFR_M error: $e");
      }
    }
    // counting AMFR_M
    for (var m in quizdata) {
      try {
        if (m["AMFR"] == true) {
          setState(() {
            AMFR_M += 1;
          });
        }
      } catch (e) {
        print("AMFR_M error: $e");
      }
    }
  }

  getQuiz() async {
    try {
      print("uuuiiioooiiii");
      await FirebaseFirestore.instance
          .collection("Quiz")
          .where('module', isEqualTo: "python course")
          .where("quizranking", isEqualTo: "1")
          .get()
          .then((value) {
        print("questionbucket: ${value.docs.first.data()["questionbucket"]}");
        value.docs.forEach((e) {
          quizdata = e.data()['questionbucket'];
          quiztiming = e.data()['quiztiming'];
          setState(() {
            quizdata;
          });

          quizdata[0]["visited"] = true;
          print("quizdata:  ${quizdata}");
          notVisitedM = quizdata.length;
          lengthofquizquestion = quizdata.length;
          countParameter("saveNext");
          countDownTimer(quiztiming);
        });
      });
    } catch (e) {
      print("jjoijoijo: ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Stack(children: [
        !submitvalue
            ? SafeArea(
                child: GestureDetector(
                  onTap: () =>
                      FocusScope.of(context).requestFocus(_unfocusNode),
                  child: Align(
                    alignment: AlignmentDirectional(-1, -1),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (responsiveVisibility(
                            context: context,
                            tablet: false,
                            tabletLandscape: false,
                            desktop: false,
                          ))
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 20, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF19F80F),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0, 0),
                                              child: Text(
                                                '$answeredM',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBtnText,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10, 0, 0, 0),
                                            child: Text(
                                              'Answered',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 20, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0, 0),
                                              child: Text(
                                                '$notAnsweredM',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBtnText,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10, 0, 0, 0),
                                            child: Text(
                                              'Not Answered',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 20, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF868585),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0, 0),
                                              child: Text(
                                                '$notVisitedM',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBtnText,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10, 0, 0, 0),
                                            child: Text(
                                              'Not Visited',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 20, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          GestureDetector(
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional(0, 0),
                                                child: Text(
                                                  '$MFR_M',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryBtnText,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10, 0, 0, 0),
                                            child: Text(
                                              'Marked for \nReview',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 50),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            20, 20, 0, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Color(0x8F1487DD),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional(0, 0),
                                                child: Text(
                                                  '$AMFR_M',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryBtnText,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(10, 0, 0, 0),
                                              child: Text(
                                                'Answered and Marked for review\n(will be considered for evaluation)',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          if (responsiveVisibility(
                            context: context,
                            tablet: false,
                            tabletLandscape: false,
                            desktop: false,
                          ))
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20, 20, 20, 20),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Container(
                                  width: 100,
                                  height: 112,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20, 20, 20, 20),
                                    child: GridView.builder(
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 6,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 1,
                                      ),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: quizdata.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF19F80F),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0, 0),
                                            child: Text(
                                              '2',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryBtnText,
                                                      ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (responsiveVisibility(
                            context: context,
                            phone: false,
                          ))
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 80,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Visibility(
                                visible: responsiveVisibility(
                                  context: context,
                                  phone: false,
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional(-1, -1),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (responsiveVisibility(
                                        context: context,
                                        phone: false,
                                      ))
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1, 0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 10, 0, 0),
                                            child: Text(
                                              'R Certification Quiz',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyText1
                                                  .override(
                                                    fontFamily: 'Poppins',
                                                    color:
                                                        valueOrDefault<Color>(
                                                      random_data.randomColor(),
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryColor,
                                                    ),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      Align(
                                        alignment: AlignmentDirectional(-1, 0),
                                        child: Container(
                                          width: 325.9,
                                          height: 62.4,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBtnText,
                                          ),
                                          alignment:
                                              AlignmentDirectional(-1, 0),
                                          child: Visibility(
                                            visible: responsiveVisibility(
                                              context: context,
                                              phone: false,
                                            ),
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(-1, -1),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            -1, 0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 10, 10, 0),
                                                      child: Icon(
                                                        Icons
                                                            .fullscreen_exit_sharp,
                                                        color: Colors.black,
                                                        size: 24,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            -1, 0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 10, 0, 0),
                                                      child: Text(
                                                        'Remaining Time:',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .title3
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 18,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 10, 0, 0),
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 110,
                                                      child: Card(
                                                        // clipBehavior:
                                                        //     Clip.antiAliasWithSaveLayer,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryColor,
                                                        elevation: 1,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0, 0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0,
                                                                        10,
                                                                        0,
                                                                        10),
                                                            child: Text(
                                                              '$timer',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .title3
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryBackground,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          Align(
                            alignment: AlignmentDirectional(-0.9, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 71.2,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              alignment: AlignmentDirectional(-0.9, 0),
                              child: Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      60, 0, 60, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 10, 0, 10),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              if (responsiveVisibility(
                                                context: context,
                                                phone: false,
                                              ))
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -0.05, 0),
                                                  child: Card(
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryColor,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(15, 10,
                                                                  15, 10),
                                                      child: Text(
                                                        'R',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                  fontSize: 17,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if (responsiveVisibility(
                                                context: context,
                                                phone: false,
                                              ))
                                                Card(
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryColor,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(15, 0,
                                                                    0, 0),
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .clipboardList,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          size: 24,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(15,
                                                                    10, 15, 10),
                                                        child: Text(
                                                          'Question Paper',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                fontSize: 16,
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
                                      if (responsiveVisibility(
                                        context: context,
                                        tablet: false,
                                        tabletLandscape: false,
                                        desktop: false,
                                      ))
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.05, -1),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.05, 0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 5),
                                                  child: SizedBox(
                                                    height: 50,
                                                    width: 100,
                                                    child: Card(
                                                      // clipBehavior:
                                                      //     Clip.antiAliasWithSaveLayer,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryColor,
                                                      elevation: 1,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      16,
                                                                      10,
                                                                      16,
                                                                      10),
                                                          child: Text(
                                                            '$timer',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .title3
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                  fontSize: 17,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
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
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: AlignmentDirectional(-0.55, -1),
                                  child: Container(
                                    width: 774,
                                    height:
                                        MediaQuery.of(context).size.height * 1,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                    ),
                                    child: Wrap(
                                      spacing: 0,
                                      runSpacing: 0,
                                      alignment: WrapAlignment.start,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      direction: Axis.horizontal,
                                      runAlignment: WrapAlignment.start,
                                      verticalDirection: VerticalDirection.down,
                                      clipBehavior: Clip.none,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1, -1),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              if (responsiveVisibility(
                                                context: context,
                                                tablet: false,
                                                tabletLandscape: false,
                                                desktop: false,
                                              ))
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1, 0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 10, 0, 0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(20,
                                                                      0, 0, 0),
                                                          child: Text(
                                                            'Question ${questionindex + 1}',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .title3
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              if (responsiveVisibility(
                                                  context: context,
                                                  phone: false,
                                                  tablet: false))
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1, 0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 10, 0, 0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(20,
                                                                      0, 0, 0),
                                                          child: Text(
                                                            'Question ${questionindex + 1}',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .title3
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            40,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child: Text(
                                                                  'Single Correct Option,',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                ),
                                                              ),
                                                              Text(
                                                                ' +1.00, ',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText1
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      color: Color(
                                                                          0xFF4AAF0D),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                              ),
                                                              Text(
                                                                ' -0.00',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText1
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      color: Color(
                                                                          0xFFDD2D68),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              Divider(
                                                thickness: 1,
                                                color: Color(0xFF918888),
                                              ),
                                              Align(
                                                alignment:
                                                    AlignmentDirectional(-1, 0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 70, 0, 0),
                                                  child: Wrap(
                                                    spacing: 0,
                                                    runSpacing: 0,
                                                    alignment:
                                                        WrapAlignment.start,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .start,
                                                    direction: Axis.horizontal,
                                                    runAlignment:
                                                        WrapAlignment.start,
                                                    verticalDirection:
                                                        VerticalDirection.down,
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1, 0),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(20,
                                                                      0, 0, 30),
                                                          child: Text(
                                                            '${quizdata[questionindex]["question"]}',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    AlignmentDirectional(-1, 0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      A = !A;
                                                      B = false;
                                                      C = false;
                                                      D = false;
                                                    });
                                                    save();
                                                  },
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(20, 0,
                                                                    0, 0),
                                                        child: Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: quizdata[questionindex]
                                                                            [
                                                                            "answeredValue"] ==
                                                                        "A" ||
                                                                    A == true
                                                                ? Color
                                                                    .fromARGB(
                                                                        255,
                                                                        117,
                                                                        255,
                                                                        121)
                                                                : Color(
                                                                    0xFFC9C1C1),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.05, 0),
                                                            child: Text(
                                                              'A',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyText1
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(30,
                                                                      0, 0, 0),
                                                          child: Text(
                                                            '${quizdata[questionindex]["options"][0]}',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 5, 0, 0),
                                                child: Wrap(
                                                  spacing: 0,
                                                  runSpacing: 0,
                                                  alignment:
                                                      WrapAlignment.start,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.start,
                                                  direction: Axis.horizontal,
                                                  runAlignment:
                                                      WrapAlignment.start,
                                                  verticalDirection:
                                                      VerticalDirection.down,
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -1, 0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            B = !B;
                                                            A = false;
                                                            C = false;
                                                            D = false;
                                                          });
                                                          save();
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          20,
                                                                          0,
                                                                          0,
                                                                          0),
                                                              child: Container(
                                                                width: 50,
                                                                height: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: quizdata[questionindex]["answeredValue"] ==
                                                                              "B" ||
                                                                          B ==
                                                                              true
                                                                      ? Color.fromARGB(
                                                                          255,
                                                                          117,
                                                                          255,
                                                                          121)
                                                                      : Color(
                                                                          0xFFC9C1C1),
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.05,
                                                                          0),
                                                                  child: Text(
                                                                    'B',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText1
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              22,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0, 0),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            30,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child: Text(
                                                                  '${quizdata[questionindex]["options"][1]}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    -1, -1),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 5, 0, 0),
                                                  child: Wrap(
                                                    spacing: 0,
                                                    runSpacing: 0,
                                                    alignment:
                                                        WrapAlignment.start,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .start,
                                                    direction: Axis.horizontal,
                                                    runAlignment:
                                                        WrapAlignment.start,
                                                    verticalDirection:
                                                        VerticalDirection.down,
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1, 0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              C = !C;
                                                              B = false;
                                                              A = false;
                                                              D = false;
                                                            });
                                                            save();
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            20,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child:
                                                                    Container(
                                                                  width: 50,
                                                                  height: 50,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: quizdata[questionindex]["answeredValue"] ==
                                                                                "C" ||
                                                                            C ==
                                                                                true
                                                                        ? Color.fromARGB(
                                                                            255,
                                                                            117,
                                                                            255,
                                                                            121)
                                                                        : Color(
                                                                            0xFFC9C1C1),
                                                                  ),
                                                                  child: Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            0.05,
                                                                            0),
                                                                    child: Text(
                                                                      'C',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyText1
                                                                          .override(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontSize:
                                                                                22,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0, 0),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          30,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    '${quizdata[questionindex]["options"][2]}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText1
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                  ),
                                                                ),
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
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 5, 0, 110),
                                                child: Wrap(
                                                  spacing: 0,
                                                  runSpacing: 0,
                                                  alignment:
                                                      WrapAlignment.start,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.start,
                                                  direction: Axis.horizontal,
                                                  runAlignment:
                                                      WrapAlignment.start,
                                                  verticalDirection:
                                                      VerticalDirection.down,
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -1, 0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            D = !D;
                                                            B = false;
                                                            C = false;
                                                            A = false;
                                                          });
                                                          save();
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          20,
                                                                          0,
                                                                          0,
                                                                          0),
                                                              child: Container(
                                                                width: 50,
                                                                height: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: quizdata[questionindex]["answeredValue"] ==
                                                                              "D" ||
                                                                          D ==
                                                                              true
                                                                      ? Color.fromARGB(
                                                                          255,
                                                                          117,
                                                                          255,
                                                                          121)
                                                                      : Color(
                                                                          0xFFC9C1C1),
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.05,
                                                                          0),
                                                                  child: Text(
                                                                    'D',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText1
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              22,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0, 0),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            30,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child: Text(
                                                                  '${quizdata[questionindex]["options"][3]}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                thickness: 1,
                                                color: Color(0xFF918888),
                                              ),
                                              if (responsiveVisibility(
                                                context: context,
                                                phone: false,
                                                tablet: false,
                                                tabletLandscape: false,
                                                desktop: false,
                                              ))
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 92.8,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1, 0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            10,
                                                                            0),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    saveNext();
                                                                  },
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () {
                                                                      print(
                                                                          'Button pressed ...');
                                                                    },
                                                                    text:
                                                                        'SAVE & NEXT',
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          30,
                                                                      color: Color(
                                                                          0xFF0AAB4E),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .subtitle2
                                                                          .override(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                          ),
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  saveNext();
                                                                },
                                                                child:
                                                                    FFButtonWidget(
                                                                  onPressed:
                                                                      () {
                                                                    print(
                                                                        'Button pressed ...');
                                                                  },
                                                                  text:
                                                                      'MARK FOR REVIEW & NEXT',
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width: 180,
                                                                    height: 30,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .subtitle2
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width: 0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      A = false;
                                                                      B = false;
                                                                      C = false;
                                                                      D = false;
                                                                    });
                                                                  },
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () {
                                                                      print(
                                                                          'Button pressed ...');
                                                                    },
                                                                    text:
                                                                        'CLEAR RESPONSE',
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width:
                                                                          125,
                                                                      height:
                                                                          30,
                                                                      color: Color(
                                                                          0xFF9A98A9),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .subtitle2
                                                                          .override(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                          ),
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child: Text(
                                                                  'Report an error',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1, 0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                        () {
                                                                          if (questionindex !=
                                                                              0) {
                                                                            questionindex -=
                                                                                1;
                                                                            saveNext();
                                                                          }
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        FFButtonWidget(
                                                                      onPressed:
                                                                          () {
                                                                        print(
                                                                            'Button pressed ...');
                                                                      },
                                                                      text:
                                                                          'PREVIOUS',
                                                                      options:
                                                                          FFButtonOptions(
                                                                        width:
                                                                            90,
                                                                        height:
                                                                            30,
                                                                        color: Color(
                                                                            0xFF918888),
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .subtitle2
                                                                            .override(
                                                                              fontFamily: 'Poppins',
                                                                              color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.transparent,
                                                                          width:
                                                                              1,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          if (questionindex !=
                                                                              quizdata.length) {
                                                                            questionindex +=
                                                                                1;
                                                                          }
                                                                        });
                                                                      },
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          questionindex +=
                                                                              1;
                                                                        },
                                                                        child:
                                                                            FFButtonWidget(
                                                                          onPressed:
                                                                              () {
                                                                            print('Button pressed ...');
                                                                          },
                                                                          text:
                                                                              'NEXT QUESTION',
                                                                          options:
                                                                              FFButtonOptions(
                                                                            width:
                                                                                115,
                                                                            height:
                                                                                30,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryColor,
                                                                            textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                                                                                  fontFamily: 'Poppins',
                                                                                  color: Colors.white,
                                                                                  fontSize: 10,
                                                                                  fontWeight: FontWeight.normal,
                                                                                ),
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Colors.transparent,
                                                                              width: 1,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    submit();
                                                                  },
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () {
                                                                      submit();
                                                                    },
                                                                    text:
                                                                        'SUBMIT',
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width: 90,
                                                                      height:
                                                                          30,
                                                                      color: Color(
                                                                          0xFF00C356),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .subtitle2
                                                                          .override(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                          ),
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xFFC39A9A),
                                                                        width:
                                                                            0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              GestureDetector(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 300,
                                                  decoration: BoxDecoration(),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        10,
                                                                        0,
                                                                        10,
                                                                        0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                saveNext();
                                                              },
                                                              child: Container(
                                                                width: 100,
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xFF0A9E04),
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0, 0),
                                                                  child: Text(
                                                                    'SAVE & NEXT',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText1
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBtnText,
                                                                          fontSize:
                                                                              10,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                markreview =
                                                                    true;
                                                                saveNext();
                                                              },
                                                              child: Container(
                                                                width: 100,
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0, 0),
                                                                  child: Text(
                                                                    'MARK FOR REVIEW',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText1
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBtnText,
                                                                          fontSize:
                                                                              10,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                A = false;
                                                                B = false;
                                                                C = false;
                                                                D = false;
                                                                quizdata[questionindex]
                                                                        [
                                                                        "Answered"] =
                                                                    false;
                                                                quizdata[questionindex]
                                                                        [
                                                                        'notAnswered'] =
                                                                    true;
                                                                quizdata[questionindex]
                                                                        [
                                                                        'answeredValue'] =
                                                                    null;
                                                                countParameter(
                                                                    'save');
                                                              });
                                                            },
                                                            child: Expanded(
                                                              flex: 1,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10,
                                                                            0,
                                                                            10,
                                                                            0),
                                                                child:
                                                                    Container(
                                                                  width: 100,
                                                                  height: 40,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0xFF868585),
                                                                  ),
                                                                  child: Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                      'CLEAR RESPONCE',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyText1
                                                                          .override(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryBtnText,
                                                                            fontSize:
                                                                                10,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 10,
                                                                    0, 0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10,
                                                                            0,
                                                                            10,
                                                                            0),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      if (questionindex !=
                                                                          0) {
                                                                        saveNext();
                                                                        questionindex -=
                                                                            2;
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 100,
                                                                    height: 40,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xFF0A9E04),
                                                                    ),
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          AlignmentDirectional(
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Text(
                                                                        'PREVIOUS',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyText1
                                                                            .override(
                                                                              fontFamily: 'Poppins',
                                                                              color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                              fontSize: 10,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10,
                                                                            0,
                                                                            10,
                                                                            0),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      if (quizdata
                                                                              .length !=
                                                                          questionindex +
                                                                              1) {
                                                                        questionindex +=
                                                                            1;
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        saveNext();
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          40,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Color(
                                                                            0xFF868585),
                                                                      ),
                                                                      child:
                                                                          Align(
                                                                        alignment: AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Text(
                                                                          'NEXT QUESTION',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyText1
                                                                              .override(
                                                                                fontFamily: 'Poppins',
                                                                                color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                                fontSize: 10,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0.05),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(0,
                                                                      60, 0, 0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0, 1),
                                                                child: Text(
                                                                  '   Report an error',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                      ),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.1,
                                                                        0.15),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      submit();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          40,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Color(
                                                                            0xFF0A9E04),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              Colors.transparent,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Align(
                                                                        alignment: AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Text(
                                                                          'SUBMIT',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyText1
                                                                              .override(
                                                                                fontFamily: 'Poppins',
                                                                                color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
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
                              ),
                              if (responsiveVisibility(
                                context: context,
                                phone: false,
                                tablet: false,
                                tabletLandscape: false,
                              ))
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 100,
                                    height:
                                        MediaQuery.of(context).size.height * 1,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      border: Border.all(
                                        color: Color(0x95000000),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(20, 20, 0, 0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF19F80F),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0),
                                                        child: Text(
                                                          '$answeredM',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBtnText,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10, 0, 0, 0),
                                                      child: Text(
                                                        'Answered',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyText1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(20, 20, 0, 0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0),
                                                        child: Text(
                                                          '$notAnsweredM',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBtnText,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(10, 0,
                                                                    0, 0),
                                                        child: Text(
                                                          'Not Answered',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(20, 20, 0, 0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0x8F57636C),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0),
                                                        child: Text(
                                                          '$notVisitedM',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBtnText,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(10, 0,
                                                                    0, 0),
                                                        child: Text(
                                                          'Not Visited',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(20, 20, 0, 0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryColor,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0),
                                                        child: Text(
                                                          '$MFR_M',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBtnText,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: GestureDetector(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(10,
                                                                      0, 0, 0),
                                                          child: Text(
                                                            'Marked For \nReview',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyText1,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 50),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(20, 20, 0, 0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 50,
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0x8F1487DD),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0, 0),
                                                          child: Text(
                                                            '$AMFR_M',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBtnText,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(10,
                                                                      0, 0, 0),
                                                          child: Text(
                                                            'Answered & Marked For Review\n( will be considered for evaluation)',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyText1,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(-1, 0),
                                            child: Container(
                                              width: 400,
                                              height: 300,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBtnText,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(20, 20, 20, 20),
                                                child: GridView.builder(
                                                  padding: EdgeInsets.zero,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 6,
                                                    crossAxisSpacing: 10,
                                                    mainAxisSpacing: 10,
                                                    childAspectRatio: 1,
                                                  ),
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: quizdata.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    print(quizdata[index]
                                                        ['AMRF']);
                                                    return Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color: (quizdata[index]['AMFR'] !=
                                                                    null &&
                                                                quizdata[index]['AMFR'] !=
                                                                    false
                                                            ? Color.fromARGB(
                                                                255, 80, 142, 218)
                                                            : quizdata[index]['MFR'] !=
                                                                        null &&
                                                                    quizdata[index]['MFR'] !=
                                                                        false
                                                                ? Color.fromARGB(
                                                                    255, 50, 41, 219)
                                                                : quizdata[index]['Answered'] != null &&
                                                                        quizdata[index]['Answered'] !=
                                                                            false
                                                                    ? Color.fromARGB(
                                                                        255,
                                                                        5,
                                                                        217,
                                                                        76)
                                                                    : quizdata[index]['notAnswered'] != null &&
                                                                            quizdata[index]['notAnswered'] != false
                                                                        ? Color.fromARGB(255, 233, 26, 26)
                                                                        : quizdata[index]['visited'] == null
                                                                            ? Color.fromARGB(255, 207, 196, 196)
                                                                            : Color.fromARGB(255, 207, 196, 196)),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0),
                                                        child: Text(
                                                          '${index + 1}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBtnText,
                                                              ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (responsiveVisibility(
                                context: context,
                                phone: false,
                                desktop: false,
                              ))
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 100,
                                    height:
                                        MediaQuery.of(context).size.height * 1,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      border: Border.all(
                                        color: Color(0x95000000),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20, 20, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0, 0),
                                                  child: Text(
                                                    '$notAnsweredM',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBtnText,
                                                          fontSize: 12,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(10, 0, 0, 0),
                                                child: Text(
                                                  'Not nswered',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 12,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 20, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF19F80F),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0, 0),
                                                      child: Text(
                                                        '$answeredM',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBtnText,
                                                                  fontSize: 12,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                10, 0, 0, 0),
                                                    child: Text(
                                                      'Answered',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 12,
                                                              ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 20, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: Color(0x8F57636C),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0, 0),
                                                      child: Text(
                                                        '$notVisitedM',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBtnText,
                                                                  fontSize: 12,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                10, 0, 0, 0),
                                                    child: Text(
                                                      'Not Visited',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 12,
                                                              ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20, 20, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0, 0),
                                                  child: Text(
                                                    '$MFR_M',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBtnText,
                                                          fontSize: 12,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(10, 0, 0, 0),
                                                child: Text(
                                                  'Marked For\n Review',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 12,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 50),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(20, 20, 0, 0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0x8F1487DD),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0, 0),
                                                          child: Text(
                                                            '$AMFR_M',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBtnText,
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(10,
                                                                      0, 10, 0),
                                                          child: Text(
                                                            'Answered & Marked For Review\n(will be considered for evaluation)',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 400,
                                          height: 300,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBtnText,
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 20, 20, 20),
                                            child: GridView.builder(
                                              padding: EdgeInsets.zero,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 6,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                                childAspectRatio: 1,
                                              ),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: quizdata.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF19F80F),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0, 0),
                                                    child: Text(
                                                      '2',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBtnText,
                                                              ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
        submitvalue
            ? Center(
                child: Container(
                  width: 700,
                  height: 400,
                  color: Color.fromARGB(26, 195, 64, 64),
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
            : Container()
      ]),
    );
  }
}
