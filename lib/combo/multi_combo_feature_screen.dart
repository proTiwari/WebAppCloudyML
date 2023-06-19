
import 'package:cloudyml_app2/combo/controller/multi_combo_feature_controller.dart';
import 'package:cloudyml_app2/combo/non_trial_course_paynowbtsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';

class MultiComboFeatureScreen extends StatelessWidget {
   final String? id;
  final String? courseName;
  final String? coursePrice;
  final String? cID;
  const MultiComboFeatureScreen({Key? key, this.id, this.courseName, this.coursePrice, this.cID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomSheet: 
      NonTrialCourseBottomSheet(
        coursePrice: '₹${coursePrice}/-',
        map: {},
        isItComboCourse: false,
        cID: cID!,
      ),
  
    body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FbackGroundImage.jpg?alt=media&token=c7282af8-222d-4761-89b0-35fa206f0ac1"),
                    fit: BoxFit.fill),
                color: HexColor("#fef0ff"),
              ),
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                      InkWell(
                                onTap: () {
                                GoRouter.of(context)
                                          .pushReplacementNamed('home');
                                },
                                child: Container(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                                        child: Icon(Icons.arrow_back_rounded),
                                      ),
                                      Text(
                                        'Back',
                                        style: TextStyle(
                                          fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                )),
                              ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Welcome to ",
                            style: TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: width < 850
                                    ? width < 430
                                        ? 25
                                        : 30
                                    : 40,
                                color: Colors.black)),
                        TextSpan(
                            text: courseName,
                            style: TextStyle(
                                fontSize: width < 850
                                    ? width < 430
                                        ? 25
                                        : 30
                                    : 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.black))
                      ]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
             GetX<MultiComboFeatureController>(

              init: MultiComboFeatureController(courseId: id),
              builder: (controller) => 
              controller.courseList.isEmpty ?
               Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(color: Colors.deepPurpleAccent, strokeWidth: 3),
                      ),
                    )  :
              
               Padding(
                 padding: constraints.maxWidth>=630?
                  EdgeInsets.fromLTRB(240, 0, 240, 0):EdgeInsets.fromLTRB(0, 0, 0, 0),
                 child: Container(
                          width: constraints.maxWidth,
                         height: MediaQuery.of(context).size.height / 1.2,
                          child: ListView.builder(
                              itemCount: controller.courseList.length,
                              itemBuilder: (BuildContext context, index) {
                                return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      margin: EdgeInsets.only(bottom: 15),
                                      width: width < 1700
                                          ? width < 1300
                                          ? width < 850
                                          ? constraints.maxWidth - 20
                                          : constraints.maxWidth - 200
                                          : constraints.maxWidth - 400
                                          : constraints.maxWidth - 700,
                                      height: width > 700
                                          ? 230
                                          : width < 300
                                          ? 190
                                          : 210,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          color: Colors.white),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
             
                                          Container(
                                            height: double.infinity,
                                            width: width /5,
                                            decoration: BoxDecoration(
                                               borderRadius:
                                        BorderRadius.circular(20),
                                              image: DecorationImage(image: NetworkImage(controller.courseList[index]['image_url']),fit: BoxFit.cover)
                                            ),
                                          ),
                                           SizedBox(
                                                        width: width/100,
                                                      ),
             
                                          Expanded(
                                              flex: width < 600 ? 6 : 4,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                // mainAxisAlignment:
                                                // width>700?
                                                // MainAxisAlignment
                                                    // .spaceAround,
                                                // :MainAxisAlignment.start,
                                                children: [
                                               
                                                  
                                               
                                                  Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        controller.courseList[index]['name'],
                                                        style: TextStyle(
                                                            height: 1,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: width >
                                                                700
                                                                ? 25
                                                                : width < 540
                                                                ? 12
                                                                : 14),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 4,
                                                      ),
                                                      SizedBox(
                                                        height: 13,
                                                      ),
                                                      Text(
                                                        controller.courseList[index]['description'],
                                                        style: TextStyle( fontWeight: FontWeight.w500,
                                                                              fontSize: width < 540
                                                                                  ? width < 420
                                                                                  ? 11
                                                                                  : 13
                                                                                  : 14),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 4,
                                                        
                                                      ),
                                                   ],
                                                  )
                                                ,  
                                                SizedBox(height: 15,),
                                                
                                                ElevatedButton(
                    onPressed: () async {
                   if (controller.courseList[index]['combo']) {
                                    

                                      final id = index.toString();
                                      final cID = controller.courseList[index]['docid'];
                                      final courseName =controller.courseList[index]['name'];
                                      final courseP =controller.courseList[index]['Course Price'];
                                      
                                      GoRouter.of(context).pushNamed(
                                          'NewFeature',
                                          queryParams: {
                                            'cID': cID,
                                            'courseName': courseName,
                                            'id': id,
                                            'coursePrice': courseP
                                          });
                                    }   else {
                                      final id = index.toString();
                                      GoRouter.of(context)
                                          .pushNamed('catalogue', queryParams: {
                                        'id': id,
                                        'cID':controller.courseList[index]['docid']
                                      });
                                    }
                    },
                    child: Text("View Details"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
               
                 RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(12),
                  
                 )
               )
             )
                  )
                                               
                                                ],
                                              )),
                               
                                        ],
                                      ),
                                    ),
                                  );
                               
                              }),
                        ),
               ),
             ),

                  ],
                ),
              )
             );
        },
      ),
    );
  
 
  }
}