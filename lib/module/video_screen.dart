import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:auto_orientation/auto_orientation.dart';
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
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
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

  void getData() async {
    await setModuleId();
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('Modules')
        .doc(moduleId)
        .collection('Topics')
        .orderBy('sr')
        .get()
        .then((value) {
      for (var video in value.docs) {
        _listOfVideoDetails.add(
          VideoDetails(
            videoId: video.data()['id'] ?? '',
            type: video.data()['type'] ?? '',
            canSaveOffline: video.data()['Offline'] ?? true,
            serialNo: video.data()['sr'].toString(),
            videoTitle: video.data()['name'] ?? '',
            videoUrl: video.data()['url'] ?? '',
          ),
        );
      }
    });
  }

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
      updateCourseCompletionPercentage(videoPercentageList);
      _currentVideoIndex.value++;
      initializeVidController(
        _listOfVideoDetails[_currentVideoIndex.value].videoUrl,
        _listOfVideoDetails[_currentVideoIndex.value].videoTitle,
      );
    }
    var duration = _duration;
    if (duration == null) return;

    if (sectionName.length != 0 && videoPercentageList.length != 0) {
      for (int i = 0; i < sectionName.length; i++) {
        print('ii = $i');
        for (int j = 0;
        j < videoPercentageList[i][sectionName[i]].length;
        j++) {
          print('jjj = $j $i  }');
          try {
            print('video $videoTitle');
            print(
                'ssss ${videoPercentageList[i][sectionName[i]][j].toString()}');
            print('length of == ${videoTitle.toString().length}');
            if (videoPercentageList[i][sectionName[i]][j][videoTitle.toString()]
                .toString() !=
                'null') {
              videoPercentageList[i][sectionName[i]][j][videoTitle.toString()] =
                  ((currentPosition / totalDuration) * 100).toInt();
            }
            print(
                'dd ${videoPercentageList[i][sectionName[i]][j][videoTitle.toString()].toString()}');
          } catch (e) {
            print('I am error ${e.toString()}');
          }
        }
      }
    }

    // if (sectionName.length != 0 && videoPercentageList.length != 0) {
    //   for (int i = 0; i < sectionName.length; i++) {
    //     print('ii = $i');
    //     for (int j = 0;
    //         j < videoPercentageList[i][sectionName[i]].length;
    //         j++) {
    //       print('jjj = $j $i  }');
    //       try {
    //         print('video $videoTitle');
    //         print(
    //             'ssss ${videoPercentageList[i][sectionName[i]][j].toString()}');
    //         print('length of == ${videoTitle.toString().length}');
    //         if (videoPercentageList[i][sectionName[i]][j][videoTitle.toString()]
    //                 .toString() !=
    //             'null') {
    //           videoPercentageList[i][sectionName[i]][j][videoTitle.toString()] =
    //               ((currentPosition / totalDuration) * 100).toInt();
    //         }
    //         print(
    //             'dd ${videoPercentageList[i][sectionName[i]][j][videoTitle.toString()].toString()}');
    //       } catch (e) {
    //         print('I am error ${e.toString()}');
    //       }
    //     }
    //   }
    // }

    setState(() {
      currentPosition = _videoController!.value.position.inSeconds.toInt();
      videoPercentageList;
    });

    updateCourseCompletionPercentage(videoPercentageList);

    var position = _videoController?.value.position;
    setState(() {
      _position = position;
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
      updateCourseCompletionPercentage(videoPercentageList);
    }
    _isPlaying = playing;
  }

  int totalDuration = 0;
  int currentPosition = 0;

  void initializeVidController(String url, String name) async {
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

  Future<Map<String, dynamic>> getDataFrom(sectionName, curriculumdata) async {
    var data = {};
    await sectionName.entries.forEach((element) async {
      curriculumdata.entries.forEach((entry) {
        if (element.key.toString() == entry.key) {
          entry.value.forEach((name) {
            listOfVideo.add(name);
          });
          data[element] = listOfVideo.toList();
          dataList.add({element: listOfVideo.toList()});
          listOfVideo = [];
        }
      });
    });
    Map<String, dynamic> done = {};

    for (var t in data.entries) {
      print("t = ${t.key}");
      for (var name in t.value) {
        print("Name = == = ${name}");
        await FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .collection('Modules')
            .doc(moduleId)
            .collection('Topics')
            .where("name", isEqualTo: "${name.toString()}")
            .get()
            .then((value) {
          print("YY");
          print(value.docs.length);
          for (var video in value.docs) {
            listOfVideo.add(VideoDetails(
              videoId: video.data()['id'] ?? '',
              type: video.data()['type'] ?? '',
              canSaveOffline: video.data()['Offline'] ?? true,
              serialNo: video.data()['sr'].toString(),
              videoTitle: video.data()['name'] ?? '',
              videoUrl: video.data()['url'] ?? '',
            ));
            print("oo");
            String str = t.key.toString();
            str = str.replaceRange(0, 9, "");
            var st = "";
            for (int i = 0; i < str.length; i++) {
              if (str[i] == ":") {
                break;
              }
              st += str[i];
            }
            done[st] = listOfVideo.toList();
            print("oopp");
          }
          // print(value.docs.length);
        });
      }
      listOfVideo = [];
    }
    print("done = $done");
    print("length= = ${dataList.length}");

    print("yes");
    print(listOfVideo.length);
    return done;
  }

  var dataa;

  Future<void> getCourseData() async {
    setState(() {
      loading = true;
    });

    var val;

    print("LLLLLLL ${FirebaseAuth.instance.currentUser!.uid} ${courseId}");

    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .get()
        .then((value) async {
      print(value.data());

      val = value.data();

      curriculumdata = val["curriculum"];

      courseName = val['name'];
      sectionName = curriculumdata['sectionsName'];
      var dic = {};
      print(sectionName);
      for (var i in sectionName) {
        dic[i] = i;
      }

      dataa = await getDataFrom(dic, curriculumdata);
      // await FirebaseFirestore.instance.collection('courseprogress')
      //     .doc(_auth.currentUser!.uid).get().then((value) async {
      //   if(value.exists) {
      //     var progressData = await FirebaseFirestore.instance.collection('courseprogress')
      //         .doc(_auth.currentUser!.uid).get();
      //     print('progressdata ${progressData.get(courseName)}');
      //     var restData = progressData.data();
      //     print('restdata = ${restData!['Machine Learning']}');
      //
      //     // videoPercentageList = progressData.data();
      //   } else {
      //
      //   }
      // });
      for (var i in dataa.entries) {
        print('i == dip ${i.key}');
        print('i == dip ${i.value[0].videoTitle}');
        var sectionList = [];
        for (var k = 0; k < i.value.length; k++) {
          sectionList.add({
            i.value[k].videoTitle.toString(): 0,
          });
        }
        videoPercentageList.add({i.key.toString(): sectionList});
      }

      print('videoPercentage = $videoPercentageList');
      setState(() {
        videoPercentageList;
      });
      print('this is $sectionName');
      print("datamap = $datamap");
      curriculumdata.remove("sectionsName");
      print("this is srinivas $curriculumdata");
      try {
        courseData = dataa;
        courseData = courseData;
        print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy ");
        print(curriculumdata.length);
        print(courseData);
        if (courseData == datamap) {
          setState(() {
            loading = false;
            courseData;
          });
        }

        print("LLLLLLLLLLLLLLLLLLyyyyyyyyyyyyyy ");
      } catch (e) {
        print('2');
        if (courseData == dataa) {
          setState(() {
            loading = false;
            courseData;
          });
        }
        print(e);
      }
    });
    if (courseData == dataa) {
      setState(() {
        loading = false;
        courseData;
      });
    }
    // for (var i = 0; i < datamap.length; i++) {
    //   var value = datamap.entries.elementAt(i).value;
    //   for (var i in value) {
    //     resultValue.add(OptionItem(id: 'null', title: i.videoTitle));
    //   }
    //   print(resultValue);
    // }

    print("LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL ");
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

  updateCourseCompletionPercentage(videoPercentageListUpdate) async {

    // await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).update({
    //   courseName : videoPercentageListUpdate,
    // }).then((value) => print(videoPercentageListUpdate)).catchError((error) => print('dipen = $error'));
    // print('I am uid = ${FirebaseAuth.instance.currentUser!.uid}');

    await FirebaseFirestore.instance.collection('courseprogress').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) async {
      print('srinivas ${value.data().toString()}');
      if(value.exists) {
        await FirebaseFirestore.instance.collection('courseprogress').doc(_auth.currentUser!.uid).update({
          courseName: videoPercentageListUpdate,
          'email': _auth.currentUser!.email,
        }).catchError((onError) {print('srinnn = $onError');});
      } else {
        await FirebaseFirestore.instance.collection('courseprogress').doc(_auth.currentUser!.uid).set(
            {
              courseName : videoPercentageListUpdate,
              'email': FirebaseAuth.instance.currentUser!.email,
            });
      }
    }).catchError((onError) { print('srinu $onError');});

    // await FirebaseFirestore.instance.collection('courseprogress').doc().set(
    //     {
    //       courseName : videoPercentageListUpdate,
    //       'email': FirebaseAuth.instance.currentUser!.email,
    //     });
  }

  @override
  void dispose() {
    super.dispose();
    AutoOrientation.portraitUpMode();
    _disposed = true;
    _videoController!.dispose();
    _videoController = null;
  }

  getFiles() async {
    futureAssignments =
        await FirebaseApi.listAll('courses/${widget.courseName}/assignment');
    futureSolutions =
        await FirebaseApi.listAll('courses/${widget.courseName}/solution');
    futureDataSets =
        await FirebaseApi.listAll('courses/${widget.courseName}/dataset');

    setState(() {
      futureAssignments;
      futureDataSets;
      futureSolutions;
    });
  }

  @override
  void initState() {
    html.window.document.onContextMenu.listen((evt) => evt.preventDefault());
    VideoScreen.currentSpeed.value = 1.0;
    getData();
    getCourseData();
    getFiles();
    Future.delayed(Duration(milliseconds: 500), () {
      initializeVidController(
        _listOfVideoDetails[0].videoUrl,
        _listOfVideoDetails[0].videoTitle,
      );
    });

    super.initState();
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
                              Navigator.pop(context);
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
                          Expanded(
                            child: _buildVideoDetailsListTiles(
                              horizontalScale,
                              verticalScale,
                            ),
                          ),
                        ],
                      ),
                    ),
              Expanded(
                flex: 2,
                child: showAssignment
                    ? AssignmentScreen(
                        selectedSection: selectedSection,
                        courseData: courseData,
                        courseName: widget.courseName,
                        assignmentUrl: assignmentUrl,
                        solutionUrl: solutionUrl,
                  dataSetUrl: dataSetUrl,
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
                                          child: VideoPlayer(_videoController!),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            enablePauseScreen =
                                                !enablePauseScreen;
                                            print(
                                                'Container of column clicked');
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
                                              child: CircularProgressIndicator(
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
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF7860DC),
                                  ),
                                );
                              }
                            },
                          ),
                          menuClicked
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Text(
                                    videoTitle.toString() != 'null'
                                        ? videoTitle.toString()
                                        : '',
                                    style: TextStyle(
                                        fontSize: 18, fontFamily: 'SemiBold'),
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
                              ? Expanded(
                                  flex: 2,
                                  child: _buildVideoDetailsListTile(
                                    horizontalScale,
                                    verticalScale,
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    ));
  }

  void goFullScreen() {

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
                          setState((){
                            menuClicked = !menuClicked;
                          });
                          if (menuClicked) {
                            html.document.documentElement?.requestFullscreen();
                          } else {
                            html.document.exitFullscreen();
                          }

                        },
                        icon: Icon(
                          menuClicked ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
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

  int? selectedSection;
  int? selectedIndexOfVideo;
  String? selectedVideoIndexName;
  String? videoTitle;
  String dataSetUrl = '';

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

  Widget _buildVideoDetailsListTiles(
      double horizontalScale, double verticalScale) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.width;

    print('sddddddddddddddddddddddddddddddddddddddddd');
    print(courseData?.length);
    print('sddddddddddddddddddddddddddddddddddddddddd');
    // return Container();
    return InkWell(
      onTap: () {
        print('sddddddddddddddddddddddddddddddddddddddddd');

        print(courseData?.length);

        print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      },
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          child: loading
              ? Center(
                  child: Container(
                    height: 40,
                    width: 40,
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: courseData?.length,
                  itemBuilder: (BuildContext context, int index) {
                    // return Container();

                    print("this is index : ${index}");
                    var sectionList = [];
                    var count = -1;
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Column(
                        children: [
                          Container(
                            child: ExpansionTile(
                                title: Text(
                                  '${index + 1}. ' +
                                      courseData.entries.elementAt(index).key,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                children: List.generate(
                                    courseData.entries
                                        .elementAt(index)
                                        .value
                                        .length, (index1) {
                                  sectionList.add({
                                    courseData.entries
                                        .elementAt(index)
                                        .value[index1]
                                        .toString(): 0
                                  });

                                  return Column(
                                    children: [
                                       GestureDetector(
                                          onTap: () {
                                            print('vdo = $videoPercentageList');

                                            showAssignment = false;
                                            setState(() {
                                              currentPosition = 0;
                                              videoTitle = courseData.entries
                                                  .elementAt(index)
                                                  .value[index1]
                                                  .videoTitle
                                                  .toString();
                                              totalDuration = 0;
                                            });

                                            selectedIndexOfVideo = index1;
                                            VideoScreen.currentSpeed.value =
                                                1.0;
                                            initializeVidController(
                                                courseData.entries
                                                    .elementAt(index)
                                                    .value[index1]
                                                    .videoUrl
                                                    .toString(),
                                                courseData.entries
                                                    .elementAt(index)
                                                    .value[index1]
                                                    .videoTitle
                                                    .toString());
                                          },
                                          child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 60,
                                                  top: 15,
                                                  bottom: 15),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  courseData.entries
                                                      .elementAt(index)
                                                      .value[index1]
                                                      .videoTitle
                                                      .toString(),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ))),
                                      // totalDuration != 0 &&
                                      //         courseData.entries
                                      //                 .elementAt(index)
                                      //                 .value[index1]
                                      //                 .videoUrl
                                      //                 .toString() ==
                                      //             selectedVideoIndexName
                                      //                 .toString()
                                      //     ? Text(((currentPosition /
                                      //                     totalDuration) *
                                      //                 100)
                                      //             .toInt()
                                      //             .toString() +
                                      //         "%")
                                      //     : Text("0%"),
                                      // LinearProgressIndicator(
                                      //   color: Colors.blue,
                                      //   valueColor:
                                      //       new AlwaysStoppedAnimation<Color>(
                                      //           Colors.red),
                                      //   value: totalDuration != 0 &&
                                      //           courseData.entries
                                      //                   .elementAt(index)
                                      //                   .value[index1]
                                      //                   .videoUrl
                                      //                   .toString() ==
                                      //               selectedVideoIndexName
                                      //                   .toString()
                                      //       ? ((currentPosition /
                                      //                   totalDuration) *
                                      //               100) /
                                      //           100
                                      //       : 0,
                                      // ),
                                      index1 ==
                                              courseData.entries
                                                      .elementAt(index)
                                                      .value
                                                      .length -
                                                  1
                                          ? Column(
                                              children: List.generate(
                                                courseData.entries
                                                    .elementAt(index)
                                                    .value
                                                    .length,
                                                (firstIndex) => Column(
                                                  children: List.generate(
                                                      futureAssignments.length,
                                                      (fileIndex) {
                                                    print(courseData.entries
                                                        .elementAt(index)
                                                        .key);
                                                    print('dipen');
                                                    print(courseData.entries
                                                            .elementAt(index)
                                                            .key
                                                            .toString() +
                                                        '${fileIndex + 1}' +
                                                        '.ipynb');

                                                    print(courseData.entries
                                                            .elementAt(index)
                                                            .key
                                                            .toString() +
                                                        '${fileIndex + 1}' +
                                                        '.pdf');

                                                    if ((futureAssignments[
                                                                    fileIndex]
                                                                .name
                                                                .toString() ==
                                                            courseData.entries
                                                                    .elementAt(
                                                                        index)
                                                                    .key
                                                                    .toString() +
                                                                '${index + 1}.' +
                                                                '${firstIndex}' +
                                                                '.ipynb')
                                                        // ||
                                                        //     (futureSolutions[fileIndex].name.toString() ==
                                                        //         courseData.entries.elementAt(index).key.toString() + '${index+1}.' + '${firstIndex}' + '.pdf')
                                                        ) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            for (int i = 0;
                                                                i <
                                                                    futureSolutions
                                                                        .length;
                                                                i++) {
                                                              if (futureSolutions[
                                                                          i]
                                                                      .name
                                                                      .toString() ==
                                                                  courseData
                                                                          .entries
                                                                          .elementAt(
                                                                              index)
                                                                          .key
                                                                          .toString() +
                                                                      '${index + 1}.' +
                                                                      '${firstIndex}' +
                                                                      '.pdf') {
                                                                solutionUrl =
                                                                    futureSolutions[
                                                                            i]
                                                                        .url;
                                                              }
                                                            }

                                                            for (int i = 0;
                                                            i <
                                                                futureDataSets
                                                                    .length;
                                                            i++) {
                                                              if (futureDataSets[
                                                              i]
                                                                  .name
                                                                  .toString() ==
                                                                  courseData
                                                                      .entries
                                                                      .elementAt(
                                                                      index)
                                                                      .key
                                                                      .toString() +
                                                                      '${index + 1}.' +
                                                                      '${firstIndex}' +
                                                                      '.csv') {
                                                                dataSetUrl =
                                                                    futureDataSets[
                                                                    i]
                                                                        .url;
                                                              }
                                                            }
                                                            setState(() {
                                                              dataSetUrl;
                                                              solutionUrl;
                                                              assignmentUrl =
                                                                  futureAssignments[
                                                                          fileIndex]
                                                                      .url;
                                                              selectedSection =
                                                                  fileIndex;
                                                              print(
                                                                  '$index and section is $selectedSection');
                                                              showAssignment =
                                                                  !showAssignment;
                                                              _videoController!
                                                                  .pause();
                                                              enablePauseScreen =
                                                                  !enablePauseScreen;
                                                              print(
                                                                  futureAssignments);
                                                            });
                                                          },
                                                          child: Container(
                                                            width: screenWidth /
                                                                3,
                                                            height:
                                                                screenHeight /
                                                                    24,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Icon(Icons.assignment),
                                                                SizedBox(width: 5),
                                                                Text(
                                                                    'Assignment ${index + 1}.$firstIndex'),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    return SizedBox();
                                                  }),
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  );
                                })),
                          ),
                          // Text(videoPercentageList.toString()),
                        ],
                      ),
                    );
                  }),
        ),
      ),
    );
  }

  Widget _buildVideoDetailsListTile(
      double horizontalScale, double verticalScale) {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .collection('Modules')
            .doc(moduleId)
            .collection('Topics')
            .orderBy('sr')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: courseData?.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> map = snapshot.data!.docs[index].data();
                  return Card(
                    elevation: 0,
                    color: _currentVideoIndex.value == index
                        ? Color(0xFFDDD2FB)
                        : Colors.white,
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            VideoScreen.currentSpeed.value = 1.0;
                            initializeVidController(
                              _listOfVideoDetails[index].videoUrl,
                              _listOfVideoDetails[index].videoTitle,
                            );
                            _currentVideoIndex.value = index;
                            showAssignment = false;
                          },
                          leading: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${index + 1}'),
                          ),
                          title: Text(
                            map['name'],
                            textScaleFactor: min(
                              horizontalScale,
                              verticalScale,
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              fontFamily: "Medium",
                            ),
                          ),
                          // trailing: InkWell(
                          //   onTap: () async {
                          //     var directory =
                          //         await getApplicationDocumentsDirectory();
                          //     _currentVideoIndex.value = index;
                          //     download(
                          //         dio: Dio(),
                          //         fileName: map['name'],
                          //         url: map['url'],
                          //         savePath:
                          //             "${directory.path}/${map['name'].replaceAll(' ', '')}.mp4",
                          //         topicName: map['name'],
                          //         courseName: widget.courseName);
                          //   },
                          //   child: _currentVideoIndex.value == index
                          //       ? Stack(
                          //           children: [
                          //             Positioned(
                          //               bottom: 0,
                          //               left: 0,
                          //               right: 0,
                          //               top: 0,
                          //               child: Icon(
                          //                 Icons.download_for_offline_rounded,
                          //               ),
                          //             ),
                          //             SizedBox(
                          //               height: 30,
                          //               width: 30,
                          //               child: CircularProgressIndicator(
                          //                 value: _downloadProgress.value,
                          //                 color: Color(0xFF7860DC),
                          //                 backgroundColor: Color(0xFFDDD2FB),
                          //               ),
                          //             )
                          //           ],
                          //         )
                          //       : Icon(
                          //           Icons.download_for_offline_rounded,
                          //         ),
                          // ),
                        ),
                        ListTile(
                          onTap: () {
                            _videoController!.pause();
                            enablePauseScreen = !enablePauseScreen;
                          },
                          leading: Icon(Icons.assignment_ind_outlined),
                          title: Text(
                            'Assignment 1.${index + 1}',
                            textScaleFactor: min(
                              horizontalScale,
                              verticalScale,
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              fontFamily: "Medium",
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
          } else {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Lottie.asset('assets/load-shimmer.json',
                  fit: BoxFit.fill, reverse: true),
            );
          }
        },
      ),
    );
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

class fullScreenIcon extends StatelessWidget {
    const fullScreenIcon({
    Key? key,
    required this.isPortrait,

  }) : super(key: key);

  final bool isPortrait;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IconButton(
        onPressed: () {
          if (isPortrait) {
            AutoOrientation.landscapeRightMode();
          } else {
            AutoOrientation.portraitUpMode();
          }
        },
        icon: Icon(
          isPortrait ? Icons.fullscreen_rounded : Icons.fullscreen_exit_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
