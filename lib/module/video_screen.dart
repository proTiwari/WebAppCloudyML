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
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
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
    int total = 0;
    // int count = 0;
    for(var i in _getVideoPercentageList)
    {
      if(i[moduleName.toString()]!=null)
      {
        for(var j in i[moduleName.toString()])
        {
          print("0kkkkk");
          j[videoTitle.toString()]!=null && j[videoTitle.toString()]<((currentPosition / totalDuration) * 100).toInt()?
          j[videoTitle.toString()] = ((currentPosition / totalDuration) * 100).toInt():null;
        }
      }
    }


    print("done");
    FirebaseFirestore.instance.collection("courseprogress").doc(_auth.currentUser!.uid).update({widget.courseName.toString():_getVideoPercentageList});


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
          print('this is -- $name');
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

  var dataa;
  var curriculum1;

/*-------------- Video Percentage Srinivas Code ------------- */

  var _initialVideoPercentageList = {};
  var _getVideoPercentageList;

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
            .set({
          widget.courseName.toString():
          _initialVideoPercentageList[widget.courseName.toString()],"email":_auth.currentUser!.email.toString()
        });
        _getVideoPercentageList =
        _initialVideoPercentageList[widget.courseName.toString()];
      }
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

  updateCourseCompletionPercentage(videoPercentageListUpdate) async {
    // await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).update({
    //   courseName : videoPercentageListUpdate,
    // }).then((value) => print(videoPercentageListUpdate)).catchError((error) => print('dipen = $error'));
    // print('I am uid = ${FirebaseAuth.instance.currentUser!.uid}');
    print("Videosssssssssssss ${videoPercentageList.length}");
    int total = 0;
    int count = 0;
    if (videoPercentageListUpdate.length != 0) {
      print("ppop = ${videoPercentageListUpdate}");
      for (int i = 0; i < videoPercentageListUpdate.length; i++) {
        print("999999999999");
        print("dddddddddd ${videoPercentageListUpdate[i].toString()}");
        for (int j = 0;
        j < videoPercentageListUpdate[i][sectionName[i]]!.length;
        j++) {
          print("lllllllllllllllllllllllll");
          for (var kv
          in videoPercentageListUpdate[i][sectionName[i]]![j].entries) {
            print("ppppppppppppppppppppppppppp");
            print(kv.value);
            total += int.parse(kv.value.toString());
            count += 1;
          }
        }
      }
    }

    videoPercentageListUpdate != null
        ? await FirebaseFirestore.instance
        .collection('courseprogress')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      print('srinivas ${value.data().toString()}');
      if (value.exists && videoPercentageListUpdate.length != 0) {
        await FirebaseFirestore.instance
            .collection('courseprogress')
            .doc(_auth.currentUser!.uid)
            .update({
          courseName: videoPercentageListUpdate,
          'email': _auth.currentUser!.email,
          courseName.toString() + "percentage":
          total != 0 && count != 0 ? total / count : 0
        }).catchError((onError) {
          print('srinnn = $onError');
        });
      } else {
        videoPercentageListUpdate.length != 0
            ? await FirebaseFirestore.instance
            .collection('courseprogress')
            .doc(_auth.currentUser!.uid)
            .set({
          courseName: videoPercentageListUpdate,
          'email': FirebaseAuth.instance.currentUser!.email,
          courseName.toString() + "percentage":
          total != 0 && count != 0 ? (total / count).toInt() : 0
        })
            : null;
      }
    }).catchError((onError) {
      print('srinu $onError');
    })
        : null;
  }

  @override
  void dispose() {
    super.dispose();
    AutoOrientation.portraitUpMode();
    _disposed = true;
    _videoController!.dispose();
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


  @override
  void initState() {
    html.window.document.onContextMenu.listen((evt) => evt.preventDefault());
    VideoScreen.currentSpeed.value = 1.0;
    getUserRole();
    getProgressData();
    getpathway(widget.courseName);
    Future.delayed(Duration(milliseconds: 500), () {
      getFirstVideo();
    });
    super.initState();
  }

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
    initializeVidController(
        list[0]["videos"][0]["url"].toString(),
        list[0]["videos"][0]["name"].toString(),
        list[0]["modulename"].toString());
  }

  bool menuClicked = false;
  String solutionUrl = '';
  String assignmentUrl = '';
  int? currentIndex;

  @override
  Widget build(BuildContext context) {
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
                            Navigator.of(context).pop();
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
                                            _videoController!,),
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
  String selectedSection = '';
  int? selectedIndexOfVideo;
  String? selectedVideoIndexName;
  String? videoTitle;
  List<dynamic> dataSetUrl = [];
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
            listOfSectionData = snapshot.data["curriculum1"];
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
                                      subIndex != null &&
                                          subIndex == subsectionIndex &&
                                          index == sectionIndex
                                          ? Draggable(
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
                                      )
                                          : DragTarget<int>(
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
                                                          listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["dataset"];
                                                        });
                                                    print(
                                                        "Eagle");
                                                  }

                                                },
                                                child: Container(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                        listOfSectionData[
                                                        widget
                                                            .courseName]
                                                        [
                                                        sectionIndex]
                                                        ["videos"][subsectionIndex]["type"]=="video"?60:80,
                                                        top: 15,
                                                        bottom: 15),
                                                    child: Align(
                                                      alignment: Alignment
                                                          .centerLeft,
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
                                                          Expanded(
                                                            child: Text(
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
                                                                  .toString(),style: TextStyle(overflow: TextOverflow.ellipsis),),
                                                          )
                                                        ],
                                                      ),
                                                    ))),
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

class videoNameClass extends StatelessWidget {
  final videoController;
  final String? videoName;
  videoNameClass({Key? key, this.videoController, this.videoName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: VideoPlayer(
          videoController,),
      ),
    );
  }
}
