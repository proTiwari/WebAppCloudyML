// import '../flutter_flow/flutter_flow_theme.dart';
// import '../flutter_flow/flutter_flow_util.dart';
// import '../flutter_flow/flutter_flow_widgets.dart';
// import '../flutter_flow/random_data_util.dart' as random_data;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Align(
            alignment: AlignmentDirectional(-0.05, -0.25),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: AlignmentDirectional(-1, -1),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(120, 10, 0, 0),
                            child: Text(
                              'R Certification Quiz',
                              // style: FlutterFlowTheme.of(context)
                              //     .bodyText1
                              //     .override(
                              //       fontFamily: 'Poppins',
                              //       color: valueOrDefault<Color>(
                              //         random_data.randomColor(),
                              //         FlutterFlowTheme.of(context).primaryColor,
                              //       ),
                              //       fontSize: 18,
                              //       fontWeight: FontWeight.normal,
                              //     ),
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 0,
                        runSpacing: 0,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        direction: Axis.horizontal,
                        runAlignment: WrapAlignment.start,
                        verticalDirection: VerticalDirection.down,
                        clipBehavior: Clip.none,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Container(
                              width: 387.6,
                              height: 62.4,
                              decoration: BoxDecoration(
                                // color: FlutterFlowTheme.of(context)
                                //     .primaryBackground,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 10, 10, 0),
                                    child: Icon(
                                      Icons.fullscreen_exit_sharp,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 10, 0, 0),
                                    child: Text(
                                      'Remaining Time:',
                                      textAlign: TextAlign.start,
                                      // style: FlutterFlowTheme.of(context)
                                      //     .title3
                                      //     .override(
                                      //       fontFamily: 'Poppins',
                                      //       fontSize: 18,
                                      //     ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 10, 120, 0),
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      // color: FlutterFlowTheme.of(context)
                                      //     .primaryColor,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16, 10, 16, 10),
                                          child: Text(
                                            '00:28:45',
                                            textAlign: TextAlign.center,
                                            // style: FlutterFlowTheme.of(context)
                                            //     .title3
                                            //     .override(
                                            //       fontFamily: 'Poppins',
                                            //       color: FlutterFlowTheme.of(
                                            //               context)
                                            //           .primaryBackground,
                                            //       fontSize: 17,
                                            //     ),
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
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Container(
                    width: 1443.1,
                    height: 71.2,
                    decoration: BoxDecoration(
                      color: Color(0xFFE7E7E7),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(120, 0, 0, 0),
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              // color: FlutterFlowTheme.of(context).primaryColor,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    15, 10, 15, 10),
                                child: Text(
                                  'R',
                                  // style: FlutterFlowTheme.of(context)
                                  //     .bodyText1
                                  //     .override(
                                  //       fontFamily: 'Poppins',
                                  //       color: FlutterFlowTheme.of(context)
                                  //           .primaryBackground,
                                  //       fontSize: 17,
                                  //     ),
                                ),
                              ),
                            ),
                          ),
                          Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            // color: FlutterFlowTheme.of(context).primaryColor,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      15, 0, 0, 0),
                                  child: FaIcon(
                                    FontAwesomeIcons.clipboardList,
                                    // color: FlutterFlowTheme.of(context)
                                    //     .primaryBackground,
                                    // size: 24,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      15, 10, 15, 10),
                                  child: Text(
                                    'Question Paper',
                                    // style: FlutterFlowTheme.of(context)
                                    //     .bodyText1
                                    //     .override(
                                    //       fontFamily: 'Poppins',
                                    //       color: FlutterFlowTheme.of(context)
                                    //           .primaryBackground,
                                    //       fontSize: 16,
                                    //     ),
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
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-0.55, 0),
                      child: Container(
                        width: 774,
                        height: 52.9,
                        decoration: BoxDecoration(
                          // color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(-1, -1),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          120, 0, 0, 0),
                                      child: Text(
                                        'Question 20',
                                        // style: FlutterFlowTheme.of(context)
                                        //     .title3
                                        //     .override(
                                        //       fontFamily: 'Poppins',
                                        //       fontWeight: FontWeight.normal,
                                        //     ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Single Correct Option,',
                                          // style: FlutterFlowTheme.of(context)
                                          //     .bodyText1
                                          //     .override(
                                          //       fontFamily: 'Poppins',
                                          //       fontSize: 15,
                                          //       fontWeight: FontWeight.normal,
                                          //     ),
                                        ),
                                        Text(
                                          ' +1.00, ',
                                          // style: FlutterFlowTheme.of(context)
                                          //     .bodyText1
                                          //     .override(
                                          //       fontFamily: 'Poppins',
                                          //       color: Color(0xFF4AAF0D),
                                          //       fontSize: 15,
                                          //       fontWeight: FontWeight.normal,
                                          //     ),
                                        ),
                                        Text(
                                          ' -0.00',
                                          // style: FlutterFlowTheme.of(context)
                                          //     .bodyText1
                                          //     .override(
                                          //       fontFamily: 'Poppins',
                                          //       color: Color(0xFFDD2D68),
                                          //       fontSize: 15,
                                          //       fontWeight: FontWeight.normal,
                                          //     ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                indent: 120,
                                color: Color(0xFF918888),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
                                child: Wrap(
                                  spacing: 0,
                                  runSpacing: 0,
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  direction: Axis.horizontal,
                                  runAlignment: WrapAlignment.start,
                                  verticalDirection: VerticalDirection.down,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(-0.15, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 30),
                                        child: Text(
                                          'How do you create a variable name x with nemuric value 5?',
                                          textAlign: TextAlign.start,
                                          // style: FlutterFlowTheme.of(context)
                                          //     .bodyText1
                                          //     .override(
                                          //       fontFamily: 'Poppins',
                                          //       fontSize: 17,
                                          //       fontWeight: FontWeight.normal,
                                          //     ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        120, 0, 0, 0),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFC9C1C1),
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.05, 0),
                                        child: Text(
                                          'A',
                                          // style: FlutterFlowTheme.of(context)
                                          //     .bodyText1
                                          //     .override(
                                          //       fontFamily: 'Poppins',
                                          //       fontSize: 22,
                                          //       fontWeight: FontWeight.normal,
                                          //     ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          30, 0, 0, 0),
                                      child: Text(
                                        'X:5',
                                        textAlign: TextAlign.start,
                                        // style: FlutterFlowTheme.of(context)
                                        //     .bodyText1
                                        //     .override(
                                        //       fontFamily: 'Poppins',
                                        //       fontSize: 20,
                                        //       fontWeight: FontWeight.normal,
                                        //     ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                child: Wrap(
                                  spacing: 0,
                                  runSpacing: 0,
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  direction: Axis.horizontal,
                                  runAlignment: WrapAlignment.start,
                                  verticalDirection: VerticalDirection.down,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  120, 0, 0, 0),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFC9C1C1),
                                            ),
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0.05, 0),
                                              child: Text(
                                                'B',
                                                // style:
                                                //     FlutterFlowTheme.of(context)
                                                //         .bodyText1
                                                //         .override(
                                                //           fontFamily: 'Poppins',
                                                //           fontSize: 22,
                                                //           fontWeight:
                                                //               FontWeight.normal,
                                                //         ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    30, 0, 0, 0),
                                            child: Text(
                                              'X < -5',
                                              textAlign: TextAlign.start,
                                              // style:
                                              //     FlutterFlowTheme.of(context)
                                              //         .bodyText1
                                              //         .override(
                                              //           fontFamily: 'Poppins',
                                              //           fontSize: 20,
                                              //           fontWeight:
                                              //               FontWeight.normal,
                                              //         ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                child: Wrap(
                                  spacing: 0,
                                  runSpacing: 0,
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  direction: Axis.horizontal,
                                  runAlignment: WrapAlignment.start,
                                  verticalDirection: VerticalDirection.down,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  120, 0, 0, 0),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFC9C1C1),
                                            ),
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0.05, 0),
                                              child: Text(
                                                'C',
                                                // style:
                                                //     FlutterFlowTheme.of(context)
                                                //         .bodyText1
                                                //         .override(
                                                //           fontFamily: 'Poppins',
                                                //           fontSize: 22,
                                                //           fontWeight:
                                                //               FontWeight.normal,
                                                //         ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    30, 0, 0, 0),
                                            child: Text(
                                              'int x = 5',
                                              textAlign: TextAlign.start,
                                              // style:
                                              //     FlutterFlowTheme.of(context)
                                              //         .bodyText1
                                              //         .override(
                                              //           fontFamily: 'Poppins',
                                              //           fontSize: 20,
                                              //           fontWeight:
                                              //               FontWeight.normal,
                                              //         ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 5, 0, 110),
                                child: Wrap(
                                  spacing: 0,
                                  runSpacing: 0,
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  direction: Axis.horizontal,
                                  runAlignment: WrapAlignment.start,
                                  verticalDirection: VerticalDirection.down,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  120, 0, 0, 0),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFC9C1C1),
                                            ),
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0.05, 0),
                                              child: Text(
                                                'D',
                                                // style:
                                                //     FlutterFlowTheme.of(context)
                                                //         .bodyText1
                                                //         .override(
                                                //           fontFamily: 'Poppins',
                                                //           fontSize: 22,
                                                //           fontWeight:
                                                //               FontWeight.normal,
                                                //         ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    30, 0, 0, 0),
                                            child: Text(
                                              'All of the above',
                                              textAlign: TextAlign.start,
                                              // style:
                                              //     FlutterFlowTheme.of(context)
                                              //         .bodyText1
                                              //         .override(
                                              //           fontFamily: 'Poppins',
                                              //           fontSize: 20,
                                              //           fontWeight:
                                              //               FontWeight.normal,
                                              //         ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                indent: 120,
                                color: Color(0xFF918888),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        120, 0, 10, 0),
                                    child: ButtonBar(
                                      // onPressed: () {
                                      //   print('Button pressed ...');
                                      // },
                                      // text: 'SAVE & NEXT',
                                      // options: FFButtonOptions(
                                      //   width: 130,
                                      //   height: 40,
                                      //   color: Color(0xFF0AAB4E),
                                      //   textStyle: FlutterFlowTheme.of(context)
                                      //       .subtitle2
                                      //       .override(
                                      //         fontFamily: 'Poppins',
                                      //         color: Colors.white,
                                      //         fontSize: 15,
                                      //         fontWeight: FontWeight.normal,
                                      //       ),
                                      //   borderSide: BorderSide(
                                      //     color: Colors.transparent,
                                      //     width: 0,
                                      //   ),
                                      // ), child: null,
                                    ),
                                  ),
                                  // FFButtonWidget(
                                  //   onPressed: () {
                                  //     print('Button pressed ...');
                                  //   },
                                  //   text: 'MARK FOR REVIEW & NEXT',
                                  //   options: FFButtonOptions(
                                  //     width: 230,
                                  //     height: 40,
                                  //     color: FlutterFlowTheme.of(context)
                                  //         .primaryColor,
                                  //     textStyle: FlutterFlowTheme.of(context)
                                  //         .subtitle2
                                  //         .override(
                                  //           fontFamily: 'Poppins',
                                  //           color: Colors.white,
                                  //           fontSize: 15,
                                  //           fontWeight: FontWeight.normal,
                                  //         ),
                                  //     borderSide: BorderSide(
                                  //       color: Colors.transparent,
                                  //       width: 0,
                                  //     ),
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: EdgeInsetsDirectional.fromSTEB(
                                  //       10, 0, 0, 0),
                                  //   child: FFButtonWidget(
                                  //     onPressed: () {
                                  //       print('Button pressed ...');
                                  //     },
                                  //     text: 'CLEAR RESPONSE',
                                  //     options: FFButtonOptions(
                                  //       width: 160,
                                  //       height: 40,
                                  //       color: Color(0xFF9A98A9),
                                  //       textStyle: FlutterFlowTheme.of(context)
                                  //           .subtitle2
                                  //           .override(
                                  //             fontFamily: 'Poppins',
                                  //             color: Colors.white,
                                  //             fontSize: 15,
                                  //             fontWeight: FontWeight.normal,
                                  //           ),
                                  //       borderSide: BorderSide(
                                  //         color: Colors.transparent,
                                  //         width: 0,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: EdgeInsetsDirectional.fromSTEB(
                                  //       10, 0, 0, 0),
                                  //   child: Text(
                                  //     'Report an error',
                                  //     textAlign: TextAlign.end,
                                  //     style: FlutterFlowTheme.of(context)
                                  //         .bodyText1
                                  //         .override(
                                  //           fontFamily: 'Poppins',
                                  //           fontSize: 14,
                                  //           fontWeight: FontWeight.normal,
                                  //         ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    120, 10, 0, 10),
                                child: Container(
                                  width: 803.3,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    // color: FlutterFlowTheme.of(context)
                                    //     .primaryBtnText,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                      //     FFButtonWidget(
                                      //       onPressed: () {
                                      //         print('Button pressed ...');
                                      //       },
                                      //       text: 'PREVIOUS',
                                      //       options: FFButtonOptions(
                                      //         width: 130,
                                      //         height: 40,
                                      //         color: Color(0xFF918888),
                                      //         textStyle:
                                      //             FlutterFlowTheme.of(context)
                                      //                 .subtitle2
                                      //                 .override(
                                      //                   fontFamily: 'Poppins',
                                      //                   color:
                                      //                       FlutterFlowTheme.of(
                                      //                               context)
                                      //                           .primaryBtnText,
                                      //                   fontSize: 15,
                                      //                   fontWeight:
                                      //                       FontWeight.normal,
                                      //                 ),
                                      //         borderSide: BorderSide(
                                      //           color: Colors.transparent,
                                      //           width: 1,
                                      //         ),
                                      //         borderRadius:
                                      //             BorderRadius.circular(8),
                                      //       ),
                                      //     ),
                                      //     Padding(
                                      //       padding:
                                      //           EdgeInsetsDirectional.fromSTEB(
                                      //               10, 0, 0, 0),
                                      //       child: FFButtonWidget(
                                      //         onPressed: () {
                                      //           print('Button pressed ...');
                                      //         },
                                      //         text: 'NEXT QUESTION',
                                      //         options: FFButtonOptions(
                                      //           width: 140,
                                      //           height: 40,
                                      //           color:
                                      //               FlutterFlowTheme.of(context)
                                      //                   .primaryColor,
                                      //           textStyle:
                                      //               FlutterFlowTheme.of(context)
                                      //                   .subtitle2
                                      //                   .override(
                                      //                     fontFamily: 'Poppins',
                                      //                     color: Colors.white,
                                      //                     fontSize: 15,
                                      //                     fontWeight:
                                      //                         FontWeight.normal,
                                      //                   ),
                                      //           borderSide: BorderSide(
                                      //             color: Colors.transparent,
                                      //             width: 1,
                                      //           ),
                                      //           borderRadius:
                                      //               BorderRadius.circular(8),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      // FFButtonWidget(
                                      //   onPressed: () {
                                      //     print('Button pressed ...');
                                      //   },
                                      //   text: 'SUBMIT',
                                      //   options: FFButtonOptions(
                                      //     width: 130,
                                      //     height: 40,
                                      //     color: Color(0xFF00C356),
                                      //     textStyle:
                                      //         FlutterFlowTheme.of(context)
                                      //             .subtitle2
                                      //             .override(
                                      //               fontFamily: 'Poppins',
                                      //               color: Colors.white,
                                      //               fontWeight:
                                      //                   FontWeight.normal,
                                      //             ),
                                      //     borderSide: BorderSide(
                                      //       color: Color(0xFFC39A9A),
                                      //       width: 0,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),]
                                ),
                              ),
                          )],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.1, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                            child: Wrap(
                              spacing: 0,
                              runSpacing: 0,
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              direction: Axis.horizontal,
                              runAlignment: WrapAlignment.start,
                              verticalDirection: VerticalDirection.down,
                              clipBehavior: Clip.none,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF4AAF0D),
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0, 0.55),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 10, 0, 10),
                                          child: Text(
                                            '2',
                                            textAlign: TextAlign.center,
                                            // style: FlutterFlowTheme.of(context)
                                            //     .bodyText1
                                            //     .override(
                                            //       fontFamily: 'Poppins',
                                            //       color: Colors.white,
                                            //       fontSize: 16,
                                            //       fontWeight: FontWeight.normal,
                                            //     ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '     Answered                ',
                                      // style: FlutterFlowTheme.of(context)
                                      //     .bodyText1,
                                    ),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFED0D58),
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0, 0.55),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 10, 0, 10),
                                          child: Text(
                                            '2',
                                            textAlign: TextAlign.center,
                                            // style: FlutterFlowTheme.of(context)
                                            //     .bodyText1
                                            //     .override(
                                            //       fontFamily: 'Poppins',
                                            //       color: Colors.white,
                                            //       fontSize: 16,
                                            //       fontWeight: FontWeight.normal,
                                            //     ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '    Not Answered',
                                      // style: FlutterFlowTheme.of(context)
                                      //     .bodyText1,
                                    ),
                                  ],
                                ),
                              ],
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
    );
  }
}
