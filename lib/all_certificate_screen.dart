import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/screens/quiz/quiz_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart'
    as PermissionHandler;
import 'package:share_extend/share_extend.dart';

class AllCertificateScreen extends StatefulWidget {
  const AllCertificateScreen({Key? key}) : super(key: key);

  @override
  State<AllCertificateScreen> createState() => _AllCertificateScreenState();
}

class _AllCertificateScreenState extends State<AllCertificateScreen> {
  String urlPDFPath = "";
  bool exists = true;
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  late PDFViewController _pdfViewController;
  bool loaded = false;

  Future<File> getFileFromUrl(String url, {name}) async {
    setState(() {
      loaded = true;
    });
    var fileName = 'testonline';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/" + fileName + ".pdf");
      print(dir.path);
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  @override
  void initState() {
    super.initState();
    getCertificate();
  }

  Future<Uint8List> downloadImageFromUrl(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download image: ${response.statusCode}');
    }
  }

  List<dynamic> certificates = [];
  List<String> paths = [];
  List<String> pathurl = [];

  getCertificate() async {
    setState(() {
      loaded = true;
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      // print(value.data()!['certificates']);

      certificates = value.data()!['certificates'];
      try {
        print("wiejfowj");
        print(certificates.length);
        for (var i in certificates) {
          if (i.contains('pdf')) {
            // getFileFromUrl(i).then(
            //   (value) => {
            //     print("wewef"),
            //     urlPDFPath = value.path,
            //     print("woijefow"),
            //     setState(() {
            //       paths.add(urlPDFPath);
            //       pathurl.add(i);
            //     }),
            //     print("yyyuu ${urlPDFPath}"),
            //   },
            // );
            setState(() {
              loaded = false;
            });
          } else {
            setState(() {
              paths.add(i);
            });
          }
          print('efwef');

          print("ttii : ${urlPDFPath}");
        }
      } catch (e) {
        print("error : $e");
      }
    });
  }

  Future<void> _downloadImage(image) async {
    // print("aaaaaaaaaaaaaaaaaaaaaa");
    // printWrapped(Uri.parse(globals.downloadCertificateLink).toString().replaceAll('"', ''));
    // print('kkkkkkkkkkkkkkkkkkkkkkk');

    try {
      print(image.replaceAll('"', ""));
      await WebImageDownloader.downloadImageFromWeb(image);
      // url.replaceAll('"', '');
    } catch (e) {
      print("the cer error is$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: loaded
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: ListView.builder(
                  itemCount: paths.length,
                  itemBuilder: (BuildContext context, int index) {
                    return paths[index].contains('http')
                        ? Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 290,
                                  child: Image.network(paths[index]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            print("aaaaaaaaaaaaaaaaaaaaaa");
                                            _downloadImage(paths[index]);
                                          },
                                          child: Icon(Icons.download_sharp)),
                                      // GestureDetector(
                                      //     onTap: () async {
                                      //       try {
                                      //         await CertificateDynamicLink
                                      //                 .createDynamicLink(
                                      //                     url: pathurl[index])
                                      //             .then((value) {
                                      //           setState(() {
                                      //             pathurl[index] = value;
                                      //           });
                                      //         });
                                      //       } catch (e) {
                                      //         print('Error in generating link');
                                      //       }
                                      //       ShareExtend.share(pathurl[index], "text");
                                      //     },
                                      //     child: Icon(Icons.share))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        // : Padding(
                        //     padding: const EdgeInsets.all(14.0),
                        //     child: Column(
                        //       children: [
                        //         Container(
                        //           height: 290,
                        //           child: PDFView(
                        //             filePath: paths[index],
                        //           ),
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceAround,
                        //             children: [
                        //               GestureDetector(
                        //                   onTap: () {
                        //                     _downloadImage(pathurl[index]);
                        //                   },
                        //                   child: Icon(Icons.download_sharp)),
                        //               // GestureDetector(
                        //               //     onTap: () async {
                        //               //       try {
                        //               //         await CertificateDynamicLink
                        //               //                 .createDynamicLink(
                        //               //                     url: pathurl[index])
                        //               //             .then((value) {
                        //               //           setState(() {
                        //               //             pathurl[index] = value;
                        //               //           });
                        //               //         });
                        //               //       } catch (e) {
                        //               //         print('Error in generating link');
                        //               //       }
                        //               //       ShareExtend.share(pathurl[index], "text");
                        //               //     },
                        //               //     child: Icon(Icons.share))
                        //             ],
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   );
                        : Container();
                  },
                ),
              ),
      ),
    );
  }
}
