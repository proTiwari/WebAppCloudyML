import 'package:cloudyml_app2/homepage.dart';
import 'package:go_router/go_router.dart';

import '../../home.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class QuizSolutionCopyWidget extends StatefulWidget {
  var quizdata;
  var total;
  var unanswered;
  var wronganswered;
  var correctanswered;
  QuizSolutionCopyWidget(this.quizdata, this.total, this.unanswered,
      this.wronganswered, this.correctanswered,
      {Key? key})
      : super(key: key);

  @override
  _QuizSolutionCopyWidgetState createState() => _QuizSolutionCopyWidgetState();
}

class _QuizSolutionCopyWidgetState extends State<QuizSolutionCopyWidget> {
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

  @override
  Widget build(BuildContext context) {
    print("jhjijefij: ${widget.quizdata}");
    print("answer: ${widget.quizdata[0]['options']}");
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Align(
            alignment: AlignmentDirectional(0.05, 0),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Align(
                        //   alignment: AlignmentDirectional(-0.7, 0),
                        //   child: Padding(
                        //     padding:
                        //         EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                        //     child: Row(
                        //       mainAxisSize: MainAxisSize.min,
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       children: [
                        //         // Container(
                        //         //   width: 220,
                        //         //   height: 50,
                        //         //   decoration: BoxDecoration(
                        //         //     color: FlutterFlowTheme.of(context)
                        //         //         .secondaryBackground,
                        //         //   ),
                        //         //   child: Theme(
                        //         //     data: ThemeData(
                        //         //       unselectedWidgetColor: Color(0xFF95A1AC),
                        //         //     ),
                        //         //     child: CheckboxListTile(
                        //         //       value: true,
                        //         //       onChanged: (newValue) async {},
                        //         //       title: Text(
                        //         //         'All Solutions',
                        //         //         style: FlutterFlowTheme.of(context)
                        //         //             .title3
                        //         //             .override(
                        //         //               fontFamily: 'Poppins',
                        //         //               fontSize: 16,
                        //         //             ),
                        //         //       ),
                        //         //       tileColor: Color(0xFFF5F5F5),
                        //         //       activeColor: FlutterFlowTheme.of(context)
                        //         //           .primaryColor,
                        //         //       dense: false,
                        //         //       controlAffinity:
                        //         //           ListTileControlAffinity.trailing,
                        //         //     ),
                        //         //   ),
                        //         // ),
                        //         // Container(
                        //         //   width: 260,
                        //         //   height: 50,
                        //         //   decoration: BoxDecoration(
                        //         //     color: FlutterFlowTheme.of(context)
                        //         //         .secondaryBackground,
                        //         //   ),
                        //         //   child: Theme(
                        //         //     data: ThemeData(
                        //         //       unselectedWidgetColor: Color(0xFF95A1AC),
                        //         //     ),
                        //         //     child: CheckboxListTile(
                        //         //       value: true,
                        //         //       onChanged: (newValue) async {},
                        //         //       title: Text(
                        //         //         'Wrong Answered',
                        //         //         style: FlutterFlowTheme.of(context)
                        //         //             .title3
                        //         //             .override(
                        //         //               fontFamily: 'Poppins',
                        //         //               fontSize: 16,
                        //         //             ),
                        //         //       ),
                        //         //       tileColor: Color(0xFFF5F5F5),
                        //         //       activeColor: FlutterFlowTheme.of(context)
                        //         //           .primaryColor,
                        //         //       dense: false,
                        //         //       controlAffinity:
                        //         //           ListTileControlAffinity.trailing,
                        //         //     ),
                        //         //   ),
                        //         // ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Align(
                          alignment: AlignmentDirectional(-0.7, 0),
                          child: Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                            child: Container(
                              width: 200,
                              height: 50,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.05, 0),
                                child: Text(
                                  'Total Obtained ${widget.total}%',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF41E150),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.3, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-1, -1),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 50, 0, 0),
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Align(
                                      alignment: AlignmentDirectional(0.05, 0),
                                      child: Text(
                                        'Right ${widget.correctanswered}',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1
                                            .override(
                                          fontFamily: 'Poppins',
                                          color: Color(0xFF41E150),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.05, 0),
                                    child: Text(
                                      'Wrong ${widget.wronganswered}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFFDF3F3F),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.05, 0),
                                    child: Text(
                                      'Unanswered ${widget.unanswered}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFFD0C400),
                                        fontSize: 16,
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 20, 20, 20),
                                child: Container(
                                  width:
                                  MediaQuery.of(context).size.width * 0.7,
                                  height:
                                  MediaQuery.of(context).size.height * 0.85,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(-0.15, 0),
                                    child: ListView.builder(
                                      itemCount: widget.quizdata.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Row(
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
                                                            'Question ${index + 1}',
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
                                                    Divider(
                                                      thickness: 1,
                                                      color: Color(0xFF918888),
                                                    ),
                                                    Align(
                                                      alignment:
                                                      AlignmentDirectional(
                                                          -1, 0),
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0, 70,
                                                            0, 0),
                                                        child: Wrap(
                                                          spacing: 0,
                                                          runSpacing: 0,
                                                          alignment:
                                                          WrapAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .start,
                                                          direction:
                                                          Axis.horizontal,
                                                          runAlignment:
                                                          WrapAlignment
                                                              .start,
                                                          verticalDirection:
                                                          VerticalDirection
                                                              .down,
                                                          clipBehavior:
                                                          Clip.none,
                                                          children: [
                                                            Align(
                                                              alignment:
                                                              AlignmentDirectional(
                                                                  -1, 0),
                                                              child: Padding(
                                                                padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    20,
                                                                    0,
                                                                    0,
                                                                    30),
                                                                child: Text(
                                                                  "${widget.quizdata[index]['question']}",
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
                                                                    17,
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
                                                    Align(
                                                      alignment:
                                                      AlignmentDirectional(
                                                          -1, 0),
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
                                                                color: widget
                                                                    .quizdata[
                                                                index]
                                                                [
                                                                'answerIndex']
                                                                    .contains(
                                                                    'A')
                                                                    ? Color
                                                                    .fromARGB(
                                                                    255,
                                                                    42,
                                                                    174,
                                                                    119)
                                                                    : widget.quizdata[index]['answeredValue'] ==
                                                                    'A'
                                                                    ? Color.fromARGB(
                                                                    255,
                                                                    176,
                                                                    26,
                                                                    26)
                                                                    : Color(
                                                                    0xFFC9C1C1),
                                                              ),
                                                              child: Align(
                                                                alignment:
                                                                AlignmentDirectional(
                                                                    0.05,
                                                                    0),
                                                                child: Text(
                                                                  'A',
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
                                                                '${widget.quizdata[index]['options']['A']}',
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
                                                                  FontWeight
                                                                      .normal,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 5, 0, 0),
                                                      child: Wrap(
                                                        spacing: 0,
                                                        runSpacing: 0,
                                                        alignment:
                                                        WrapAlignment.start,
                                                        crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .start,
                                                        direction:
                                                        Axis.horizontal,
                                                        runAlignment:
                                                        WrapAlignment.start,
                                                        verticalDirection:
                                                        VerticalDirection
                                                            .down,
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Align(
                                                            alignment:
                                                            AlignmentDirectional(
                                                                -1, 0),
                                                            child: Row(
                                                              mainAxisSize:
                                                              MainAxisSize
                                                                  .min,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
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
                                                                      color: widget.quizdata[index]['answerIndex'].contains(
                                                                          'B')
                                                                          ? Color.fromARGB(
                                                                          255,
                                                                          42,
                                                                          174,
                                                                          119)
                                                                          : widget.quizdata[index]['answeredValue'] == 'B'
                                                                          ? Color.fromARGB(255, 176, 26, 26)
                                                                          : Color(0xFFC9C1C1),
                                                                    ),
                                                                    child:
                                                                    Align(
                                                                      alignment:
                                                                      AlignmentDirectional(
                                                                          0.05,
                                                                          0),
                                                                      child:
                                                                      Text(
                                                                        'B',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyText1
                                                                            .override(
                                                                          fontFamily: 'Poppins',
                                                                          fontSize: 22,
                                                                          fontWeight: FontWeight.normal,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                  AlignmentDirectional(
                                                                      0, 0),
                                                                  child:
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        30,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                    child: Text(
                                                                      '${widget.quizdata[index]['options']['B']}',
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
                                                        ],
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                      AlignmentDirectional(
                                                          -1, -1),
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 5, 0, 0),
                                                        child: Wrap(
                                                          spacing: 0,
                                                          runSpacing: 0,
                                                          alignment:
                                                          WrapAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .start,
                                                          direction:
                                                          Axis.horizontal,
                                                          runAlignment:
                                                          WrapAlignment
                                                              .start,
                                                          verticalDirection:
                                                          VerticalDirection
                                                              .down,
                                                          clipBehavior:
                                                          Clip.none,
                                                          children: [
                                                            Align(
                                                              alignment:
                                                              AlignmentDirectional(
                                                                  -1, 0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        20,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                    child:
                                                                    Container(
                                                                      width: 50,
                                                                      height:
                                                                      50,
                                                                      decoration:
                                                                      BoxDecoration(
                                                                        color: widget.quizdata[index]['answerIndex'].contains(
                                                                            'C')
                                                                            ? Color.fromARGB(
                                                                            255,
                                                                            42,
                                                                            174,
                                                                            119)
                                                                            : widget.quizdata[index]['answeredValue'] == 'C'
                                                                            ? Color.fromARGB(255, 176, 26, 26)
                                                                            : Color(0xFFC9C1C1),
                                                                      ),
                                                                      child:
                                                                      Align(
                                                                        alignment: AlignmentDirectional(
                                                                            0.05,
                                                                            0),
                                                                        child:
                                                                        Text(
                                                                          'C',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyText1
                                                                              .override(
                                                                            fontFamily: 'Poppins',
                                                                            fontSize: 22,
                                                                            fontWeight: FontWeight.normal,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                    AlignmentDirectional(
                                                                        0,
                                                                        0),
                                                                    child:
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          30,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                      child:
                                                                      Text(
                                                                        '${widget.quizdata[index]['options']['C']}',
                                                                        textAlign:
                                                                        TextAlign.start,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyText1
                                                                            .override(
                                                                          fontFamily: 'Poppins',
                                                                          fontSize: 20,
                                                                          fontWeight: FontWeight.normal,
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
                                                    Padding(
                                                      padding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 5, 0, 70),
                                                      child: Wrap(
                                                        spacing: 0,
                                                        runSpacing: 0,
                                                        alignment:
                                                        WrapAlignment.start,
                                                        crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .start,
                                                        direction:
                                                        Axis.horizontal,
                                                        runAlignment:
                                                        WrapAlignment.start,
                                                        verticalDirection:
                                                        VerticalDirection
                                                            .down,
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Align(
                                                            alignment:
                                                            AlignmentDirectional(
                                                                -1, 0),
                                                            child: Row(
                                                              mainAxisSize:
                                                              MainAxisSize
                                                                  .min,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
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
                                                                      color: widget.quizdata[index]['answerIndex'].contains(
                                                                          'D')
                                                                          ? Color.fromARGB(
                                                                          255,
                                                                          42,
                                                                          174,
                                                                          119)
                                                                          : widget.quizdata[index]['answeredValue'] == 'D'
                                                                          ? Color.fromARGB(255, 176, 26, 26)
                                                                          : Color(0xFFC9C1C1),
                                                                    ),
                                                                    child:
                                                                    Align(
                                                                      alignment:
                                                                      AlignmentDirectional(
                                                                          0.05,
                                                                          0),
                                                                      child:
                                                                      Text(
                                                                        'D',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyText1
                                                                            .override(
                                                                          fontFamily: 'Poppins',
                                                                          fontSize: 22,
                                                                          fontWeight: FontWeight.normal,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                  AlignmentDirectional(
                                                                      0, 0),
                                                                  child:
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        30,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                    child: Text(
                                                                      '${widget.quizdata[index]['options']['D']}',
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
                                                        ],
                                                      ),
                                                    ),
                                                    widget.quizdata[index]
                                                    ['quizlevel'] ==
                                                        'modulelevel'
                                                        ? Divider(
                                                      thickness: 1,
                                                      color: Color(
                                                          0xFF918888),
                                                    )
                                                        : SizedBox(),
                                                    widget.quizdata[index]
                                                    ['quizlevel'] ==
                                                        'modulelevel'
                                                        ? Container(
                                                      width:
                                                      MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width,
                                                      height: 92.8,
                                                      decoration:
                                                      BoxDecoration(
                                                        color: FlutterFlowTheme
                                                            .of(context)
                                                            .secondaryBackground,
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                        MainAxisSize
                                                            .max,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                            MainAxisSize
                                                                .min,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    20,
                                                                    0,
                                                                    0,
                                                                    0),
                                                                child:
                                                                Text(
                                                                  'Solution ${index + 1}',
                                                                  style: FlutterFlowTheme.of(context)
                                                                      .title3
                                                                      .override(
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.normal,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                            MainAxisSize
                                                                .min,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    20,
                                                                    0,
                                                                    0,
                                                                    0),
                                                                child:
                                                                Text(
                                                                  '${widget.quizdata[index]['solution']}',
                                                                  style: FlutterFlowTheme.of(context)
                                                                      .bodyText1
                                                                      .override(
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.normal,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                        : SizedBox(),
                                                    Container(
                                                      width:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      height: 300,
                                                      decoration:
                                                      BoxDecoration(),
                                                    ),
                                                  ]),
                                              // Padding(
                                              //   padding: EdgeInsetsDirectional
                                              //       .fromSTEB(50, 50, 50, 50),
                                              //   child: Container(
                                              //     width: 200,
                                              //     height: 50,
                                              //     decoration: BoxDecoration(
                                              //       color: FlutterFlowTheme.of(
                                              //               context)
                                              //           .primaryColor,
                                              //     ),
                                              //     child: Align(
                                              //       alignment:
                                              //           AlignmentDirectional(
                                              //               0, 0),
                                              //       child: Text(
                                              //         'Back to courses',
                                              //         style:
                                              //             FlutterFlowTheme.of(
                                              //                     context)
                                              //                 .bodyText1
                                              //                 .override(
                                              //                   fontFamily:
                                              //                       'Poppins',
                                              //                   color: FlutterFlowTheme.of(
                                              //                           context)
                                              //                       .primaryBtnText,
                                              //                   fontSize: 16,
                                              //                 ),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
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
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: (() {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => HomePage()));
                  }),
                  child: Align(
                    alignment: AlignmentDirectional(0.95, 0.95),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 1,
                      shape: const CircleBorder(),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color:
                          FlutterFlowTheme.of(context).secondaryBackground,
                          shape: BoxShape.circle,
                        ),
                        alignment: AlignmentDirectional(0, 0),
                        child: Icon(
                          Icons.home,
                          color: FlutterFlowTheme.of(context).primaryColor,
                          size: 30,
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
