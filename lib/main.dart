import 'dart:async';
import 'dart:core';
import 'dart:core';
import 'dart:core';
import 'dart:html' as html;
import 'dart:js';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/Notifications/web_messaging.dart';
import 'package:cloudyml_app2/Providers/AppProvider.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/Providers/chat_screen_provider.dart';
import 'package:cloudyml_app2/Services/database_service.dart';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:cloudyml_app2/models/video_details.dart';
import 'package:cloudyml_app2/router/login_state_check.dart';
import 'package:cloudyml_app2/router/router.dart';
import 'package:cloudyml_app2/screens/chat_screen.dart';
import 'package:cloudyml_app2/screens/review_screen/review_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloudyml_app2/screens/splash.dart';
import 'package:cloudyml_app2/services/local_notificationservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:renderer_switcher/renderer_switcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'authentication_screens/phone_auth.dart';
import 'homepage.dart';



//Receive message when app is in background ...solution for on message
Future<void> backgroundHandler(RemoteMessage message) async {
  // print("backgroundMessage=======================");
  // print(message.data.toString());
  // print(message.notification!.title);
  // print(message.notification!.android!.count);
  // print(message.ttl);

  // int? ttl = message.ttl;
  // print(message.messageId![0] as int);


  //  final FlutterLocalNotificationsPlugin
  // _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();



  // print(message.notification.)
  // LocalNotificationService.showNotificationfromApp(title: message.notification!.title,body: message.notification!.body);
// LocalNotificationService.createanddisplaynotification(message);

  // await Firebase.initializeApp();
  // await Hive.initFlutter();
  // await Hive.openBox('myBox');
  // final myBox = Hive.box('myBox');
  //   print("MEssage");
  //   var data = await LocalNotificationService.display(message,message.notification!.title);
  //   print("Background = $data");
  //   await myBox.put(data["ID"], data);
  //   await myBox.delete(data["ID"]);
  //   print("Message removed");

}




Future<void> main() async {

  await Hive.initFlutter();
  await Hive.openBox('myBox');
  await Hive.openBox("NotificationBox");
  setPathUrlStrategy();
  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  // SchedulerBinding.instance.addPostFrameCallback((timeStamp) { });

  final state = LoginState(await SharedPreferences.getInstance());
  state.checkLoggedIn();


  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBdAio1wI3RVwl32RoKE7F9GNG_oWBpfbM",
          appId: "1:67056708090:web:f4a43d6b987991016ddc43",
          messagingSenderId: "67056708090",
          projectId: "cloudyml-app",
          storageBucket: "cloudyml-app.appspot.com",
          databaseURL: "https://cloudyml-app-default-rtdb.firebaseio.com",
          authDomain: "cloudyml-app.firebaseapp.com")
  );
  if(kIsWeb) {
    await FirebaseAuth.instance.authStateChanges().first;
  }
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  FBMessaging().init();

  runApp(MyApp(loginState: state,));

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  html.window.document.onContextMenu.listen((evt) => evt.preventDefault());
  final currentRenderer = await RendererSwitcher.getCurrentWebRenderer();

  if(currentRenderer == WebRenderer.auto){
    // Switches web renderer to html and reloads the window.
    RendererSwitcher.switchWebRenderer(WebRenderer.html);
  }

  print('this is url ${Uri.base.path}');


  if(Uri.base.path == '/comboPaymentPortal') {
    print('abc home');

    final url=Uri.base.path;
    FirebaseFirestore.instance.collection("Notice")
        .doc("NBrEm6KGry8gxOJJkegG_redirect_pay").set({
      'url' : url });
// navigatorKey.currentState?.pushNamed('/login');

    print('pushed');
  }
  else if(Uri.base.path == '/featuredCourses'){

    final url=Uri.base.path;
    FirebaseFirestore.instance.collection("Notice")
        .doc("7A85zuoLi4YQpbXlbOAh_redirect").set({
      'url' : url });
// navigatorKey.currentState?.pushNamed('/login');

    print('pushed');

  }
 else if (Uri.base.path == '/NewFeature') {
    if (Uri.base.queryParameters['cID'] == 'aEGX6kMfHzQrVgP3WCwU') {
      final url = Uri.base.queryParameters['cID'];
      FirebaseFirestore.instance
          .collection("Notice")
          .doc("XdYtk2DJBIkRGx0ASthZ_newfeaturecourse")
          .set({'url': url});
    } else if (Uri.base.queryParameters['cID'] == 'F9gxnjW9nf5Lxg5A6758') {
      final url = Uri.base.queryParameters['cID'];
      FirebaseFirestore.instance
          .collection("Notice")
          .doc("fSU4MLz1E0858ft8m7F5_dataeng")
          .set({'url': url});
    }

// navigatorKey.currentState?.pushNamed('/login');

    print('pushed');
  }

 

}



class MyApp extends StatefulWidget {

  final LoginState loginState;

  MyApp({required this.loginState});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // showNoInternet() {
    //   AlertDialog alert = AlertDialog(
    //     content: Padding(
    //       padding: const EdgeInsets.all(18.0),
    //       child: Container(
    //         height: MediaQuery.of(context).size.height * 0.3,
    //         width: MediaQuery.of(context).size.width,
    //         child: Center(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Icon(
    //                 Icons.signal_wifi_connected_no_internet_4_rounded,
    //                 color: Colors.red,
    //                 size: 70,
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   SizedBox(),
    //                   Row(
    //                     children: [
    //                       InkWell(
    //                         onTap: () {
    //                           Navigator.of(context).pop();
    //                         },
    //                         child: Container(
    //                           decoration: BoxDecoration(
    //                             borderRadius: BorderRadius.circular(30),
    //                           ),
    //                           child: Padding(
    //                             padding: const EdgeInsets.all(4.0),
    //                             child: Text(
    //                               'Skip',
    //                               style: TextStyle(
    //                                   fontFamily: 'SemiBold',
    //                                   fontSize: 18,
    //                                   color: Colors.black),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         width: 6,
    //                       ),
    //                       InkWell(
    //                         onTap: () {
    //                           Navigator.push(
    //                             context,
    //                             MaterialPageRoute(
    //                               builder: (context) => OfflinePage(),
    //                             ),
    //                           );
    //                           // Navigator.pushAndRemoveUntil(
    //                           //     context,
    //                           //     PageTransition(
    //                           //         duration: Duration(milliseconds: 200),
    //                           //         curve: Curves.bounceInOut,
    //                           //         type: PageTransitionType.fade,
    //                           //         child: VideoScreenOffline()),
    //                           //     (route) => false);
    //                         },
    //                         child: Container(
    //                           decoration: BoxDecoration(
    //                               borderRadius: BorderRadius.circular(30),
    //                               gradient: gradient),
    //                           child: Padding(
    //                             padding: const EdgeInsets.all(14.0),
    //                             child: Text(
    //                               'Go offline',
    //                               style: TextStyle(
    //                                   fontFamily: 'SemiBold',
    //                                   fontSize: 18,
    //                                   color: Colors.black),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   )
    //                 ],
    //               )
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   );

    //   // show the dialog
    //   showDialog(
    //     barrierColor: Colors.black38,
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) {
    //       return alert;
    //     },
    //   );
    // }

    // final StreamSubscription<InternetConnectionStatus> listener =
    //     InternetConnectionChecker().onStatusChange.listen(
    //   (InternetConnectionStatus status) {
    //     switch (status) {
    //       case InternetConnectionStatus.connected:
    //         print('Data connection is available.');
    //         // showToast("You're now connected");
    //         break;
    //       case InternetConnectionStatus.disconnected:
    //         print('You are disconnected from the internet.');
    //         // Future.delayed(Duration(seconds: 10), () {
    //         //   showNoInternet();
    //         // });
    //         // showToast("You are disconnected from the internet");
    //         break;
    //     }
    //   },
    // );
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: StyledToast(
        locale: const Locale('en', 'US'),
        textStyle: TextStyle(
            fontSize: 25.0, color: Colors.white, fontFamily: 'Medium'),
        backgroundColor: Colors.black,
        borderRadius: BorderRadius.circular(30.0),
        textPadding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
        toastAnimation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.slideToBottom,
        startOffset: Offset(0.0, 3.0),
        reverseEndOffset: Offset(0.0, 3.0),
        duration: Duration(seconds: 5),
        animDuration: Duration(milliseconds: 500),
        alignment: Alignment.center,
        toastPositions: StyledToastPosition.center,
        curve: Curves.bounceIn,
        reverseCurve: Curves.bounceOut,
        dismissOtherOnShow: true,
        fullWidth: false,
        isHideKeyboard: false,
        isIgnoring: true,
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_)=> ChatScreenNotifier(),
                child: ChatScreen()),
            ChangeNotifierProvider.value(value: UserProvider.initialize()),
            ChangeNotifierProvider.value(value: AppProvider()),
            ChangeNotifierProvider<LoginState>(
              lazy: false,
              create: (BuildContext createContext) => widget.loginState,
            ),
            Provider<MyRouter>(
              lazy: false,
              create: (BuildContext createContext) => MyRouter(widget.loginState),
            ),
            StreamProvider<List<CourseDetails>>.value(
              value: DatabaseServices().courseDetails,
              initialData: [],
            ),
            StreamProvider<List<VideoDetails>>.value(
              value: DatabaseServices().videoDetails,
              initialData: [],
            ),
          ],

          // builder: (context,child)
          // {
          //   return MediaQuery(
          //     child: child!,
          //     data: MediaQuery.of(context).copyWith(textScaleFactor: 1.15),
          //   );
          // },

          child: ResponsiveSizer(
            builder: (context, orientation, screenType) {
              final botToastBuilder = BotToastInit();
              final router = Provider.of<MyRouter>(context, listen: false).routes;
              return MaterialApp.router(

                routerDelegate: router.routerDelegate,
                routeInformationParser: router.routeInformationParser,
                routeInformationProvider: router.routeInformationProvider,
                debugShowCheckedModeBanner: false,
                title: 'CloudyML',
                scrollBehavior: MyCustomScrollBehavior(),
                builder: (BuildContext context, child) {
                  child = MediaQuery(
                    child: child!,
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.15),
                  );
                  child = botToastBuilder(context,child);
                  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                    return Container();
                  };
                 botToastBuilder(context,widget);
                  return child;
                },
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  // textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
                ),
              //   home: splash(),
              //   // routes: {
              //   // MyRoutes.initialRoute : (context) => splash(),
              //   //   "/authenticate": (context) =>
              //   //       Authenticate(),
              //   //   "/myCourses": (context) =>
              //   //       HomeScreen(),
              //   //   '/Store': (context) => StoreScreen(),
              //   //   '/Messages': (context) => GroupsList(),
              //   //   '/myAccount': (context) => MyAccountPage(),
              //   //   '/reviewAssignments': (context) => Assignments(),
              //   //   '/paymentHistory': (context) => PaymentHistory(),
              //   //   '/reviews': (context) => ReviewsScreen(),
              //   //   '/catalogue': (context) => CatelogueScreen(),
              //   //   '/home': (context) => Home(),
              //   // },
              // )
        );
            }
          ),
      ),
    ));
  }
}




class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}