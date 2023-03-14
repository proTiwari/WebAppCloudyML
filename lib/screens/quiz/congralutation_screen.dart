import 'package:cloudyml_app2/screens/quiz/quizsolution.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../flutter_flow/flutter_flow_theme.dart';
// import 'certificate.dart';

class CongratulationsWidget extends StatefulWidget {
  var quizdata;
  var total;

  var unanswered;
  var correctanswered;
  var wronganswered;
  CongratulationsWidget(this.quizdata, this.total, this.unanswered,
      this.wronganswered, this.correctanswered,
      {Key? key})
      : super(key: key);

  @override
  _CongratulationsWidgetState createState() => _CongratulationsWidgetState();
}

class _CongratulationsWidgetState extends State<CongratulationsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _downloadImage() async {
    await WebImageDownloader.downloadImageFromWeb("https://picsum.photos/200");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 5,
                      child: Container(
                        width: 1119.5,
                        height: MediaQuery.of(context).size.height * 0.85,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 140, 0, 0),
                                  child: Image.asset(
                                    'assets/cloud.jpeg',
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 40, 0, 0),
                                    child: widget.total < 70
                                        ? Text(
                                            'Better Luck Next Time!',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                          )
                                        : Text(
                                            'Congratulations!',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 130,
                                  width: 130,
                                  margin: EdgeInsets.all(0.0),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Text(
                                      "${double.parse(widget.total.toString()).toStringAsFixed(2)}%",
                                      style: TextStyle(color: Colors.white, fontSize: 27),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Text(
                                //   'You won our certificate of data scientist',
                                //   style: FlutterFlowTheme.of(context)
                                //       .bodyText1
                                //       .override(
                                //         fontFamily: 'Poppins',
                                //         fontWeight: FontWeight.normal,
                                //       ),
                                // ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 30, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     _downloadImage();
                                      //     // Navigator.pushReplacement(
                                      //     //     context,
                                      //     //     MaterialPageRoute(
                                      //     //         builder: (context) =>
                                      //     //             Certificate()));
                                      //   },
                                      //   child: Padding(
                                      //     padding:
                                      //         EdgeInsetsDirectional.fromSTEB(
                                      //             0, 0, 10, 0),
                                      //     child: Container(
                                      //       width: 260,
                                      //       height: 50,
                                      //       decoration: BoxDecoration(
                                      //         color:
                                      //             FlutterFlowTheme.of(context)
                                      //                 .primaryColor,
                                      //         borderRadius:
                                      //             BorderRadius.circular(50),
                                      //         shape: BoxShape.rectangle,
                                      //       ),
                                      //       child: Align(
                                      //         alignment:
                                      //             AlignmentDirectional(0.05, 0),
                                      //         child: Text(
                                      //           'Download Certificate',
                                      //           style:
                                      //               FlutterFlowTheme.of(context)
                                      //                   .bodyText1
                                      //                   .override(
                                      //                     fontFamily: 'Poppins',
                                      //                     color: FlutterFlowTheme
                                      //                             .of(context)
                                      //                         .primaryBtnText,
                                      //                     fontSize: 17,
                                      //                   ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      InkWell(
                                        onTap: () {
                                          print(
                                              "ppppkkklklll ${widget.quizdata}");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  QuizSolutionCopyWidget(
                                                      widget.quizdata,
                                                      widget.total,
                                                      widget.unanswered,
                                                      widget.wronganswered,
                                                      widget.correctanswered),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10, 0, 0, 0),
                                          child: Container(
                                            width: 160,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBtnText,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryColor,
                                              ),
                                            ),
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0.05, 0),
                                              child: Text(
                                                'View Solutions',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryColor,
                                                          fontSize: 17,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Align(
                //   alignment: AlignmentDirectional(0, 0.4),
                //   child: Padding(
                //     padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                //     child: Lottie.asset(
                //       'assets/cong.json',
                //       width: MediaQuery.of(context).size.width * 0.7,
                //       height: MediaQuery.of(context).size.height * 0.7,
                //       fit: BoxFit.cover,
                //       frameRate: FrameRate(18260),
                //       repeat: false,
                //       animate: true,
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
