
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/module/review resume/review_resume_detailed.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class ReviewResumeScreen extends StatefulWidget {
  const ReviewResumeScreen({Key? key});

  @override
  State<ReviewResumeScreen> createState() => _ReviewResumeScreenState();
}

class _ReviewResumeScreenState extends State<ReviewResumeScreen> {
  List<StudentResumeData> studentData = [];
  @override
  void initState() {
   loadStudentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),

      body: LayoutBuilder(builder: (context, constraints) => SingleChildScrollView(

        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                      GoRouter.of(context)
                                          .pushReplacementNamed('home');
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white, size: height / 25,)),
                  Text('Student Resume', style: TextStyle(
                      fontSize: height / 30,
                      color: Colors.white
                  ),),
                  SizedBox()
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 5, vertical: height / 50),
              child:

                  studentData.isEmpty ?
                      Center(
                        child: CircularProgressIndicator(),
                      ) :

              SizedBox(

                  child: ListView.builder(
                    itemCount: studentData.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:  EdgeInsets.only(bottom: height / 100),
                        child: GestureDetector(
                          onTap: (){

                            GoRouter.of(context).pushNamed('reviewResumeDetailed', queryParams: {
                              'studentId' : studentData[index].id,
                              'studentName' : studentData[index].name,
                              'studentEmail' : studentData[index].email,
                              'resumeLink' : studentData[index].resumeLink
                            });
                           },
                          child: Container(
                            height: height/ 10,
                            padding: EdgeInsets.symmetric(horizontal: width / 50),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:  Color.fromRGBO(232, 225, 250, 1)
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(studentData[index].name, style:  TextStyle(
                                      fontSize: width / 80,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700
                                  ),),
                                  IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios, size: width /60,))
                                ],
                              ) ,
                            ),
                          ),
                        ),
                      );
                    },)),
            )
          ],
        ),
      ),),
    );
  }

  loadStudentData()async{
    try{
      await FirebaseFirestore.instance.collection('StudentResumes').get().then((value) {
        value.docs.forEach((element) {
          studentData.add(
              StudentResumeData(name: element.get('name'), resumeLink: element.get('link'), email: element.get('email'), id: element.get('id')));
        });
        setState(() {});
      });
    }catch(e){
      print('Error in load student resume data : $e');
    }
  }
}



class StudentResumeData{
  String _name;
  String _resumeLink;
  String _email;
  String _id;

  StudentResumeData({
    required String name,
    required String resumeLink,
    required String email,
    required String id,
  })  : _name = name,
        _resumeLink = resumeLink,
        _email = email,
        _id = id;

  String get name => _name;
  String get resumeLink => _resumeLink;
  String get email => _email;
  String get id => _id;
}