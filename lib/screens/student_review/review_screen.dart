import 'dart:convert';
import 'dart:developer';
import 'package:cloudyml_app2/screens/student_review/ReviewApi.dart';
import 'package:cloudyml_app2/screens/student_review/postReviewScreen.dart';
import 'package:cloudyml_app2/screens/student_review/reviewModel.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:star_rating/star_rating.dart';
import 'package:timeago/timeago.dart' as timeago;

class StudentReviewScreen extends StatefulWidget {
  const StudentReviewScreen({Key? key}) : super(key: key);

  @override
  State<StudentReviewScreen> createState() => _StudentReviewScreenState();
}

class _StudentReviewScreenState extends State<StudentReviewScreen> {
  bool isLoading = true;
  Avgrating? avgrating;
  List<Review> reviews = [];

  @override
  void initState() {
    getreviewdata();
    super.initState();
  }

  bool error = false;

  getreviewdata() async {
    setState(() {
      isLoading = true;
    });
    dynamic data = await getReviewsApi();
    print('iwefoijwo${data.runtimeType}');
    if (data == 'error') {
      setState(() {
        isLoading = false;
      });
      error = true;
    } else {
      setState(() {
        isLoading = false;
        print('weoifjwoejfo $data');
        StudentReviewsModel studentReviewsModel =
            StudentReviewsModel.fromJson(jsonDecode(data));
        avgrating = studentReviewsModel.result!.avgrating;
        reviews = studentReviewsModel.result!.reviews!;
      });
    }
  }

  String formatTimeAgo(String timestamp) {
    final DateTime parsedTime = DateTime.parse(timestamp);
    final now = DateTime.now();

    return timeago.format(now.subtract(now.difference(parsedTime)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : error
              ? Center(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostReviewScreen()));
                      },
                      child: Text('Error occured while fetching data!')),
                )
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraint) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        constraints: BoxConstraints(
                            maxWidth: constraint.maxWidth < 750
                                ? MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.width / 2,
                            maxHeight: MediaQuery.of(context).size.height),
                        child: Column(
                          children: [
                            Expanded(
                                child: ListView.builder(
                                    itemCount: reviews.length,
                                    scrollDirection: Axis.vertical,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return index == 0
                                          ? Column(
                                              children: [
                                                Center(
                                                    child: Text(
                                                  'Reviews And Rating',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 50),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '${avgrating!.total?.toStringAsFixed(1)}',
                                                            style: TextStyle(
                                                              fontSize: 36,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          StarRating(
                                                            length: 5,
                                                            rating: avgrating!
                                                                .total!
                                                                .toDouble(),
                                                            color: Colors
                                                                .purpleAccent,
                                                            starSize: 20,
                                                          ),
                                                          Text(
                                                            '${reviews.length} Reviews',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          rateBar(
                                                              rate: '5',
                                                              value: (avgrating!
                                                                          .five!
                                                                          .toDouble() /
                                                                      100) *
                                                                  5,
                                                              context: context),
                                                          rateBar(
                                                              rate: '4',
                                                              value: (avgrating!
                                                                          .four!
                                                                          .toDouble() /
                                                                      100) *
                                                                  5,
                                                              context: context),
                                                          rateBar(
                                                              rate: '3',
                                                              value: (avgrating!
                                                                          .three!
                                                                          .toDouble() /
                                                                      100) *
                                                                  5,
                                                              context: context),
                                                          rateBar(
                                                              rate: '2',
                                                              value: (avgrating!
                                                                          .two!
                                                                          .toDouble() /
                                                                      100) *
                                                                  5,
                                                              context: context),
                                                          rateBar(
                                                              rate: '1',
                                                              value: (avgrating!
                                                                          .one!
                                                                          .toDouble() /
                                                                      100) *
                                                                  5,
                                                              context: context),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PostReviewScreen()));
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    16.0,
                                                                vertical: 8.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              'Add Your Review',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                            SizedBox(width: 8),
                                                            Icon(Icons.add,
                                                                size: 16,
                                                                color: Colors
                                                                    .blue),
                                                          ],
                                                        ),
                                                      ),
                                                    )),
                                                SizedBox(height: 8),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 20),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.all(16.0),
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${reviews[index].name}',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            StarRating(
                                                              rating: double
                                                                  .parse(reviews[
                                                                          index]
                                                                      .rating!),
                                                              starSize: 20,
                                                              color: Colors
                                                                  .purpleAccent,
                                                              length: 5,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text(
                                                              formatTimeAgo(
                                                                '${reviews[index].date.toString()}',
                                                              ),
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text(
                                                          '${reviews[index].reviewdescription}',
                                                          maxLines: 5,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 20),
                                              child: Container(
                                                padding: EdgeInsets.all(16.0),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${reviews[index].name}',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        StarRating(
                                                          rating: double.parse(
                                                              reviews[index]
                                                                  .rating!),
                                                          starSize: 20,
                                                          color: Colors
                                                              .purpleAccent,
                                                          length: 5,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          formatTimeAgo(
                                                            '${reviews[index].date.toString()}',
                                                          ),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      '${reviews[index].reviewdescription}',
                                                      maxLines: 5,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                    }))
                          ],
                        ),
                      ),
                    ),
                  );
                }),
    );
  }

  Widget rateBar(
      {required String rate,
      required double value,
      required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            rate,
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
          SizedBox(
            width: 15,
          ),
          SizedBox(
            height: 5,
            width: MediaQuery.of(context).size.width / 4,
            child: LinearProgressIndicator(
              value: value / 5,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.purpleAccent[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
            ),
          ),
        ],
      ),
    );
  }
}
