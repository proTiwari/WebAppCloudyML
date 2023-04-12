import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/screens/quiz/quiz_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'model/quiztrackmodel.dart';

class InstructionspageWidget extends StatefulWidget {
  var quizdata;
  InstructionspageWidget(this.quizdata, {Key? key}) : super(key: key);

  @override
  _InstructionspageWidgetState createState() => _InstructionspageWidgetState();
}

class _InstructionspageWidgetState extends State<InstructionspageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  checkQuizStatusOrNavigate() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      try {
        var data = value.data()!['quiztrack'];
        bool attemptingquizforthefirsttime = true;
        for (var i in data) {
          if (i != null) {
            i = QuizTrackModel.fromJson(i);
            print(i.quizname);
            print(widget.quizdata['name']);
            try {
              if (i!.quizname == widget.quizdata['name']) {
                attemptingquizforthefirsttime = false;
                print("quiz found");
                if (i.quizCleared == true) {
                  print("quiz cleared");
                  showToast('You have already aced this quiz!',
                      context: context,
                      animation: StyledToastAnimation.slideFromBottom,
                      reverseAnimation: StyledToastAnimation.slideToBottom,
                      position: StyledToastPosition.bottom,
                      animDuration: Duration(seconds: 1),
                      duration: Duration(seconds: 4),
                      curve: Curves.elasticOut,
                      reverseCurve: Curves.fastOutSlowIn);
                }

                // condition for quiz not cleared
                if (i.quizCleared == false) {
                  print("quiz not cleared");
                  // condition for course quiz
                  if (i.quizlevel == "courselevel") {
                    if (i.quizAttemptGapForCourseQuiz!
                            .compareTo(DateTime.now()) <
                        0) {
                      print("quiz attempt gap over");
                      print(i.quizAttemptGapForCourseQuiz);
                      print(DateTime.now());
                      // navigate to quiz page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuizPage(widget.quizdata)));
                    } else {
                      print("quiz attempt gap not over");
                      showToast(
                          'You can attempt this quiz after ${i.quizAttemptGapForCourseQuiz}',
                          context: context,
                          animation: StyledToastAnimation.slideFromBottom,
                          reverseAnimation: StyledToastAnimation.slideToBottom,
                          position: StyledToastPosition.bottom,
                          animDuration: Duration(seconds: 1),
                          duration: Duration(seconds: 4),
                          curve: Curves.elasticOut,
                          reverseCurve: Curves.fastOutSlowIn);
                    }
                  } else {
                    print("quiz attempt gap not over");
                    // condition for modular quiz
                    if (i.quizAttemptGapForModularQuiz!
                            .compareTo(DateTime.now()) <
                        0) {
                      // navigate to quiz page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuizPage(widget.quizdata)));
                    } else {
                      print('quiz attempt gap not over');
                      showToast(
                          'You can attempt this quiz after ${i.quizAttemptGapForModularQuiz}',
                          context: context,
                          animation: StyledToastAnimation.slideFromBottom,
                          reverseAnimation: StyledToastAnimation.slideToBottom,
                          position: StyledToastPosition.bottom,
                          animDuration: Duration(seconds: 1),
                          duration: Duration(seconds: 4),
                          curve: Curves.elasticOut,
                          reverseCurve: Curves.fastOutSlowIn);
                    }
                  }
                }
              }
            } catch (e) {
              print("error id: ifwjoefjwoeivfff: ${e.toString()}");
            }
          }
        }
        if (attemptingquizforthefirsttime) {
          print("quiz is taken for the first time");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuizPage(widget.quizdata)));
        }
      } catch (e) {
        print("error id: efwefwe3223232: ${e.toString()}");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => QuizPage(widget.quizdata)));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Align(
            alignment: AlignmentDirectional(0, -0.35),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 5,
                      child: Container(
                        width: 800,
                        height: 540,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 10),
                                child: Text(
                                  'Quiz Instructions\nThe quizzes consists of questions carefully designed to help you self-assess your comprehension of the information presented on the topics covered in the module. No data will be collected on the website regarding your responses or how many times you take the quiz.\n\nEach question in the quiz is of multiple-choice or \"true or false\" format. Read each question carefully, and click on the button next to your response that is based on the information covered on the topic in the module. Each correct or incorrect response will result in appropriate feedback immediately at the bottom of the screen.\n\nAfter responding to a question, click on the \"Next Question\" button at the bottom to go to the next questino. After responding to the 8th question, click on \"Close\" on the top of the window to exit the quiz.\n\nIf you select an incorrect response for a question, you can try again until you get the correct response. If you retake the quiz, the questions and their respective responses will be randomized.\n\nThe total score for the quiz is based on your responses to all questions. If you respond incorrectly to a question or retake a question again and get the correct response, your quiz score will reflect it appropriately. However, your quiz will not be graded, if you skip a question or exit before responding to all the questions.\n\nQuiz Instructions\nThe quizzes consists of questions carefully designed to help you self-assess your comprehension of the information presented on the topics covered in the module. No data will be collected on the website regarding your responses or how many times you take the quiz.\n\nEach question in the quiz is of multiple-choice or \"true or false\" format. Read each question carefully, and click on the button next to your response that is based on the information covered on the topic in the module. Each correct or incorrect response will result in appropriate feedback immediately at the bottom of the screen.\n\nAfter responding to a question, click on the \"Next Question\" button at the bottom to go to the next questino. After responding to the 8th question, click on \"Close\" on the top of the window to exit the quiz.\n\nIf you select an incorrect response for a question, you can try again until you get the correct response. If you retake the quiz, the questions and their respective responses will be randomized.\n\nThe total score for the quiz is based on your responses to all questions. If you respond incorrectly to a question or retake a question again and get the correct response, your quiz score will reflect it appropriately. However, your quiz will not be graded, if you skip a question or exit before responding to all the questions.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Poppins',
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0, -0.2),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 10, 10, 10),
                                  child: GestureDetector(
                                    onTap: (() {
                                       checkQuizStatusOrNavigate();
                                      // GoRouter.of(context)
                                      //     .pushNamed('/quizpage', queryParams: {
                                      //   'data': "${widget.quizdata}"
                                      // });
                                    }),
                                    child: Container(
                                      width: 780,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryColor,
                                        ),
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(-0.05, 0),
                                        child: Text(
                                          'Start',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Poppins',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
