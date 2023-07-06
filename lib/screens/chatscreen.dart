import 'package:cloudyml_app2/screens/config.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
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
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

//import 'package:flutter_sound/flutter_sound.dart';

class ChatScreen extends StatefulWidget {
  final String id;
  final String groupId;
  final String role;
  final String name;
  final String icon;
  final String title;
  // final String number;

  ChatScreen({
    required this.id,
    required this.groupId,
    required this.role,
    required this.name,
    required this.title,
    required this.icon,
    //  required this.number ,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FocusNode _focusNode = FocusNode();
  File? _selectedFile;
  String? _downloadUrl;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _textController = TextEditingController();
  late IO.Socket _socket;
  Record record = Record();
  Directory? appStorage;
  bool _isRecording = false;
  //FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  String _audioPath = 'path/to/audio/file.mp3';
  final _firebaseStorage = FirebaseStorage.instance;

  File? pickedFile;

  String? pickedFileName;
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

  void updatetime(DateTime time) {
    _firestore.collection("groups").doc(widget.groupId).update({'time': time});
  }

  void updatelast() {
    _firestore
        .collection("groups")
        .doc(widget.groupId)
        .update({'last': FirebaseAuth.instance.currentUser!.uid.toString()});
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
      _firestore
          .collection("groups")
          .doc(widget.groupId)
          .collection("chats")
          .add({
        'message': '${DateTime.now()}.mp3',
        'role': widget.role,
        'sendBy': widget.name,
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

  Widget _buildMicButton() {
    return IconButton(
      icon: Icon(Icons.mic_none_rounded, color: Colors.purple),
      onPressed: _startRecording,
    );
  }

  bool isURL(String string) {
    // Regular expression pattern to match a URL
    // Regular expression pattern to match a URL
      return (string.contains('http',0) ||string.contains('www')||string.contains('https',0) ||string.contains('.com'));
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

  Widget _buildAudioPlayer() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.play_arrow_rounded, color: Colors.purple),
          onPressed: () {
            // logic for playing the audio file
          },
        ),
        IconButton(
          icon: Icon(Icons.send, color: Colors.purple),
          onPressed: _sendMessage,
        ),
      ],
    );
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

      _firestore
          .collection("groups")
          .doc(widget.groupId)
          .collection("chats")
          .add({
        'message': _selectedFile!.path.split('/').last,
        'role': widget.role,
        'sendBy': widget.name,
        'link': _downloadUrl,
        'time': time,
        'type': 'image'
      });
    }
  }
Future<void> _pickFilePhoto() async {
  final imagePicker = ImagePicker();

  final pickedFile = await imagePicker.getImage(source: ImageSource.camera);
  if (pickedFile != null) {
    setState(() {
      _selectedFile = File(pickedFile.path);
    });

    // Upload the file to Firebase Storage
    Reference ref = FirebaseStorage.instance.ref().child('files/${_selectedFile!.path}');
    UploadTask uploadTask = ref.putFile(_selectedFile!);
    TaskSnapshot snapshot = await uploadTask;
    _downloadUrl = await snapshot.ref.getDownloadURL();
    final time = DateTime.now();
    // Add message to Firestore
    updatelast();
    updatetime(time);

    _firestore.collection("groups").doc(widget.groupId).collection("chats").add({
      'message': _selectedFile!.path.split('/').last,
      'role': widget.role,
      'sendBy': widget.name,
      'link': _downloadUrl,
      'time': time,
      'type': 'image'
    });
  }
}
Future<void> _pickFileRecord() async {
  final imagePicker = ImagePicker();

  final pickedFile = await imagePicker.getVideo(source: ImageSource.camera);
  if (pickedFile != null) {
    setState(() {
      _selectedFile = File(pickedFile.path);
    });

    // Upload the file to Firebase Storage
    Reference ref = FirebaseStorage.instance.ref().child('files/${_selectedFile!.path}');
    UploadTask uploadTask = ref.putFile(_selectedFile!);
    TaskSnapshot snapshot = await uploadTask;
    _downloadUrl = await snapshot.ref.getDownloadURL();
    final time = DateTime.now();
    // Add message to Firestore
    updatelast();
    updatetime(time);

    _firestore.collection("groups").doc(widget.groupId).collection("chats").add({
      'message': _selectedFile!.path.split('/').last,
      'role': widget.role,
      'sendBy': widget.name,
      'link': _downloadUrl,
      'time': time,
      'type': 'video'
    });
  }
}
  Future<void> _pickFilevideo() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);

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

      _firestore
          .collection("groups")
          .doc(widget.groupId)
          .collection("chats")
          .add({
        'message': _selectedFile!.path.split('/').last,
        'role': widget.role,
        'sendBy': widget.name,
        'link': _downloadUrl,
        'time': time,
        'type': 'video'
      });
    }
  }

  Future<void> _pickFileany() async {
   FilePickerResult? result = await FilePicker.platform.pickFiles(
  type: FileType.custom,
  allowedExtensions: [
    'doc',
    'docx',
    'pdf',
    'txt',
    'ppt',
    'pptx',
    'xls',
    'xlsx',
    'csv',
    'tsv',
    'json',
    'xml',
    'yaml',
    'sql',
    'r',
    'py',
    'ipynb',
    'mp3',
    'wav',
    'flac',
    'ogg',
    'aac',
    'wma',
    'm4a',
    'opus',
    'mid',
    'amr',
    'aiff',
    'ape',
    'caf',
    'mka',
    'pcm',
    'ac3',
    'alac',
    'au',
    'dts',
    'eac3',
    'gsm',
    'mp1',
    'mp2',
    'mpa',
    'ra',
    'tta',
    'wv',
    'webm',
    '3ga',
    '3gpa',
    '3gp',
    'aif',
    'oga',
    'oma',
    'spx',
    'xmf',
    'mogg',
    'mod',
    'mo3',
    'mtm',
    'umx',
    'it',
    's3m',
    'xm',
    'sid',
  ],
);

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

      _firestore
          .collection("groups")
          .doc(widget.groupId)
          .collection("chats")
          .add({
        'message': _selectedFile!.path.split('/').last,
        'role': widget.role,
        'sendBy': widget.name,
        'link': _downloadUrl,
        'time': time,
        'type': 'file'
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _connectToServer();
    print(loadata());
  }

  @override
  void dispose() {
    // disconnect from the socket server
    Configuration.docid = '';
    _socket.disconnect();
    super.dispose();
  }

  void _connectToServer() {
    // _socket = IO.io(
    //   'https://13.233.244.122:3000/${widget.role}-namespace',
    //   IO.OptionBuilder().setTransports(['websocket']).build(),
    // );
    // _socket.onConnect((_) {
    //   print('Connected to server');
    //   _socket.emit('join', {
    //     'id': widget.id,
    //     'groupId': widget.groupId,
    //   });
    // });
    // _socket.on('messageFromClient', _handleNewMessage);
    //   _socket.onDisconnect((_) => print('Disconnected from server'));
  }

  void sendtext() {}
  void _handleNewMessage(data) {
    print('New Message Received: $data');
  }

  void _sendMessage() async {
    if (_textController.text.isNotEmpty) {
      String data = _textController.text;
      // _socket = await IO.io(
      //   'http://13.233.244.122:3000/${widget.role}-namespace',
      //   IO.OptionBuilder().setTransports(['websocket']).build(),
      // );
      // _socket.onConnect((_) {
      //   print('Connected to server');
      //   _socket.emit('join', {
      //     'id': widget.id,
      //     'groupId': widget.groupId,
      //   });
      // });
      _focusNode.unfocus();
      String id = widget.groupId; // mentor Id
      String student_id = widget.id;
      // here student_id will come from frontEnd  socket.handshake.auth.student_id4

      final time = DateTime.now();
      updatelast();
      updatetime(time);
      final post = await _firestore
          .collection("groups")
          .doc(id)
          .collection("chats")
          .add({
        'message': _textController.text,
        'role': widget.role,
        'sendBy': widget.name,
        'time': time,
        'type': 'text'
      });

      //   });
      // } else {}
      // _socket.emit('message', {
      //   'text': _textController.text,
      //   'sender': widget.id,
      //   'groupId': widget.groupId,
      // });
      _textController.clear();
    }
  }

  Stream<QuerySnapshot> loadata() {
    return FirebaseFirestore.instance
        .collection("groups")
        .doc(widget.groupId)
        .collection("chats")
        .orderBy('timestamp')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _collectionStream = FirebaseFirestore.instance
        .collection("groups")
        .doc(widget.groupId)
        .collection("chats")
        .orderBy('time', descending: true)
        .limit(100)
        .snapshots();
    return Scaffold(
      body: Stack(
        children: [
          Container(
              width: 100.w,
              child: Image.asset(
                "images/bgimg.png",
                fit: BoxFit.fitWidth,
              )),
          Padding(
            padding: EdgeInsets.only(top: 7.h, left: 6.w),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: SizedBox(
                    width: 15.w,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        weight: 500,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                CircleAvatar(
                  radius:22.sp,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: 20.sp,
                    backgroundImage: AssetImage("images/icon.jpeg"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w),
                  child: SizedBox(
                    width:55.w,
                    child: Text(
                      "${widget.title}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 6.0,
                            color: Color.fromARGB(100, 0, 0, 0),
                          ),
                        ],
                        fontFamily: 'Inter',
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Container(
              width: 100.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.sp),
                    topRight: Radius.circular(40.sp)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _collectionStream,
                      builder: (context, snapshot) {
                        print(
                          FirebaseFirestore.instance
                              .collection("groups")
                              .doc(widget.groupId)
                              .collection("chats")
                              .orderBy('time', descending: true)
                              .snapshots(),
                        );
                        if (snapshot.hasError) {
                          print("snaphot.error");
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
                        print('Number of documents: ${messages.length}');
                        List<MessageBubble> messageBubbles = [];
                        for (var message in messages) {
                          final messageText = message['message'];
                          final messageSender = message['sendBy'];
                          final messageType = message['type'];
                          final messagetime = message['time'];
                          final currentUser = widget.id;
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
                              isMe: messageSender == widget.name,
                              link: link,
                              type: messageType,
                              isURL: isURL(messageText));
                          messageBubbles.add(messageBubble);
                        }
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 5.h,
                                bottom: _focusNode.hasFocus ? 30.h : 100.h),
                            child: Column(
                              children: [
                                Container(
                                  height: 70.h,
                                  width: 100.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40.sp),
                                        topRight: Radius.circular(40.sp)),
                                    color: Colors.white,
                                  ),
                                  // child:
                                  //     Padding(
                                  //       padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,),
                                  child: ListView(
                                    reverse: true,
                                    children: messageBubbles,
                                  ),
                                ),

                                //),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // _isRecording
                        //     ? _buildStopRecordingButton()
                        //     : _buildMicButton(),
                        
                        
                             Expanded(
                                child: LimitedBox(
                                  maxHeight: 4 *
                                          TextField().maxLines!.toInt() *
                                          (TextStyle().fontSize ?? 14.0) +
                                      16.0,
                                  child: TextField(
                                    maxLines: null,
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
                                ),
                              ),
                             Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.attachment_outlined,
                                        color: Colors.purple),
                                    onPressed: _pickFileany,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add_a_photo_rounded,
                                        color: Colors.purple),
                                    onPressed: _selectimage,
                                  ),
                                ],
                              ),
                        IconButton(
                                icon: Icon(Icons.send, color: Colors.purple),
                                onPressed: _sendMessage,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
                ListTile(
                leading: Icon(Icons.image),
                title: Text('Click Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFilePhoto();
                },
              ),
                ListTile(
                leading: Icon(Icons.image),
                title: Text('Record Video'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFileRecord();
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Select Image'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFile();
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

  bool _isPlaying = false; // <-- track whether the audio is playing
  AudioPlayer _audioPlayer =
      AudioPlayer(); // <-- create an instance of AudioPlayer
  void copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Text copied to clipboard')),
    );
  }

  bool isurl = false;
  bool isURL(String string) {
    // Regular expression pattern to match a URL
    // Regular expression pattern to match a URL
    return (string.contains('http',0) ||string.contains('www')||string.contains('https',0) ||string.contains('.com'));
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
    _audioPlayer.dispose();
    if (widget.type == "video") {
      _chewieController.dispose();
      _videoPlayerController.dispose();
    }
// <-- dispose the AudioPlayer when the widget is removed from the tree
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
    final cacheManager = DefaultCacheManager();
    final file = await cacheManager.getSingleFile(url);

    final appDocDir = await getTemporaryDirectory();
    final filePath = '${appDocDir.path}/video.mp4';
    await file.copy(filePath);
    OpenFilex.open(filePath);
    //  OpenFile.open(filePath);
  }

  Future<void> downloadAndOpenFile(String url, String fileName) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$fileName';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      OpenFilex.open(filePath);
      // await OpenFile.open(filePath);
    }
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
            color: Colors.grey,
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
                    ? Color.fromRGBO(255, 137, 51, 0.6)
                    : Color.fromRGBO(255, 199, 0, 0.6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft:
                      widget.isMe ? Radius.circular(12) : Radius.circular(0),
                  bottomRight:
                      widget.isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              //constraints: BoxConstraints(maxWidth: 300),
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
                          ? Container(
                            width:300,
                            child: Column(children: [
                                Container(
                                  height: 300,
                                  child: InAppWebView(
                                    initialUrlRequest: URLRequest(
                                      url: Uri.parse(widget.message),
                                    ),
                                    initialOptions: InAppWebViewGroupOptions(
                                      crossPlatform: InAppWebViewOptions(
                                        useShouldOverrideUrlLoading: true,
                                        mediaPlaybackRequiresUserGesture: false,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          launch(widget.message);
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
                              ]),
                          )
                          : Container(
                            constraints: BoxConstraints(maxWidth: 300,minWidth: 0),
                          //  width: 300,
                            child: Row(
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
                              ),
                          )
                      : widget.type == 'image'
                          ? Container(
                          width: 300,
                         
                            child: Column(
                              children: [
                                GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        _showMaximizedImage(widget.link);
                                      });
                                    },
                                    child: CachedNetworkImage(
                                      width: 300,                        
                                      height: 300,
                                      imageUrl: widget.link,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.fitWidth,
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
                            ),
                          )
                          : widget.type == 'audio'
                              ? Container(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: _isPlaying
                                            ? Icon(Icons.pause)
                                            : Icon(Icons.play_arrow),
                                        onPressed: () {
                                          if (_isPlaying) {
                                            _audioPlayer.pause();
                                          } else {
                                            print(widget.link);
                                             _audioPlayer.play(UrlSource(widget.link));
                                          }
                                          setState(() {
                                            _isPlaying = !_isPlaying;
                                          });
                                        },
                                      ),
                                      Text(
                                        _isPlaying ? 'Playing' : 'Paused',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : widget.type == 'video'
                                  ? Container(
                                    width: 300,
                                    child: Column(
                                        children: [
                                          SizedBox(
                                            height: 300,
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
                                      ),
                                  )
                                  : SizedBox(
                                    width:300,
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
                      color: Colors.grey,
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
