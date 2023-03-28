// TODO Implement this library.import 'package:cloudyml_app2/payment_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NonTrialCourseBottomSheet extends StatelessWidget {
  String coursePrice;
  Map<String, dynamic> map;
  bool isItComboCourse;
  String cID;

  NonTrialCourseBottomSheet({

    required this.coursePrice,
    required this.map,
    required this.isItComboCourse,
    required this.cID,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (BuildContext context) {
        return Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          // duration: Duration(milliseconds: 1000),
          // curve: Curves.easeIn,
          child: Center(
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: InkWell(
                      onTap: () {

                      },
                      child: Text(
                        coursePrice,
                        // 'Start your free trial',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Medium',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {

                      GoRouter.of(context)
                          .pushNamed('comboPaymentPortal',
                          queryParams: {
                            'cID': cID,
                          }
                      );

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PaymentScreen(
                      //       map: map,
                      //       isItComboCourse: isItComboCourse,
                      //     ),
                      //   ),
                      // );
                    },
                    child: Container(
                      height: 60,
                      // width: 300,
                      color: Color(0xFF7860DC),
                      child: Center(
                        child: Text(
                          'Pay Now',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Medium',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        );
      },
      onClosing: () {},
    );
  }
}
