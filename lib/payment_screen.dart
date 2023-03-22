import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:cloudyml_app2/screens/chat_group.dart';
import 'package:cloudyml_app2/widgets/coupon_code.dart';
import 'package:cloudyml_app2/widgets/payment_portal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:star_rating/star_rating.dart';
import 'dart:js' as js;
import 'fun.dart';
import 'global_variable.dart' as globals;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic>? map;
  final cID;
  final bool isItComboCourse;
  const PaymentScreen(
      {Key? key, this.map, required this.cID, required this.isItComboCourse})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with CouponCodeMixin {
  var amountcontroller = TextEditingController();
  final TextEditingController couponCodeController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // GlobalKey key = GlobalKey();
  // final scaffoldState = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> showBottomSheet = ValueNotifier(false);
  // VoidCallback? _showPersistentBottomSheetCallBack;

  String? id;
  int newcoursevalue = 0;

  String couponAppliedResponse = "";

  //If it is false amountpayble showed will be the amount fetched from db
  //If it is true which will be set to true if when right coupon code is
  //applied and the amountpayble will be set using appludiscount to the finalamountpayble variable
  // declared below same for discount
  bool NoCouponApplied = true;

  String finalamountToDisplay = "";

  String finalAmountToPay = "";

  String discountedPrice = "";

  bool isPayButtonPressed = false;

  bool isPayInPartsPressed = false;

  bool isMinAmountCheckerPressed = false;

  bool isOutStandingAmountCheckerPressed = false;

  String courseprice = "0";
  String discountvalue = "0";
  bool apply = false;
  String rewardvalue = "0";

  var gstAmount;
  var totalAmount;
  final textStyle = TextStyle(
      color: Color.fromARGB(223, 48, 48, 49),
      fontFamily: 'Poppins',
      fontSize: 14,
      letterSpacing:
      0 /*percentages not used in flutter. defaulting to zero*/,
      fontWeight: FontWeight.w500,
      height: 1);



  Map<String, dynamic> courseMap = {};

  void url_del()
  {
    FirebaseFirestore.instance.collection('Notice')..doc("7A85zuoLi4YQpbXlbOAh_redirect").update({
      'url' : "" }).whenComplete((){
      print('feature Deleted');});

    FirebaseFirestore.instance.collection('Notice')..doc("NBrEm6KGry8gxOJJkegG_redirect_pay").update({
      'url' :"" }).whenComplete((){
      print('pay Deleted');});
  }

  void getCourseName() async {

    try{
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.cID)
          .get()
          .then((value) {
        setState(() {
          print('course id is ${widget.cID}');
          courseMap = value.data()!;
          print('paymentscree map ${courseMap.toString()} ');
          // print('gste = ${courseMap['gst'].toString()}');
        });
      });

      // gst function is here

      try{
        if (courseMap['gst'] != null) {
          gstAmount = int.parse('${courseMap['gst']}') * 0.01 * int.parse('${courseMap['Course Price']}');
          print('this is gst ${gstAmount.round()}');

          totalAmount = (int.parse('${courseMap['gst']}') * 0.01 * int.parse('${courseMap['Course Price']}')) + int.parse('${courseMap['Course Price']}');
          print('this is totalAmount ${totalAmount.round()}');

        } else {
          print('gst is nulll');
        }
      } catch(e){
        Fluttertoast.showToast(msg: e.toString());
        print('amount error is here ${e.toString()}');
      }

    }catch(e){
      print('catalogue screen ${e.toString()} ');
    }

    // reward function
    print("wewewewewew1");
    courseprice = courseMap['Course Price'].toString().replaceAll("₹", "");

    courseprice = courseprice.replaceAll("/-", "");
    print(courseprice);
    try {
      print("wewewewewew1");
      print(FirebaseAuth.instance.currentUser!.uid);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) async {
        print("wewewewewew2");
        rewardvalue = await value.data()!['reward'].toString();
        setState(() {
          rewardvalue;
        });
        print("wewewewewew3");
      });
      print(rewardvalue);
    } catch (e) {
      print("wewewewewew4");
      print(e);
      print("wewewewewew5");
    }
  }


  @override
  void initState() {

    super.initState();
    url_del();
    getCourseName();
  }


  void setcoursevalue() async {
    if (rewardvalue != "0") {
      print(courseprice);
      setState(() {
        discountvalue = rewardvalue;
      });

      print(rewardvalue);
      setState(() {
        rewardvalue = "0";
      });

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "reward": 0,
      });
    }
  }

  final congoStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 56,
    height: 1,
  );

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    return Scaffold(
      // drawer: customDrawer(context),
      appBar: AppBar(
        title: Center(
          child: Text(
            'Payment Details',
            textScaleFactor:
            min(horizontalScale, verticalScale),
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontFamily: 'Poppins',
                fontSize: 35,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth >= 650) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: screenHeight/5,
                width: screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Congratulations',
                      textScaleFactor: min(horizontalScale, verticalScale),
                      style: congoStyle,),
                    Text('🤩You are just one step away🤩',
                      textScaleFactor: min(horizontalScale, verticalScale),
                      style: congoStyle,),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 90.0, right: 90, top: 10, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(
                            2, // Move to right 10  horizontally
                            2.0, // Move to bottom 10 Vertically
                          ),
                          blurRadius: 40)
                    ],
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 1),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: screenHeight/3.5,
                                width: screenWidth/3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: courseMap['image_url'],
                                    placeholder: (context, url) =>
                                        Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.fill,
                                    // height: 110 * verticalScale,
                                    // width: 140 * horizontalScale,
                                  ),
                                ),
                              ),
                              Container(
                                width: screenWidth/3,
                                padding: EdgeInsets.only(left: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade100,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5.0),
                                      child: Container(
                                        height: 20,
                                        width: 25,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3.0),
                                          color: HexColor('440F87'),
                                        ),
                                        child: Center(
                                          child: Text(courseMap['reviews'] != null ? courseMap['reviews'] : '5.0',
                                            style: TextStyle(fontSize: 12, color: Colors.white,
                                                fontWeight: FontWeight.normal),),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(right: 5.0),
                                      child: StarRating(
                                        length: 5,
                                        rating: courseMap['reviews'] != null ? double.parse(courseMap['reviews']) : 5.0,
                                        color: HexColor('440F87'),
                                        starSize: 25,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                width: screenWidth/3,
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      courseMap['name'],
                                      textScaleFactor: min(horizontalScale, verticalScale),
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        height: 1,
                                      ),
                                      maxLines: 2,
                                    ),
                                    SizedBox(height: 15 * verticalScale,),
                                    Text(
                                      courseMap['description'],
                                      textScaleFactor: min(horizontalScale, verticalScale),
                                      style: TextStyle(
                                        fontSize: 18,
                                        height: 1
                                      ),
                                    ),
                                    SizedBox(height: 15 * verticalScale,),
                                    Text(
                                      'English  ||  online  ||  lifetime',
                                      textScaleFactor: min(horizontalScale, verticalScale),
                                      style: TextStyle(
                                        color: Colors.deepPurple.shade600,
                                        fontSize: 24,
                                        height: 1
                                      ),
                                    ),
                                    SizedBox(height: 15 * verticalScale,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 40 * horizontalScale,),
                      Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Container(
                          width: screenWidth/3.5,
                          height: screenHeight/2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Center(
                                  child: Text('BILL SUMMARY',
                                    textScaleFactor: min(horizontalScale, verticalScale),
                                    style: TextStyle(
                                      fontSize: 45 * verticalScale,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                    ),),
                                ),
                              ),
                              SizedBox(height: 25 * verticalScale,),
                              SizedBox(
                                  child: Divider(
                                    color: Colors.black,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0, bottom: 10),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Course Details',
                                        style: TextStyle(
                                            color: Color.fromARGB(223, 48, 48, 49),
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1)),
                                      Text('Unit Price',
                                        style: TextStyle(
                                            color: Color.fromARGB(223, 48, 48, 49),
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                  child: Divider(
                                    color: Colors.black,
                                  )),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Actual price",
                                    style: textStyle,
                                  ),
                                  Text(
                                    courseMap['gst'] != null ? '₹${courseMap['Amount Payable']}/-' : courseMap['Amount Payable'],
                                    style: textStyle,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Discounted price',
                                    style: textStyle,
                                  ),
                                  Text(
                                    courseMap['gst'] != null ? '₹${courseMap['Course Price']}/-' : courseMap['Course Price'],
                                    style: textStyle,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "GST",
                                    style: textStyle,
                                  ),
                                  Text(
                                    courseMap['gst'] != null ? '₹${gstAmount.round().toString()}/-' : '18%',
                                    style: textStyle,
                                  ),
                                ],
                              ),

                              // SizedBox(
                              //   height: 15,
                              // ),
                              // Container(
                              //   height: 30,
                              //   width: screenWidth/3.5,
                              //   child: TextField(
                              //     textAlignVertical: TextAlignVertical.center,
                              //     enabled: !apply ? true : false,
                              //     controller: couponCodeController,
                              //     style: TextStyle(
                              //       fontSize: 16 * min(horizontalScale, verticalScale),
                              //       letterSpacing: 1.2,
                              //       fontFamily: 'Medium',
                              //     ),
                              //     decoration: InputDecoration(
                              //       contentPadding: EdgeInsets.only(left: 10),
                              //       // constraints: BoxConstraints(minHeight: 52, minWidth: 366),
                              //       suffixIcon: TextButton(
                              //         child: apply
                              //             ? Text(
                              //           'Applied',
                              //           style: TextStyle(
                              //             color: Color.fromARGB(255, 96, 220, 193),
                              //             fontFamily: 'Medium',
                              //             fontSize:
                              //             18 * min(horizontalScale, verticalScale),
                              //             fontWeight: FontWeight.bold,
                              //           ),
                              //         )
                              //             : Text(
                              //           'Apply',
                              //           style: TextStyle(
                              //             color: Color(0xFF7860DC),
                              //             fontFamily: 'Medium',
                              //             fontSize:
                              //             18 * min(horizontalScale, verticalScale),
                              //             fontWeight: FontWeight.bold,
                              //           ),
                              //         ),
                              //         onPressed: () async {
                              //           try {
                              //             print("pressed${couponCodeController.text}");
                              //             await FirebaseFirestore.instance
                              //                 .collection("couponcode")
                              //                 .where("cname",
                              //                 isEqualTo: couponCodeController.text)
                              //                 .get()
                              //                 .then((value) {
                              //               print(value.docs.first['cname']);
                              //               print(DateTime.now().isBefore(
                              //                   value.docs.first['end_date'].toDate()));
                              //               var notexpired = DateTime.now().isBefore(
                              //                   value.docs.first['end_date'].toDate());
                              //               if (notexpired) {
                              //                 print(courseMap['name']);
                              //                 if (courseMap['name']
                              //                     .toString()
                              //                     .toLowerCase() ==
                              //                     value.docs.first['coursename']
                              //                         .toString()
                              //                         .toLowerCase()) {
                              //                   setState(() {
                              //                     print("fsijfoije");
                              //                     print(courseMap["Course Price"]);
                              //                     var coursevalue;
                              //                     try {
                              //                       coursevalue = courseMap['Course Price']
                              //                           .toString()
                              //                           .split("₹")[1]
                              //                           .toString()
                              //                           .split('/-')[0]
                              //                           .toString();
                              //                     } catch (e) {
                              //                       print(e);
                              //                       coursevalue = courseMap["Course Price"];
                              //                       print('uguy');
                              //                     }
                              //
                              //                     print(
                              //                         "oooooo${String.fromCharCodes(coursevalue.codeUnits.reversed).substring(0, 2)}");
                              //                     if (String.fromCharCodes(
                              //                         coursevalue.codeUnits.reversed)
                              //                         .substring(0, 2) ==
                              //                         '-/') {
                              //                       print("sdfsdo");
                              //                       coursevalue = String.fromCharCodes(
                              //                           coursevalue.codeUnits.reversed)
                              //                           .substring(2);
                              //                       coursevalue = String.fromCharCodes(
                              //                           coursevalue.codeUnits.reversed);
                              //                     }
                              //                     var courseintvalue = int.parse(coursevalue);
                              //                     print("lllll $courseintvalue");
                              //                     if (value.docs.first['type'] ==
                              //                         'percentage') {
                              //                       setState(() {
                              //                         newcoursevalue = courseintvalue *
                              //                             int.parse(
                              //                                 value.docs.first['value']) ~/
                              //                             100;
                              //                       });
                              //                     }
                              //                     if (value.docs.first['type'] == 'number') {
                              //                       setState(() {
                              //                         newcoursevalue = int.parse(
                              //                             value.docs.first['value']);
                              //                       });
                              //                     }
                              //                     apply = true;
                              //                     showToast(
                              //                         "cuponcode applyed successfully!");
                              //                     globals.cuponcode = "applied";
                              //                     globals.cuponname =
                              //                     value.docs.first['cname'];
                              //                     globals.cuponcourse =
                              //                     value.docs.first['coursename'];
                              //                     globals.cupondiscount =
                              //                     value.docs.first['value'];
                              //                     globals.cuponcourseprice =
                              //                         courseintvalue.toString();
                              //                     globals.cupontype =
                              //                     value.docs.first['type'];
                              //                   });
                              //                 } else {
                              //                   showToast(
                              //                       "This cuponcode belongs to '${value.docs.first['coursename']}' course!");
                              //                 }
                              //               }
                              //               if (notexpired == false) {
                              //                 showToast("invalid cuponcode!");
                              //               }
                              //             });
                              //           } catch (e) {
                              //             print(e);
                              //             print(courseMap['name']);
                              //             print(courseMap['Course Price']
                              //                 .toString()
                              //                 .split("₹")[1]
                              //                 .toString()
                              //                 .split('/-')[0]
                              //                 .toString());
                              //             showToast("invalid cuponcode!");
                              //           }
                              //
                              //           // setState(() {
                              //           //   NoCouponApplied = whetherCouponApplied(
                              //           //     couponCodeText: couponCodeController.text,
                              //           //   );
                              //           //   couponAppliedResponse = whenCouponApplied(
                              //           //     couponCodeText: couponCodeController.text,
                              //           //   );
                              //           //   finalamountToDisplay = amountToDisplayAfterCCA(
                              //           //     amountPayable: courseMap['Amount Payable'],
                              //           //     couponCodeText: couponCodeController.text,
                              //           //   );
                              //           //   finalAmountToPay = amountToPayAfterCCA(
                              //           //     couponCodeText: couponCodeController.text,
                              //           //     amountPayable: courseMap['Amount Payable'],
                              //           //   );
                              //           //   discountedPrice = discountAfterCCA(
                              //           //       couponCodeText: couponCodeController.text,
                              //           //       amountPayable: courseMap['Amount Payable']);
                              //           // });
                              //         },
                              //       ),
                              //       hintText: 'Enter coupon code',
                              //       fillColor: Colors.deepPurple.shade100,
                              //       filled: true,
                              //       // suffixIconConstraints:
                              //       // BoxConstraints(minHeight: 52, minWidth: 70),
                              //       // contentPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0),
                              //       enabledBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(5),
                              //         borderSide: BorderSide.none
                              //       ),
                              //       focusedBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(5),
                              //           borderSide: BorderSide.none
                              //       ),
                              //       disabledBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(5),
                              //           borderSide: BorderSide.none
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              SizedBox(height: 15),
                              SizedBox(
                                  child: Divider(
                                    color: Colors.black,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total Pay',
                                      style: textStyle,
                                    ),
                                    Text(
                                      NoCouponApplied
                                          ?
                                      courseMap['gst'] != null ? '₹${totalAmount.round().toString()}/-' :
                                      '₹${int.parse(courseprice) - (int.parse(discountvalue) + newcoursevalue)}/-' //courseMap["Amount Payable"]
                                          : finalamountToDisplay,
                                      style: textStyle,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  child: Divider(
                                    color: Colors.black,
                                  )),
                              SizedBox(height: 15 * verticalScale),
                              Center(
                                child: PaymentButton(
                                  coursePriceMoneyRef:
                                  int.parse(courseprice),
                                  amountString:
                                  (double.parse(NoCouponApplied
                                      ? courseMap['gst'] != null ? '${totalAmount.round().toString()}' :
                                  "${int.parse(courseprice) - int.parse(discountvalue)}"
                                      : finalAmountToPay) *
                                      100)
                                      .toString(),
                                  buttonText:
                                  NoCouponApplied ?
                                  courseMap['gst'] != null ?
                                  'PAY ₹${totalAmount.round().toString()}/-' :
                                  'PAY ₹${int.parse(courseprice) - int.parse(discountvalue)}/-' //${courseMap['Course Price']}

                                      : 'PAY ${finalamountToDisplay}',
                                  buttonTextForCode:
                                      "$finalamountToDisplay",
                                  changeState: () {
                                    setState(() {
                                      // isLoading = !isLoading;
                                    });
                                  },
                                  courseDescription: courseMap['description'],
                                  courseName: courseMap['name'],
                                  isPayButtonPressed: isPayButtonPressed,
                                  NoCouponApplied: NoCouponApplied,
                                  scrollController: _scrollController,
                                  updateCourseIdToCouponDetails: () {
                                    void addCourseId() {
                                      setState(() {
                                        id = courseMap['id'];
                                      });
                                    }

                                    addCourseId();
                                    print(NoCouponApplied);
                                  },
                                  outStandingAmountString:
                                  (
                                      double.parse( NoCouponApplied
                                          ? courseMap['Amount_Payablepay']
                                          : finalAmountToPay) -
                                          1000)
                                      .toStringAsFixed(2),
                                  courseId: courseMap['id'],
                                  courseImageUrl: courseMap['image_url'],
                                  couponCodeText: couponCodeController.text,
                                  isItComboCourse: widget.isItComboCourse,
                                  whichCouponCode: couponCodeController.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      } else {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10.0),
                child: Container(
                  height: screenHeight/5,
                  width: screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text('Congratulations',
                          textScaleFactor: min(horizontalScale, verticalScale),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 48 * verticalScale,
                            height: 1,
                          )),
                      ),
                      SizedBox(height: 25 * verticalScale),
                      Container(
                        child: Text('🤩You are just one step away🤩',
                          textScaleFactor: min(horizontalScale, verticalScale),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20 * verticalScale,
                            height: 1,
                          ),),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30, top: 15, bottom: 15),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(
                            2, // Move to right 10  horizontally
                            2.0, // Move to bottom 10 Vertically
                          ),
                          blurRadius: 40)
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 10, bottom: 10, right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Container(
                                // height: screenHeight/3.5,
                                // width: screenWidth/3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: courseMap['image_url'],
                                    placeholder: (context, url) =>
                                        Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.fill,
                                    height: 150 * verticalScale,
                                    width: 165 * horizontalScale,
                                  ),
                                ),
                              ),
                              // Container(
                              //   width: screenWidth/3,
                              //   padding: EdgeInsets.only(left: 5.0),
                              //   decoration: BoxDecoration(
                              //     color: Colors.deepPurple.shade100,
                              //   ),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     children: [
                              //       Padding(
                              //         padding: const EdgeInsets.only(right: 5.0),
                              //         child: Container(
                              //           height: 20,
                              //           width: 25,
                              //           decoration: BoxDecoration(
                              //             borderRadius: BorderRadius.circular(3.0),
                              //             color: HexColor('440F87'),
                              //           ),
                              //           child: Center(
                              //             child: Text(courseMap['reviews'] != null ? courseMap['reviews'] : '5.0',
                              //               style: TextStyle(fontSize: 12, color: Colors.white,
                              //                   fontWeight: FontWeight.normal),),
                              //           ),
                              //         ),
                              //       ),
                              //       Padding(
                              //         padding:
                              //         const EdgeInsets.only(right: 5.0),
                              //         child: StarRating(
                              //           length: 5,
                              //           rating: courseMap['reviews'] != null ? double.parse(courseMap['reviews']) : 5.0,
                              //           color: HexColor('440F87'),
                              //           starSize: 25,
                              //           mainAxisAlignment: MainAxisAlignment.start,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // SizedBox(height: 20,),
                              Container(
                                width: screenWidth/2.5,
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        courseMap['name'],
                                        textScaleFactor: min(horizontalScale, verticalScale),
                                        style: TextStyle(
                                          fontSize: 20 * verticalScale,
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                    SizedBox(height: 10 * verticalScale,),
                                    Container(
                                      child: Text(
                                        courseMap['description'],
                                        textScaleFactor: min(horizontalScale, verticalScale),
                                        style: TextStyle(
                                            fontSize: 12 * verticalScale,
                                            height: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 4,
                                      ),
                                    ),
                                    SizedBox(height: 10 * verticalScale,),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        'English  ||  online  ||  lifetime',
                                        textScaleFactor: min(horizontalScale, verticalScale),
                                        style: TextStyle(
                                            color: Colors.deepPurple.shade600,
                                            fontSize: 18 * verticalScale,
                                            height: 1
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15 * verticalScale,),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15 * verticalScale,),
                      Padding(
                        padding: EdgeInsets.only(right: 10.0, top: 10, bottom: 10, left: 10),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 25.0),
                                child: Container(
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text('BILL SUMMARY',
                                        textScaleFactor: min(horizontalScale, verticalScale),
                                        style: TextStyle(
                                          fontSize: 34 * verticalScale,
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                        ),),
                                    ),
                                  ),
                                ),
                              ),
                              DottedLine(
                                dashGapLength: 0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0, bottom: 10),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text('Course Details',
                                            style: TextStyle(
                                                color: Color.fromARGB(223, 48, 48, 49),
                                                fontFamily: 'Poppins',
                                                fontSize: 16 * verticalScale,
                                                letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                                fontWeight: FontWeight.bold,
                                                height: 1)),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text('Unit Price',
                                            style: TextStyle(
                                                color: Color.fromARGB(223, 48, 48, 49),
                                                fontFamily: 'Poppins',
                                                fontSize: 16 * verticalScale,
                                                letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                                fontWeight: FontWeight.bold,
                                                height: 1)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DottedLine(
                                dashGapLength: 0,
                              ),
                              SizedBox(height: 5 * verticalScale),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "Actual Price",
                                      style: textStyle,
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      courseMap['gst'] != null ? '₹${courseMap['Amount Payable']}/-' : courseMap['Amount Payable'],
                                      style: textStyle,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5 * verticalScale),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      'Discounted Price',
                                      style: textStyle,
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      courseMap['gst'] != null ? '₹${courseMap['Course Price']}/-' : courseMap['Course Price'],
                                      style: textStyle,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5 * verticalScale),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "GST",
                                      style: textStyle,
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      courseMap['gst'] != null ? '₹${gstAmount.round().toString()}/-' : '18%',
                                      style: textStyle,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15 * verticalScale,
                              ),
                              // Container(
                              //   height: 30,
                              //   // width: screenWidth/3.5,
                              //   child: TextField(
                              //     textAlignVertical: TextAlignVertical.center,
                              //     enabled: !apply ? true : false,
                              //     controller: couponCodeController,
                              //     style: TextStyle(
                              //       fontSize: 16 * min(horizontalScale, verticalScale),
                              //       letterSpacing: 1.2,
                              //       fontFamily: 'Medium',
                              //     ),
                              //     decoration: InputDecoration(
                              //       contentPadding: EdgeInsets.only(left: 10),
                              //       // constraints: BoxConstraints(minHeight: 52, minWidth: 366),
                              //       suffixIcon: TextButton(
                              //         child: apply
                              //             ? Text(
                              //           'Applied',
                              //           style: TextStyle(
                              //             color: Color.fromARGB(255, 96, 220, 193),
                              //             fontFamily: 'Medium',
                              //             fontSize:
                              //             18 * min(horizontalScale, verticalScale),
                              //             fontWeight: FontWeight.bold,
                              //           ),
                              //         )
                              //             : Text(
                              //           'Apply',
                              //           style: TextStyle(
                              //             color: Color(0xFF7860DC),
                              //             fontFamily: 'Medium',
                              //             fontSize:
                              //             18 * min(horizontalScale, verticalScale),
                              //             fontWeight: FontWeight.bold,
                              //           ),
                              //         ),
                              //         onPressed: () async {
                              //           try {
                              //             print("pressed${couponCodeController.text}");
                              //             await FirebaseFirestore.instance
                              //                 .collection("couponcode")
                              //                 .where("cname",
                              //                 isEqualTo: couponCodeController.text)
                              //                 .get()
                              //                 .then((value) {
                              //               print(value.docs.first['cname']);
                              //               print(DateTime.now().isBefore(
                              //                   value.docs.first['end_date'].toDate()));
                              //               var notexpired = DateTime.now().isBefore(
                              //                   value.docs.first['end_date'].toDate());
                              //               if (notexpired) {
                              //                 print(courseMap['name']);
                              //                 if (courseMap['name']
                              //                     .toString()
                              //                     .toLowerCase() ==
                              //                     value.docs.first['coursename']
                              //                         .toString()
                              //                         .toLowerCase()) {
                              //                   setState(() {
                              //                     print("fsijfoije");
                              //                     print(courseMap["Course Price"]);
                              //                     var coursevalue;
                              //                     try {
                              //                       coursevalue = courseMap['Course Price']
                              //                           .toString()
                              //                           .split("₹")[1]
                              //                           .toString()
                              //                           .split('/-')[0]
                              //                           .toString();
                              //                     } catch (e) {
                              //                       print(e);
                              //                       coursevalue = courseMap["Course Price"];
                              //                       print('uguy');
                              //                     }
                              //
                              //                     print(
                              //                         "oooooo${String.fromCharCodes(coursevalue.codeUnits.reversed).substring(0, 2)}");
                              //                     if (String.fromCharCodes(
                              //                         coursevalue.codeUnits.reversed)
                              //                         .substring(0, 2) ==
                              //                         '-/') {
                              //                       print("sdfsdo");
                              //                       coursevalue = String.fromCharCodes(
                              //                           coursevalue.codeUnits.reversed)
                              //                           .substring(2);
                              //                       coursevalue = String.fromCharCodes(
                              //                           coursevalue.codeUnits.reversed);
                              //                     }
                              //                     var courseintvalue = int.parse(coursevalue);
                              //                     print("lllll $courseintvalue");
                              //                     if (value.docs.first['type'] ==
                              //                         'percentage') {
                              //                       setState(() {
                              //                         newcoursevalue = courseintvalue *
                              //                             int.parse(
                              //                                 value.docs.first['value']) ~/
                              //                             100;
                              //                       });
                              //                     }
                              //                     if (value.docs.first['type'] == 'number') {
                              //                       setState(() {
                              //                         newcoursevalue = int.parse(
                              //                             value.docs.first['value']);
                              //                       });
                              //                     }
                              //                     apply = true;
                              //                     showToast(
                              //                         "cuponcode applyed successfully!");
                              //                     globals.cuponcode = "applied";
                              //                     globals.cuponname =
                              //                     value.docs.first['cname'];
                              //                     globals.cuponcourse =
                              //                     value.docs.first['coursename'];
                              //                     globals.cupondiscount =
                              //                     value.docs.first['value'];
                              //                     globals.cuponcourseprice =
                              //                         courseintvalue.toString();
                              //                     globals.cupontype =
                              //                     value.docs.first['type'];
                              //                   });
                              //                 } else {
                              //                   showToast(
                              //                       "This cuponcode belongs to '${value.docs.first['coursename']}' course!");
                              //                 }
                              //               }
                              //               if (notexpired == false) {
                              //                 showToast("invalid cuponcode!");
                              //               }
                              //             });
                              //           } catch (e) {
                              //             print(e);
                              //             print(courseMap['name']);
                              //             print(courseMap['Course Price']
                              //                 .toString()
                              //                 .split("₹")[1]
                              //                 .toString()
                              //                 .split('/-')[0]
                              //                 .toString());
                              //             showToast("invalid cuponcode!");
                              //           }
                              //
                              //           // setState(() {
                              //           //   NoCouponApplied = whetherCouponApplied(
                              //           //     couponCodeText: couponCodeController.text,
                              //           //   );
                              //           //   couponAppliedResponse = whenCouponApplied(
                              //           //     couponCodeText: couponCodeController.text,
                              //           //   );
                              //           //   finalamountToDisplay = amountToDisplayAfterCCA(
                              //           //     amountPayable: courseMap['Amount Payable'],
                              //           //     couponCodeText: couponCodeController.text,
                              //           //   );
                              //           //   finalAmountToPay = amountToPayAfterCCA(
                              //           //     couponCodeText: couponCodeController.text,
                              //           //     amountPayable: courseMap['Amount Payable'],
                              //           //   );
                              //           //   discountedPrice = discountAfterCCA(
                              //           //       couponCodeText: couponCodeController.text,
                              //           //       amountPayable: courseMap['Amount Payable']);
                              //           // });
                              //         },
                              //       ),
                              //       hintText: 'Enter coupon code',
                              //       fillColor: Colors.deepPurple.shade100,
                              //       filled: true,
                              //       // suffixIconConstraints:
                              //       // BoxConstraints(minHeight: 52, minWidth: 70),
                              //       // contentPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0),
                              //       enabledBorder: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(5),
                              //           borderSide: BorderSide.none
                              //       ),
                              //       focusedBorder: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(5),
                              //           borderSide: BorderSide.none
                              //       ),
                              //       disabledBorder: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(5),
                              //           borderSide: BorderSide.none
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              // SizedBox(height: 15),
                              DottedLine(
                                dashGapLength: 0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        'Total Pay',
                                        style: textStyle,
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        NoCouponApplied
                                            ?
                                        courseMap['gst'] != null ? '₹${totalAmount.round().toString()}/-' :
                                        '₹${int.parse(courseprice) - (int.parse(discountvalue) + newcoursevalue)}/-' //courseMap["Amount Payable"]
                                            : finalamountToDisplay,
                                        style: textStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DottedLine(
                                dashGapLength: 0,
                              ),
                              SizedBox(height: 25 * verticalScale),
                              Container(
                                width: screenWidth,
                                child: PaymentButton(
                                  coursePriceMoneyRef: int.parse(courseprice),
                                  amountString: (double.parse(NoCouponApplied
                                      ?
                                  courseMap['gst'] != null ? '${totalAmount.round().toString()}' :

                                  "${int.parse(courseprice) - int.parse(discountvalue)}"
                                      : finalAmountToPay) * //courseMap['Amount_Payablepay']
                                      100)
                                      .toString(),
                                  buttonText: NoCouponApplied
                                      ?
                                  courseMap['gst'] != null ?
                                  'PAY ₹${totalAmount.round().toString()}/-' :
                                  'PAY ₹${int.parse(courseprice) - int.parse(discountvalue)}/-' //${courseMap['Course Price']}

                                      : 'PAY ${finalamountToDisplay}',
                                  buttonTextForCode: "PAY $finalamountToDisplay",
                                  changeState: () {
                                    setState(() {
                                      // isLoading = !isLoading;
                                    });
                                  },
                                  courseDescription: courseMap['description'],
                                  courseName: courseMap['name'],
                                  isPayButtonPressed: isPayButtonPressed,
                                  NoCouponApplied: NoCouponApplied,
                                  scrollController: _scrollController,
                                  updateCourseIdToCouponDetails: () {
                                    void addCourseId() {
                                      setState(() {
                                        id = courseMap['id'];
                                      });
                                    }

                                    addCourseId();
                                    print(NoCouponApplied);
                                  },
                                  outStandingAmountString: (
                                      double.parse( NoCouponApplied
                                          ? courseMap['Amount_Payablepay']
                                          : finalAmountToPay) -
                                          1000)
                                      .toStringAsFixed(2),
                                  courseId: courseMap['id'],
                                  courseImageUrl: courseMap['image_url'],
                                  couponCodeText: couponCodeController.text,
                                  isItComboCourse: widget.isItComboCourse,
                                  whichCouponCode: couponCodeController.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
        //   Stack(
        //   children: [
        //     Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 20),
        //       child: SingleChildScrollView(
        //         controller: _scrollController,
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             SizedBox(
        //               height: 150,
        //             ),
        //             Text(
        //               'Course Details',
        //               textScaleFactor: min(horizontalScale, verticalScale),
        //               style: TextStyle(
        //                   color: Color.fromRGBO(48, 48, 49, 1),
        //                   fontFamily: 'Poppins',
        //                   fontSize: 34,
        //                   letterSpacing:
        //                   0 /*percentages not used in flutter. defaulting to zero*/,
        //                   fontWeight: FontWeight.bold,
        //                   height: 1),
        //             ),
        //             SizedBox(
        //               height: 20,
        //             ),
        //             Center(
        //               child: Container(
        //                 width: 366 * horizontalScale,
        //                 height: 170 * verticalScale,
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.only(
        //                     topLeft: Radius.circular(15),
        //                     topRight: Radius.circular(15),
        //                     bottomLeft: Radius.circular(15),
        //                     bottomRight: Radius.circular(15),
        //                   ),
        //                   boxShadow: [
        //                     BoxShadow(
        //                         color:
        //                         Color.fromRGBO(31, 31, 31, 0.20000000298023224),
        //                         offset: Offset(2, 10),
        //                         blurRadius: 20)
        //                   ],
        //                   color: Color.fromRGBO(255, 255, 255, 1),
        //                 ),
        //                 child: Row(
        //                   children: [
        //                     SizedBox(
        //                       width: 5,
        //                     ),
        //                     Container(
        //                       height: 140 * verticalScale,
        //                       width: 80 * horizontalScale,
        //                       child: ClipRRect(
        //                         borderRadius: BorderRadius.circular(15),
        //                         child: CachedNetworkImage(
        //                           imageUrl: courseMap['image_url'],
        //                           placeholder: (context, url) =>
        //                               Center(child: CircularProgressIndicator()),
        //                           errorWidget: (context, url, error) =>
        //                               Icon(Icons.error),
        //                           fit: BoxFit.fill,
        //                           height: 110 * verticalScale,
        //                           width: 140 * horizontalScale,
        //                         ),
        //                       ),
        //                     ),
        //                     SizedBox(
        //                       width: 10,
        //                     ),
        //                     Expanded(
        //                       flex: 2,
        //                       child: Column(
        //                         crossAxisAlignment: CrossAxisAlignment.start,
        //                         children: [
        //                           SizedBox(
        //                             height: 10,
        //                           ),
        //                           Container(
        //                             width: 250 * horizontalScale,
        //                             height: 30 * verticalScale,
        //                             child: Text(
        //                               courseMap['name'],
        //                               textScaleFactor:
        //                               min(horizontalScale, verticalScale),
        //                               textAlign: TextAlign.left,
        //                               style: TextStyle(
        //                                 color: Color.fromRGBO(0, 0, 0, 1),
        //                                 fontFamily: 'Poppins',
        //                                 fontSize: 26,
        //                                 letterSpacing: 0,
        //                                 fontWeight: FontWeight.bold,
        //                                 height: 1,
        //                               ),
        //                             ),
        //                           ),
        //                           SizedBox(
        //                             height: 10,
        //                           ),
        //                           Container(
        //                             width: 250 * horizontalScale,
        //                             height: 30 * verticalScale,
        //                             child: Text(
        //                               courseMap['description'],
        //                               // overflow: TextOverflow.ellipsis,
        //                               textScaleFactor:
        //                               min(horizontalScale, verticalScale),
        //                               textAlign: TextAlign.left,
        //                               style: TextStyle(
        //                                 color: Color.fromRGBO(0, 0, 0, 1),
        //                                 fontFamily: 'Poppins',
        //                                 fontSize: 18,
        //                                 letterSpacing: 0,
        //                                 fontWeight: FontWeight.normal,
        //                                 height: 1,
        //                               ),
        //                             ),
        //                           ),
        //                           // SizedBox(
        //                           //   height: 10,
        //                           // ),
        //                           Expanded(
        //                             child: Image.asset(
        //                               'assets/Rating.png',
        //                               fit: BoxFit.fill,
        //                               height: 15,
        //                               width: 71,
        //                             ),
        //                           ),
        //                           SizedBox(
        //                             height: 10,
        //                           ),
        //                           Expanded(
        //                             child: Row(
        //                               children: [
        //                                 Text(
        //                                   'English  ||  ${courseMap['videosCount']} Videos',
        //                                   textAlign: TextAlign.left,
        //                                   textScaleFactor:
        //                                   min(horizontalScale, verticalScale),
        //                                   style: TextStyle(
        //                                       color: Color.fromRGBO(88, 88, 88, 1),
        //                                       fontFamily: 'Poppins',
        //                                       fontSize: 14,
        //                                       letterSpacing:
        //                                       0 /*percentages not used in flutter. defaulting to zero*/,
        //                                       fontWeight: FontWeight.normal,
        //                                       height: 1),
        //                                 ),
        //                                 SizedBox(
        //                                   width: 20,
        //                                 ),
        //                                 Text(
        //                                   '₹${courseMap['Course Price']}/-',
        //                                   textScaleFactor:
        //                                   min(horizontalScale, verticalScale),
        //                                   textAlign: TextAlign.left,
        //                                   style: TextStyle(
        //                                       color:
        //                                       Color.fromRGBO(155, 117, 237, 1),
        //                                       fontFamily: 'Poppins',
        //                                       fontSize: 18,
        //                                       letterSpacing:
        //                                       0 /*percentages not used in flutter. defaulting to zero*/,
        //                                       fontWeight: FontWeight.bold,
        //                                       height: 1),
        //                                 ),
        //                               ],
        //                             ),
        //                           ),
        //                           SizedBox(
        //                             height: 10,
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //             SizedBox(
        //               height: 30,
        //             ),
        //             Text(
        //               'Coupon Code',
        //               textScaleFactor: min(horizontalScale, verticalScale),
        //               style: TextStyle(
        //                   color: Color.fromRGBO(48, 48, 49, 1),
        //                   fontFamily: 'Poppins',
        //                   fontSize: 34,
        //                   letterSpacing:
        //                   0 /*percentages not used in flutter. defaulting to zero*/,
        //                   fontWeight: FontWeight.bold,
        //                   height: 1),
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             TextField(
        //               enabled: !apply ? true : false,
        //               controller: couponCodeController,
        //               style: TextStyle(
        //                 fontSize: 16 * min(horizontalScale, verticalScale),
        //                 letterSpacing: 1.2,
        //                 fontFamily: 'Medium',
        //               ),
        //               decoration: InputDecoration(
        //                 // constraints: BoxConstraints(minHeight: 52, minWidth: 366),
        //                 suffixIcon: TextButton(
        //                   child: apply
        //                       ? Text(
        //                     'Applied',
        //                     style: TextStyle(
        //                       color: Color.fromARGB(255, 96, 220, 193),
        //                       fontFamily: 'Medium',
        //                       fontSize:
        //                       18 * min(horizontalScale, verticalScale),
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   )
        //                       : Text(
        //                     'Apply',
        //                     style: TextStyle(
        //                       color: Color(0xFF7860DC),
        //                       fontFamily: 'Medium',
        //                       fontSize:
        //                       18 * min(horizontalScale, verticalScale),
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ),
        //                   onPressed: () async {
        //                     try {
        //                       print("pressed${couponCodeController.text}");
        //                       await FirebaseFirestore.instance
        //                           .collection("couponcode")
        //                           .where("cname",
        //                           isEqualTo: couponCodeController.text)
        //                           .get()
        //                           .then((value) {
        //                         print(value.docs.first['cname']);
        //                         print(DateTime.now().isBefore(
        //                             value.docs.first['end_date'].toDate()));
        //                         var notexpired = DateTime.now().isBefore(
        //                             value.docs.first['end_date'].toDate());
        //                         if (notexpired) {
        //                           print(courseMap['name']);
        //                           if (courseMap['name']
        //                               .toString()
        //                               .toLowerCase() ==
        //                               value.docs.first['coursename']
        //                                   .toString()
        //                                   .toLowerCase()) {
        //                             setState(() {
        //                               print("fsijfoije");
        //                               print(courseMap["Course Price"]);
        //                               var coursevalue;
        //                               try {
        //                                 coursevalue = courseMap['Course Price']
        //                                     .toString()
        //                                     .split("₹")[1]
        //                                     .toString()
        //                                     .split('/-')[0]
        //                                     .toString();
        //                               } catch (e) {
        //                                 print(e);
        //                                 coursevalue = courseMap["Course Price"];
        //                                 print('uguy');
        //                               }
        //
        //                               print(
        //                                   "oooooo${String.fromCharCodes(coursevalue.codeUnits.reversed).substring(0, 2)}");
        //                               if (String.fromCharCodes(
        //                                   coursevalue.codeUnits.reversed)
        //                                   .substring(0, 2) ==
        //                                   '-/') {
        //                                 print("sdfsdo");
        //                                 coursevalue = String.fromCharCodes(
        //                                     coursevalue.codeUnits.reversed)
        //                                     .substring(2);
        //                                 coursevalue = String.fromCharCodes(
        //                                     coursevalue.codeUnits.reversed);
        //                               }
        //                               var courseintvalue = int.parse(coursevalue);
        //                               print("lllll $courseintvalue");
        //                               if (value.docs.first['type'] ==
        //                                   'percentage') {
        //                                 setState(() {
        //                                   newcoursevalue = courseintvalue *
        //                                       int.parse(
        //                                           value.docs.first['value']) ~/
        //                                       100;
        //                                 });
        //                               }
        //                               if (value.docs.first['type'] == 'number') {
        //                                 setState(() {
        //                                   newcoursevalue = int.parse(
        //                                       value.docs.first['value']);
        //                                 });
        //                               }
        //                               apply = true;
        //                               showToast(
        //                                   "cuponcode applyed successfully!");
        //                               globals.cuponcode = "applied";
        //                               globals.cuponname =
        //                               value.docs.first['cname'];
        //                               globals.cuponcourse =
        //                               value.docs.first['coursename'];
        //                               globals.cupondiscount =
        //                               value.docs.first['value'];
        //                               globals.cuponcourseprice =
        //                                   courseintvalue.toString();
        //                               globals.cupontype =
        //                               value.docs.first['type'];
        //                             });
        //                           } else {
        //                             showToast(
        //                                 "This cuponcode belongs to '${value.docs.first['coursename']}' course!");
        //                           }
        //                         }
        //                         if (notexpired == false) {
        //                           showToast("invalid cuponcode!");
        //                         }
        //                       });
        //                     } catch (e) {
        //                       print(e);
        //                       print(courseMap['name']);
        //                       print(courseMap['Course Price']
        //                           .toString()
        //                           .split("₹")[1]
        //                           .toString()
        //                           .split('/-')[0]
        //                           .toString());
        //                       showToast("invalid cuponcode!");
        //                     }
        //
        //                     // setState(() {
        //                     //   NoCouponApplied = whetherCouponApplied(
        //                     //     couponCodeText: couponCodeController.text,
        //                     //   );
        //                     //   couponAppliedResponse = whenCouponApplied(
        //                     //     couponCodeText: couponCodeController.text,
        //                     //   );
        //                     //   finalamountToDisplay = amountToDisplayAfterCCA(
        //                     //     amountPayable: courseMap['Amount Payable'],
        //                     //     couponCodeText: couponCodeController.text,
        //                     //   );
        //                     //   finalAmountToPay = amountToPayAfterCCA(
        //                     //     couponCodeText: couponCodeController.text,
        //                     //     amountPayable: courseMap['Amount Payable'],
        //                     //   );
        //                     //   discountedPrice = discountAfterCCA(
        //                     //       couponCodeText: couponCodeController.text,
        //                     //       amountPayable: courseMap['Amount Payable']);
        //                     // });
        //                   },
        //                 ),
        //                 hintText: 'Enter coupon code',
        //                 fillColor: Colors.grey.shade100,
        //                 filled: true,
        //                 suffixIconConstraints:
        //                 BoxConstraints(minHeight: 52, minWidth: 100),
        //                 // contentPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0),
        //                 enabledBorder: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(15),
        //                   borderSide: BorderSide(
        //                     color: Colors.grey.shade300,
        //                     width: 2,
        //                   ),
        //                 ),
        //                 focusedBorder: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(15),
        //                   borderSide: BorderSide(
        //                     color: Colors.grey.shade300,
        //                     width: 2,
        //                   ),
        //                 ),
        //                 disabledBorder: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(15),
        //                   borderSide: BorderSide(
        //                     color: Colors.grey.shade300,
        //                     width: 2,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             Center(
        //               child: Container(
        //                 width: MediaQuery.of(context).size.width * 0.9,
        //                 height: 55,
        //                 child: TextButton(
        //                   style: ButtonStyle(
        //                       shape: MaterialStateProperty.all<
        //                           RoundedRectangleBorder>(
        //                           RoundedRectangleBorder(
        //                               borderRadius: BorderRadius.circular(15.0),
        //                               side:
        //                               BorderSide(color: Color(0xFF7860DC))))),
        //                   onPressed: () {
        //                     setcoursevalue();
        //                   },
        //                   child: rewardvalue == null
        //                       ? Text('Redeem Reward 0',
        //                       style: TextStyle(color: Color(0xFF7860DC)))
        //                       : Text('Redeem Reward $rewardvalue',
        //                       style: TextStyle(color: Color(0xFF7860DC))),
        //                 ),
        //               ),
        //             ),
        //             SizedBox(
        //               height: 40,
        //             ),
        //             Text(
        //               'Bill Details',
        //               textScaleFactor: min(horizontalScale, verticalScale),
        //               style: TextStyle(
        //                   color: Color.fromRGBO(48, 48, 49, 1),
        //                   fontFamily: 'Poppins',
        //                   fontSize: 34,
        //                   letterSpacing:
        //                   0 /*percentages not used in flutter. defaulting to zero*/,
        //                   fontWeight: FontWeight.bold,
        //                   height: 1),
        //             ),
        //             SizedBox(
        //               height: 20,
        //             ),
        //             Center(
        //               child: Container(
        //                 width: 366 * horizontalScale,
        //                 // height: 170 * verticalScale,
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.only(
        //                     topLeft: Radius.circular(15),
        //                     topRight: Radius.circular(15),
        //                     bottomLeft: Radius.circular(15),
        //                     bottomRight: Radius.circular(15),
        //                   ),
        //                   boxShadow: [
        //                     BoxShadow(
        //                         color:
        //                         Color.fromRGBO(31, 31, 31, 0.20000000298023224),
        //                         offset: Offset(0, 0),
        //                         blurRadius: 5)
        //                   ],
        //                   color: Color.fromRGBO(255, 255, 255, 1),
        //                 ),
        //                 child: Padding(
        //                   padding: EdgeInsets.all(10),
        //                   child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                     children: [
        //                       Container(
        //                         child: Row(
        //                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                           children: [
        //                             Expanded(
        //                               flex: 3,
        //                               child: Text(
        //                                 'Course Price',
        //                                 style: textStyle,
        //                               ),
        //                             ),
        //                             Expanded(
        //                               // flex: 2,
        //                               child: Text(
        //                                 courseMap['gst'] != null ? '₹${courseMap['Course Price']}/-' : courseMap['Course Price'],
        //                                 style: textStyle,
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                       SizedBox(height: 5),
        //                       Container(
        //                         child: Row(
        //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                           children: [
        //                             Expanded(
        //                               flex: 3,
        //                               child: Text(
        //                                 "Discount",
        //                                 style: textStyle,
        //                               ),
        //                             ),
        //                             Expanded(
        //                               child: Text(
        //                                 NoCouponApplied
        //                                     ? '₹${double.parse(discountvalue) + newcoursevalue} /-' //${courseMap["Discount"]}
        //                                     : discountedPrice,
        //                                 style: textStyle,
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                       SizedBox(height: 5),
        //                       Container(
        //                         child: Row(
        //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                           children: [
        //                             Expanded(
        //                               flex: 3,
        //                               child: Text(
        //                                 "GST",
        //                                 style: textStyle,
        //                               ),
        //                             ),
        //                             Expanded(
        //                               child: Text(
        //                                 courseMap['gst'] != null ? '₹${gstAmount.round().toString()}/-' : '18%',
        //                                 style: textStyle,
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                       SizedBox(height: 15),
        //
        //                       DottedLine(),
        //                       SizedBox(height: 15),
        //                       Container(
        //                         child: Row(
        //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                           children: [
        //                             Expanded(
        //                               flex: 3,
        //                               child: Text(
        //                                 'Total Pay',
        //                                 style: textStyle,
        //                               ),
        //                             ),
        //                             Expanded(
        //                               child: Text(
        //                                 NoCouponApplied
        //                                     ?
        //                                 courseMap['gst'] != null ? '₹${totalAmount.round().toString()}/-' :
        //                                 '₹${int.parse(courseprice) - (int.parse(discountvalue) + newcoursevalue)}/-' //courseMap["Amount Payable"]
        //                                     : finalamountToDisplay,
        //                                 style: textStyle,
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             SizedBox(
        //               height: 20,
        //             ),
        //             Center(
        //               child:  PaymentButton(
        //                 coursePriceMoneyRef: int.parse(courseprice),
        //                 amountString: (double.parse(NoCouponApplied
        //                     ?
        //                 courseMap['gst'] != null ? '${totalAmount.round().toString()}' :
        //
        //                 "${int.parse(courseprice) - int.parse(discountvalue)}"
        //                     : finalAmountToPay) * //courseMap['Amount_Payablepay']
        //                     100)
        //                     .toString(),
        //                 buttonText: NoCouponApplied
        //                     ?
        //                 courseMap['gst'] != null ?
        //                 'Buy Now for ₹${totalAmount.round().toString()}/-' :
        //                 'Buy Now for ₹${int.parse(courseprice) - int.parse(discountvalue)}/-' //${courseMap['Course Price']}
        //
        //                     : 'Buy Now for ${finalamountToDisplay}',
        //                 buttonTextForCode: "Buy Now for $finalamountToDisplay",
        //                 changeState: () {
        //                   setState(() {
        //                     // isLoading = !isLoading;
        //                   });
        //                 },
        //                 courseDescription: courseMap['description'],
        //                 courseName: courseMap['name'],
        //                 isPayButtonPressed: isPayButtonPressed,
        //                 NoCouponApplied: NoCouponApplied,
        //                 scrollController: _scrollController,
        //                 updateCourseIdToCouponDetails: () {
        //                   void addCourseId() {
        //                     setState(() {
        //                       id = courseMap['id'];
        //                     });
        //                   }
        //
        //                   addCourseId();
        //                   print(NoCouponApplied);
        //                 },
        //                 outStandingAmountString: (
        //                     double.parse( NoCouponApplied
        //                         ? courseMap['Amount_Payablepay']
        //                         : finalAmountToPay) -
        //                         1000)
        //                     .toStringAsFixed(2),
        //                 courseId: courseMap['id'],
        //                 courseImageUrl: courseMap['image_url'],
        //                 couponCodeText: couponCodeController.text,
        //                 isItComboCourse: widget.isItComboCourse,
        //                 whichCouponCode: couponCodeController.text,
        //               ),
        //             ),
        //             SizedBox(
        //               height: 20,
        //             ),
        //             // Center(
        //             //   child: Container(
        //             //     width: 200,
        //             //     child: Text(
        //             //       "* Amount payable is inclusive of taxes. TERMS & CONDITIONS APPLY",
        //             //       textAlign: TextAlign.center,
        //             //       style: TextStyle(
        //             //         fontFamily: 'Regular',
        //             //         fontSize: 12,
        //             //       ),
        //             //     ),
        //             //   ),
        //             // ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // );
      }

        }
      ),
    );
  }
}