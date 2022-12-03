import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/authentication_screens/signin_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:cloudyml_app2/theme.dart';
import 'package:cloudyml_app2/global_variable.dart' as globals;
import '../globals.dart';
import 'login_username.dart';

class LoginEmailPage extends StatefulWidget {
  const LoginEmailPage({Key? key}) : super(key: key);
  @override
  _LoginEmailPageState createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    print("rrrrrrrrrrrrrrrrr");
    print(globals.action);
  }

  @override
  Widget build(BuildContext context) {
    
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Color.fromARGB(255, 140, 58, 240),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                color: Color.fromRGBO(35, 0, 79, 1),
                size: 16,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          backgroundColor: HexColor("7226D1"),
          brightness: Brightness.light,
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth >= 700) {
            return Stack(
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          color: Color.fromRGBO(35, 0, 79, 1),
                        ),
                      ),
                      Expanded(flex: 1, child: Container()),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(80.00),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 525,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30)),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                HexColor("440F87"),
                                HexColor("7226D1"),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 40.0, // soften the shadow
                                offset: Offset(
                                  0, // Move to right 10  horizontally
                                  2.0, // Move to bottom 10 Vertically
                                ),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/logo.png',
                                  height: 75,
                                  width: 110,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Let's Explore",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 22),
                                ),
                                Text(
                                  "Data Science Together!",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 34),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Image.asset('assets/loginoop.png'),
                                    // child: SvgPicture.asset(
                                    //   'assets/Frame.svg',
                                    //   height: verticalScale * 360,
                                    //   width: horizontalScale * 300,
                                    //   fit: BoxFit.fill,
                                    // ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 325,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 40.0, // soften the shadow
                                offset: Offset(
                                  0, // Move to right 10  horizontally
                                  2.0, // Move to bottom 10 Vertically
                                ),
                              ),
                            ],
                          ),
                          height: MediaQuery.of(context).size.height,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 158, 4, 0),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          constraints: const BoxConstraints(
                                              maxWidth: 500),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                  text:
                                                      'We look forward to getting to know you better at ',
                                                  style: TextStyle(
                                                      color:
                                                          MyColors.primaryColor,
                                                      fontSize: 18)),
                                              TextSpan(
                                                  text: 'CloudyML.',
                                                  style: TextStyle(
                                                      color:
                                                          MyColors.primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18)),
                                              TextSpan(
                                                  text:
                                                      " Let's begin with email",
                                                  style: TextStyle(
                                                      color:
                                                          MyColors.primaryColor,
                                                      fontSize: 18)),
                                            ]),
                                          )),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Container(
                                        height: 60,
                                        constraints:
                                            const BoxConstraints(maxWidth: 500),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: CupertinoTextField(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(4))),
                                          controller: emailController,
                                          clearButtonMode:
                                              OverlayVisibilityMode.editing,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          maxLines: 1,
                                          placeholder: 'Email',
                                        ),
                                      ),
                                       
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0,8,18,8),
                                        child: InkWell(
                                  onTap: () {
                                    if (emailController.text.isNotEmpty) {
                                        _auth.sendPasswordResetEmail(
                                            email: emailController.text);
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              Future.delayed(
                                                  Duration(seconds: 13), () {
                                                Navigator.of(context).pop(true);
                                              });
                                              return AlertDialog(
                                                title: Center(
                                                  child: Column(
                                                    children: [
                                                      Lottie.asset(
                                                          'assets/email.json',
                                                          height: height * 0.15,
                                                          width: width * 0.5),
                                                      Text(
                                                        'Reset Password',
                                                        textScaleFactor: min(
                                                            horizontalScale,
                                                            verticalScale),
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'An email has been sent to ',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(),
                                                    ),
                                                    Text(
                                                      '${emailController.text}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Click the link in the email to change password.',
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    SizedBox(
                                                      height: verticalScale * 10,
                                                    ),
                                                    Text(
                                                      'Didn\'t get the email?',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Check entered email or check spam folder.',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(),
                                                    ),
                                                    TextButton(
                                                        child: Text(
                                                          'Retry',
                                                          textScaleFactor: min(
                                                              horizontalScale,
                                                              verticalScale),
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, true);
                                                        }),
                                                  ],
                                                ),
                                              );
                                            });
                                    } else {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                  title: Center(
                                                    child: Text(
                                                      'Error',
                                                      textScaleFactor: min(
                                                          horizontalScale,
                                                          verticalScale),
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  content: Text(
                                                    'Enter email in the email field or check if the email is valid.',
                                                    textAlign: TextAlign.center,
                                                    textScaleFactor: min(
                                                        horizontalScale,
                                                        verticalScale),
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        child: Text('Retry'),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, true);
                                                        })
                                                  ]);
                                            });
                                    }
                                  },
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                        'Forgot Password?',
                                        textScaleFactor:
                                            min(horizontalScale, verticalScale),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: HexColor('8346E1'),
                                            fontSize: 16),
                                    ),
                                  ),
                                ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await email(context,
                                              emailController.text.toString());
                                          // loginStore.email(
                                          //     context, emailController.text.toString());
                                          // if (RegExp(
                                          //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          //     .hasMatch(
                                          //         emailController.text.toString())) {
                                          //   if (emailController.text.isNotEmpty) {
                                          //     loginStore.isLoginLoading = true;
                                          //     final docSnapshots = await FirebaseFirestore
                                          //         .instance
                                          //         .collection('Users')
                                          //         .where('email',
                                          //             isEqualTo:
                                          //                 "${emailController.text.toString()}")
                                          //         .get();
                                          //     try {
                                          //       if (docSnapshots.docs.first.exists) {
                                          //         print(docSnapshots.docs.first.exists);
                                          //         //    setState(() {
                                          //         //   loginStore.isLoginLoading = false;
                                          //         // });
                                          //         Navigator.pushReplacement(
                                          //             context,
                                          //             MaterialPageRoute(
                                          //                 builder: (context) =>
                                          //                     SigninPasswordPage(
                                          //                         email: emailController
                                          //                             .text
                                          //                             .toString())));
                                          //       } else {
                                          //         //  setState(() {
                                          //         //   loginStore.isLoginLoading = false;
                                          //         // });
                                          //         Navigator.pushReplacement(
                                          //             context,
                                          //             MaterialPageRoute(
                                          //                 builder: (context) =>
                                          //                     SignupPasswordPage(
                                          //                         email: emailController
                                          //                             .text
                                          //                             .toString())));
                                          //       }
                                          //     } catch (e) {
                                          //       // setState(() {
                                          //       //   loginStore.isLoginLoading = false;
                                          //       // });

                                          //       if (e.toString() ==
                                          //           "Bad state: No element") {
                                          //         Navigator.pushReplacement(
                                          //             context,
                                          //             MaterialPageRoute(
                                          //                 builder: (context) =>
                                          //                     SignupPasswordPage(
                                          //                         email: emailController
                                          //                             .text
                                          //                             .toString())));
                                          //       }
                                          //       ;
                                          //     }
                                          //   } else {
                                          //     // setState(() {
                                          //     //     loginStore.isLoginLoading = false;
                                          //     //   });
                                          //     ScaffoldMessenger.of(context)
                                          //         .showSnackBar(
                                          //       const SnackBar(
                                          //         content: Text('Please enter a email'),
                                          //       ),
                                          //     );
                                          //     //  setState(() {
                                          //     //       loginStore.isLoginLoading = false;
                                          //     //     });
                                          //   }
                                          // }else{

                                          // }
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          constraints: const BoxConstraints(
                                              maxWidth: 500),
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(14)),
                                              gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    // Color(0xFF8A2387),
                                                    Color.fromRGBO(
                                                        120, 96, 220, 1),
                                                    Color.fromRGBO(
                                                        120, 96, 220, 1),
                                                    Color.fromARGB(
                                                        255, 88, 52, 246),
                                                  ])),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          child: loading
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Container(
                                                      height: 20,
                                                      width: 20,
                                                      child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                                  color: Colors
                                                                      .white))),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          12, 0, 0, 0),
                                                      child: Text(
                                                        'Next',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    20)),
                                                        color: MyColors
                                                            .primaryColorLight,
                                                      ),
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                        ),
                                      ),
                                      
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // Container(
                                      //   margin: const EdgeInsets.symmetric(
                                      //       horizontal: 20, vertical: 10),
                                      //   constraints:
                                      //       const BoxConstraints(maxWidth: 500),
                                      //   child: RaisedButton(
                                      //     onPressed: () {
                                      //       if (phoneController.text.isNotEmpty) {
                                      //         loginStore.getCodeWithPhoneNumber(context,
                                      //             "+91${phoneController.text.toString()}");
                                      //       } else {
                                      //         loginStore.loginScaffoldKey.currentState
                                      //             ?.showSnackBar(SnackBar(
                                      //           behavior: SnackBarBehavior.floating,
                                      //           backgroundColor: Colors.red,
                                      //           content: Text(
                                      //             'Please enter a phone number',
                                      //             style: TextStyle(color: Colors.white),
                                      //           ),
                                      //         ));
                                      //       }
                                      //     },
                                      //     color: MyColors.primaryColor,
                                      //     shape: const RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.all(
                                      //             Radius.circular(14))),
                                      //     child: Container(
                                      //       padding: const EdgeInsets.symmetric(
                                      //           vertical: 8, horizontal: 8),
                                      //       child: Row(
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment.spaceBetween,
                                      //         children: <Widget>[
                                      //           Text(
                                      //             'Next',
                                      //             style: TextStyle(color: Colors.white),
                                      //           ),
                                      //           Container(
                                      //             padding: const EdgeInsets.all(8),
                                      //             decoration: BoxDecoration(
                                      //               borderRadius:
                                      //                   const BorderRadius.all(
                                      //                       Radius.circular(20)),
                                      //               color: MyColors.primaryColorLight,
                                      //             ),
                                      //             child: Icon(
                                      //               Icons.arrow_forward_ios,
                                      //               color: Colors.white,
                                      //               size: 16,
                                      //             ),
                                      //           )
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ),
                                      // )
                                      
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                    ],
                  ),

                ),
              ],
            );
          } else {
            return SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Stack(
                                children: <Widget>[
                                 
                                  Center(
                                    child: Container(
                                        constraints: const BoxConstraints(
                                            maxHeight: 340),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Image.asset('assets/loginoop.png')),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text('CloudyML',
                                    style: TextStyle(
                                        color: MyColors.primaryColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w800)))
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            'We look forward to getting to know you better at ',
                                        style: TextStyle(
                                            color: MyColors.primaryColor)),
                                    TextSpan(
                                        text: 'CloudyML.',
                                        style: TextStyle(
                                            color: MyColors.primaryColor,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: " Let's begin with email",
                                        style: TextStyle(
                                            color: MyColors.primaryColor)),
                                  ]),
                                )),
                            Container(
                              height: 40,
                              constraints: const BoxConstraints(maxWidth: 500),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: CupertinoTextField(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4))),
                                controller: emailController,
                                clearButtonMode: OverlayVisibilityMode.editing,
                                keyboardType: TextInputType.emailAddress,
                                maxLines: 1,
                                placeholder: 'Email',
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0,8,18,8),
                                        child: InkWell(
                                  onTap: () {
                                    if (emailController.text.isNotEmpty) {
                                        _auth.sendPasswordResetEmail(
                                            email: emailController.text);
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              Future.delayed(
                                                  Duration(seconds: 13), () {
                                                Navigator.of(context).pop(true);
                                              });
                                              return AlertDialog(
                                                title: Center(
                                                  child: Column(
                                                    children: [
                                                      Lottie.asset(
                                                          'assets/email.json',
                                                          height: height * 0.15,
                                                          width: width * 0.5),
                                                      Text(
                                                        'Reset Password',
                                                        textScaleFactor: min(
                                                            horizontalScale,
                                                            verticalScale),
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'An email has been sent to ',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(),
                                                    ),
                                                    Text(
                                                      '${emailController.text}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Click the link in the email to change password.',
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    SizedBox(
                                                      height: verticalScale * 10,
                                                    ),
                                                    Text(
                                                      'Didn\'t get the email?',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Check entered email or check spam folder.',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(),
                                                    ),
                                                    TextButton(
                                                        child: Text(
                                                          'Retry',
                                                          textScaleFactor: min(
                                                              horizontalScale,
                                                              verticalScale),
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, true);
                                                        }),
                                                  ],
                                                ),
                                              );
                                            });
                                    } else {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                  title: Center(
                                                    child: Text(
                                                      'Error',
                                                      textScaleFactor: min(
                                                          horizontalScale,
                                                          verticalScale),
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  content: Text(
                                                    'Enter email in the email field or check if the email is valid.',
                                                    textAlign: TextAlign.center,
                                                    textScaleFactor: min(
                                                        horizontalScale,
                                                        verticalScale),
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        child: Text('Retry'),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, true);
                                                        })
                                                  ]);
                                            });
                                    }
                                  },
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                        'Forgot Password?',
                                        textScaleFactor:
                                            min(horizontalScale, verticalScale),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: HexColor('8346E1'),
                                            fontSize: 16),
                                    ),
                                  ),
                                ),
                                      ),
                            GestureDetector(
                              onTap: () async {
                                await email(
                                    context, emailController.text.toString());
                                // loginStore.email(
                                //     context, emailController.text.toString());
                                // if (RegExp(
                                //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                //     .hasMatch(
                                //         emailController.text.toString())) {
                                //   if (emailController.text.isNotEmpty) {
                                //     loginStore.isLoginLoading = true;
                                //     final docSnapshots = await FirebaseFirestore
                                //         .instance
                                //         .collection('Users')
                                //         .where('email',
                                //             isEqualTo:
                                //                 "${emailController.text.toString()}")
                                //         .get();
                                //     try {
                                //       if (docSnapshots.docs.first.exists) {
                                //         print(docSnapshots.docs.first.exists);
                                //         //    setState(() {
                                //         //   loginStore.isLoginLoading = false;
                                //         // });
                                //         Navigator.pushReplacement(
                                //             context,
                                //             MaterialPageRoute(
                                //                 builder: (context) =>
                                //                     SigninPasswordPage(
                                //                         email: emailController
                                //                             .text
                                //                             .toString())));
                                //       } else {
                                //         //  setState(() {
                                //         //   loginStore.isLoginLoading = false;
                                //         // });
                                //         Navigator.pushReplacement(
                                //             context,
                                //             MaterialPageRoute(
                                //                 builder: (context) =>
                                //                     SignupPasswordPage(
                                //                         email: emailController
                                //                             .text
                                //                             .toString())));
                                //       }
                                //     } catch (e) {
                                //       // setState(() {
                                //       //   loginStore.isLoginLoading = false;
                                //       // });

                                //       if (e.toString() ==
                                //           "Bad state: No element") {
                                //         Navigator.pushReplacement(
                                //             context,
                                //             MaterialPageRoute(
                                //                 builder: (context) =>
                                //                     SignupPasswordPage(
                                //                         email: emailController
                                //                             .text
                                //                             .toString())));
                                //       }
                                //       ;
                                //     }
                                //   } else {
                                //     // setState(() {
                                //     //     loginStore.isLoginLoading = false;
                                //     //   });
                                //     ScaffoldMessenger.of(context)
                                //         .showSnackBar(
                                //       const SnackBar(
                                //         content: Text('Please enter a email'),
                                //       ),
                                //     );
                                //     //  setState(() {
                                //     //       loginStore.isLoginLoading = false;
                                //     //     });
                                //   }
                                // }else{

                                // }
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(14)),
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          // Color(0xFF8A2387),
                                          Color.fromRGBO(120, 96, 220, 1),
                                          Color.fromRGBO(120, 96, 220, 1),
                                          Color.fromARGB(255, 88, 52, 246),
                                        ])),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: loading
                                    ? Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Container(
                                            height: 20,
                                            width: 20,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: Colors.white))),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 0, 0, 0),
                                            child: Text(
                                              'Next',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              color: MyColors.primaryColorLight,
                                            ),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          )
                                        ],
                                      ),
                              ),
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Container(
                            //   margin: const EdgeInsets.symmetric(
                            //       horizontal: 20, vertical: 10),
                            //   constraints:
                            //       const BoxConstraints(maxWidth: 500),
                            //   child: RaisedButton(
                            //     onPressed: () {
                            //       if (phoneController.text.isNotEmpty) {
                            //         loginStore.getCodeWithPhoneNumber(context,
                            //             "+91${phoneController.text.toString()}");
                            //       } else {
                            //         loginStore.loginScaffoldKey.currentState
                            //             ?.showSnackBar(SnackBar(
                            //           behavior: SnackBarBehavior.floating,
                            //           backgroundColor: Colors.red,
                            //           content: Text(
                            //             'Please enter a phone number',
                            //             style: TextStyle(color: Colors.white),
                            //           ),
                            //         ));
                            //       }
                            //     },
                            //     color: MyColors.primaryColor,
                            //     shape: const RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.all(
                            //             Radius.circular(14))),
                            //     child: Container(
                            //       padding: const EdgeInsets.symmetric(
                            //           vertical: 8, horizontal: 8),
                            //       child: Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: <Widget>[
                            //           Text(
                            //             'Next',
                            //             style: TextStyle(color: Colors.white),
                            //           ),
                            //           Container(
                            //             padding: const EdgeInsets.all(8),
                            //             decoration: BoxDecoration(
                            //               borderRadius:
                            //                   const BorderRadius.all(
                            //                       Radius.circular(20)),
                            //               color: MyColors.primaryColorLight,
                            //             ),
                            //             child: Icon(
                            //               Icons.arrow_forward_ios,
                            //               color: Colors.white,
                            //               size: 16,
                            //             ),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        }));
  }

  Future<void> email(BuildContext context, String email) async {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      if (email != "" || email != null) {
        globals.email = email;
        setState(() {
          loading = true;
        });
        final docSnapshots = await FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: "${email}")
            .get();
        setState(() {
          loading = false;
        });
        try {
          if (docSnapshots.docs.first.exists) {
            print(docSnapshots.docs.first.exists);
            //    setState(() {
            //   loginStore.isLoginLoading = false;
            // });
            setState(() {
              loading = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SigninPasswordPage(email: email),
              ),
            );
          } else {
            setState(() {
              loading = false;
            });
            //  setState(() {
            //   loginStore.isLoginLoading = false;
            // });
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginUsernamePage()));
          }
        } catch (e) {
          // showToast(e.toString());
          setState(() {
            loading = false;
          });
          // setState(() {
          //   loginStore.isLoginLoading = false;
          // });
          if (e.toString() == "Bad state: No element") {
            setState(() {
              loading = false;
            });

            // isLoginLoading = false;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginUsernamePage()));
          }
          ;
        }
      } else {
        setState(() {
          loading = false;
        });
        // setState(() {
        //     loginStore.isLoginLoading = false;
        //   });
        showToast('Please enter a email');

        //  setState(() {
        //       loginStore.isLoginLoading = false;
        //     });
      }
    } else {
      setState(() {
        loading = false;
      });
    }
    setState(() {
      loading = false;
    });
  }
}
