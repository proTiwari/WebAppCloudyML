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
import 'fun.dart';
import 'global_variable.dart' as globals;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic>? map;
  final bool isItComboCourse;
  const PaymentScreen(
      {Key? key, required this.map, required this.isItComboCourse})
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

  getAmounts() {
    try{
      if (widget.map!['gst'] != null) {
        gstAmount = int.parse('${widget.map!['gst']}') * 0.01 * int.parse('${widget.map!['Course Price']}');
        print('this is gst ${gstAmount.round()}');

        totalAmount = (int.parse('${widget.map!['gst']}') * 0.01 * int.parse('${widget.map!['Course Price']}')) + int.parse('${widget.map!['Course Price']}');
        print('this is totalAmount ${totalAmount.round()}');

      }
    } catch(e){
      Fluttertoast.showToast(msg: e.toString());
      print('amount error is here ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    getrewardvalue();
    getAmounts();
  }

  Future<void> getrewardvalue() async {
    print("wewewewewew1");
    courseprice = widget.map!['Course Price'].toString().replaceAll("₹", "");

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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 65 * max(verticalScale, horizontalScale),
                  ),
                  Text(
                    'Course Details',
                    textScaleFactor: min(horizontalScale, verticalScale),
                    style: TextStyle(
                        color: Color.fromRGBO(48, 48, 49, 1),
                        fontFamily: 'Poppins',
                        fontSize: 34,
                        letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.bold,
                        height: 1),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      width: 366 * horizontalScale,
                      height: 150 * verticalScale,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color:
                              Color.fromRGBO(31, 31, 31, 0.20000000298023224),
                              offset: Offset(2, 10),
                              blurRadius: 20)
                        ],
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: widget.map!['image_url'],
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.fill,
                                height: 110 * verticalScale,
                                width: 127 * horizontalScale,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    width: 194 * horizontalScale,
                                    height: 25 * verticalScale,
                                    child: Text(
                                      widget.map!['name'],
                                      textScaleFactor:
                                      min(horizontalScale, verticalScale),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 18,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.bold,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    width: 194,
                                    child: Text(
                                      widget.map!['description'],
                                      // overflow: TextOverflow.ellipsis,
                                      textScaleFactor:
                                      min(horizontalScale, verticalScale),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 10,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.normal,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                Expanded(
                                  child: Image.asset(
                                    'assets/Rating.png',
                                    fit: BoxFit.fill,
                                    height: 11,
                                    width: 71,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        'English  ||  ${widget.map!['videosCount']} Videos',
                                        textAlign: TextAlign.left,
                                        textScaleFactor:
                                        min(horizontalScale, verticalScale),
                                        style: TextStyle(
                                            color: Color.fromRGBO(88, 88, 88, 1),
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.normal,
                                            height: 1),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        '₹${widget.map!['Course Price']}/-',
                                        textScaleFactor:
                                        min(horizontalScale, verticalScale),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color:
                                            Color.fromRGBO(155, 117, 237, 1),
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Coupon Code',
                    textScaleFactor: min(horizontalScale, verticalScale),
                    style: TextStyle(
                        color: Color.fromRGBO(48, 48, 49, 1),
                        fontFamily: 'Poppins',
                        fontSize: 34,
                        letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.bold,
                        height: 1),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    enabled: !apply ? true : false,
                    controller: couponCodeController,
                    style: TextStyle(
                      fontSize: 16 * min(horizontalScale, verticalScale),
                      letterSpacing: 1.2,
                      fontFamily: 'Medium',
                    ),
                    decoration: InputDecoration(
                      // constraints: BoxConstraints(minHeight: 52, minWidth: 366),
                      suffixIcon: TextButton(
                        child: apply
                            ? Text(
                          'Applied',
                          style: TextStyle(
                            color: Color.fromARGB(255, 96, 220, 193),
                            fontFamily: 'Medium',
                            fontSize:
                            18 * min(horizontalScale, verticalScale),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            : Text(
                          'Apply',
                          style: TextStyle(
                            color: Color(0xFF7860DC),
                            fontFamily: 'Medium',
                            fontSize:
                            18 * min(horizontalScale, verticalScale),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          try {
                            print("pressed${couponCodeController.text}");
                            await FirebaseFirestore.instance
                                .collection("couponcode")
                                .where("cname",
                                isEqualTo: couponCodeController.text)
                                .get()
                                .then((value) {
                              print(value.docs.first['cname']);
                              print(DateTime.now().isBefore(
                                  value.docs.first['end_date'].toDate()));
                              var notexpired = DateTime.now().isBefore(
                                  value.docs.first['end_date'].toDate());
                              if (notexpired) {
                                print(widget.map!['name']);
                                if (widget.map!['name']
                                    .toString()
                                    .toLowerCase() ==
                                    value.docs.first['coursename']
                                        .toString()
                                        .toLowerCase()) {
                                  setState(() {
                                    print("fsijfoije");
                                    print(widget.map!["Course Price"]);
                                    var coursevalue;
                                    try {
                                      coursevalue = widget.map!['Course Price']
                                          .toString()
                                          .split("₹")[1]
                                          .toString()
                                          .split('/-')[0]
                                          .toString();
                                    } catch (e) {
                                      print(e);
                                      coursevalue = widget.map!["Course Price"];
                                      print('uguy');
                                    }

                                    print(
                                        "oooooo${String.fromCharCodes(coursevalue.codeUnits.reversed).substring(0, 2)}");
                                    if (String.fromCharCodes(
                                        coursevalue.codeUnits.reversed)
                                        .substring(0, 2) ==
                                        '-/') {
                                      print("sdfsdo");
                                      coursevalue = String.fromCharCodes(
                                          coursevalue.codeUnits.reversed)
                                          .substring(2);
                                      coursevalue = String.fromCharCodes(
                                          coursevalue.codeUnits.reversed);
                                    }
                                    var courseintvalue = int.parse(coursevalue);
                                    print("lllll $courseintvalue");
                                    if (value.docs.first['type'] ==
                                        'percentage') {
                                      setState(() {
                                        newcoursevalue = courseintvalue *
                                            int.parse(
                                                value.docs.first['value']) ~/
                                            100;
                                      });
                                    }
                                    if (value.docs.first['type'] == 'number') {
                                      setState(() {
                                        newcoursevalue = int.parse(
                                            value.docs.first['value']);
                                      });
                                    }
                                    apply = true;
                                    showToast(
                                        "cuponcode applyed successfully!");
                                    globals.cuponcode = "applied";
                                    globals.cuponname =
                                    value.docs.first['cname'];
                                    globals.cuponcourse =
                                    value.docs.first['coursename'];
                                    globals.cupondiscount =
                                    value.docs.first['value'];
                                    globals.cuponcourseprice =
                                        courseintvalue.toString();
                                    globals.cupontype =
                                    value.docs.first['type'];
                                  });
                                } else {
                                  showToast(
                                      "This cuponcode belongs to '${value.docs.first['coursename']}' course!");
                                }
                              }
                              if (notexpired == false) {
                                showToast("invalid cuponcode!");
                              }
                            });
                          } catch (e) {
                            print(e);
                            print(widget.map!['name']);
                            print(widget.map!['Course Price']
                                .toString()
                                .split("₹")[1]
                                .toString()
                                .split('/-')[0]
                                .toString());
                            showToast("invalid cuponcode!");
                          }

                          // setState(() {
                          //   NoCouponApplied = whetherCouponApplied(
                          //     couponCodeText: couponCodeController.text,
                          //   );
                          //   couponAppliedResponse = whenCouponApplied(
                          //     couponCodeText: couponCodeController.text,
                          //   );
                          //   finalamountToDisplay = amountToDisplayAfterCCA(
                          //     amountPayable: widget.map!['Amount Payable'],
                          //     couponCodeText: couponCodeController.text,
                          //   );
                          //   finalAmountToPay = amountToPayAfterCCA(
                          //     couponCodeText: couponCodeController.text,
                          //     amountPayable: widget.map!['Amount Payable'],
                          //   );
                          //   discountedPrice = discountAfterCCA(
                          //       couponCodeText: couponCodeController.text,
                          //       amountPayable: widget.map!['Amount Payable']);
                          // });
                        },
                      ),
                      hintText: 'Enter coupon code',
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      suffixIconConstraints:
                      BoxConstraints(minHeight: 52, minWidth: 100),
                      // contentPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 55,
                      child: TextButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side:
                                    BorderSide(color: Color(0xFF7860DC))))),
                        onPressed: () {
                          setcoursevalue();
                        },
                        child: rewardvalue == null
                            ? Text('Redeem Reward 0',
                            style: TextStyle(color: Color(0xFF7860DC)))
                            : Text('Redeem Reward $rewardvalue',
                            style: TextStyle(color: Color(0xFF7860DC))),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Bill Details',
                    textScaleFactor: min(horizontalScale, verticalScale),
                    style: TextStyle(
                        color: Color.fromRGBO(48, 48, 49, 1),
                        fontFamily: 'Poppins',
                        fontSize: 34,
                        letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.bold,
                        height: 1),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      width: 366 * horizontalScale,
                      height: 150 * verticalScale,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color:
                              Color.fromRGBO(31, 31, 31, 0.20000000298023224),
                              offset: Offset(0, 0),
                              blurRadius: 5)
                        ],
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(right: 10, left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Course Price',
                                      style: TextStyle(
                                        color: Color.fromARGB(223, 48, 48, 49),
                                        fontFamily: 'Poppins',
                                        fontSize: 18,
                                        letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.w500,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    // flex: 2,
                                    child: Text(
                                      widget.map!['gst'] != null ? '₹${widget.map!['Course Price']}/-' : widget.map!['Course Price'],
                                      style: TextStyle(
                                          color: Color.fromARGB(223, 48, 48, 49),
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "Discount",
                                      style: TextStyle(
                                          color: Color.fromARGB(223, 48, 48, 49),
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      NoCouponApplied
                                          ? '₹${double.parse(discountvalue) + newcoursevalue} /-' //${widget.map!["Discount"]}
                                          : discountedPrice,
                                      style: TextStyle(
                                          color: Color.fromARGB(223, 48, 48, 49),
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "GST",
                                      style: TextStyle(
                                          color: Color.fromARGB(223, 48, 48, 49),
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.map!['gst'] != null ? '₹${gstAmount.round().toString()}/-' : '18%',
                                      style: TextStyle(
                                          color: Color.fromARGB(223, 48, 48, 49),
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),

                            DottedLine(),
                            SizedBox(height: 15),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Total Pay',
                                      style: TextStyle(
                                          color: Color.fromARGB(223, 48, 48, 49),
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      NoCouponApplied
                                          ?
                                      widget.map!['gst'] != null ? '₹${totalAmount.round().toString()}/-' :
                                      '₹${int.parse(courseprice) - (int.parse(discountvalue) + newcoursevalue)}/-' //widget.map!["Amount Payable"]
                                          : finalamountToDisplay,
                                      style: TextStyle(
                                          color: Color.fromARGB(223, 48, 48, 49),
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.w500,
                                          height: 1),
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
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child:  PaymentButton(
                      coursePriceMoneyRef: int.parse(courseprice),
                      amountString: (double.parse(NoCouponApplied
                          ?
                      widget.map!['gst'] != null ? '${totalAmount.round().toString()}' :

                      "${int.parse(courseprice) - int.parse(discountvalue)}"
                          : finalAmountToPay) * //widget.map!['Amount_Payablepay']
                          100)
                          .toString(),
                      buttonText: NoCouponApplied
                          ?
                      widget.map!['gst'] != null ?
                      'Buy Now for ₹${totalAmount.round().toString()}/-' :
                      'Buy Now for ₹${int.parse(courseprice) - int.parse(discountvalue)}/-' //${widget.map!['Course Price']}

                          : 'Buy Now for ${finalamountToDisplay}',
                      buttonTextForCode: "Buy Now for $finalamountToDisplay",
                      changeState: () {
                        setState(() {
                          // isLoading = !isLoading;
                        });
                      },
                      courseDescription: widget.map!['description'],
                      courseName: widget.map!['name'],
                      isPayButtonPressed: isPayButtonPressed,
                      NoCouponApplied: NoCouponApplied,
                      scrollController: _scrollController,
                      updateCourseIdToCouponDetails: () {
                        void addCourseId() {
                          setState(() {
                            id = widget.map!['id'];
                          });
                        }

                        addCourseId();
                        print(NoCouponApplied);
                      },
                      outStandingAmountString: (
                          double.parse( NoCouponApplied
                              ? widget.map!['Amount_Payablepay']
                              : finalAmountToPay) -
                              1000)
                          .toStringAsFixed(2),
                      courseId: widget.map!['id'],
                      courseImageUrl: widget.map!['image_url'],
                      couponCodeText: couponCodeController.text,
                      isItComboCourse: widget.isItComboCourse,
                      whichCouponCode: couponCodeController.text,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Center(
                  //   child: Container(
                  //     width: 200,
                  //     child: Text(
                  //       "* Amount payable is inclusive of taxes. TERMS & CONDITIONS APPLY",
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         fontFamily: 'Regular',
                  //         fontSize: 12,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Container(
            width: screenWidth,
            height: 193 * verticalScale,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              color: Color.fromRGBO(122, 98, 222, 1),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 90 * verticalScale,
                  left: 50 * horizontalScale,
                  child: Container(
                    // width: 230,
                    // height: 81,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30 * min(horizontalScale, verticalScale),
                          ),
                        ),
                        SizedBox(width: 10),
                        Center(
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}