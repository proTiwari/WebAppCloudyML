import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/global_variable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SubmitResume extends StatefulWidget {
  final String studentId;
  final String studentEmail;
  final String studentName;

  SubmitResume(
      {Key? key,
      required this.studentId,
      required this.studentEmail,
      required this.studentName})
      : super(key: key);

  @override
  State<SubmitResume> createState() => _SubmitResumeState();
}

class _SubmitResumeState extends State<SubmitResume> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? fileName;
  Uint8List? uploadedFile;
  String? titleMessage;

  String? filePath;
  String comments = '';
  bool isSubmitted = false;

  @override
  void initState() {
    print('user id : ${widget.studentId}');
    print('Email : ${widget.studentEmail}');
    print('name : ${widget.studentName}');
    getTitle();
    getComments();
    getNumberOfSubmissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Text(
                              'Submit Resume',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      titleMessage == null
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey,
                                        width: 0.2,
                                        style: BorderStyle.solid)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          titleMessage!,
                                          textAlign: TextAlign.left,
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white12, width: 0.5),
                          color: Colors.black12,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Upload Resume",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "You can upload maximum 10 MB of file size.",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              //button container
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                width: MediaQuery.of(context).size.width / 1.2,
                                color: Colors.black12,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await getFile();
                                          if (fileName!.isNotEmpty) {
                                            print(fileName);
                                          }
                                        },
                                        child: Text("Choose file",
                                            style: TextStyle(
                                                color: Colors.black26)),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    uploadedFile != null
                                        ? Text(
                                            fileName.toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        : Text(
                                            "No file chosen",
                                            style: TextStyle(
                                                color: Colors.black26),
                                          )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              ElevatedButton(
                                onPressed: () {
                                  if (numberOfSubmission == 2) {
                                    Fluttertoast.showToast(
                                        msg:
                                            'You can submit resume only 2 times.');
                                  } else {
                                    uploadResume();
                                  }
                                },
                                child: Text("Submit"),
                                style: ElevatedButton.styleFrom(),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      isSubmitted && comments.isEmpty
                          ? Text(
                              'You Will See Comments Here Once Your Resume Review Done By Mentors.',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            )
                          : SizedBox(),
                      comments.isEmpty
                          ? SizedBox()
                          : Container(
                              width: MediaQuery.of(context).size.width / 2,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Comments From TA :',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(comments,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400))
                                ],
                              ),
                            )
                    ],
                  ),
                )),
          ),
        ));
  }

  Future getFile() async {
    FilePickerResult? result;

    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
    } catch (e) {
      print(e.toString());
    }

    if (result != null && result.files.isNotEmpty) {
      try {
        Uint8List? uploadFile = result.files.single.bytes;

        String pickedFileName = result.files.first.name;

        setState(() {
          uploadedFile = uploadFile;
          fileName = pickedFileName;
        });

        if (uploadedFile != null) {
          Fluttertoast.showToast(msg: 'Your file is attached');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
        print(e.toString());
      }
    }
  }

  getTitle() async {
    try {
      await FirebaseFirestore.instance.collection("Notice").get().then((value) {
        setState(() {
          titleMessage = value.docs
              .firstWhere((element) => element.id == 'gp1aFyIZsix1tH7pouva')
              .get("msg");
        });
      });
    } catch (e) {}
  }

  int numberOfSubmission = 0;
  getNumberOfSubmissions() async {
    try {
      await FirebaseFirestore.instance
          .collection('StudentResumes')
          .get()
          .then((value) {
        final data = value.docs
            .where((element) => element.get('id') == widget.studentId);
        numberOfSubmission = data.first.get('numberOfSubmission');
        setState(() {});
      });
    } catch (e) {
      print('Error while fetching comments : $e');
    }
  }

  UploadTask? uploadTask;

  uploadResume() async {
    try {
      if (uploadedFile == null) {
        Fluttertoast.showToast(msg: 'Please Select File');
      } else {
        var storageRef = FirebaseStorage.instance
            .ref()
            .child('Student Resumes')
            .child(fileName!);

        final UploadTask uploadTask = storageRef.putData(uploadedFile!);

        final TaskSnapshot downloadUrl = await uploadTask;
        final String fileURL = (await downloadUrl.ref.getDownloadURL());
        print('Resume Download link :  $fileURL');

        final collectionReference =
            FirebaseFirestore.instance.collection('StudentResumes');

        final query =
            collectionReference.where('id', isEqualTo: widget.studentId);

        final snapshot = await query.get();
        if (snapshot.docs.isNotEmpty) {
          print('Document Exists');
          await FirebaseFirestore.instance
              .collection('StudentResumes')
              .get()
              .then((value) {
            final data = value.docs
                .where((element) => element.get('id') == widget.studentId);
            FirebaseFirestore.instance
                .collection('StudentResumes')
                .doc(data.first.id)
                .update({
              'link': '${fileURL}',
              "numberOfSubmission": numberOfSubmission + 1,
            }).whenComplete(() {
              isSubmitted = true;
              Fluttertoast.showToast(msg: 'Your Resume Has Been Uploaded');
              setState(() {});
            });
          });
        } else {
          print('Document Not Exists');
          await FirebaseFirestore.instance.collection('StudentResumes').add({
            "name": '${widget.studentName}',
            "link": '${fileURL}',
            "email": '${widget.studentEmail}',
            "id": '${widget.studentId}',
            "comments": '',
            "submitDate": DateTime.now(),
            "reviewDate": null,
            "numberOfSubmission": numberOfSubmission + 1,
          }).whenComplete(() {
            isSubmitted = true;
            Fluttertoast.showToast(msg: 'Your Resume Has Been Uploaded');
            setState(() {});
          });
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error in uploading resume, Try again');
    }
  }

  getComments() async {
    try {
      await FirebaseFirestore.instance
          .collection('StudentResumes')
          .get()
          .then((value) {
        final data = value.docs
            .where((element) => element.get('id') == widget.studentId);
        comments = data.first.get('comments');
        setState(() {});
      });
    } catch (e) {
      print('Error while fetching comments : $e');
    }
  }
}
