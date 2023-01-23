import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:cloudyml_app2/homepage.dart';
import 'package:cloudyml_app2/models/video_details.dart';
import 'package:cloudyml_app2/offline/db.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/models/offline_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/widgets/assignment_bottomsheet.dart';
import 'package:cloudyml_app2/widgets/settings_bottomsheet.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:html' as html;
import '../api/firebase_api.dart';
import '../models/course_details.dart';
import '../models/firebase_file.dart';
import 'new_assignment_screen.dart';

class VideoScreen extends StatefulWidget {
  final List<dynamic>? courses;
  final int? sr;
  final bool? isDemo;
  final String? courseName;
  static ValueNotifier<double> currentSpeed = ValueNotifier(1.0);

  const VideoScreen(
      {required this.isDemo, this.sr, this.courseName, this.courses});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late List<FirebaseFile> futureAssignments;
  late List<FirebaseFile> futureSolutions;
  late List<FirebaseFile> futureDataSets;

  VideoPlayerController? _videoController;
  late String htmltext;
  bool htmlbool = false;
  List pathwaydata = [];
  bool? downloading = false;
  bool downloaded = false;
  Map<String, dynamic>? data;
  String? videoUrl;
  Future<void>? playVideo;
  bool showAssignment = false;
  int? serialNo;
  String? assignMentVideoUrl;
  bool _disposed = false;
  bool _isPlaying = false;
  bool loading = false;
  bool enablePauseScreen = false;
  bool _isBuffering = false;
  Duration? _duration;
  Duration? _position;
  bool switchTOAssignment = false;
  bool stopdownloading = true;
  bool showAssignSol = false;

  var _delayToInvokeonControlUpdate = 0;
  var _progress = 0.0;
  List<VideoDetails> _listOfVideoDetails = [];

  ValueNotifier<int> _currentVideoIndex = ValueNotifier(0);
  ValueNotifier<int> _currentVideoIndex2 = ValueNotifier(0);
  ValueNotifier<double> _downloadProgress = ValueNotifier(0);

  // void getData() async {
  //   await setModuleId();
  //   await FirebaseFirestore.instance
  //       .collection('courses')
  //       .doc(courseId)
  //       .collection('Modules')
  //       .doc(moduleId)
  //       .collection('Topics')
  //       .orderBy('sr')
  //       .get()
  //       .then((value) {
  //     for (var video in value.docs) {
  //       _listOfVideoDetails.add(
  //         VideoDetails(
  //           videoId: video.data()['id'] ?? '',
  //           type: video.data()['type'] ?? '',
  //           canSaveOffline: video.data()['Offline'] ?? true,
  //           serialNo: video.data()['sr'].toString(),
  //           videoTitle: video.data()['name'] ?? '',
  //           videoUrl: video.data()['url'] ?? '',
  //         ),
  //       );
  //     }
  //   });
  // }


  Future<void> setModuleId() async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('Modules')
        .where('firstType', isEqualTo: 'video')
        .get()
        .then((value) {
      moduleId = value.docs[0].id;
    });
  }

  String convertToTwoDigits(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  // Widget timeRemainingString() {
  //   final totalDuration =
  //       _videoController!.value.duration.toString().substring(2, 7);
  //   final duration = _duration?.inSeconds ?? 0;
  //   final currentPosition = _position?.inSeconds ?? 0;
  //   final timeRemained = max(0, duration - currentPosition);
  //   final mins = convertToTwoDigits(timeRemained ~/ 60);
  //   final seconds = convertToTwoDigits(timeRemained % 60);
  //   // timeRemaining = '$mins:$seconds';
  //   return Text(
  //     totalDuration,
  //     style: TextStyle(
  //       color: Colors.white,
  //       fontWeight: FontWeight.bold,
  //     ),
  //   );
  // }

  Widget timeElapsedString() {
    var timeElapsedString = "00.00";
    final currentPosition = _position?.inSeconds ?? 0;
    final mins = convertToTwoDigits(currentPosition ~/ 60);
    final seconds = convertToTwoDigits(currentPosition % 60);
    timeElapsedString = '$mins:$seconds';
    return Text(
      timeElapsedString,
      style: TextStyle(
          color: Colors.white,
          // fontSize: 12,
          fontWeight: FontWeight.bold),
    );
  }

  void _onVideoControllerUpdate() async {
    print("this is video ------ $videoTitle");
    print("----$moduleName");
    print("---total duration $totalDuration");
    print("----percent ${((currentPosition / totalDuration) * 100).toInt()}");

    print(_getVideoPercentageList);
    //
    // for(var i in _getVideoPercentageList)
    //   {
    //     if(i[moduleName.toString()]!=null)
    //       {
    //          for(var j in i[moduleName.toString()])
    //            {
    //              print("0kkkkk");
    //              j[videoTitle.toString()]!=null && j[videoTitle.toString()]<((currentPosition / totalDuration) * 100).toInt()?
    //              j[videoTitle.toString()] = ((currentPosition / totalDuration) * 100).toInt():null;
    //            }
    //       }
    //   }
    // //
    // int total = 0,count = 0;
    // for(int i=0;i<_getVideoPercentageList.length;i++)
    //   {
    //     for(var j in _getVideoPercentageList[i].entries)
    //       {
    //         j.value.forEach((element){
    //           Map<String,dynamic> dic = element as Map<String,dynamic>;
    //           int t = dic.values.first;
    //           total+=t;
    //           count+=1;
    //         });
    //       }
    //   }
    // FirebaseFirestore.instance.collection("courseprogress").doc(_auth.currentUser!.uid).update({widget.courseName.toString():_getVideoPercentageList,
    // widget.courseName.toString()+"percentage":(total/(count*100))*100});

    if (_disposed) {
      return;
    }
    final now = DateTime.now().microsecondsSinceEpoch;
    if (_delayToInvokeonControlUpdate > now) {
      return;
    }
    _delayToInvokeonControlUpdate = now + 500;
    final controller = _videoController;
    if (controller == null) {
      debugPrint("The video controller is null");
      return;
    }
    if (!controller.value.isInitialized) {
      debugPrint("The video controller cannot be initialized");
      return;
    }
    if (_duration == null) {
      _duration = _videoController!.value.duration;
    }
    if (!(_videoController!.value.duration >
        _videoController!.value.position) &&
        !_videoController!.value.isPlaying) {
      VideoScreen.currentSpeed.value = 1.0;
      // updateCourseCompletionPercentage(videoPercentageList);

      _currentVideoIndex.value++;
      initializeVidController(
          _listOfVideoDetails[_currentVideoIndex.value].videoUrl,
          _listOfVideoDetails[_currentVideoIndex.value].videoTitle,
          "");
    }
    var duration = _duration;
    if (duration == null) return;
    if(_getVideoPercentageList!=null) {
      for (var i in _getVideoPercentageList!) {
        if (i[moduleName.toString()] != null) {
          for (var j in i[moduleName.toString()]) {
            print("0kkkkk");
            j[videoTitle.toString()] != null && j[videoTitle.toString()] <
                ((currentPosition / totalDuration) * 100).toInt() ?
            j[videoTitle.toString()] =
                ((currentPosition / totalDuration) * 100).toInt() : null;
          }
        }
      }
      //
      int total = 0,
          count = 0;
      try{
        for (int i = 0; i < _getVideoPercentageList!.length; i++) {
          for (var j in _getVideoPercentageList![i].entries) {
            // j.value.forEach((element) {
            //   Map<String, int> dic = element as Map<String, int>;
            //   int t = dic.values.first;
            //   total += t;
            //   count += 1;
            // });
            try{
              j.value.forEach((element) {
                // Map<String, int> dic = element as Map<String, int>;
                // int t = dic.values.first;
                print(element.values.first);
                total += int.parse(element.values.first.toString()).toInt();
                count += 1;
                // print(dic);
              });
            }
            catch(err){
              print("j--$j");
              print("Errrrrrrrrrrrrrr");
            }
          }
        }
      }
      catch(err)
      {
        print("errrororor");
      }
      FirebaseFirestore.instance.collection("courseprogress").doc(_auth.currentUser!.uid).update({widget.courseName.toString():_getVideoPercentageList,
        widget.courseName.toString()+"percentage":((total/(count*100))*100).toInt()});
    }

    // if (sectionName.length != 0 && videoPercentageList.length != 0) {
    //   for (int i = 0; i < sectionName.length; i++) {
    //     print('ii = $i');
    //     for (int j = 0; j < videoPercentageList[i][sectionName[i]].length; j++) {
    //       print('jjj = $j $i  }');
    //       try {
    //         print('video $videoTitle');
    //         print(
    //             'ssss ${videoPercentageList[i][sectionName[i]][j].toString()}');
    //         print('length of == ${videoTitle.toString().length}');
    //         if (videoPercentageList[i][sectionName[i]][j][videoTitle.toString()]
    //             .toString() !=
    //             'null') {
    //           if(((currentPosition / totalDuration) * 100).toInt()>=videoPercentageList[i][sectionName[i]][j][videoTitle.toString()])
    //           {
    //             print("True-----------------");
    //             videoPercentageList[i][sectionName[i]][j][videoTitle.toString()] =
    //                 ((currentPosition / totalDuration) * 100).toInt();
    //           }
    //         }
    //         print(
    //             'dd ${videoPercentageList[i][sectionName[i]][j][videoTitle.toString()].toString()}');
    //       } catch (e) {
    //         print('I am error ${e.toString()}');
    //       }
    //     }
    //   }
    // }

    var position = _videoController?.value.position;
    setState(() {
      _position = position;
      currentPosition = _videoController!.value.position.inSeconds.toInt();
    });
    final buffering = controller.value.isBuffering;
    setState(() {
      _isBuffering = buffering;
    });
    final playing = controller.value.isPlaying;
    if (playing) {
      if (_disposed) return;
      setState(() {
        _progress = position!.inMilliseconds.ceilToDouble() /
            duration.inMilliseconds.ceilToDouble();
      });
    } else {
      // updateCourseCompletionPercentage(videoPercentageList);
    }
    _isPlaying = playing;
  }

  int totalDuration = 0;
  int currentPosition = 0;
  String? moduleName;
  void initializeVidController(
      String url, String name, String modulename) async {
    print('this is -- $url ');
    try {
      final oldVideoController = _videoController;
      if (oldVideoController != null) {
        oldVideoController.removeListener(_onVideoControllerUpdate);
        oldVideoController.pause();
        oldVideoController.dispose();
      }
      final _localVideoController = await VideoPlayerController.network(url);
      setState(() {
        _videoController = _localVideoController;
      });
      playVideo = _localVideoController.initialize().then((value) {
        setState(() {
          print('this is -- $name ');
          videoTitle = name.toString();
          moduleName = modulename.toString();
          totalDuration =
              _localVideoController.value.duration.inSeconds.toInt();
          selectedVideoIndexName = url.toString();
          _localVideoController.addListener(_onVideoControllerUpdate);
          _localVideoController.play();
          _duration = _localVideoController.value.duration;
        });
      });
    } catch (e) {
      showToast(e.toString());
    }
  }

  void getPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  var courseData;
  String courseName = '';
  var curriculumdata;
  var sectionName = [];

  Map<String, List> datamap = {};

  List<VideoDetails> _videodetails = [];
  var listData = [];
  var listOfVideo = [];
  var dataList = [];
  var videoPercentageList = [];
  var totalPercentageList = {};

  // Future<Map<String, dynamic>> getDataFrom(sectionName, curriculumdata) async {
  //   var data = {};
  //   await sectionName.entries.forEach((element) async {
  //     curriculumdata.entries.forEach((entry) {
  //       if (element.key.toString() == entry.key) {
  //         entry.value.forEach((name) {
  //           listOfVideo.add(name);
  //         });
  //         data[element] = listOfVideo.toList();
  //         dataList.add({element: listOfVideo.toList()});
  //         listOfVideo = [];
  //       }
  //     });
  //   });
  //   Map<String, dynamic> done = {};
  //
  //   for (var t in data.entries) {
  //     print("t = ${t.key}");
  //     for (var name in t.value) {
  //       print("Name = == = ${name}");
  //       await FirebaseFirestore.instance
  //           .collection('courses')
  //           .doc(courseId)
  //           .collection('Modules')
  //           .doc(moduleId)
  //           .collection('Topics')
  //           .where("name", isEqualTo: "${name.toString()}")
  //           .get()
  //           .then((value) {
  //         print("YY");
  //         print(value.docs.length);
  //         for (var video in value.docs) {
  //           listOfVideo.add(VideoDetails(
  //             videoId: video.data()['id'] ?? '',
  //             type: video.data()['type'] ?? '',
  //             canSaveOffline: video.data()['Offline'] ?? true,
  //             serialNo: video.data()['sr'].toString(),
  //             videoTitle: video.data()['name'] ?? '',
  //             videoUrl: video.data()['url'] ?? '',
  //           ));
  //           print("oo");
  //           String str = t.key.toString();
  //           str = str.replaceRange(0, 9, "");
  //           var st = "";
  //           for (int i = 0; i < str.length; i++) {
  //             if (str[i] == ":") {
  //               break;
  //             }
  //             st += str[i];
  //           }
  //           done[st] = listOfVideo.toList();
  //           print("oopp");
  //         }
  //         // print(value.docs.length);
  //       });
  //     }
  //     listOfVideo = [];
  //   }
  //   print("done = $done");
  //   print("length= = ${dataList.length}");
  //
  //   print("yes");
  //   print(listOfVideo.length);
  //   return done;
  // }

  var dataa;
  var curriculum1;
  Future<void> getCourseData() async {
    // setState(() {
    //   loading = true;
    // });

    var val;

    // print("LLLLLLL ${FirebaseAuth.instance.currentUser!.uid} ${courseId}");

    // await FirebaseFirestore.instance
    //     .collection('courses')
    //     .doc(courseId)
    //     .get()
    //     .then((value) async {
    //   print(value.data());
    //
    //   val = value.data();
    //
    //   curriculumdata = val["curriculum"];
    //   curriculum1 = val["curriculum1"];
    //
    //
    //   print("curriculum1 = $curriculum1");
    //
    //
    //
    //   courseName = val['name'];
    //   sectionName = curriculumdata['sectionsName'];
    //   var dic = {};
    //   print(sectionName);
    //   for (var i in sectionName) {
    //     dic[i] = i;
    //   }
    //
    //   // dataa = await getDataFrom(dic, curriculumdata);
    //   await FirebaseFirestore.instance.collection('courseprogress')
    //       .doc(_auth.currentUser!.uid).get().then((value) async {
    //     if(value.exists) {
    //       var progressData = await FirebaseFirestore.instance.collection('courseprogress')
    //           .doc(_auth.currentUser!.uid).get();
    //       // print("poppp");
    //       // print('progressdata ${progressData.data()!.containsKey(courseName)}');
    //       // // var restData = progressData.data();
    //       // print("sss");
    //       if(progressData.data()!.containsKey(courseName))
    //       {
    //         // print("pp");
    //         if(progressData.get(courseName).length!=0)
    //         {
    //           videoPercentageList = progressData.get(courseName);
    //         }
    //         else
    //         {
    //           for (var i in dataa.entries) {
    //             // print('i == dip ${i.key}');
    //             // print('i == dip ${i.value[0].videoTitle}');
    //             var sectionList = [];
    //             for (var k = 0; k < i.value.length; k++) {
    //               sectionList.add({
    //                 i.value[k].videoTitle.toString(): 0,
    //               });
    //             }
    //             videoPercentageList.add({i.key.toString(): sectionList});
    //           }
    //         }
    //       }
    //       else{
    //         for (var i in dataa.entries) {
    //           print('i == dip ${i.key}');
    //           print('i == dip ${i.value[0].videoTitle}');
    //           var sectionList = [];
    //           for (var k = 0; k < i.value.length; k++) {
    //             sectionList.add({
    //               i.value[k].videoTitle.toString(): 0,
    //             });
    //           }
    //           videoPercentageList.add({i.key.toString(): sectionList});
    //         }
    //       }
    //     }
    //     else {
    //       for (var i in dataa.entries) {
    //         print('i == dip ${i.key}');
    //         print('i == dip ${i.value[0].videoTitle}');
    //         var sectionList = [];
    //         for (var k = 0; k < i.value.length; k++) {
    //           sectionList.add({
    //             i.value[k].videoTitle.toString(): 0,
    //           });
    //         }
    //         videoPercentageList.add({i.key.toString(): sectionList});
    //       }
    //     }
    //   });
    //
    //   print('videoPercentage = $videoPercentageList');
    //   setState(() {
    //     videoPercentageList;
    //   });
    //   print('this is $sectionName');
    //   print("datamap = $datamap");
    //   curriculumdata.remove("sectionsName");
    //   print("this is srinivas $curriculumdata");
    //
    //
    //   // try {
    //     // courseData = dataa;
    //     // courseData = courseData;
    //     // print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy ");
    //     // print(curriculumdata.length);
    //     // print(courseData);
    //     // if (courseData == datamap) {
    //     //   setState(() {
    //     //     loading = false;
    //     //     courseData;
    //     //   });
    //     // }
    //
    //     print("LLLLLLLLLLLLLLLLLLyyyyyyyyyyyyyy ");
    //   // } catch (e) {
    //   //   print('2');
    //   //   if (courseData == dataa) {
    //   //     setState(() {
    //   //       loading = false;
    //   //       courseData;
    //   //     });
    //   //   }
    //   //   print(e);
    //   // }
    // });

    // if (courseData == dataa) {
    //   setState(() {
    //     loading = false;
    //     courseData;
    //   });
    // }
  }

/*-------------- Video Percentage Srinivas Code ------------- */

  var _initialVideoPercentageList = {};
  List<dynamic>? _getVideoPercentageList;

  getProgressData() async {
    await FirebaseFirestore.instance
        .collection("courseprogress")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      print("vvvvvvvvvvvvvvvvvvvvvvvvv");
      print(_auth.currentUser!.uid.toString());
      print(value.exists);
      if (value.exists && value.data()![widget.courseName]!=null) {
        print(value.data()![widget.courseName]);
        _getVideoPercentageList = value.data()![widget.courseName];
      } else {
        var res = await FirebaseFirestore.instance
            .collection("courses")
            .doc(courseId)
            .get();
        var list = await res.get("curriculum1")[widget.courseName];

        _initialVideoPercentageList[widget.courseName.toString()] = [];
        for (int i = 0; i < list.length; i++) {
          print(_initialVideoPercentageList[widget.courseName.toString()]
              .runtimeType);
          _initialVideoPercentageList[widget.courseName.toString()]
              .add({list[i]["modulename"].toString(): []});
          for (int j = 0; j < list[i]["videos"].length; j++) {
            list[i]["videos"][j]["type"]=="video"?_initialVideoPercentageList[widget.courseName][i]
            [list[i]["modulename"]]
                .add({list[i]["videos"][j]["name"]: 0}):null;
          }
        }
        await FirebaseFirestore.instance
            .collection("courseprogress")
            .doc(_auth.currentUser!.uid.toString())
            .update({
          widget.courseName.toString():
          _initialVideoPercentageList[widget.courseName.toString()],"email":_auth.currentUser!.email.toString()
        });
        _getVideoPercentageList =
        _initialVideoPercentageList[widget.courseName.toString()];
      }
    });
    setState(() {
      _getVideoPercentageList;
    });
  }

  Future download({
    Dio? dio,
    String? url,
    String? savePath,
    String? fileName,
    String? courseName,
    String? topicName,
  }) async {
    getPermission();
    var directory = await getApplicationDocumentsDirectory();
    try {
      setState(() {
        downloading = true;
      });
      Response response = await dio!.get(
        url!,
        onReceiveProgress: (rec, total) {
          _downloadProgress.value = rec / total;
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print(response.headers);
      File file = File(savePath!);
      var raf = file.openSync(mode: FileMode.write);
      print('savePath--$savePath');

      raf.writeFromSync(response.data);
      await raf.close();
      DatabaseHelper _dbhelper = DatabaseHelper();
      OfflineModel video = OfflineModel(
          topic: topicName,
          path: '${directory.path}/${fileName!.replaceAll(' ', '')}.mp4');
      _dbhelper.insertTask(video);

      setState(() {
        downloading = false;
        downloaded = true;
      });
    } catch (e) {
      print('e::$e');
    }
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  // updateCourseCompletionPercentage(videoPercentageListUpdate) async {
  //   // await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).update({
  //   //   courseName : videoPercentageListUpdate,
  //   // }).then((value) => print(videoPercentageListUpdate)).catchError((error) => print('dipen = $error'));
  //   // print('I am uid = ${FirebaseAuth.instance.currentUser!.uid}');
  //   print("Videosssssssssssss ${videoPercentageList.length}");
  //   int total = 0;
  //   int count = 0;
  //   if (videoPercentageListUpdate.length != 0) {
  //     print("ppop = ${videoPercentageListUpdate}");
  //     for (int i = 0; i < videoPercentageListUpdate.length; i++) {
  //       print("999999999999");
  //       print("dddddddddd ${videoPercentageListUpdate[i].toString()}");
  //       for (int j = 0;
  //           j < videoPercentageListUpdate[i][sectionName[i]]!.length;
  //           j++) {
  //         print("lllllllllllllllllllllllll");
  //         for (var kv
  //             in videoPercentageListUpdate[i][sectionName[i]]![j].entries) {
  //           print("ppppppppppppppppppppppppppp");
  //           print(kv.value);
  //           total += int.parse(kv.value.toString());
  //           count += 1;
  //         }
  //       }
  //     }
  //   }
  //
  //   videoPercentageListUpdate != null
  //       ? await FirebaseFirestore.instance
  //           .collection('courseprogress')
  //           .doc(FirebaseAuth.instance.currentUser!.uid)
  //           .get()
  //           .then((value) async {
  //           print('srinivas ${value.data().toString()}');
  //           if (value.exists && videoPercentageListUpdate.length != 0) {
  //             await FirebaseFirestore.instance
  //                 .collection('courseprogress')
  //                 .doc(_auth.currentUser!.uid)
  //                 .update({
  //               courseName: videoPercentageListUpdate,
  //               'email': _auth.currentUser!.email,
  //               courseName.toString() + "percentage":
  //                   total != 0 && count != 0 ? total / count : 0
  //             }).catchError((onError) {
  //               print('srinnn = $onError');
  //             });
  //           } else {
  //             videoPercentageListUpdate.length != 0
  //                 ? await FirebaseFirestore.instance
  //                     .collection('courseprogress')
  //                     .doc(_auth.currentUser!.uid)
  //                     .set({
  //                     courseName: videoPercentageListUpdate,
  //                     'email': FirebaseAuth.instance.currentUser!.email,
  //                     courseName.toString() + "percentage":
  //                         total != 0 && count != 0 ? (total / count).toInt() : 0
  //                   })
  //                 : null;
  //           }
  //         }).catchError((onError) {
  //           print('srinu $onError');
  //         })
  //       : null;
  // }

  @override
  void dispose() {
    super.dispose();
    print("disposeeeee");
    _videoController!.dispose();
    AutoOrientation.portraitUpMode();
    _disposed = true;
    _videoController = null;
  }

  String? role;
  getUserRole()
  async{
    await FirebaseFirestore.instance.collection("Users").doc(_auth.currentUser!.uid).get().then((value) {
      setState(() {
        role = value.exists?value.data()!["role"]:null;
      });
    });
  }

  getFiles() async {
    // futureAssignments =
    //     await FirebaseApi.listAll('courses/${widget.courseName}/assignment');
    // futureSolutions =
    //     await FirebaseApi.listAll('courses/${widget.courseName}/solution');
    // futureDataSets =
    //     await FirebaseApi.listAll('courses/${widget.courseName}/dataset');
    //
    // setState(() {
    //   futureAssignments;
    //   futureDataSets;
    //   futureSolutions;
    // });
  }

  @override
  void initState() {
    html.window.document.onContextMenu.listen((evt) => evt.preventDefault());
    VideoScreen.currentSpeed.value = 1.0;
    // getData();
    // getCourseData();
    getUserRole();
    getProgressData();
    getFiles();
    getpathway(widget.courseName);
    Future.delayed(Duration(milliseconds: 500), () {
      getFirstVideo();
    });

    super.initState();
  }

  String? currentPlayingVideoName;

  getFirstVideo() async {
    print("Firstvideo---");
    var res = await FirebaseFirestore.instance
        .collection("courses")
        .doc(courseId)
        .get();
    var list = res.get("curriculum1")[widget.courseName];
    list.sort((a, b) {
      if (a["sr"] > b["sr"]) {
        return 1;
      }
      return -1;
    });
    list[0]["videos"].sort((a, b) {
      if (a["sr"] > b["sr"]) {
        return 1;
      }
      return -1;
    });
    setState(() {
      currentPlayingVideoName =
          list[0]["videos"][0]["name"].toString();
    });
    initializeVidController(
        list[0]["videos"][0]["url"].toString(),
        list[0]["videos"][0]["name"].toString(),
        list[0]["modulename"].toString());
  }

  bool menuClicked = false;
  String solutionUrl = '';
  String assignmentUrl = '';

  @override
  Widget build(BuildContext context) {
    List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    return Scaffold(
        body: Container(
          color: Colors.white,
          child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              final isPortrait = orientation == Orientation.portrait;
              return Row(
                children: [
                  menuClicked
                      ? isPortrait
                      ? Container()
                      : SizedBox()
                      : Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            widget.isDemo == null ?
                            Navigator.of(context).pop() :
                            GoRouter.of(context).pushReplacementNamed('home');

                            // Navigator.of(context).pushReplacement(
                            //     MaterialPageRoute(builder: (context)=>Home()));
                            // Navigator.pop(context);
                          },
                          child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_back_ios),
                                    Text(
                                      'Back to courses',
                                      style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )),
                        ),
                        // Expanded(
                        //   flex: 0,
                        //     child: _buildPartition(
                        //   context,
                        //   horizontalScale,
                        //   verticalScale,
                        // ),),
                        ///
                        // Expanded(
                        //   child: _buildVideoDetailsListTiles(
                        //     horizontalScale,
                        //     verticalScale,
                        //   ),
                        // ),

                        Expanded(
                          child: _buildVideoDetails(
                            horizontalScale,
                            verticalScale,
                          ),
                        ),
                      ],
                    ),
                  ),
                  !htmlbool
                      ? Expanded(
                    flex: 2,
                    child: showAssignment
                        ? AssignmentScreen(
                      selectedSection: selectedSection,
                      courseData: courseData,
                      courseName: widget.courseName,
                      assignmentUrl: assignmentUrl,
                      dataSetUrl: dataSetUrl,
                      solutionUrl: solutionUrl,
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                          future: playVideo,
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (ConnectionState.done ==
                                snapshot.connectionState) {
                              return Stack(
                                children: [
                                  Container(
                                    height: menuClicked
                                        ? screenHeight
                                        : screenHeight / 1.2,
                                    child: Center(
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: VideoPlayer(
                                            _videoController!),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          enablePauseScreen =
                                          !enablePauseScreen;
                                          // print(
                                          //     'Container of column clicked');
                                        });
                                      },
                                      child: Container(
                                        height: menuClicked
                                            ? screenHeight
                                            : screenHeight / 1.2,
                                        width: screenWidth,
                                      )),
                                  enablePauseScreen
                                      ? Container(
                                    height: menuClicked
                                        ? screenHeight
                                        : screenHeight / 1.2,
                                    child: _buildControls(
                                      context,
                                      isPortrait,
                                      horizontalScale,
                                      verticalScale,
                                    ),
                                  )
                                      : SizedBox(),
                                  _isBuffering && !enablePauseScreen
                                      ? Center(
                                    heightFactor: 6.2,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      child:
                                      CircularProgressIndicator(
                                        color: Color.fromARGB(
                                          114,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
                                    ),
                                  )
                                      : Container(),
                                ],
                              );
                            } else {
                              return Container(
                                height: screenHeight / 1.2,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF7860DC),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        menuClicked
                            ? Container()
                            : Padding(
                          padding:
                          const EdgeInsets.only(top: 15.0),
                          child: Text(
                            videoTitle.toString() != 'null'
                                ? videoTitle.toString()
                                : '',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'SemiBold'),
                          ),
                        ),
                        isPortrait
                            ? _buildPartition(
                          context,
                          horizontalScale,
                          verticalScale,
                        )
                            : SizedBox(),
                        isPortrait
                            ? SizedBox()
                        // Expanded(
                        //   flex: 2,
                        //   child: _buildVideoDetailsListTile(
                        //     horizontalScale,
                        //     verticalScale,
                        //   ),
                        // )
                            : SizedBox(),
                      ],
                    ),
                  )
                      : Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: SingleChildScrollView(
                          child: HtmlWidget('''
                                            $htmltext
                                            '''),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }

  Widget _buildControls(
      BuildContext context,
      bool isPortrait,
      double horizontalScale,
      double verticalScale,
      ) {
    return InkWell(
      onTap: () {
        setState(() {
          enablePauseScreen = !enablePauseScreen;
        });
      },
      child: Container(
        color: Color.fromARGB(114, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListTile(
              title: Text(
                videoTitle.toString() != 'null' ? videoTitle.toString() : '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              trailing: InkWell(
                onTap: () {
                  showSettingsBottomsheet(
                    context,
                    horizontalScale,
                    verticalScale,
                    _videoController!,
                  );
                  // var directory = await getApplicationDocumentsDirectory();
                  // download(
                  //   dio: Dio(),
                  //   fileName: data!['name'],
                  //   url: data!['url'],
                  //   savePath:
                  //       "${directory.path}/${data!['name'].replaceAll(' ', '')}.mp4",
                  //   topicName: data!['name'],
                  // );
                  // print(directory.path);
                },
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _currentVideoIndex,
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _currentVideoIndex.value >= 1
                        ? InkWell(
                      onTap: () {
                        VideoScreen.currentSpeed.value = 1.0;
                        _currentVideoIndex.value--;
                        initializeVidController(
                            _listOfVideoDetails[_currentVideoIndex.value]
                                .videoUrl,
                            _listOfVideoDetails[_currentVideoIndex.value]
                                .videoTitle,
                            ""
                        );
                      },
                      child: Icon(
                        Icons.skip_previous_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    )
                        : SizedBox(),
                    replay10(
                      videoController: _videoController,
                    ),
                    !_isBuffering
                        ? InkWell(
                      onTap: () {
                        if (_isPlaying) {
                          setState(() {
                            _videoController!.pause();
                          });
                        } else {
                          setState(() {
                            enablePauseScreen = !enablePauseScreen;
                            _videoController!.play();
                          });
                        }
                      },
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 50,
                      ),
                    )
                        : CircularProgressIndicator(
                      color: Color.fromARGB(
                        114,
                        255,
                        255,
                        255,
                      ),
                    ),
                    fastForward10(
                      videoController: _videoController,
                    ),
                    _currentVideoIndex.value < _listOfVideoDetails.length - 1
                        ? InkWell(
                      onTap: () {
                        VideoScreen.currentSpeed.value = 1.0;
                        _currentVideoIndex.value++;
                        initializeVidController(
                            _listOfVideoDetails[_currentVideoIndex.value]
                                .videoUrl,
                            _listOfVideoDetails[_currentVideoIndex.value]
                                .videoTitle,
                            ""
                        );
                      },
                      child: Icon(
                        Icons.skip_next_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    )
                        : SizedBox(),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Container(
                    height: 10,
                    child: VideoProgressIndicator(
                      _videoController!,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        backgroundColor: Color.fromARGB(74, 255, 255, 255),
                        bufferedColor: Color(0xFFC0AAF5),
                        playedColor: Color(0xFF7860DC),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          timeElapsedString(),
                          Text(
                            '/${_videoController!.value.duration.toString().substring(2, 7)}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            menuClicked = !menuClicked;
                          });
                          if (menuClicked) {
                            html.document.documentElement?.requestFullscreen();
                          } else {
                            html.document.exitFullscreen();
                          }
                        },
                        icon: Icon(
                          menuClicked
                              ? Icons.fullscreen_exit_rounded
                              : Icons.fullscreen_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildPartition(
      BuildContext context, double horizontalScale, double verticalScale) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.courseName!,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Medium",
              ),
            ),
          ),
        ),
        SizedBox(
          height: 60,
          child: Center(
            child: Row(
              children: [
                SizedBox(width: 20),
                Expanded(child: _buildLecturesTab(context)),
                SizedBox(width: 30),
                Expanded(
                  flex: 1,
                  child: _buildAssignmentTab(
                    context,
                    horizontalScale,
                    verticalScale,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container _buildLecturesTab(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Lectures',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            height: 3,
            width: MediaQuery.of(context).size.width * 0.2,
            color: Color(0xFF7860DC),
          )
        ],
      ),
    );
  }

  InkWell _buildAssignmentTab(
      BuildContext context, double horizontalScale, double verticalScale) {
    return InkWell(
      onTap: () {
        setState(() {
          _videoController!.pause();
          showAssignmentBottomSheet(
            context,
            horizontalScale,
            verticalScale,
          );
        });
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Assignments',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              height: 3,
              width: MediaQuery.of(context).size.width * 0.25,
              color: Color(0xFF7860DC),
            )
          ],
        ),
      ),
    );
  }

  String selectedSection = '';
  int? selectedIndexOfVideo;
  String? selectedVideoIndexName;
  String? videoTitle;
  List<dynamic> dataSetUrl = [];

  Color color = Colors.black;

  Future<void> getpathway(String? courseName) async {
    List path;
    String jsonString;
    var d;
    try {
      // print("1");
      await FirebaseFirestore.instance
          .collection('courses')
          .where("name", isEqualTo: "${courseName}")
          .get()
          .then((value) async => {
        // print("2"),
        path = await value.docs[0]['pathway'],
        // print("3"),
        for (var i in path)
          {
            // print("4"),
            jsonString = jsonEncode(i),
            // print("5"),
            pathwaydata.add(jsonString),
            // print("6"),
          },
        // htmltext = pathwaydata[1]['data'],
        d = jsonDecode(pathwaydata[1]),
        htmltext = d['data'],
        // print("7"),
        // print("llll $htmltext")
      });
      // print("pathwaydata ${pathwaydata}");
    } catch (e) {
      // print("pathwaydata -- ${e}");
    }
    ;
  }

  int? dragSectionIndex, dragSubsectionIndex;
  int? subIndex, index;
  bool assignmentDrag = false;
  List<Map<String, dynamic>> listAssignment = [
    {
      "assign": [
        {"assignment": "assignment 1"}
      ],
      "index": 0
    },
    {
      "assign": [
        {"assignment": "assignment 1"}
      ],
      "index": 1
    },
  ];
  String? name;
  // int? selectAssignment;
  // int? selectAssignmentSectionIndex;
  Widget _buildVideoDetails(horizontalScale, verticalScale) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("courses")
            .doc(courseId)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print("snapdata----------");
            var listOfSectionData;
            // setState(() {
            listOfSectionData = snapshot.data["curriculum1"];
            // });
            // var listOfSectionSort = snapshot.data["curriculum1"][widget.courseName];
            // listOfSectionSort.sort((a,b){
            //   if(a["sr"]>b["sr"]){
            //     return 1;
            //   }
            //   return -1;
            // });
            print(widget.courseName);
            print(snapshot.data);
            listOfSectionData[widget.courseName].sort((a, b) {
              print("---========");
              print(a["sr"]);
              if (a["sr"] > b["sr"]) {
                return 1;
              }
              return -1;
            });
            // print("listtttt ${listOfSectionData}");
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:
                List.generate(listOfSectionData[widget.courseName].length,
                        (sectionIndex) {
                      // var listOfDraggable = List<List>.generate(listOfSectionSort.length, (index) => []);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          sectionIndex == 0
                              ? Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Column(
                              children: [
                                Container(
                                  child: ExpansionTile(
                                    title: Text(
                                      'Important Instructions',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    children: List.generate(
                                      pathwaydata.length,
                                          (index1) {
                                        Map valueMap =
                                        json.decode(pathwaydata[index1]);
                                        // print("ppppp ${valueMap}");
                                        return Column(
                                          children: [
                                            // videoPercentageList.length != 0 ?
                                            // Text(videoPercentageList[index][courseData.entries.elementAt(index).key][courseData.entries.elementAt(index).value[index1].videoTitle].toString()) : SizedBox(),
                                            GestureDetector(
                                              onTap: () {
                                                print(valueMap['name']);
                                                showAssignment = false;
                                                setState(() {
                                                  currentPosition = 0;
                                                  videoTitle =
                                                  valueMap['name'];
                                                  totalDuration = 0;
                                                });
                                                if (valueMap['type'] ==
                                                    "video") {
                                                  setState(() {
                                                    htmlbool = false;
                                                    enablePauseScreen = false;
                                                  });

                                                  selectedIndexOfVideo =
                                                      index1;
                                                  VideoScreen.currentSpeed
                                                      .value = 1.0;

                                                  initializeVidController(
                                                      valueMap['data'],
                                                      valueMap['name'],"");
                                                } else {
                                                  setState(() {
                                                    htmltext =
                                                    valueMap['data'];
                                                    enablePauseScreen = false;
                                                    htmlbool = true;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 60,
                                                    top: 15,
                                                    bottom: 15),
                                                child: Align(
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: Text(
                                                    valueMap['name'],
                                                    textAlign:
                                                    TextAlign.start,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                              : SizedBox(),
                          // SizedBox(),
                          Text(" ",style: TextStyle(fontSize: 0.5),),
                          Container(
                            child: ExpansionTile(
                                expandedCrossAxisAlignment:
                                CrossAxisAlignment.stretch,
                                title: Text(
                                  listOfSectionData[widget.courseName][sectionIndex]
                                  ["modulename"]
                                      .toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                children: List.generate(
                                    listOfSectionData[widget.courseName]
                                    [sectionIndex]["videos"]
                                        .length, (subsectionIndex) {
                                  // var listOfSubSectionSort = snapshot.data["curriculum1"][widget.courseName][sectionIndex]["subsection"];
                                  // listOfSubSectionSort.sort((a,b){
                                  //   if(a["sr"]>b["sr"])
                                  //   {
                                  //     return 1;
                                  //   }
                                  //   return -1;
                                  // });
                                  listOfSectionData[widget.courseName][sectionIndex]
                                  ["videos"]
                                      .sort((a, b) {
                                    // print("a=====${a["sr"]}");
                                    if (a["sr"] > b["sr"]) {
                                      return 1;
                                    }
                                    return -1;
                                  });

                                  // print("545454 ${listOfSubSectionSort}");
                                  //
                                  // var listColor =  List<bool>.generate(listOfSubSectionSort.length, (index) => currentIndex==null && index==0?true:
                                  // currentIndex!=null?index==currentIndex?true:false:false);

                                  // listOfDraggable[sectionIndex].add(dragSectionIndex!=null && dragSubsectionIndex!=null?
                                  // dragSubsectionIndex==subsectionIndex && dragSectionIndex==sectionIndex?
                                  // true:false:(subsectionIndex==0 && dragSectionIndex==sectionIndex) ||
                                  //     (dragSubsectionIndex==null && dragSectionIndex==null && subsectionIndex==0)?true:false);

                                  // print("-----$listColor");
                                  // print("draggable = ${listOfDraggable[sectionIndex]} ${listOfDraggable.length}");
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // listOfSectionData[widget.courseName]
                                      //             [sectionIndex]["assignments"] !=
                                      //         null
                                      //     ? Column(
                                      //         children: List.generate(
                                      //             listOfSectionData[
                                      //                             widget.courseName]
                                      //                         [sectionIndex]
                                      //                     ["assignments"]
                                      //                 .length, (assignment_index) {
                                      //               print("000000000000000");
                                      //           return subsectionIndex ==
                                      //                   listOfSectionData[widget
                                      //                                       .courseName]
                                      //                                   [
                                      //                                   sectionIndex]
                                      //                               [
                                      //                               "assignments"]
                                      //                           [assignment_index]
                                      //                       ["index"]
                                      //               ? selectAssignment != null &&
                                      //                       selectAssignment ==
                                      //                           assignment_index
                                      //                   ? Draggable(
                                      //                       data: assignment_index,
                                      //                       child: Container(
                                      //                         color: Colors.red,
                                      //                         child: Row(
                                      //                           children: [
                                      //                             Column(
                                      //                               children: List.generate(
                                      //                                   listOfSectionData[widget.courseName][sectionIndex]["assignments"][assignment_index]
                                      //                                           [
                                      //                                           "assignment"]
                                      //                                       .length,
                                      //                                   (sub_assign_index) {
                                      //
                                      //                                     print("99090909090909");
                                      //                                 return Container(
                                      //                                   padding: EdgeInsets.only(
                                      //                                       left:
                                      //                                           60,
                                      //                                       top: 15,
                                      //                                       bottom:
                                      //                                           15),
                                      //                                   alignment:
                                      //                                       Alignment
                                      //                                           .center,
                                      //                                   child:
                                      //                                       Center(
                                      //                                     child: Text(
                                      //                                         "Assignment  " +
                                      //                                             listOfSectionData[widget.courseName][sectionIndex]["assignments"][assignment_index]["assignment"][sub_assign_index]["name"]
                                      //                                                 .toString(),
                                      //                                         // maxLines: 1,
                                      //                                         overflow: TextOverflow.ellipsis,
                                      //                                         textAlign:
                                      //                                             TextAlign.center),
                                      //                                   ),
                                      //                                 );
                                      //                               }),
                                      //                             )
                                      //                           ],
                                      //                         ),
                                      //                       ),
                                      //                       feedback: Container(
                                      //                         color: Colors.blue,
                                      //                         width: 50,
                                      //                         height: 30,
                                      //                       ))
                                      //                   : GestureDetector(
                                      //                       onTap: () {
                                      //                         print(
                                      //                             "Assignment $showAssignment");
                                      //                         // showAssignment = true;
                                      //                         // setState(() {
                                      //                         //   assignmentUrl = listOfSectionData[widget.courseName][sectionIndex]
                                      //                         //                   [
                                      //                         //                   "assignments"]
                                      //                         //               [
                                      //                         //               assignment_index]
                                      //                         //           [
                                      //                         //           "assignment"]["url"]
                                      //                         //       .toString();
                                      //                         // });
                                      //                       },
                                      //                       onDoubleTap: () {
                                      //                         setState(() {
                                      //                           selectAssignmentSectionIndex =
                                      //                               sectionIndex;
                                      //                           selectAssignment =
                                      //                               assignment_index;
                                      //                           index = null;
                                      //                           subIndex = null;
                                      //                         });
                                      //                       },
                                      //                       child: Container(
                                      //                         color: Colors.green,
                                      //                         child: Row(
                                      //                           children: [
                                      //                             Column(
                                      //                               children: List.generate(
                                      //                                   listOfSectionData[widget.courseName][sectionIndex]["assignments"][assignment_index]
                                      //                                           [
                                      //                                           "assignment"]
                                      //                                       .length,
                                      //                                   (sub_assign_index) {
                                      //                                 return InkWell(
                                      //                                   onTap: () {
                                      //                                     showAssignment =
                                      //                                         true;
                                      //                                     setState(
                                      //                                         () {
                                      //                                       assignmentUrl =
                                      //                                           listOfSectionData[widget.courseName][sectionIndex]["assignments"][assignment_index]["assignment"][sub_assign_index]["url"].toString();
                                      //                                       solutionUrl =
                                      //                                           listOfSectionData[widget.courseName][sectionIndex]["assignments"][assignment_index]["assignment"][sub_assign_index]["pdf"].toString();
                                      //                                       dataSetUrl =
                                      //                                           listOfSectionData[widget.courseName][sectionIndex]["assignments"][assignment_index]["assignment"][sub_assign_index]["dataset"];
                                      //                                     });
                                      //                                     print(
                                      //                                         "Eagle");
                                      //                                   },
                                      //                                   child:
                                      //                                       Container(
                                      //                                     padding: EdgeInsets.only(
                                      //                                         left:
                                      //                                             60,
                                      //                                         top:
                                      //                                             15,
                                      //                                         bottom:
                                      //                                             15),
                                      //                                     alignment:
                                      //                                         Alignment
                                      //                                             .center,
                                      //                                     child:
                                      //                                         Center(
                                      //                                       child: Text(
                                      //                                           "Assignment  " +
                                      //                                               listOfSectionData[widget.courseName][sectionIndex]["assignments"][assignment_index]["assignment"][sub_assign_index]["name"].toString(),
                                      //                                           textAlign: TextAlign.center),
                                      //                                     ),
                                      //                                   ),
                                      //                                 );
                                      //                               }),
                                      //                             )
                                      //                           ],
                                      //                         ),
                                      //                       ),
                                      //                     )
                                      //               : SizedBox();
                                      //         }),
                                      //       )
                                      //     : SizedBox(),

                                      if (subIndex != null &&
                                          subIndex == subsectionIndex &&
                                          index == sectionIndex) Draggable(
                                        data: 0,
                                        child: Container(
                                          color: Colors.purpleAccent,
                                          child: GestureDetector(
                                              onTap: () {
                                                print(
                                                    'vdo = $videoPercentageList');
                                                htmlbool = false;
                                                showAssignment = false;
                                                if(listOfSectionData[widget.courseName]
                                                [sectionIndex]
                                                ["videos"]
                                                [
                                                subsectionIndex]
                                                ["type"]=="video") {
                                                  setState(() {
                                                    currentPosition = 0;
                                                    videoTitle =
                                                        listOfSectionData[
                                                        widget
                                                            .courseName]
                                                        [
                                                        sectionIndex]
                                                        ["videos"][
                                                        subsectionIndex]["name"]
                                                            .toString();
                                                    totalDuration = 0;
                                                  });

                                                  VideoScreen
                                                      .currentSpeed.value =
                                                  1.0;
                                                  initializeVidController(
                                                      listOfSectionData[widget
                                                          .courseName]
                                                      [sectionIndex]
                                                      ["videos"]
                                                      [
                                                      subsectionIndex]
                                                      ["url"]
                                                          .toString(),
                                                      listOfSectionData[widget
                                                          .courseName]
                                                      [
                                                      sectionIndex]
                                                      ["videos"][
                                                      subsectionIndex]["name"]
                                                          .toString(),
                                                      listOfSectionData[widget
                                                          .courseName][sectionIndex]["modulename"]
                                                          .toString());
                                                }
                                                else{

                                                  showAssignment =
                                                  true;
                                                  setState(
                                                          () {
                                                        assignmentUrl =
                                                            listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["url"].toString();
                                                        solutionUrl =
                                                            listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["pdf"].toString();
                                                        dataSetUrl =
                                                        listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["dataset"];
                                                      });
                                                  print(
                                                      "Eagle");
                                                }
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 60,
                                                      top: 15,
                                                      bottom: 15),
                                                  child: Align(
                                                    alignment:
                                                    Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        listOfSectionData[
                                                        widget
                                                            .courseName]
                                                        [
                                                        sectionIndex]
                                                        ["videos"][subsectionIndex]["type"]=="video"?
                                                        Icon(Icons.play_circle):Icon(Icons.assessment),
                                                        SizedBox(width: 10,),
                                                        Expanded(child: Text(
                                                          listOfSectionData[
                                                          widget
                                                              .courseName]
                                                          [
                                                          sectionIndex]
                                                          ["videos"][subsectionIndex]["type"]=="video"?
                                                          listOfSectionData[
                                                          widget
                                                              .courseName]
                                                          [
                                                          sectionIndex]
                                                          ["videos"][
                                                          subsectionIndex]["name"]
                                                              .toString():"Assignment : "+listOfSectionData[
                                                          widget
                                                              .courseName]
                                                          [
                                                          sectionIndex]
                                                          ["videos"][
                                                          subsectionIndex]["name"]
                                                              .toString(),style: TextStyle(overflow: TextOverflow.ellipsis),))
                                                      ],
                                                    ),
                                                  ))),
                                        ),
                                        feedback: SizedBox(
                                          height: 50,
                                          child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 60,
                                                  top: 15,
                                                  bottom: 15),
                                              child: Align(
                                                alignment:
                                                Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    listOfSectionData[
                                                    widget
                                                        .courseName]
                                                    [
                                                    index]
                                                    ["videos"][subIndex]["type"]=="video"?
                                                    Icon(Icons.play_circle):Icon(Icons.assessment),
                                                    SizedBox(width: 10,),
                                                    DefaultTextStyle(style: TextStyle(color: Colors.black,overflow: TextOverflow.ellipsis), child:
                                                    // Expanded(
                                                    //   child:
                                                    Text(
                                                      listOfSectionData[
                                                      widget
                                                          .courseName]
                                                      [
                                                      index]
                                                      ["videos"][subIndex]["type"]=="video"?
                                                      listOfSectionData[
                                                      widget
                                                          .courseName]
                                                      [
                                                      index]
                                                      ["videos"][
                                                      subIndex]["name"]
                                                          .toString():"Assignment : "+listOfSectionData[
                                                      widget
                                                          .courseName]
                                                      [
                                                      index]
                                                      ["videos"][subIndex]["name"]
                                                          .toString(),style: TextStyle(color: Colors.black,fontSize: 17,
                                                        fontWeight: FontWeight.normal,overflow: TextOverflow.ellipsis),),
                                                      // )
                                                    )
                                                  ],
                                                ),
                                              )),
                                          // width: 50,
                                          // height: 50,
                                        ),
                                      ) else
                                        DragTarget<int>(
                                          builder: (context, _, __) =>
                                              GestureDetector(
                                                  onDoubleTap: () {
                                                    print("doubletap");
                                                    if(role!=null)
                                                    {
                                                      if(role=="mentor")
                                                      {
                                                        setState(() {
                                                          // selectAssignment = null;
                                                          subIndex =
                                                              subsectionIndex;
                                                          index = sectionIndex;
                                                        });
                                                      }
                                                    }
                                                    print(subsectionIndex);
                                                  },
                                                  onTap: () {
                                                    _videoController!.pause();
                                                    setState(() {
                                                      currentPlayingVideoName = listOfSectionData[
                                                      widget
                                                          .courseName]
                                                      [
                                                      sectionIndex]
                                                      ["videos"][
                                                      subsectionIndex]["name"]
                                                          .toString();
                                                    });
                                                    if(listOfSectionData[
                                                    widget
                                                        .courseName]
                                                    [
                                                    sectionIndex]
                                                    ["videos"][
                                                    subsectionIndex]["type"]=="video")
                                                    {

                                                      print(
                                                          'vdo = $videoPercentageList');
                                                      htmlbool = false;
                                                      showAssignment = false;
                                                      setState(() {
                                                        currentPosition = 0;
                                                        videoTitle = listOfSectionData[
                                                        widget
                                                            .courseName]
                                                        [
                                                        sectionIndex]
                                                        ["videos"][
                                                        subsectionIndex]["name"]
                                                            .toString();
                                                        totalDuration = 0;
                                                      });

                                                      VideoScreen.currentSpeed
                                                          .value = 1.0;

                                                      initializeVidController(
                                                          listOfSectionData[widget.courseName]
                                                          [sectionIndex]
                                                          ["videos"]
                                                          [
                                                          subsectionIndex]
                                                          ["url"]
                                                              .toString(),
                                                          listOfSectionData[widget
                                                              .courseName]
                                                          [
                                                          sectionIndex]
                                                          ["videos"][
                                                          subsectionIndex]["name"]
                                                              .toString(),
                                                          listOfSectionData[widget.courseName][sectionIndex]["modulename"].toString());
                                                    }
                                                    else{

                                                      showAssignment =
                                                      true;
                                                      setState(
                                                              () {
                                                            assignmentUrl =
                                                                listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["url"].toString();
                                                            solutionUrl =
                                                                listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["pdf"].toString();
                                                            dataSetUrl =
                                                            listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["dataset"]!=null?
                                                            listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["dataset"]:[];
                                                          });
                                                      print(
                                                          "Eagle");
                                                    }

                                                  },
                                                  child: Container(
                                                      color:
                                                      currentPlayingVideoName==listOfSectionData[
                                                      widget
                                                          .courseName]
                                                      [
                                                      sectionIndex]
                                                      ["videos"][
                                                      subsectionIndex]["name"]
                                                          .toString()?HexColor("#fbedfc"):Colors.white,
                                                      //     Colors.red,

                                                      padding: EdgeInsets.only(
                                                          left:
                                                          listOfSectionData[
                                                          widget
                                                              .courseName]
                                                          [
                                                          sectionIndex]
                                                          ["videos"][subsectionIndex]["type"]=="video"?60:60,
                                                          top: 15,
                                                          bottom: 15),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            listOfSectionData[
                                                            widget
                                                                .courseName]
                                                            [
                                                            sectionIndex]
                                                            ["videos"][subsectionIndex]["type"]=="video"?
                                                            Icon(Icons.play_circle,color:
                                                            // currentPlayingVideoName==listOfSectionData[
                                                            // widget
                                                            //     .courseName]
                                                            // [
                                                            // sectionIndex]
                                                            // ["videos"][
                                                            // subsectionIndex]["name"]
                                                            //     .toString()?
                                                            Colors.black
                                                              // :null,
                                                            ):Icon(Icons.assessment,color:
                                                            // currentPlayingVideoName==listOfSectionData[
                                                            // widget
                                                            //     .courseName]
                                                            // [
                                                            // sectionIndex]
                                                            // ["videos"][
                                                            // subsectionIndex]["name"]
                                                            //     .toString()?
                                                            Colors.purple
                                                              // :null,
                                                            ),
                                                            SizedBox(width: 10,),
                                                            // _getVideoPercentageList!=null?
                                                            // _getVideoPercentageList![sectionIndex][listOfSectionData[
                                                            // widget
                                                            //     .courseName]
                                                            // [
                                                            // sectionIndex]["modulename"].toString()]!.forEach((element)
                                                            // {
                                                            //   if(element.containsKey(listOfSectionData[
                                                            //   widget
                                                            //       .courseName]
                                                            //   [
                                                            //   sectionIndex]
                                                            //   ["videos"][
                                                            //   subsectionIndex]["name"].toString()))
                                                            //     {
                                                            //       return Text("true");
                                                            //     }
                                                            //   else{
                                                            //     print(false);
                                                            //   }
                                                            // }):null,
                                                            ///
                                                            // Column(
                                                            // children: List.generate(
                                                            // _getVideoPercentageList![sectionIndex][listOfSectionData[
                                                            // widget
                                                            //     .courseName]
                                                            // [
                                                            // sectionIndex]["modulename"].toString()].length
                                                            // , (index) {
                                                            // if(_getVideoPercentageList![sectionIndex][listOfSectionData[widget.courseName][sectionIndex]["modulename"].toString()]
                                                            // [index][listOfSectionData[
                                                            // widget
                                                            //     .courseName]
                                                            // [
                                                            // sectionIndex]
                                                            // ["videos"][
                                                            // subsectionIndex]["name"]]!=null)
                                                            // {
                                                            // return Text(listOfSectionData[
                                                            // widget
                                                            //     .courseName]
                                                            // [
                                                            // sectionIndex]
                                                            // ["videos"][
                                                            // subsectionIndex]["name"].toString());
                                                            // }
                                                            // else{
                                                            // return SizedBox();
                                                            // }
                                                            // }),
                                                            // ),
                                                            ///
                                                            // Text(_getVideoPercentageList[sectionIndex][listOfSectionData[
                                                            // widget
                                                            //     .courseName]
                                                            // [
                                                            // sectionIndex]].),
                                                            _getVideoPercentageList!=null?
                                                            listOfSectionData[
                                                            widget
                                                                .courseName]
                                                            [
                                                            sectionIndex]
                                                            ["videos"][subsectionIndex]["type"]=="video"?Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: List.generate(_getVideoPercentageList![sectionIndex][listOfSectionData[widget.courseName][sectionIndex]["modulename"].toString()].length,
                                                                        (index) {
                                                                      if(_getVideoPercentageList![sectionIndex][listOfSectionData[widget.courseName][sectionIndex]["modulename"].toString()]
                                                                      [index][
                                                                      listOfSectionData[
                                                                      widget
                                                                          .courseName]
                                                                      [
                                                                      sectionIndex]
                                                                      ["videos"][subsectionIndex]["name"].toString()]!=null)
                                                                      {
                                                                        return Text(
                                                                          listOfSectionData[
                                                                          widget
                                                                              .courseName]
                                                                          [
                                                                          sectionIndex]
                                                                          ["videos"][subsectionIndex]["type"]=="video"?
                                                                          listOfSectionData[
                                                                          widget
                                                                              .courseName]
                                                                          [
                                                                          sectionIndex]
                                                                          ["videos"][
                                                                          subsectionIndex]["name"]
                                                                              .toString():"Assignment : "+listOfSectionData[
                                                                          widget
                                                                              .courseName]
                                                                          [
                                                                          sectionIndex]
                                                                          ["videos"][
                                                                          subsectionIndex]["name"]
                                                                              .toString(),style: TextStyle(overflow: TextOverflow.ellipsis,
                                                                            color:
                                                                            // currentPlayingVideoName==listOfSectionData[
                                                                            // widget
                                                                            //     .courseName]
                                                                            // [
                                                                            // sectionIndex]
                                                                            // ["videos"][
                                                                            // subsectionIndex]["name"]
                                                                            //     .toString()?Colors.purple:
                                                                            _getVideoPercentageList![sectionIndex][listOfSectionData[widget.courseName][sectionIndex]["modulename"].toString()]
                                                                            [index][
                                                                            listOfSectionData[
                                                                            widget
                                                                                .courseName]
                                                                            [
                                                                            sectionIndex]
                                                                            ["videos"][subsectionIndex]["name"].toString()]==100?Colors.green:Colors.black),);
                                                                      }
                                                                      else{
                                                                        return SizedBox();
                                                                      }
                                                                    }),
                                                              ),
                                                            ):SizedBox():SizedBox(),
                                                            listOfSectionData[
                                                            widget
                                                                .courseName]
                                                            [
                                                            sectionIndex]
                                                            ["videos"][subsectionIndex]["type"]!="video"?
                                                            Expanded(
                                                              child: Text(
                                                                listOfSectionData[
                                                                widget
                                                                    .courseName]
                                                                [
                                                                sectionIndex]
                                                                ["videos"][subsectionIndex]["type"]=="video"?
                                                                // listOfSectionData[
                                                                // widget
                                                                //     .courseName]
                                                                // [
                                                                // sectionIndex]
                                                                // ["videos"][
                                                                // subsectionIndex]["name"]
                                                                //     .toString()
                                                                '':"Assignment : "+listOfSectionData[
                                                                widget
                                                                    .courseName]
                                                                [
                                                                sectionIndex]
                                                                ["videos"][
                                                                subsectionIndex]["name"]
                                                                    .toString(),style: TextStyle(overflow: TextOverflow.ellipsis,
                                                                  color:
                                                                  // currentPlayingVideoName==listOfSectionData[
                                                                  // widget
                                                                  //     .courseName]
                                                                  // [
                                                                  // sectionIndex]
                                                                  // ["videos"][
                                                                  // subsectionIndex]["name"]
                                                                  //     .toString()?
                                                                  Colors.purple
                                                                // :null
                                                              ),),

                                                            ):SizedBox(),
                                                            _getVideoPercentageList!=null?
                                                            listOfSectionData[
                                                            widget
                                                                .courseName]
                                                            [
                                                            sectionIndex]
                                                            ["videos"][subsectionIndex]["type"]=="video"?
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: List.generate(_getVideoPercentageList![sectionIndex][listOfSectionData[widget.courseName][sectionIndex]["modulename"].toString()].length,
                                                                      (index) {
                                                                    if(_getVideoPercentageList![sectionIndex][listOfSectionData[widget.courseName][sectionIndex]["modulename"].toString()]
                                                                    [index][
                                                                    listOfSectionData[
                                                                    widget
                                                                        .courseName]
                                                                    [
                                                                    sectionIndex]
                                                                    ["videos"][subsectionIndex]["name"].toString()]!=null)
                                                                    {
                                                                      return
                                                                        // Container(
                                                                        // alignment: Alignment.center,
                                                                        // padding: EdgeInsets.only(top: 4,left:2),
                                                                        // height: 35,
                                                                        // width: 35,
                                                                        // decoration: BoxDecoration(
                                                                        //   shape: BoxShape.circle,
                                                                        //   border: Border.all(
                                                                        //     color: Colors.green
                                                                        //         ,width: 5
                                                                        //   )
                                                                        // ),
                                                                        // child:
                                                                        Text(_getVideoPercentageList![sectionIndex][listOfSectionData[widget.courseName][sectionIndex]["modulename"].toString()]
                                                                        [index][
                                                                        listOfSectionData[
                                                                        widget
                                                                            .courseName]
                                                                        [
                                                                        sectionIndex]
                                                                        ["videos"][subsectionIndex]["name"].toString()].toString()+"%",style: TextStyle(fontWeight: FontWeight.bold,
                                                                            fontSize: 14,color:
                                                                            _getVideoPercentageList![sectionIndex][listOfSectionData[widget.courseName][sectionIndex]["modulename"].toString()]
                                                                            [index][
                                                                            listOfSectionData[
                                                                            widget
                                                                                .courseName]
                                                                            [
                                                                            sectionIndex]
                                                                            ["videos"][subsectionIndex]["name"].toString()]==100?
                                                                            Colors.green:Colors.black),);
                                                                      // ,
                                                                      // );
                                                                    }
                                                                    else{
                                                                      return SizedBox();
                                                                    }
                                                                  }),
                                                            )
                                                                :SizedBox():SizedBox(),
                                                            ///
                                                            // listOfSectionData[
                                                            // widget
                                                            //     .courseName]
                                                            // [
                                                            // sectionIndex]
                                                            // ["videos"][subsectionIndex]["type"]=="video"?
                                                            // SizedBox(
                                                            //   child: CircularPercentIndicator(
                                                            //     radius: 15.0,
                                                            //     lineWidth: 1.5,
                                                            //     percent: 0.10,
                                                            //     center: Text("10%",style: TextStyle(fontSize: 10),),
                                                            //     progressColor: Colors.green,
                                                            //   ),
                                                            //   height: 50,
                                                            //   width: 50,
                                                            // ):SizedBox(),
                                                            SizedBox(width: 10,)
                                                          ],
                                                        ),
                                                      ))
                                              ),
                                          onAccept: (data) async {
                                            // if (index == null &&
                                            //     selectAssignmentSectionIndex ==
                                            //         sectionIndex) {
                                            //   setState(() {
                                            //     listOfSectionData[widget
                                            //                         .courseName]
                                            //                     [sectionIndex]
                                            //                 ["assignments"]
                                            //             [selectAssignment]
                                            //         ["index"] = subsectionIndex;
                                            //     selectAssignment = null;
                                            //     selectAssignmentSectionIndex =
                                            //         null;
                                            //   });
                                            //   await FirebaseFirestore.instance
                                            //       .collection("courses")
                                            //       .doc(courseId)
                                            //       .update({
                                            //     "curriculum1": listOfSectionData
                                            //   });
                                            // }
                                            print("data---------");
                                            // print(data);
                                            print(
                                                "selected sectionIndex=${index}");
                                            print(
                                                "selected subsectionIndex = ${subIndex}");
                                            print(
                                                "subsectionIndex = ${subsectionIndex}");
                                            print(
                                                "section index= ${sectionIndex}");
                                            print(subsectionIndex);
                                            int count = 0;
                                            if (subIndex != null &&
                                                index != null &&
                                                index == sectionIndex) {
                                              if (subIndex! < subsectionIndex) {
                                                print(true);
                                                for (int i = 0;
                                                i <= subsectionIndex;
                                                i++) {
                                                  print("count===");
                                                  if (i == subIndex) {
                                                    listOfSectionData[widget
                                                        .courseName]
                                                    [sectionIndex]
                                                    ["videos"][i]
                                                    ["sr"] = listOfSectionData[
                                                    widget.courseName]
                                                    [sectionIndex]["videos"]
                                                    [subsectionIndex]["sr"];
                                                    continue;
                                                  }
                                                  print("count===${count}");
                                                  listOfSectionData[widget
                                                      .courseName]
                                                  [sectionIndex]
                                                  ["videos"][i]["sr"] =
                                                      count;
                                                  count++;
                                                }
                                              } else {
                                                print(false);
                                                count = 0;

                                                ///
                                                for (int j = subsectionIndex;
                                                j <= subIndex!;
                                                j++) {
                                                  // print("count===${count}");
                                                  print("j======${j}");
                                                  if (j == subIndex) {
                                                    listOfSectionData[widget
                                                        .courseName]
                                                    [sectionIndex][
                                                    "videos"][j]["sr"] =
                                                        subsectionIndex;
                                                    print(
                                                        "a = ${listOfSectionData[widget.courseName][sectionIndex]["videos"][j]["sr"]}");
                                                  } else {
                                                    listOfSectionData[widget
                                                        .courseName]
                                                    [sectionIndex]
                                                    ["videos"][j]
                                                    ["sr"] = j + 1;
                                                    print(
                                                        "b = ${listOfSectionData[widget.courseName][sectionIndex]["videos"][j]["sr"]}");
                                                  }
                                                }
                                              }
                                              await FirebaseFirestore.instance
                                                  .collection("courses")
                                                  .doc(courseId)
                                                  .update({
                                                "curriculum1": listOfSectionData
                                              });
                                              setState(() {
                                                listOfSectionData;
                                                subIndex = null;
                                                index = null;
                                              });
                                            }
                                            // for (int i = 0;
                                            //     i <
                                            //         listOfSectionData[widget
                                            //                         .courseName]
                                            //                     [sectionIndex]
                                            //                 ["subsection"]
                                            //             .length;
                                            //     i++) {
                                            //   print("i = ==");
                                            //   print(listOfSectionData[widget
                                            //           .courseName][sectionIndex]
                                            //       ["subsection"][i]["sr"]);
                                            // }
                                            // print(listOfSectionData);

                                            ///
                                            // int temp = listOfSectionData[widget.courseName][sectionIndex]["subsection"][subIndex]["sr"];
                                            // listOfSectionData[widget.courseName][sectionIndex]["subsection"][subIndex]["sr"] = listOfSectionData[widget.courseName][sectionIndex]["subsection"][subsectionIndex]["sr"];
                                            // listOfSectionData[widget.courseName][sectionIndex]["subsection"][subsectionIndex]["sr"] = temp;
                                            ///
                                            // listOfSectionData[widget.courseName][sectionIndex]["subsection"][subsectionIndex]["sr"]
                                            // for(int i=0;i<listOfSectionData[widget.courseName][sectionIndex]["subsection"].length;i++)
                                            //   {
                                            //     if(listOfSectionData[widget.courseName][sectionIndex]["subsection"][i]["status"])
                                            //       {
                                            //         listOfSectionData[widget.courseName][sectionIndex]["subsection"][i]["status"] = false;
                                            //         listOfSectionData[widget.courseName][sectionIndex]["subsection"][subsectionIndex]["status"] = true;
                                            //         int index = listOfSectionData[widget.courseName][sectionIndex]["subsection"][i]["sr"];
                                            //         print("index----${index}");
                                            //         int currentIndex = listOfSectionData[widget.courseName][sectionIndex]["subsection"][subsectionIndex]["sr"];
                                            //         print("cuurent--${currentIndex}");
                                            //         listOfSectionData[widget.courseName][sectionIndex]["subsection"][subsectionIndex]["sr"] = index;
                                            //         listOfSectionData[widget.courseName][sectionIndex]["subsection"][i]["sr"] = currentIndex;
                                            //       }
                                            //   }
                                          },
                                        ),
                                      // listOfSectionData[widget.courseName][sectionIndex]["subsection"][subsectionIndex]["status"]?
                                      //     Container(child: Text(listOfSectionData[widget.courseName][sectionIndex]["assignment"].toString()),):SizedBox(),
                                      ///
                                      // listOfSectionData[widget.courseName][sectionIndex]["subsection"][subsectionIndex]["status"]?
                                      // Draggable(
                                      //     data:
                                      //     listOfSectionData[widget.courseName][sectionIndex],
                                      //     child: Container(
                                      //       alignment: Alignment.center,
                                      //       decoration: BoxDecoration(
                                      //           color: Colors.green,
                                      //           borderRadius: BorderRadius.circular(20)
                                      //       ),
                                      //       width: 150,
                                      //       height: 100,
                                      //       child: Text("Drag Assignment"),
                                      //     ), feedback: Container(
                                      //   alignment: Alignment.center,
                                      //   decoration: BoxDecoration(
                                      //       color: Colors.green,
                                      //       borderRadius: BorderRadius.circular(20)
                                      //   ),
                                      //   width: 150,
                                      //   height: 100,
                                      //   child: Text("Drag Assignment",style: TextStyle(fontSize: 13),),
                                      // )):
                                      // DragTarget(
                                      //   builder: (context,_,__)=>
                                      //     Container(
                                      //       decoration: BoxDecoration(
                                      //           color:listOfSectionData[widget.courseName][sectionIndex]["subsection"][subsectionIndex]["status"]?Colors.red:Colors.red,
                                      //           borderRadius: BorderRadius.circular(20)
                                      //       ),
                                      //       alignment: Alignment.center,
                                      //       height: listOfSectionData[widget.courseName][sectionIndex]["subsection"][subsectionIndex]["status"]?100:100,
                                      //       width: listOfSectionData[widget.courseName][sectionIndex]["subsection"][subsectionIndex]["status"]?150:150,
                                      //       child: Text("Drop here"),
                                      //     ),
                                      //   onAccept: (data)async{
                                      //   // print(listOfSectionSort);
                                      //   print("ppp");
                                      //
                                      //   // print(listOfSectionSort[sectionIndex]["subsection"][subsectionIndex]);
                                      //   for(int i=0;i<listOfSectionData[widget.courseName][sectionIndex]["subsection"].length;i++)
                                      //   {
                                      //     if(listOfSectionData[widget.courseName][sectionIndex]["subsection"][i]["status"]==true)
                                      //     {
                                      //       listOfSectionData[widget.courseName][sectionIndex]["subsection"][i]["status"] = false;
                                      //     }
                                      //   }
                                      //   listOfSectionData[widget.courseName][sectionIndex]["subsection"][subsectionIndex]["status"] = true;
                                      //   await FirebaseFirestore.instance.collection("courses").doc(courseId).
                                      //   update({"curriculum1":listOfSectionData});
                                      //   setState(() {
                                      //     print("Accept");
                                      //     // color = data;
                                      //     print(subsectionIndex);
                                      //     print(sectionIndex);
                                      //     listOfSectionData;
                                      //     print("--------------${listOfSectionData[widget.courseName][sectionIndex]["subsection"][sectionIndex]["status"]}");
                                      //     print(listOfSectionData);
                                      //   });
                                      // },)
                                    ],
                                  );
                                })),
                          ),
                        ],
                      );
                    }),
              ),
            );
          } else {
            return Text("Loading..");
          }
          // Widget _buildVideoDetailsListTiles(
          //     double horizontalScale, double verticalScale) {
          //   final screenWidth = MediaQuery.of(context).size.width;
          //   final screenHeight = MediaQuery.of(context).size.width;
          //
          //   print('sddddddddddddddddddddddddddddddddddddddddd');
          //   print(courseData?.length);
          //   print('sddddddddddddddddddddddddddddddddddddddddd');
          //   // return Container();
          //   return InkWell(
          //     onTap: () {
          //       print('sddddddddddddddddddddddddddddddddddddddddd');
          //
          //       print(courseData?.length);
          //
          //       print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.all(3.0),
          //       child: Container(
          //         child: loading
          //             ? Center(
          //                 child: Container(
          //                   height: 40,
          //                   width: 40,
          //                   child: Center(
          //                     child: CircularProgressIndicator(
          //                       backgroundColor: Color.fromARGB(255, 0, 0, 0),
          //                     ),
          //                   ),
          //                 ),
          //               )
          //             : ListView.builder(
          //                 itemCount: courseData?.length,
          //                 itemBuilder: (BuildContext context, int index) {
          //                   // return Container();
          //
          //                   print("this is index : ${index}");
          //                   var sectionList = [];
          //                   var count = -1;
          //                   return Padding(
          //                     padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          //                     child: Column(
          //                       children: [
          //                         index == 0
          //                             ? Padding(
          //                           padding:
          //                           const EdgeInsets.fromLTRB(5, 0, 5, 0),
          //                           child: Column(
          //                             children: [
          //                               Container(
          //                                 child: ExpansionTile(
          //                                   title: Text(
          //                                     'Important Instructions',
          //                                     style: TextStyle(
          //                                         fontWeight: FontWeight.bold),
          //                                   ),
          //                                   children: List.generate(
          //                                     pathwaydata.length,
          //                                         (index1) {
          //                                       Map valueMap = json
          //                                           .decode(pathwaydata[index1]);
          //                                       print("ppppp ${valueMap}");
          //                                       return Column(
          //                                         children: [
          //                                           // videoPercentageList.length != 0 ?
          //                                           // Text(videoPercentageList[index][courseData.entries.elementAt(index).key][courseData.entries.elementAt(index).value[index1].videoTitle].toString()) : SizedBox(),
          //                                           GestureDetector(
          //                                             onTap: () {
          //                                               print(valueMap['name']);
          //                                               showAssignment = false;
          //                                               setState(() {
          //                                                 currentPosition = 0;
          //                                                 videoTitle =
          //                                                 valueMap['name'];
          //                                                 totalDuration = 0;
          //                                               });
          //                                               if (valueMap['type'] ==
          //                                                   "video") {
          //                                                 setState(() {
          //                                                   htmlbool = false;
          //                                                   enablePauseScreen =
          //                                                   false;
          //                                                 });
          //
          //                               selectedIndexOfVideo =
          //                                   subsectionIndex;
          //                               VideoScreen.currentSpeed
          //                                   .value = 1.0;
          //
          //                               initializeVidController(
          //                                   subSectionSort[subsectionIndex]['url'],
          //                                   subSectionSort[subsectionIndex]['videoname']);
          //                             } else {
          //                               setState(() {
          //                                 htmltext = subSectionSort[subsectionIndex]['url'];
          //                                 enablePauseScreen =
          //                                 false;
          //                                 htmlbool = true;
          //                               });
          //                             }
          //                           },
          //                           child: Container(
          //                             padding: EdgeInsets.only(
          //                                 left: 60,
          //                                 top: 15,
          //                                 bottom: 15),
          //                             child: Align(
          //                               alignment: Alignment
          //                                   .centerLeft,
          //                               child: Text(subSectionSort[subsectionIndex]['videoname'].toString(),
          //                                 textAlign:
          //                                 TextAlign.start,
          //                               ),
          //                             ),
          //                           ),
          //                         );
          //                       },
          //                     ),
          //                   ),
          //                 );
          //                 //   Column(
          //                 //   children: List.generate(snapshot.data["curriculum1"][widget.courseName][sectionIndex]["subsection"].length, (subsectionIndex) {
          //                 //     return
          //                 //       Column(
          //                 //       children: [
          //                 //         subsectionIndex==0?Text(snapshot.data["curriculum1"][widget.courseName][sectionIndex]["sectionName"].toString()):SizedBox(),
          //                 //         Text(snapshot.data["curriculum1"][widget.courseName][sectionIndex]["subsection"][subsectionIndex]["url"].toString()),
          //                 //
          //                 //       ],
          //                 //     );
          //                 //   }),
          //                 // );
          //               }),
          //             );
          //           }
          //         else
          //           {
          //             return Text("Loading...");
          //           }
        });
  }
}

class replay10 extends StatelessWidget {
  const replay10({
    Key? key,
    required VideoPlayerController? videoController,
  })  : _videoController = videoController,
        super(key: key);

  final VideoPlayerController? _videoController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() async {
        final currentPosition = await _videoController!.position;
        final newPosition = currentPosition! - Duration(seconds: 10);
        _videoController!.seekTo(newPosition);
      }),
      child: Icon(
        Icons.replay_10,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}

class fastForward10 extends StatelessWidget {
  const fastForward10({
    Key? key,
    required VideoPlayerController? videoController,
  })  : _videoController = videoController,
        super(key: key);

  final VideoPlayerController? _videoController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() async {
        final currentPosition = await _videoController!.position;
        final newPosition = currentPosition! + Duration(seconds: 10);
        _videoController!.seekTo(newPosition);
      }),
      child: Icon(
        Icons.forward_10,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}
