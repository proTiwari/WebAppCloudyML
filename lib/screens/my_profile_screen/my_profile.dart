import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/MyAccount/ChangePassword.dart';
import 'package:cloudyml_app2/MyAccount/EditProfile.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/offline/offline_videos.dart';
import 'package:cloudyml_app2/pages/notificationpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../router/login_state_check.dart';

late DocumentSnapshot snapshot;

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  var userData;

  getUser() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      userData = value.data();
      print(userData!);
    });
  }

  //custom widget for tiles
  Widget container(width, height, icon, String name) {
    return Container(
      width: Adaptive.w(100),
      height: Adaptive.h(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              offset: Offset(
                2, // Move to right 10  horizontally
                2.0, // Move to bottom 10 Vertically
              ),
              blurRadius: 10.sp),
        ],
      ),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Row(
          children: [
            Icon(
              icon,
              size: Device.screenType == ScreenType.mobile ? 22.sp : 15.sp,
            ),
            SizedBox(
              width: Device.screenType == ScreenType.mobile ? 25.sp : 10.sp,
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                name,
                maxLines: 2,
                style: TextStyle(
                  fontSize:
                      Device.screenType == ScreenType.mobile ? 16.sp : 14.sp,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  void initState() {
    Provider.of<UserProvider>(context, listen: false).reloadUserModel();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void saveLoginOutState(BuildContext context) {
      Provider.of<LoginState>(context, listen: false).loggedIn = false;
    }
    final userprovider = Provider.of<UserProvider>(context);
    // userprovider.reloadUserModel();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Scaffold(
      backgroundColor: HexColor('946AA8'),
      appBar: Device.screenType == ScreenType.mobile ?
      PreferredSize(child: Container(), preferredSize: Size.zero)
          : AppBar(
        title: Text('My profile'),
        backgroundColor: HexColor('946AA8'),
        elevation: 0,
        leading: IconButton(onPressed: (){
          GoRouter.of(context).pushReplacementNamed('home');
        }, icon: Icon(Icons.arrow_back_rounded)),
      ),
      body: Device.screenType == ScreenType.mobile
          ? Container(
              height: Adaptive.h(100),
              width: Adaptive.w(100),
              color: Colors.white,
              child: Stack(
                children: [
                  Positioned(
                    left: 10.sp,
                    top: 10.sp,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_back_rounded,
                          color: HexColor('D9D9D9'),)),
                  ),
                  Container(
                    height: Adaptive.h(45),
                    width: Adaptive.w(100),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        color: HexColor('0C001B'),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageUrl: userData!['image'],
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    bottom: 0.sp,
                    child: Container(
                      height: Adaptive.h(65),
                      width: Adaptive.w(100),
                      decoration: BoxDecoration(
                        // color: HexColor('946AA8'),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.sp),
                            topRight: Radius.circular(30.sp)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black45,
                              offset: Offset(
                                2, // Move to right 10  horizontally
                                2.0, // Move to bottom 10 Vertically
                              ),
                              blurRadius: 40.sp),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 00,
                            child: Container(
                              height: Adaptive.h(65),
                              width: Adaptive.w(100),
                              decoration: BoxDecoration(
                                color: HexColor('946AA8'),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.sp),
                                    topRight: Radius.circular(30.sp)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black45,
                                      offset: Offset(
                                        2, // Move to right 10  horizontally
                                        2.0, // Move to bottom 10 Vertically
                                      ),
                                      blurRadius: 5.sp),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0.sp,
                            child: Container(
                              height: Adaptive.h(70),
                              width: Adaptive.w(100),
                              child: Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Course%20Images%2FMobileImage.png?alt=media&token=0ab7b913-77cb-44f6-824a-cb1c2289a2f4',
                                // height: Adaptive.h(65),
                                // width: Adaptive.w(100),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 15.sp,
                            child: Container(
                              width: Adaptive.w(100),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 20.sp),
                                      child: Text(
                                        'Hello!! ${userData!['name']}',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.sp,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.sp),
                                    child: Container(
                                      width: Adaptive.w(100),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${userData!['email']}',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            '${userData!['mobilenumber']}',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.sp,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 15.sp, right: 15.sp),
                                    child: Container(
                                      height: Adaptive.h(55),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25.sp),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditProfilePage()));
                                            },
                                            child: container(
                                                Adaptive.w(10),
                                                Adaptive.h(6),
                                                Icons.edit,
                                                'Edit Profile'),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Container(
                                                      height: 260 * verticalScale,
                                                      width: width,
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            min(horizontalScale, verticalScale) *
                                                                16.0),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.all(min(
                                                                  horizontalScale,
                                                                  verticalScale) *
                                                                  14.0),
                                                              child: Text(
                                                                'Support',
                                                                style: TextStyle(
                                                                    fontSize: 22,
                                                                    color: HexColor('7A62DE'),
                                                                    fontWeight: FontWeight.bold),
                                                                textScaleFactor: min(
                                                                    horizontalScale,
                                                                    verticalScale),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: verticalScale * 20,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () async {
                                                                    String telephoneUrl =
                                                                        'tel:8587911971';
                                                                    if (await canLaunch(
                                                                        telephoneUrl)) {
                                                                      await launch(telephoneUrl);
                                                                    } else {
                                                                      throw 'Could not launch $telephoneUrl';
                                                                    }
                                                                  },
                                                                  child: Card(
                                                                    elevation: 5,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius
                                                                          .circular(min(
                                                                          horizontalScale,
                                                                          verticalScale) *
                                                                          10.0),
                                                                    ),
                                                                    child: Container(
                                                                      width:
                                                                      horizontalScale * 120,
                                                                      child: Padding(
                                                                        padding: EdgeInsets.all(min(
                                                                            horizontalScale,
                                                                            verticalScale) *
                                                                            14.0),
                                                                        child: Container(
                                                                          child: Column(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.phone,
                                                                                color: HexColor(
                                                                                    '7A62DE'),
                                                                                size: min(
                                                                                    horizontalScale,
                                                                                    verticalScale) *
                                                                                    40,
                                                                              ),
                                                                              SizedBox(
                                                                                height:
                                                                                verticalScale *
                                                                                    12,
                                                                              ),
                                                                              Text(
                                                                                'Call us',
                                                                                textScaleFactor: min(
                                                                                    horizontalScale,
                                                                                    verticalScale),
                                                                                style: TextStyle(
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w400,
                                                                                    fontSize: 20),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () async {
                                                                    final Uri params = Uri(
                                                                        scheme: 'mailto',
                                                                        path: 'app.support@cloudyml.com',
                                                                        query:
                                                                        'subject=Query about App');
                                                                    var mailurl =
                                                                    params.toString();
                                                                    if (await canLaunch(
                                                                        mailurl)) {
                                                                      await launch(mailurl);
                                                                    } else {
                                                                      throw 'Could not launch $mailurl';
                                                                    }
                                                                  },
                                                                  child: Card(
                                                                    elevation: 5,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius
                                                                          .circular(min(
                                                                          horizontalScale,
                                                                          verticalScale) *
                                                                          10.0),
                                                                    ),
                                                                    child: Container(
                                                                      width: verticalScale * 120,
                                                                      child: Padding(
                                                                        padding: EdgeInsets.all(min(
                                                                            horizontalScale,
                                                                            verticalScale) *
                                                                            14.0),
                                                                        child: Container(
                                                                          child: Column(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.mail,
                                                                                color: HexColor(
                                                                                    '7A62DE'),
                                                                                size: min(
                                                                                    horizontalScale,
                                                                                    verticalScale) *
                                                                                    40,
                                                                              ),
                                                                              SizedBox(
                                                                                height:
                                                                                verticalScale *
                                                                                    12,
                                                                              ),
                                                                              Text(
                                                                                'Mail us',
                                                                                textScaleFactor: min(
                                                                                    horizontalScale,
                                                                                    verticalScale),
                                                                                style: TextStyle(
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w400,
                                                                                    fontSize: 20),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ));
                                                },
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30.0),
                                                ),
                                              );
                                            },
                                            child: container(
                                                Adaptive.w(10),
                                                Adaptive.h(6),
                                                Icons.support_agent_outlined,
                                                'Support'),
                                          ),
                                          container(
                                              Adaptive.w(10),
                                              Adaptive.h(6),
                                              Icons
                                                  .download_for_offline_outlined,
                                              'Certificate'),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChangePassword()));
                                            },
                                            child: container(
                                                Adaptive.w(10),
                                                Adaptive.h(6),
                                                Icons.key_outlined,
                                                'Change Password'),
                                          ),
                                          MaterialButton(
                                            color: Colors.black,
                                            height: Adaptive.h(6.5),
                                            minWidth: Adaptive.w(40),
                                            onPressed: () {
                                              logOut(context);
                                              saveLoginOutState(context);
                                              GoRouter.of(context).pushReplacement('/login');
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.sp),
                                            ),
                                            child: Text(
                                              'Logout',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.sp),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              height: Adaptive.h(100),
              width: Adaptive.w(100),
              decoration: BoxDecoration(
                  color: HexColor('946AA8'),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Course%20Images%2FWebMyAccountBG.png?alt=media&token=3c04b2ee-ac0d-4286-a7a0-3e2f8be0ad33',
                  ),
                ),
              ),
              child: Center(
                  child: Container(
                      height: Adaptive.h(65),
                      width: Adaptive.w(50),
                      decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.sp),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black45,
                        offset: Offset(
                          2, // Move to right 10  horizontally
                          2.0, // Move to bottom 10 Vertically
                        ),
                        blurRadius: 40.sp),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15.sp),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.sp),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              color: HexColor('0C001B'),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            imageUrl: userData!['image'],
                            fit: BoxFit.fill,
                            height: Adaptive.h(65),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 15.sp, bottom: 10.sp, right: 10.sp, left: 10.sp),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Hello, ${userData!['name']}',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.sp,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 0.sp),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${userData!['email']}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.normal,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      '${userData!['mobilenumber']}',
                                      style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.normal,
                                    overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.sp,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 15.sp, right: 15.sp),
                                child: Container(
                                  height: Adaptive.h(45),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProfilePage()));
                                          },
                                          child: container(width, height,
                                              Icons.edit, 'Edit Profile')),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                  height: 260 * verticalScale,
                                                  width: width,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        min(horizontalScale, verticalScale) *
                                                            16.0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.all(min(
                                                              horizontalScale,
                                                              verticalScale) *
                                                              14.0),
                                                          child: Text(
                                                            'Support',
                                                            style: TextStyle(
                                                                fontSize: 22,
                                                                color: HexColor('7A62DE'),
                                                                fontWeight: FontWeight.bold),
                                                            textScaleFactor: min(
                                                                horizontalScale,
                                                                verticalScale),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: verticalScale * 20,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                String telephoneUrl =
                                                                    'tel:8587911971';
                                                                if (await canLaunch(
                                                                    telephoneUrl)) {
                                                                  await launch(telephoneUrl);
                                                                } else {
                                                                  throw 'Could not launch $telephoneUrl';
                                                                }
                                                              },
                                                              child: Card(
                                                                elevation: 5,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius
                                                                      .circular(min(
                                                                      horizontalScale,
                                                                      verticalScale) *
                                                                      10.0),
                                                                ),
                                                                child: Container(
                                                                  width:
                                                                  horizontalScale * 120,
                                                                  child: Padding(
                                                                    padding: EdgeInsets.all(min(
                                                                        horizontalScale,
                                                                        verticalScale) *
                                                                        14.0),
                                                                    child: Container(
                                                                      child: Column(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.phone,
                                                                            color: HexColor(
                                                                                '7A62DE'),
                                                                            size: min(
                                                                                horizontalScale,
                                                                                verticalScale) *
                                                                                40,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                            verticalScale *
                                                                                12,
                                                                          ),
                                                                          Text(
                                                                            'Call us',
                                                                            textScaleFactor: min(
                                                                                horizontalScale,
                                                                                verticalScale),
                                                                            style: TextStyle(
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w400,
                                                                                fontSize: 20),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                final Uri params = Uri(
                                                                    scheme: 'mailto',
                                                                    path: 'app.support@cloudyml.com',
                                                                    query:
                                                                    'subject=Query about App');
                                                                var mailurl =
                                                                params.toString();
                                                                if (await canLaunch(
                                                                    mailurl)) {
                                                                  await launch(mailurl);
                                                                } else {
                                                                  throw 'Could not launch $mailurl';
                                                                }
                                                              },
                                                              child: Card(
                                                                elevation: 5,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius
                                                                      .circular(min(
                                                                      horizontalScale,
                                                                      verticalScale) *
                                                                      10.0),
                                                                ),
                                                                child: Container(
                                                                  width: verticalScale * 120,
                                                                  child: Padding(
                                                                    padding: EdgeInsets.all(min(
                                                                        horizontalScale,
                                                                        verticalScale) *
                                                                        14.0),
                                                                    child: Container(
                                                                      child: Column(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.mail,
                                                                            color: HexColor(
                                                                                '7A62DE'),
                                                                            size: min(
                                                                                horizontalScale,
                                                                                verticalScale) *
                                                                                40,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                            verticalScale *
                                                                                12,
                                                                          ),
                                                                          Text(
                                                                            'Mail us',
                                                                            textScaleFactor: min(
                                                                                horizontalScale,
                                                                                verticalScale),
                                                                            style: TextStyle(
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w400,
                                                                                fontSize: 20),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ));
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30.0),
                                            ),
                                          );
                                        },
                                        child: container(
                                            width,
                                            height,
                                            Icons.support_agent_outlined,
                                            'Support'),
                                      ),
                                      container(
                                          width,
                                          height,
                                          Icons.download_for_offline_outlined,
                                          'Certificate'),
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChangePassword()));
                                          },
                                          child: container(
                                              width,
                                              height,
                                              Icons.key_outlined,
                                              'Change Password')),
                                      InkWell(
                                        onTap: () {
                                          logOut(context);
                                          saveLoginOutState(context);
                                          GoRouter.of(context).pushReplacement('/login');
                                        },
                                        child: container(width, height, Icons.logout,
                                            'Logout'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              )),
            ),
    );
  }
}
