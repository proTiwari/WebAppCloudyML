import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:pinput/pinput.dart';
import 'package:cloudyml_app2/theme.dart';
import 'package:cloudyml_app2/global_variable.dart' as globals;
import 'google_auth.dart';
import 'login_email.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({Key? key}) : super(key: key);
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String text = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool? googleloading = false;
  bool formVisible = false;
  bool value = false;
  bool phoneVisible = false;
  int _formIndex = 1;
  TextEditingController textController = TextEditingController();
  final _pinPutController = TextEditingController();
  bool _isHidden = true;
  bool _isLoading = false;
  final _loginkey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool loading = false;
  late String actualCode;

  void _onKeyboardTap(String value) {
    setState(() {
      text = text + value;
    });
  }

  Widget darkRoundedPinPut() {
    return Container(
      child: Pinput(
        onChanged: (value) => text = value,
        length: 6,
      ),
    );
  }

  Widget _otpTextField(BuildContext context, bool autoFocus, int position) {
    return Container(
      height: MediaQuery.of(context).size.shortestSide * 0.04,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        shape: BoxShape.rectangle,
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: TextField(
              // controller: textController,
              autofocus: autoFocus,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: TextStyle(),
              maxLines: 1,
              onChanged: (value) {
                print(value);
                print(position);
                if (value.length == 1) {
                  text += value;
                  FocusScope.of(context).nextFocus();
                }
                print(text);
                if (value.length == 0) {
                  FocusScope.of(context).nearestScope;
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Center(
            child: Text(
          text[position],
          style: TextStyle(color: Colors.black),
        )),
      );
    } catch (e) {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
      );
    }
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
                                    child: Image.asset('assets/otpll.png'),
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
                      Container(
                        width: 325,
                        height: MediaQuery.of(context).size.height,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text(
                                                'Enter 6 digits verification code sent to your number',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              18, 80, 18, 0),
                                          child: Container(
                                            
                                            constraints: const BoxConstraints(
                                                maxWidth: 400),
                                            child: Row(
                                              
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  
                                                    child: darkRoundedPinPut()),
                                                // _otpTextField(context, true, 0),
                                                // _otpTextField(
                                                //     context, false, 1),
                                                // _otpTextField(
                                                //     context, false, 2),
                                                // _otpTextField(
                                                //     context, false, 3),
                                                // _otpTextField(
                                                //     context, false, 4),
                                                // _otpTextField(
                                                //     context, false, 5),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 58),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await validateOtpAndLogin(
                                            context, text);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        constraints:
                                            const BoxConstraints(maxWidth: 500),
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
                                                        .fromLTRB(12, 0, 0, 0),
                                                    child: Text(
                                                      'Confirm',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
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
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return SafeArea(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                        'Enter 6 digits verification code sent to your number',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w500))),
                                Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 500),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      otpNumberWidget(0),
                                      otpNumberWidget(1),
                                      otpNumberWidget(2),
                                      otpNumberWidget(3),
                                      otpNumberWidget(4),
                                      otpNumberWidget(5),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await validateOtpAndLogin(context, text);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              constraints: const BoxConstraints(maxWidth: 500),
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
                                              child: CircularProgressIndicator(
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
                                            'Confirm',
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
                          NumericKeyboard(
                            onKeyboardTap: _onKeyboardTap,
                            textColor: MyColors.primaryColorLight,
                            rightIcon: Icon(
                              Icons.backspace,
                              color: MyColors.primaryColorLight,
                            ),
                            rightButtonFn: () {
                              setState(() {
                                text = text.substring(0, text.length - 1);
                              });
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> validateOtpAndLogin(BuildContext context, String smsCode) async {
    var result;
    var output;
    actualCode = globals.actualCode;
    try {
      setState(() {
        loading = true;
      });
      final AuthCredential _authCredential = PhoneAuthProvider.credential(
          verificationId: actualCode, smsCode: smsCode);

      // print("00000000000000000000000000000000000 $output");
      // result = await _auth.currentUser!.linkWithCredential(_authCredential);
      // output = await _auth.signInWithCredential(_authCredential);

      globals.credental = _authCredential;
      print("4${result}");
      // var value = await FirebaseAuth.instance.currentUser!.uid;
      // print("5");
      // final prefs = await SharedPreferences.getInstance();
      // print("6");
      // await prefs.setString('$value', "true");
      print("7");
      // if (authResult != null && authResult.user != null) {
      //   print("8");
      //   print('Authentication successful');
      //   print("9");
      onAuthenticationSuccessful(context, output, _authCredential);

      // }
    } on FirebaseException catch (e) {
      print(e.toString());
      showToast(e.toString());
      setState(() {
        loading = false;
      });
      // showToast(e.toString());
      // setState(() {
      //   loading = false;
      // });
      // if (e.code.toString() == "provider-already-linked") {
      //   var value = await FirebaseAuth.instance.currentUser!.uid;
      //   print("5");
      //   final prefs = await SharedPreferences.getInstance();
      //   print("6");
      //   await prefs.setString('$value', "true");
      //   onAuthenticationSuccessful(context, output);
      // }
      // if (e.code.toString() == "credential-already-in-use") {
      //   var value = await FirebaseAuth.instance.currentUser!.uid;
      //   print("5");
      //   final prefs = await SharedPreferences.getInstance();
      //   print("6");
      //   await prefs.setString('$value', "true");
      //   await onAuthenticationSuccessful(context, output);
      // }
      // setState(() {
      //   loading = false;
      // });
      // showToast(e.toString());
      // print("this is error kinga${e}");
    }
  }

  Future<void> onAuthenticationSuccessful(
      BuildContext context, dynamic result, dynamic crediantial) async {
    try {
      // firebaseUser = result.user;

      // var user = FirebaseAuth.instance.currentUser;
      if (globals.googleAuth != 'true') {
        if (globals.phoneNumberexists == "true") {
          if (globals.linked == "true") {
            print("here 1");
            try {
              User? user = (await _auth.signInWithCredential(crediantial)).user;
              if (user != null) {
                print(
                    "Login Successful========================================================");
                showToast("Login Successful");
                print(user);
                print(
                    "Login Successful========================================================");
                // final prefs = await SharedPreferences.getInstance();
                // await prefs.setString('login', "true");
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => HomePage(),
                    ),
                    (Route<dynamic> route) => false);
              } else {
                showToast("Login Failed");
                print("Login Failed");
              }
            } catch (e) {
              showToast("wrong otp: ${e.toString()}");
            }
          } else if (globals.googleAuth == 'true') {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => GoogleAuthLogin()));
          } else {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => LoginEmailPage()));
          }
        } else {
          print("here 2");
          await _auth.signOut();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => LoginEmailPage()));
        }
      } else {
        if (globals.linked == 'true') {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => HomePage(),
              ),
              (Route<dynamic> route) => false);
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => GoogleAuthLogin()));
        }
      }

      // if (globals.name != "") {
      //   if (user != null) {
      //     DocumentSnapshot userDocs = await FirebaseFirestore.instance
      //         .collection('Users')
      //         .doc(FirebaseAuth.instance.currentUser!.uid)
      //         .get();
      //     if (userDocs.data() == null) {
      //       showToast('user data does not exist');
      //       // userprofile(
      //       //     name: globals.name,
      //       //     image: '',
      //       //     mobilenumber: globals.phone,
      //       //     authType: 'phoneAuth',
      //       //     phoneVerified: true,
      //       //     email: globals.email);
      //       setState(() {
      //         loading = false;
      //       });
      //     }
      //     setState(() {
      //       loading = false;
      //     });
      //   } else {
      //     showToast('user does not exist');
      //     setState(() {
      //       loading = false;
      //     });
      //   }
      // }
      setState(() {
        loading = false;
      });

      // showToast("navigate to home page");
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (_) => HomePage()),
      //     (Route<dynamic> route) => false);
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      showToast(e.toString());
    }
  }
}
