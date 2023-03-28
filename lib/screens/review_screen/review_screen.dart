import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudyml_app2/api/firebase_api.dart';
import 'package:cloudyml_app2/fun.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:cloudyml_app2/models/firebase_file.dart';
import 'package:cloudyml_app2/globals.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({Key? key}) : super(key: key);

  @override
  State<ReviewsScreen> createState() => _Review1State();
}

class _Review1State extends State<ReviewsScreen> {
  late Future<List<FirebaseFile>> futurefilesRecentReviews;
  late Future<List<FirebaseFile>> futurefilesComboCourseReviews;
  late Future<List<FirebaseFile>> futurefilesSocialMediaReviews;

  @override
  void initState() {
    super.initState();
    futurefilesRecentReviews = FirebaseApi.listAll('reviews/recent_review');
    futurefilesComboCourseReviews = FirebaseApi.listAll('reviews/combo_course_review');
    futurefilesSocialMediaReviews = FirebaseApi.listAll('reviews/social_media_review');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final containerWidth = 300.0;
    final containerHeight = 300.0;
    double height = MediaQuery.of(context).size.height;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: screenWidth,
                height: 60,
                color: HexColor("440F87"),
                child: Center(child: customMenuBar(context)),
              ),
              SizedBox(
                height: 25 * verticalScale,
              ),
              Container(
                width: 414 * horizontalScale,
                height: 125 * verticalScale,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        HexColor('8346E1'),
                        HexColor('411487'),
                      ]
                  ),
                ),
                child: Center(
                    child: Text('🤞 Our Learner\'s review speaks 🤞',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: HexColor('FFFFFF'),
                        fontSize: 38 * verticalScale,
                      ),)),
              ),

              SizedBox(
                height: 25,
              ),
              Container(
                // height: screenHeight * 0.81 * verticalScale,
                height: containerHeight,
                width: screenWidth,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: FutureBuilder<List<FirebaseFile>>(
                  future: futurefilesRecentReviews,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                            child: CircularProgressIndicator()
                        );
                      default:
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                'Some error occurred!',
                                textScaleFactor: min(horizontalScale, verticalScale),
                              ));
                        } else {
                          final files = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemCount: files.length,
                                  itemBuilder: (context, index) {
                                    final file = files[index];
                                    return Container(
                                        decoration: BoxDecoration(
                                            color: HexColor("#FFFFFF"),
                                            // borderRadius: BorderRadius.circular(15),
                                            border: Border.all(
                                              color: Colors.black, width: 0.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 1))
                                            ]),
                                        margin: EdgeInsets.only(
                                            left: 15, top: 5, bottom: 5),
                                        padding: EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 5,
                                            bottom: 5),
                                        width: containerWidth,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      GestureDetector(
                                                          onTap: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Container(
                                                            alignment:
                                                            Alignment.center,
                                                            color:
                                                            Colors.transparent,
                                                            height: 400,
                                                            width: 300,
                                                            child: AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      15.0),
                                                                  side: BorderSide
                                                                      .none),
                                                              scrollable: true,
                                                              content:
                                                              Container(
                                                                height:500,
                                                                width:500,
                                                                child: ClipRRect(
                                                                  borderRadius:BorderRadius.circular(20) ,
                                                                  child: CachedNetworkImage(
                                                                    errorWidget:
                                                                        (context, url,
                                                                        error) =>
                                                                        Icon(Icons
                                                                            .error),
                                                                    imageUrl: file.url,
                                                                    fit: BoxFit.fill,
                                                                    placeholder: (context,
                                                                        url) =>
                                                                        Center(child: CircularProgressIndicator()),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )));
                                            },
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                              imageUrl: file.url,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )
                                    );
                                    // buildFile(context, file);
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                    }
                  },
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(
              //     left: 15,
              //     top: 10,
              //   ),
              //   child: Text(
              //     'Combo course reviews',
              //     textScaleFactor: min(horizontalScale, verticalScale),
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //         color: Color.fromRGBO(0, 0, 0, 1),
              //         fontFamily: 'Poppins',
              //         fontSize: 28 * verticalScale,
              //         fontWeight: FontWeight.bold,
              //         height: 2),
              //   ),
              // ),
              SizedBox(
                height: 25,
              ),
              Container(
                height: containerHeight,
                width: screenWidth,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: FutureBuilder<List<FirebaseFile>>(
                  future: futurefilesComboCourseReviews,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                'Some error occurred!',
                                textScaleFactor: min(horizontalScale, verticalScale),
                              ));
                        } else {
                          final files = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemCount: files.length,
                                  itemBuilder: (context, index) {
                                    final file = files[index];
                                    return Container(
                                        decoration: BoxDecoration(
                                            color: HexColor("#FFFFFF"),
                                            border: Border.all(
                                              color: Colors.black, width: 0.5,
                                            ),
                                            // borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 1))
                                            ]),
                                        margin: EdgeInsets.only(
                                            left: 15, top: 5, bottom: 5),
                                        padding: EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 5,
                                            bottom: 5),
                                        width: containerWidth,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      GestureDetector(
                                                          onTap: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Container(
                                                            alignment:
                                                            Alignment.center,
                                                            color:
                                                            Colors.transparent,
                                                            height: 400,
                                                            width: 300,
                                                            child: AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      15.0),
                                                                  side: BorderSide
                                                                      .none),
                                                              scrollable: true,
                                                              content:
                                                              Container(height:500,width:500,
                                                                child: ClipRRect(borderRadius:BorderRadius.circular(20) ,
                                                                  child: CachedNetworkImage(
                                                                    errorWidget:
                                                                        (context, url,
                                                                        error) =>
                                                                        Icon(Icons
                                                                            .error),
                                                                    imageUrl: file.url,
                                                                    fit: BoxFit.fill,
                                                                    placeholder: (context,
                                                                        url) =>
                                                                        Center(child: CircularProgressIndicator()),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )));
                                            },
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                              imageUrl: file.url,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ));
                                    // buildFile(context, file);
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                    }
                  },
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(
              //     left: 15,
              //     top: 10,
              //   ),
              //   child: Text(
              //     'Social media reviews',
              //     textScaleFactor: min(horizontalScale, verticalScale),
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //         color: Color.fromRGBO(0, 0, 0, 1),
              //         fontFamily: 'Poppins',
              //         fontSize: 28 * verticalScale,
              //         fontWeight: FontWeight.bold,
              //         height: 2),
              //   ),
              // ),
              SizedBox(height: 25),
              Container(
                height: containerHeight,
                width: screenWidth,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: FutureBuilder<List<FirebaseFile>>(
                  future: futurefilesSocialMediaReviews,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                'Some error occurred!',
                                textScaleFactor: min(horizontalScale, verticalScale),
                              ));
                        } else {
                          final files = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemCount: files.length,
                                  itemBuilder: (context, index) {
                                    final file = files[index];
                                    return Container(
                                        decoration: BoxDecoration(
                                            color: HexColor("#FFFFFF"),
                                            border: Border.all(
                                              color: Colors.black, width: 0.5,
                                            ),
                                            // borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 1))
                                            ]),
                                        margin: EdgeInsets.only(
                                            left: 15, top: 5, bottom: 5),
                                        padding: EdgeInsets.only(
                                            left: 5,
                                            right:5,
                                            top: 5,
                                            bottom: 5),
                                        width: containerWidth,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      GestureDetector(
                                                          onTap: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Container(
                                                            alignment:
                                                            Alignment.center,
                                                            color:
                                                            Colors.transparent,
                                                            height: 400,
                                                            width: 300,
                                                            child: AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      15.0),
                                                                  side: BorderSide
                                                                      .none),
                                                              scrollable: true,
                                                              content:
                                                              Container(height:500,width:500,
                                                                child: ClipRRect(borderRadius: BorderRadius.circular(20),
                                                                  child: CachedNetworkImage(
                                                                    errorWidget:
                                                                        (context, url,
                                                                        error) =>
                                                                        Icon(Icons
                                                                            .error),
                                                                    imageUrl: file.url,
                                                                    fit: BoxFit.fill,
                                                                    placeholder: (context,
                                                                        url) =>
                                                                        Center(child: CircularProgressIndicator()),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )));
                                            },
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                              imageUrl: file.url,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ));
                                    // buildFile(context, file);
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                    }
                  },
                ),
              ),
              SizedBox(height: 25 * verticalScale,)
            ],
          ),
        ),
    );
  }
}
