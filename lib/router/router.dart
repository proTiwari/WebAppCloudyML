import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/MyAccount/myaccount.dart';
import 'package:cloudyml_app2/combo/combo_course.dart';
import 'package:cloudyml_app2/combo/combo_store.dart';
import 'package:cloudyml_app2/combo/updated_combo_course.dart';
import 'package:cloudyml_app2/homepage.dart';
import 'package:cloudyml_app2/homescreen/homescreen.dart';
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
import '../combo/new_combo_course.dart';
import '../combo/new_feature_course.dart';
import '../models/course_details.dart';
import '../my_Courses.dart';
import '../screens/quiz/admin_quiz.dart';
import '../screens/quiz/quiz_page.dart';
import '../screens/quiz/quizentry.dart';
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

        final directToCatalogue = state.location == ('/paymentPortal?cID=');

        if(!loggedIn && !goingToLogin) {
          return ('/');
        } else if (loggedIn && goingToLogin) {
          return ('/home');
        } else {
          return null;
        }

       },
      routes: <RouteBase>[
        // GoRoute(
        //     path: '/',
        //     pageBuilder: (context, state) {
        //       return MaterialPage(child: splash());
        //     }
        // ),
        GoRoute(
          path: '/',
          pageBuilder: (context, state) {
            return MaterialPage(child:  LoginPage());
          },
        ),
        GoRoute(
            name: 'home',
            path: '/home',
            pageBuilder: (context, state) {
              return MaterialPage(
                  child: LandingScreen());
            }
        ),
        GoRoute(
            name: 'store',
            path: '/store',
            pageBuilder: (context, state) {
              return MaterialPage(child: StoreScreen());
            }
        ),
        GoRoute(
          name: 'reviews',
          path: '/reviews',
          pageBuilder: (context, state) {
            return MaterialPage(child:  ReviewsScreen());
          },
        ),
        GoRoute(
            name: 'myAccount',
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
          name: 'AdminQuizPanel',
          path: '/adminquizpanel',
          pageBuilder: (context, state) {
            return MaterialPage(key: state.pageKey, child: AdminQuizPanel());
          },
        ), //CongratulationsWidget
        GoRoute(
          name: 'QuizPage',
          path: '/quizpage',
          pageBuilder: (context, state) {
            return MaterialPage(key: state.pageKey, child: QuizPage(""));
          },
        ),

        GoRoute(
          name: 'quizentry',
          path: '/quizentry',
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey, child: QuizentrypageWidget('param'));
          },
        ),
        GoRoute(
          name: 'catalogue',
          path: '/catalogue',
          pageBuilder: (context, state) {
            List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
            final String id = state.queryParams["id"]!;
            final String cID = state.queryParams["cID"]!;
            return MaterialPage<void>(
                key: state.pageKey,
                child: CatelogueScreen(
                  courses: course[int.parse(id)].courses,
                  cID: cID,
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
            name: 'NewComboCourse',
            path: '/NewComboCourse',
            pageBuilder: (context, state) {
              List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
              final String id = state.queryParams['id']!;
              final String courseName = state.queryParams['courseName']!;
              return MaterialPage(
                  key: state.pageKey,
                  child: NewComboCourse(
                    id: id,
                    courses: course[int.parse(id)].courses,
                    courseName: courseName,
                  ));
            }
        ),
        GoRoute(
            name: 'NewScreen',
            path: '/NewScreen',
            pageBuilder: (context, state){
              List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
              final String cID = state.queryParams['cID']!;
              final String id = state.queryParams['id']!;
              final String courseName = state.queryParams['courseName']!;
              final String coursePrice = state.queryParams['coursePrice']!;
              return MaterialPage(
                  key: state.pageKey,
                  child: NewScreen(
                    courses: course[int.parse(id)].courses,
                    id: id,
                    cID: cID,
                    courseP: coursePrice,
                    courseName: courseName,
                  ));
            }),
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
          name: 'comboPaymentPortal',
          path: '/comboPaymentPortal',
        pageBuilder: (context, state) {
          // final Map<String, dynamic> courseMap = state.queryParams['courseMap']! as Map<String, dynamic>;
          String cID = state.queryParams['cID']!;
            return MaterialPage(
                child: PaymentScreen(
                    cID: cID,
                    isItComboCourse: true,
                    map: {},),);
        }),
        GoRoute(
            name: 'paymentPortal',
            path: '/paymentPortal',
            pageBuilder: (context, state) {
              String cID = state.queryParams['cID']!;
              // Map<String, dynamic> courseMap =
              // state.queryParams['courseMap']! as Map<String, dynamic>;
              return MaterialPage(
                child: PaymentScreen(
                    cID: cID,
                    // map: courseMap,
                    isItComboCourse: false),);
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


