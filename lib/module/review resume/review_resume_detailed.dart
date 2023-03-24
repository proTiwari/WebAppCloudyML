import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';


class ReviewDetailScreen extends StatefulWidget {
  final String resumeLink;
  final String studentName;
  final String studentEmail;
  final String studentId;
   ReviewDetailScreen({Key? key, required this.resumeLink, required this.studentName, required this.studentEmail, required this.studentId});

  @override
  State<ReviewDetailScreen> createState() => _ReviewDetailScreenState();
}

class _ReviewDetailScreenState extends State<ReviewDetailScreen> {
  TextEditingController _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      body: LayoutBuilder(builder: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height / 12,
            padding: EdgeInsets.symmetric(horizontal: width / 20),
            decoration: BoxDecoration(
                color: Color.fromRGBO(118, 99, 215, 1),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white, size: height / 25,)),
                Text(widget.studentName, style: TextStyle(
                    fontSize: height / 30,
                    color: Colors.white
                ),),
                SizedBox(),

              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: width/30, vertical: height / 50),
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width/100, vertical: height / 50),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Please click on the link below to view resume',
                          style: TextStyle(
                            fontSize: width / 70,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: height / 40),
                        InkWell(
                          onTap: () {
                            launch(
                                widget.resumeLink);

                          },
                          child: Text(
                            'View Resume',
                            style: TextStyle(
                              fontSize: width / 80,
                              fontWeight: FontWeight.w500,
                              color: Colors.deepPurpleAccent,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: height / 50,),
                  Divider(color: Color.fromRGBO(118, 99, 215, 1),thickness: 1, endIndent: width / 2),
                  SizedBox(height: height / 50,),
                  Text('Comment Here', style: TextStyle(
                      fontSize: height / 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                  ),),
                  SizedBox(height: height / 60,),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.black12, width: 1),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: TextField(
                      controller: _commentController,

                      decoration: InputDecoration(
                        hintText: 'Please comment here...',
                        border: InputBorder.none,
                      ),
                      maxLines: 10,
                      minLines: 5,
                      autocorrect: true,
                    ),
                  ),
                  SizedBox(height: height / 60,),
                  ElevatedButton(
                    onPressed: (
                        ) async {
                      sendComment();
                    },
                    child: Text("Submit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Colors.deepPurpleAccent,
                    ),
                  )


                ],
              ),
            ),
          )
        ],
      ) ,),
    );
  }

  sendComment() async {
    try{
      if(_commentController.text.isEmpty){
        Fluttertoast.showToast(msg: 'Please do some comment');
      }else{
        // print('Name : ${value.docs.first.get('name')}');
        // print('Id : ${value.docs.first.get('id')}');
        // print('link : ${value.docs.first.get('link')}');
        // print('comment : ${value.docs.first.get('comment')}');

        await FirebaseFirestore.instance.collection('StudentResumes').get().then((value) {
         final data = value.docs.where((element) => element.get('id') == widget.studentId);
              FirebaseFirestore.instance.collection('StudentResumes').doc(data.first.id).update({
                'comments' : _commentController.text
              }).whenComplete(() {
                Fluttertoast.showToast(msg: 'Your Comment Uploaded');
                _commentController.text = '';
              });

        });
      }


    }catch(e){
      print('Error in commenting : $e');
    }
  }
}