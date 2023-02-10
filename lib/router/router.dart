import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/MyAccount/myaccount.dart';
import 'package:cloudyml_app2/combo/combo_course.dart';
import 'package:cloudyml_app2/combo/combo_store.dart';
import 'package:cloudyml_app2/homepage.dart';
import 'package:cloudyml_app2/module/video_screen.dart';
import 'package:cloudyml_app2/payment_screen.dart';
import 'package:cloudyml_app2/payments_history.dart';
import 'package:cloudyml_app2/router/error_page.dart';
import 'package:cloudyml_app2/screens/chat_screen.dart';
import 'package:cloudyml_app2/screens/groups_list.dart';
import 'package:cloudyml_app2/screens/quiz_page.dart';
import 'package:cloudyml_app2/screens/splash.dart';
import 'package:cloudyml_app2/store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../authentication_screens/phone_auth.dart';
import '../catalogue_screen.dart';
import '../combo/feature_courses.dart';
import '../models/course_details.dart';
import '../my_Courses.dart';
import '../screens/review_screen/review_screen.dart';
import 'login_state_check.dart';

class MyRouter {
  final LoginState loginState;
  MyRouter(this.loginState);


  late final GoRouter routes = GoRouter(
      initialLocation: '/',
      refreshListenable: loginState,
      redirect: (context, GoRouterState state) {
        final loggedIn = loginState.loggedIn;
        final goingToLogin = state.location == ('/login');
        if(!loggedIn && !goingToLogin) return ('/');

        if (loggedIn && goingToLogin) return ('/home');
        return null;
       },
      routes: <RouteBase>[
        GoRoute(
            path: '/',
            pageBuilder: (context, state) {
              return MaterialPage(child: splash());
            }
        ),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) {
            return MaterialPage(child:  LoginPage());
          },
        ),
        GoRoute(
            name: 'home',
            path: '/home',
            pageBuilder: (context, state) {
              return MaterialPage(child: Home());
            }
        ),
        GoRoute(
            path: '/store',
            pageBuilder: (context, state) {
              return MaterialPage(child: StoreScreen());
            }
        ),
        GoRoute(
          path: '/reviews',
          pageBuilder: (context, state) {
            return MaterialPage(child:  ReviewsScreen());
          },
        ),
        GoRoute(
            path: '/myAccount',
            pageBuilder: (context, state) {
              return MaterialPage(child: MyAccountPage());
            }
        ),
        GoRoute(
          name: 'chat',
            path: '/chat',
            pageBuilder: (context, state) {
              return MaterialPage(child: GroupsList());
            }
        ),
        GoRoute(
            path: '/paymentHistory',
            pageBuilder: (context, state) {
              return MaterialPage(child: PaymentHistory());
            }
        ),
        GoRoute(
          name: 'myCourses',
          path: '/myCourses',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey,
                child: HomeScreen());
          },
        ),
        GoRoute(
          name: 'ReWidget',
          path: '/ReWidget',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey,
                child: ReWidget());
          },
        ),
        GoRoute(
          name: 'catalogue',
          path: '/catalogue',
          pageBuilder: (context, state) {
            List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
            final String id = state.queryParams["id"]!;
            return MaterialPage<void>(
                key: state.pageKey,
                child: CatelogueScreen(
                  courses: course[int.parse(id)].courses,
                  id: id,));
          },
        ),
        GoRoute(
          name: 'comboStore',
          path: '/comboStore',
          pageBuilder: (context, state) {
    List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
    final String id = state.queryParams['id']!;
    final String courseName = state.queryParams['courseName']!;
    final String coursePrice = state.queryParams['coursePrice']!;
            return MaterialPage(
              key: state.pageKey,
              child: ComboStore(
                courses: course[int.parse(id)].courses,
                id: id,
                cName: courseName,
                courseP: coursePrice,
              ));
          }
        ),
        GoRoute(
            name: 'featuredCourses',
            path: '/featuredCourses',
            pageBuilder: (context, state) {
              final String cID = state.queryParams['cID']!;
              final String id = state.queryParams['id']!;
              final String courseName = state.queryParams['courseName']!;
              final String coursePrice = state.queryParams['coursePrice']!;
              return MaterialPage(
                  key: state.pageKey,
                  child: FeatureCourses(
                    cID: cID,
                    id: id,
                    cName: courseName,
                    courseP: coursePrice,
                  ));
            }
        ),
        GoRoute(
          name: 'comboCourse',
          path: '/comboCourse',
          pageBuilder: (context, state){
          List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
          final String id = state.queryParams['id']!;
          final String courseName = state.queryParams['courseName']!;
          return MaterialPage(
              key: state.pageKey,
              child: ComboCourse(
            courses: course[int.parse(id)].courses,
            id: id,
            courseName: courseName,
          ));
        }),
        GoRoute(
          name: 'videoScreen',
          path: '/videoScreen',
        pageBuilder: (context, state) {
          // final bool isDemo = state.queryParams['isDemo']! as bool;
          // final int sr = state.queryParams['sr']! as int;
          final String courseName = state.queryParams['courseName']!;
          final String cID = state.queryParams['cID']!;
            return MaterialPage(
                child: VideoScreen(
              isDemo: true,
            cID: cID,
            courseName: courseName,
            sr: 1,));
        }),
        GoRoute(
            name: 'comboVideoScreen',
            path: '/comboVideoScreen',
            pageBuilder: (context, state) {
              // final bool isDemo = state.queryParams['isDemo']! as bool;
              // final int sr = state.queryParams['sr']! as int;
              final String cID = state.queryParams['cID']!;
              final String courseName = state.queryParams['courseName']!;
              return MaterialPage(
                  child: VideoScreen(
                    isDemo: null,
                    courseName: courseName,
                    cID: cID,
                    sr: null,));
            }),
        GoRoute(
          name: 'paymentScreen',
          path: '/paymentPortal',
        pageBuilder: (context, state) {
          final Map<String, dynamic> courseMap = state.queryParams['courseMap']! as Map<String, dynamic>;
            final bool isItComboCourse = state.queryParams['isItComboCourse']! as bool;
            return MaterialPage(
                child: PaymentScreen(
                    map: courseMap,
                    isItComboCourse: isItComboCourse),);
        }),
        GoRoute(
            name: 'chatWindow',
            path: '/chatWindow',
          pageBuilder: (context, state) {
              // dynamic groupData = state.queryParams['groupData']! as dynamic;
              // final userData = state.queryParams['userData']! as dynamic;
              String? groupId = state.queryParams['groupId']!;
              // Object chatScreen = state.extra!;
              return MaterialPage(
                  child: ChatScreen(
                    // userData: userData,
                    // groupData: groupData,
                    groupId: groupId,

              ));
          }
        ),
        GoRoute(
            name: 'studentChat',
            path: '/studentChat',
            pageBuilder: (context, state) {
              // Object? chatScreen = state.extra!;
              String? groupId = state.queryParams['groupId']!;
              return MaterialPage(
                  child: ChatScreen(
                    groupId: groupId,
                    // chatScreen: chatScreen,
                  ));
            }
        ),
        // GoRoute(
        //     name: 'videoNameClass',
        //     path: '/videoNameClass',
        //     builder: (context, state) {
        //       final String videoName = state.queryParams['videoName']!;
        //       final dynamic videoController = state.queryParams['videoController']!;
        //       return videoNameClass(
        //         videoName: videoName,
        //         videoController: videoController,
        //       );
        //     },
        // ),

      ],
      errorPageBuilder: (context, state) {
        return MaterialPage(
            key: state.pageKey,
            child: ErrorPage());
      });

}


