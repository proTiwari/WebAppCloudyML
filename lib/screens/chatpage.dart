import 'dart:convert';
import 'dart:async';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:audioplayers/audioplayers.dart';

import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
//import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../Services/local_notificationservice.dart';
import 'getunread.dart';
import 'utils.dart';
import 'dart:io';
import 'dart:js' as js;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:html' as html;
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:record/record.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ChatPage extends StatefulWidget {
//  const ChatPage({Key key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

final List<String> items = List.generate(20, (index) => 'Item ${index + 1}');
Future<void> handlePasteEvent() async {
  final data = await html.window.navigator.clipboard!.read();
  if (data != null && data.files != null && data.files!.isNotEmpty) {
    for (final file in data.files!) {
      if (file.type.startsWith('image/')) {
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        await reader.onLoad.first;

        final pickedImage = XFile(reader.result as String);

        // Upload the image to Firebase Storage
        final imageReference =
            firebase_storage.FirebaseStorage.instance.ref().child(
                  'chats/${DateTime.now().millisecondsSinceEpoch}.png',
                );
        final uploadTask = imageReference.putFile(File(pickedImage.path!));
        final snapshot = await uploadTask;
        final imageUrl = await snapshot.ref.getDownloadURL();

        // Save the image URL to Firestore
        FirebaseFirestore.instance.collection('chats').add({
          'imageUrl': imageUrl,
          'timestamp': Timestamp.now(),
        });
      }
    }
  }
}

class _ChatPageState extends State<ChatPage> {
  final GetUnread unread = GetUnread();
  final _textController = TextEditingController();
  bool _isRecording = false;
  final FocusNode _focusNode = FocusNode();
  String id = FirebaseAuth.instance.currentUser!.uid;
  ScrollController _scrollController = ScrollController();
  String? idcurr;
  TextEditingController _searchController = TextEditingController();
  String namecurrent =
      FirebaseAuth.instance.currentUser!.displayName.toString().split(" ")[0];
  String selectedTileIndex = "";
  String name = "";
  String time = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? _selectedFile;
  String? _downloadUrl;
  //FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  //final _textController = TextEditingController();
  //late IO.Socket _socket;
  Record record = Record();
  Directory? appStorage;
  // bool _isRecording = false;
  //FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  String _audioPath = 'path/to/audio/file.mp3';
  final _firebaseStorage = FirebaseStorage.instance;

  File? pickedFile;

  String? pickedFileName;
  bool isLoading = false;
  //TextEditingController _searchController = TextEditingController();
  String role = "";
  List<dynamic> coursecode = [];
  List<String> coursename = [];
  List<String> cname = [];
  //List<DateTime> time = [];
  Set<String> _updatedDocuments = {};
  Set<String> newdocuments = {};

  //String? pickedFileName;
  void _getAppStorageDir() async {
    appStorage = await getApplicationDocumentsDirectory();
  }

  Future<void> _startRecording() async {
    _getAppStorageDir();
    print("REcording....");
    if (await Record().hasPermission()) {
      setState(() {
        _isRecording = true;
      });

      await record.start(
        path: appStorage!.path.toString() +
            "/audio_${DateTime.now().millisecondsSinceEpoch}.m4a",
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );
    }
  }

  void _stopRecording() async {
    if (_isRecording) {
      var filePath = await Record().stop();
      print("The audio file path is $filePath");
      pickedFile = File(filePath!);
      pickedFileName = filePath.split("/").last;
      setState(() {
        _isRecording = false;
      });

      _uploadRecording(pickedFile!);
    }
  }

  void _cancelRecording() async {
    if (_isRecording) {
      var filePath = await Record().stop();
      var recordedFile = File(filePath.toString());
      if (await recordedFile.exists()) {
        await recordedFile.delete();
      }
      setState(() {
        _isRecording = false;
      });
    }
  }

  Widget _buildMicButton() {
    return IconButton(
      icon: Icon(Icons.mic_none_rounded, color: Colors.purple),
      onPressed: _startRecording,
    );
  }

  void _onSearchTextChanged(String searchText) {
    setState(() {
      if (searchText != "") {
        _collectionStream = FirebaseFirestore.instance
            .collection('groups')
            .where('student_name', isEqualTo: searchText)
            .orderBy('time', descending: true)
            .limit(500)
            .snapshots();
      } else {
        _collectionStream = FirebaseFirestore.instance
            .collection('groups')
            .orderBy('time', descending: true)
            .limit(500)
            .snapshots();
      }
    });
  }

  bool isURL(String string) {
    // Regular expression pattern to match a URL
    // Regular expression pattern to match a URL
    return (string.contains('http', 0) ||
        string.contains('www') ||
        string.contains('https', 0) ||
        string.contains('.com'));
  }

  //FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void _sendMessage() async {
    if (_textController.text.isNotEmpty) {
      String data = _textController.text;

      _focusNode.unfocus();

      final time = DateTime.now();
      updatelast();
      updatetime(time);
      final post = await _firestore
          .collection("groups")
          .doc(idcurr)
          .collection("chats")
          .add({
        'message': _textController.text,
        'role': "mentor",
        'sendBy': namecurrent,
        'time': time,
        'type': 'text'
      });
    }
    _textController.clear();
  }

  Future<void> _pickFilePhoto() async {
    print("good");
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept =
        'image/*'; // Specify the accepted file types (e.g., images)
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final List<html.File> files = uploadInput.files!;
      if (files.isNotEmpty) {
        final html.File file = files.first;
        final html.FileReader reader = html.FileReader();
        reader.readAsDataUrl(file);

        reader.onLoadEnd.listen((e) async {
          final String? fileDataUrl = reader.result as String?;
          if (fileDataUrl != null) {
            // Convert the data URL to bytes
            final commaIndex = fileDataUrl.indexOf(',');
            if (commaIndex != -1) {
              final String base64Data = fileDataUrl.substring(commaIndex + 1);
              final Uint8List fileBytes = base64Decode(base64Data);

              final fileName = file.name;
              // Upload the file to Firebase Storage
              final storageRef =
                  FirebaseStorage.instance.ref().child('files/$fileName');
              final UploadTask uploadTask = storageRef.putData(
                  fileBytes, SettableMetadata(contentType: file.type));
              final TaskSnapshot snapshot = await uploadTask;
              final downloadUrl = await snapshot.ref.getDownloadURL();
              final time = DateTime.now();
              // Add message to Firestore
              updatelast();
              updatetime(time);

              _firestore
                  .collection("groups")
                  .doc(idcurr)
                  .collection("chats")
                  .add({
                'message': fileName,
                'role': "mentor",
                'sendBy': namecurrent,
                'link': downloadUrl,
                'time': time,
                'type': 'image'
              });
            }
          }
        });
      }
    });
  }

  Future<void> _pickFileRecord() async {
    final imagePicker = ImagePicker();

    final pickedFile = await imagePicker.getVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });

      // Upload the file to Firebase Storage
      Reference ref =
          FirebaseStorage.instance.ref().child('files/${_selectedFile!.path}');
      UploadTask uploadTask = ref.putFile(_selectedFile!);
      TaskSnapshot snapshot = await uploadTask;
      _downloadUrl = await snapshot.ref.getDownloadURL();
      final time = DateTime.now();
      // Add message to Firestore
      updatelast();
      updatetime(time);

      _firestore.collection("groups").doc(idcurr).collection("chats").add({
        'message': _selectedFile!.path.split('/').last,
        'role': "mentor",
        'sendBy': namecurrent,
        'link': _downloadUrl,
        'time': time,
        'type': 'video'
      });
    }
  }

  Future<void> _pickFilevideo() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept =
        'video/*'; // Specify the accepted file types (e.g., videos)
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final List<html.File> files = uploadInput.files!;
      if (files.isNotEmpty) {
        final html.File file = files.first;
        final html.FileReader reader = html.FileReader();
        reader.readAsDataUrl(file);

        reader.onLoadEnd.listen((e) async {
          final String? fileDataUrl = reader.result as String?;
          if (fileDataUrl != null) {
            // Convert the data URL to bytes
            final commaIndex = fileDataUrl.indexOf(',');
            if (commaIndex != -1) {
              final String base64Data = fileDataUrl.substring(commaIndex + 1);
              final Uint8List fileBytes = base64Decode(base64Data);

              final fileName = file.name;
              // Upload the file to Firebase Storage
              final storageRef =
                  FirebaseStorage.instance.ref().child('files/$fileName');
              final UploadTask uploadTask = storageRef.putData(
                  fileBytes, SettableMetadata(contentType: file.type));
              final TaskSnapshot snapshot = await uploadTask;
              final downloadUrl = await snapshot.ref.getDownloadURL();
              final time = DateTime.now();
              // Add message to Firestore
              updatelast();
              updatetime(time);

              _firestore
                  .collection("groups")
                  .doc(idcurr)
                  .collection("chats")
                  .add({
                'message': fileName,
                'role': "mentor",
                'sendBy': namecurrent,
                'link': downloadUrl,
                'time': time,
                'type': 'video'
              });
            }
          }
        });
      }
    });
  }

  html.File? _selectedFile1;
  Future<void> _pickFileany() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.accept =
        'application/pdf'; // Modify the accepted file types as needed
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final List<html.File>? files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final html.File file = files.first;
        final html.FileReader reader = html.FileReader();
        reader.readAsArrayBuffer(file);

        reader.onLoadEnd.listen((e) async {
          final Uint8List? fileBytes = reader.result as Uint8List?;
          if (fileBytes != null) {
            final fileName = file.name;
            // Upload the file to Firebase Storage
            final storageRef =
                FirebaseStorage.instance.ref().child('files/$fileName');
            final UploadTask uploadTask = storageRef.putData(
                fileBytes,
                SettableMetadata(
                    contentType:
                        'application/pdf')); // Modify the content type as needed
            final TaskSnapshot snapshot = await uploadTask;
            final downloadUrl = await snapshot.ref.getDownloadURL();
            final time = DateTime.now();
            // Add message to Firestore
            updatelast();
            updatetime(time);

            _firestore
                .collection("groups")
                .doc(idcurr)
                .collection("chats")
                .add({
              'message': fileName,
              'role': "mentor",
              'sendBy': namecurrent,
              'link': downloadUrl,
              'time': time,
              'type': 'file'
            });
          }
        });
      }
    });
  }

  bool notificationShown = false;

  void displayWebNotification(String title, String body, String icon) {
    if (!notificationShown && html.Notification.supported) {
      html.Notification.requestPermission().then((permission) {
        if (permission == 'granted') {
          html.Notification(title, body: body, icon: icon);
          notificationShown = true;
        }
      });
    }
  }

  Future<String> _uploadRecording(File recording) async {
    final storageRef =
        _firebaseStorage.ref().child('audio/${DateTime.now()}.mp3');

    try {
      await storageRef.putFile(recording);
      final downloadUrl = await storageRef.getDownloadURL();
      print('File uploaded: $downloadUrl');
      final time = DateTime.now();
      updatelast();
      updatetime(time);
      _firestore.collection("groups").doc(idcurr).collection("chats").add({
        'message': '${DateTime.now()}.mp3',
        'role': "mentor",
        'sendBy': namecurrent,
        'link': downloadUrl,
        'time': time,
        'type': 'audio'
      });

      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      throw 'Failed to upload recording';
    }
  }

  void updatetime(DateTime time) {
    _firestore.collection("groups").doc(idcurr).update({'time': time});
  }

  void updatelast() {
    _firestore
        .collection("groups")
        .doc(idcurr)
        .update({'last': FirebaseAuth.instance.currentUser!.uid.toString()});
  }

  Widget _buildStopRecordingButton() {
    return IconButton(
      icon: Icon(Icons.stop_rounded, color: Colors.red),
      onPressed: _stopRecording,
    );
  }

  Widget _buildCancelButton() {
    return IconButton(
      icon: Icon(Icons.cancel_rounded, color: Colors.grey),
      onPressed: _cancelRecording,
    );
  }

  Stream<QuerySnapshot> _collectionStream = FirebaseFirestore.instance
      .collection('groups')
      .orderBy('time', descending: true)
      .limit(500)
      .snapshots();
  Stream<QuerySnapshot> _collectionStream1 = FirebaseFirestore.instance
      .collection('groups')
      .where('student_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy('time', descending: true)
      .limit(500)
      .snapshots();
  Stream<QuerySnapshot>? _messageStream;
  void listenToFirestoreChanges() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
// savedTime = prefs.getInt('savedTime') ?? 0;

    final snapshot = await _firestore
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final data = snapshot.data();
    role = data!["role"];
    //   if (role != "student") {
    //  _filteredStream = _collectionStream;
    namecurrent = data!["name"].split(" ")[0];
    ;

    _updatedDocuments = Set<String>();
    role == "student"
        ? _collectionStream1.listen((snapshot) async {
            snapshot.docChanges.forEach((change) {
              if (change.type == DocumentChangeType.modified) {
                DocumentSnapshot changedDoc = change.doc;
                Map<String, dynamic> changedData =
                    changedDoc.data() as Map<String, dynamic>;
                if (changedData.containsKey("last")) {
                  if (change.doc["last"].toString() ==
                      FirebaseAuth.instance.currentUser!.uid.toString()) {
                  } else {
                    _updatedDocuments.add(change.doc.id);
                    print(_updatedDocuments);
                    displayWebNotification(
                        "New Message",
                        "${change.doc["student_name"]} has a new message",
                        "assets/icon.jpeg");
                  }
                  notificationShown = true;
                } else {
                  _updatedDocuments.add(change.doc.id);
                  print(_updatedDocuments);
                }
              } else if (change.type == DocumentChangeType.added) {
                newdocuments.add(change.doc.id);
              }
            });
            if (_updatedDocuments.isNotEmpty) {
              await unread.saveunread(_updatedDocuments);
            }
          })
        : _collectionStream.listen((snapshot) async {
            snapshot.docChanges.forEach((change) {
              if (change.type == DocumentChangeType.modified) {
                DocumentSnapshot changedDoc = change.doc;
                Map<String, dynamic> changedData =
                    changedDoc.data() as Map<String, dynamic>;
                if (changedData.containsKey("last")) {
                  if (change.doc["last"].toString() ==
                      FirebaseAuth.instance.currentUser!.uid.toString()) {
                  } else {
                    _updatedDocuments.add(change.doc.id);
                    print(_updatedDocuments);
                    displayWebNotification(
                        "New Message",
                        "${change.doc["student_name"]} has a new message",
                        "assets/icon.jpeg");
                  }
                  notificationShown = true;
                } else {
                  _updatedDocuments.add(change.doc.id);
                  print(_updatedDocuments);
                }
              } else if (change.type == DocumentChangeType.added) {
                newdocuments.add(change.doc.id);
              }
            });
            if (_updatedDocuments.isNotEmpty) {
              await unread.saveunread(_updatedDocuments);
            }
          });

    setState(() {
      isLoading = false;
    });
  }

  void _selectimage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //   ListTile(
              //   leading: Icon(Icons.image),
              //   title: Text('Click Photo'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     _pickFilePhoto();
              //   },
              // ),
              //   ListTile(
              //   leading: Icon(Icons.image),
              //   title: Text('Record Video'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     _pickFileRecord();
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Select Image'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFilePhoto();
                },
              ),
              ListTile(
                leading: Icon(Icons.video_library),
                title: Text('Select Video'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFilevideo();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future readunread() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    if (_prefs.containsKey("myList")) {
      var myList = _prefs.getStringList('myList');
      //return cache;
    } else {
      // return null;
    }
  }

  Future<String> loadrole() async {
    final snapshot = await _firestore
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final data = snapshot.data();
    role = data!["role"];
    // name = data["name"].toString().split(" ")[0];
    print(FirebaseAuth.instance.currentUser!.uid);
    print(role);
    // print(name);
    return role;
  }

  List<String>? myList;
  @override
  void initState() {
    super.initState();
    loadrole();
    //Configuration.docid = "";
    print("iwejoiweofwoiefwf");
    readunread();
    if (myList != null) {
      _updatedDocuments = myList!.toSet();
    } else {
      _updatedDocuments = Set<String>();
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      listenToFirestoreChanges();
    });
  }

  Future<void> _pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });

      // Upload the file to Firebase Storage
      Reference ref =
          FirebaseStorage.instance.ref().child('files/${_selectedFile!.path}');
      UploadTask uploadTask = ref.putFile(_selectedFile!);
      TaskSnapshot snapshot = await uploadTask;
      _downloadUrl = await snapshot.ref.getDownloadURL();
      final time = DateTime.now();
      // Add message to Firestore
      updatelast();
      updatetime(time);

      _firestore.collection("groups").doc(idcurr).collection("chats").add({
        'message': _selectedFile!.path.split('/').last,
        'role': "mentor",
        'sendBy': namecurrent,
        'link': _downloadUrl,
        'time': time,
        'type': 'image'
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1280;
    double fem = 100.w / baseWidth;
    double ffem = fem * 0.97;
    DateTime now = DateTime.now();
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Row(
          children: [
            Container(
              width: 30.w,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    width: double.infinity,
                    height: 10.h,
                    child: Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 0, left: 1, right: 1),
                          child: Container(
                            child: Image.asset(
                              'assets/page-1/images/vector.png',
                              height: 5.h,
                              width: 3.h,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 2.w, right: 0.5.w),
                          child: Container(
                            width: 22.w,
                            height: 4.h,
                            padding: EdgeInsets.only(left: 1.w),
                            decoration: BoxDecoration(
                              color: Color(0xfff5f5f5),
                              borderRadius: BorderRadius.circular(22.h),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Image.asset(
                                    'assets/page-1/images/search.png',
                                    height: 5.h,
                                    width: 3.h,
                                  ),
                                ),
                                SizedBox(width: 1.w),
                                Expanded(
                                  child: TextField(
                                    onChanged: _onSearchTextChanged,
                                    decoration: InputDecoration(
                                      hintText: "Search",
                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff707991),
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
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                    stream: role == "student"
                        ? _collectionStream1
                        : _collectionStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child:
                                Image.asset("assets/page-1/images/loader.gif"),
                          );
                        default:
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              DocumentSnapshot document =
                                  snapshot.data!.docs[index];

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _messageStream = FirebaseFirestore.instance
                                        .collection("groups")
                                        .doc(document.id)
                                        .collection("chats")
                                        .orderBy('time', descending: true)
                                        .snapshots();
                                    selectedTileIndex = document.id;
                                    idcurr = document.id;
                                    name = document["name"].toString();
                                    time = document["student_name"].toString();
                                    if (_updatedDocuments
                                        .contains(document.id)) {
                                      setState(() {
                                        _updatedDocuments.remove(document.id);
                                      });
                                    }
                                  });
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 0.w, right: 0.w),
                                  child: Container(
                                    width: 30.w,
                                    padding: EdgeInsets.fromLTRB(
                                        1.w, 0.2.h, 0.w, 0.2.h),
                                    color: _updatedDocuments
                                            .contains(document.id)
                                        ? Color.fromARGB(255, 157, 239, 159)
                                        : selectedTileIndex == document.id
                                            ? Color.fromARGB(255, 237, 213, 248)
                                            : Colors.transparent,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0 * fem, 0 * fem, 2.h, 0 * fem),
                                          width: 4.w,
                                          height: 4.w,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100.sp),
                                            child: Image.asset(
                                              'assets/icon.jpeg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 23.w,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 16.w,
                                                      child: Text(
                                                        "${document["name"]}",
                                                        style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Color(0xff011627),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 1.w),
                                                      child: Text(
                                                        (document["time"]
                                                                        .toDate()
                                                                        .day ==
                                                                    now.day) &&
                                                                (document["time"]
                                                                        .toDate()
                                                                        .month ==
                                                                    now
                                                                        .month) &&
                                                                (document["time"]
                                                                        .toDate()
                                                                        .year ==
                                                                    now.year)
                                                            ? "Today"
                                                            : (document["time"]
                                                                            .toDate()
                                                                            .day ==
                                                                        (now.day -
                                                                            1)) &&
                                                                    (document["time"]
                                                                            .toDate()
                                                                            .month ==
                                                                        now
                                                                            .month) &&
                                                                    (document["time"]
                                                                            .toDate()
                                                                            .year ==
                                                                        now.year)
                                                                ? "Yesterday"
                                                                : "${document["time"].toDate().day}/${document["time"].toDate().month}/${document["time"].toDate().year}",
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Color(0xff707991),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "${document["student_name"]}",
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xff707991),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                      }
                    },
                  ))
                ],
              ),
            ),
            Container(
              width: 70.w,
              child: Column(
                children: [
                  name == ""
                      ? Container()
                      : Container(
                          width: double.infinity,
                          height: 10.h,
                          child: Container(
                            // topbartFx (1:345)
                            padding: EdgeInsets.fromLTRB(2.w, 1.h, 2.w, 0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffd9dce0)),
                              color: Color(0xffffffff),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  // otherusera8n (1:346)
                                  padding: EdgeInsets.fromLTRB(0, 0, 2.h, 0),
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 0.5.h),
                                        child: Container(
                                          // avatarJ4n (1:347)
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 1.w, 0),
                                          width: 5.w,
                                          height: 5.w,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                100 * fem),
                                            child: Image.asset(
                                              'assets/icon.jpeg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // textszCW (1:348)
                                        height: double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              // datascienceanalyticswdY (1:350)
                                              margin: EdgeInsets.fromLTRB(
                                                  0 * fem,
                                                  0 * fem,
                                                  0 * fem,
                                                  4 * fem),
                                              child: Text(
                                                '$name',
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 16 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.25 * ffem / fem,
                                                  color: Color(0xff011627),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              // lastmessage5minsagoeXx (1:352)
                                              '$time',
                                              style: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 14 * ffem,
                                                fontWeight: FontWeight.w400,
                                                height:
                                                    1.2857142857 * ffem / fem,
                                                color: Color(0xff707991),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 8 * fem,
                                ),
                                SizedBox(
                                  width: 8 * fem,
                                ),
                                Container(
                                  // callicon5NN (1:356)
                                  width: 40 * fem,
                                  height: 40 * fem,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(100 * fem),
                                  ),
                                ),
                                SizedBox(
                                  width: 8 * fem,
                                )
                              ],
                            ),
                          ),
                        ),
                  name == ""
                      ? Container(
                          width: 70.w,
                          height: 100.h,
                          color: Color(0xFFB27ECA),
                          //  height: double.infinity,
                          child: Image.asset(
                            "assets/page-1/images/bg-1.png",
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          width: 70.w,
                          height: 90.h,
                          decoration: BoxDecoration(
                            color: Color(0xFFB27ECA),
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/page-1/images/bg-1.png"), // Replace with your image path
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 70.w,
                                height: 75.h,
                                child: Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: _messageStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        print("snapshot.error");
                                        return CircularProgressIndicator(
                                          color: Colors.yellow,
                                        );
                                      }

                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      final messages = snapshot.data!.docs;
                                      print(
                                          'Number of documents: ${messages.length}');
                                      List<MessageBubble> messageBubbles = [];
                                      for (var message in messages) {
                                        final messageText = message['message'];
                                        final messageSender = message['sendBy'];
                                        final messageType = message['type'];
                                        final messagetime = message['time'];
                                        final currentUser = id;
                                        final link = messageType == "image" ||
                                                messageType == "audio" ||
                                                messageType == "video" ||
                                                messageType == "file"
                                            ? message["link"]
                                            : "";

                                        final messageBubble = MessageBubble(
                                          message: messageText,
                                          sender: messageSender,
                                          timestamp: messagetime,
                                          isMe: messageSender == namecurrent,
                                          link: link,
                                          type: messageType,
                                          isURL: isURL(messageText),
                                        );
                                        messageBubbles.add(messageBubble);
                                      }
                                      return Container(
                                        height: 80.h,
                                        width: 65.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(40.sp),
                                            topRight: Radius.circular(40.sp),
                                          ),
                                          // color: Colors.white,
                                        ),
                                        child: ListView(
                                          reverse: true,
                                          children: messageBubbles,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: EdgeInsets.all(1.h),
                                child: Container(
                                  height: 8.h,
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 1.w,
                                      ),
                                      // _isRecording
                                      //     ? _buildStopRecordingButton()
                                      //     : _buildMicButton(),
                                      _isRecording
                                          ? _buildCancelButton()
                                          : Expanded(
                                              // child: RawKeyboardListener(
                                              //   focusNode: FocusNode(),
                                              //   onKey: (RawKeyEvent event) {
                                              //     if (event.isKeyPressed(
                                              //             LogicalKeyboardKey
                                              //                 .controlLeft) &&
                                              //         event.isKeyPressed(
                                              //             LogicalKeyboardKey
                                              //                 .keyV)) {
                                              //       uploadImageFromClipboard();
                                              //     }
                                              //   },
                                              //   child:
                                              child: TextField(
                                                maxLines: 1,
                                                controller: _textController,
                                                onTap: () {
                                                  _focusNode.requestFocus();
                                                },
                                                onTapOutside: (event) {
                                                  _focusNode.unfocus();
                                                },
                                                focusNode: _focusNode,
                                                decoration: InputDecoration(
                                                  hintText: 'Type a message...',
                                                ),
                                              ),
                                              // ),
                                            ),

                                      _isRecording
                                          ? SizedBox()
                                          : Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                      Icons.attachment_outlined,
                                                      color: Colors.purple),
                                                  onPressed: _pickFileany,
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                      Icons.add_a_photo_rounded,
                                                      color: Colors.purple),
                                                  onPressed: _selectimage,
                                                ),
                                              ],
                                            ),
                                      _isRecording
                                          ? SizedBox()
                                          : IconButton(
                                              icon: Icon(Icons.send,
                                                  color: Colors.purple),
                                              onPressed: _sendMessage,
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatefulWidget {
  final String message;
  final String sender;
  final bool isMe;
  final String type;
  final Timestamp timestamp;
  final String link;
  final bool isURL;

  MessageBubble(
      {required this.message,
      required this.sender,
      required this.isMe,
      required this.type,
      required this.link,
      required this.timestamp,
      required this.isURL});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  // bool _isPlaying = false; // <-- track whether the audio is playing
  // AudioPlayer _audioPlayer =
  //     AudioPlayer(); // <-- create an instance of AudioPlayer
  void copyText(String text) async {
    FlutterClipboard.copy(text).then((value) => print('copied'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Text copied to clipboard')),
    );
  }

  bool isurl = false;
  bool isURL(String string) {
    return (string.contains('http', 0) ||
        string.contains('www') ||
        string.contains('https', 0) ||
        string.contains('.com'));
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    super.dispose();
    // _audioPlayer.dispose();
    if (widget.type == "video") {
      _chewieController.dispose();
      _videoPlayerController.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    isURL(widget.message);
    if (widget.type == "video") {
      _videoPlayerController = VideoPlayerController.network(widget.link);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoInitialize: true,
        looping: false,
        autoPlay: false,
      );
    }
  }

  Future<void> _downloadAndOpenVideo(String url) async {
    final anchorElement = html.AnchorElement(href: url);

    // Set the download attribute to specify the filename
    anchorElement.download = '';

    // Simulate a click on the anchor element to trigger the download
    anchorElement.click();
  }

  Future<void> downloadAndOpenFile(String url, String fileName) async {
    final anchorElement = html.AnchorElement(href: url);

    // Set the download attribute to specify the filename
    anchorElement.download = '';

    // Simulate a click on the anchor element to trigger the download
    anchorElement.click();
  }

  @override
  Widget build(BuildContext context) {
    void _showMaximizedImage(url) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: InteractiveViewer(
              boundaryMargin: EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4.0,
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ).then((value) {
        setState(() {
          //  _isMaximized = false;
        });
      });
    }

    return Column(
      crossAxisAlignment:
          widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          "${DateFormat('MMMM d, y').format(widget.timestamp.toDate())}",
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
        Row(
          mainAxisAlignment:
              widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: widget.isMe
                    ? Color.fromARGB(255, 254, 161, 84)
                    : Color.fromRGBO(252, 207, 45, 0.988),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft:
                      widget.isMe ? Radius.circular(12) : Radius.circular(0),
                  bottomRight:
                      widget.isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              constraints: BoxConstraints(maxWidth: 300),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                crossAxisAlignment: widget.isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.sender,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  widget.type == 'text'
                      ? widget.isURL
                          ? Column(
                              children: [
                                // Container(
                                //   height: 300,
                                //   child: HtmlElementView(
                                //     viewType: 'webview-type',
                                //     key: UniqueKey(),
                                //   ),
                                // ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          if (widget.message
                                              .contains('https://')) {
                                            html.window
                                                .open(widget.message, '_blank');
                                          } else {
                                            html.window.open(
                                                'https://' + widget.message,
                                                '_blank');
                                          }
                                        },
                                        child: Text(
                                          widget.message,
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.copy),
                                      onPressed: () {
                                        copyText(widget.message);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.message,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  iconSize: 10,
                                  icon: Icon(Icons.copy),
                                  onPressed: () {
                                    copyText(widget.message);
                                  },
                                ),
                              ],
                            )
                      : widget.type == 'image'
                          ? Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      _showMaximizedImage(widget.link);
                                    });
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: widget.link,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                TextButton(
                                  child: Text('View in Gallery'),
                                  onPressed: () {
                                    downloadAndOpenFile(
                                        widget.link, widget.message);
                                  },
                                ),
                              ],
                            )
                          : widget.type == 'audio'
                              ? Container(
                                  width: 300,
                                  child:
                                      AudioPlayerWidget(audioUrl: widget.link),
                                )
                              : widget.type == 'video'
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: 300,
                                          width: 314,
                                          child: Chewie(
                                            controller: _chewieController,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        TextButton(
                                          child: Text('View in Gallery'),
                                          onPressed: () {
                                            _downloadAndOpenVideo(widget.link);
                                          },
                                        ),
                                      ],
                                    )
                                  : SizedBox(
                                      // height: 20,
                                      //  width: 50,
                                      child: TextButton(
                                        child: Text(
                                          '${widget.message} - View file',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        onPressed: () {
                                          downloadAndOpenFile(
                                              widget.link, widget.message);
                                        },
                                      ),
                                    ),
                  SizedBox(height: 4),
                  Text(
                    "${DateFormat('h:mm a').format(widget.timestamp.toDate())}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({Key? key, required this.audioUrl}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  Timer? _positionTimer;
  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer();
  Duration _totalDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;
  bool _isCompleted = false;
  StreamSubscription<Duration>? _positionSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _initializeAudioPlayer();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _initializeAudioPlayer() async {
    await _audioPlayer.open(Audio.network(widget.audioUrl), autoStart: false);

    _audioPlayer.current.listen((Playing playing) {
      setState(() {
        _totalDuration = playing.audio.duration ?? Duration.zero;
        _positionSubscription?.cancel(); // Cancel any existing subscription
        _positionSubscription = _audioPlayer.currentPosition.listen((position) {
          setState(() {
            _currentPosition = position;
          });
        });
      });
    } as void Function(Playing? event)?);

    _audioPlayer.isPlaying.listen((isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
        if (_isPlaying && _isCompleted) {
          _isCompleted = false;
          _audioPlayer.seek(Duration.zero);
        }
      });
    });
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    setState(() {
      _isCompleted = true;
      _currentPosition = Duration.zero;
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: _togglePlayback,
                  ),
                  IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: _stop,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_formatDuration(_currentPosition)),
                  SizedBox(width: 10),
                  Text('/'),
                  SizedBox(width: 10),
                  Text(_formatDuration(_totalDuration)),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: _totalDuration != Duration.zero
                    ? _currentPosition.inMilliseconds /
                        _totalDuration.inMilliseconds
                    : 0.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                backgroundColor: Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
