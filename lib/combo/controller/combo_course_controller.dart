import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../global_variable.dart';

class ComboCourseController extends GetxController {
  final String? courseId;
  ComboCourseController({required this.courseId});

  @override
  void onInit() {
 getCourseIds().whenComplete(() {
  print('CCCC: : ${courses}');
    checkCourseExist();
    getCourses();

    getPercentageOfCourse();

 });

  
    super.onInit();
  }

  var courseList = [].obs;
  var courseData = {}.obs;
  var tmp = [].obs;
  var oldModuleProgress = false.obs;

  var courses = [].obs;

  var paidCourse = [].obs;


//var isLoading = true.obs;

 Future getCourseIds()async{
  
  await FirebaseFirestore
            .instance
            .collection("courses")
            .where('id', isEqualTo: courseId)
            .get().then((value){
 courses.value = value.docs.first.get('courses');
            });

           
      
  }



  getCourses() async {
    await {
      courses.forEach((element) {
        Future<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore
            .instance
            .collection("courses")
            .where('id', isEqualTo: element)
            .get();
        data.then((value) async{

           

                        courseList.add(value.docs.first.data());
          courseList.sort((a, b) =>
              courses.indexOf(a["id"]).compareTo(courses.indexOf(b["id"])));




    
             
        });
      })
    };
   // isLoading.value = false;
  }




 checkCourseExist() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      List temPaid = value.get('paidCourseNames');
      print(' MULTII :: $mainCourseId');
      await FirebaseFirestore.instance
          .collection("courses")
          .where('id', isEqualTo: mainCourseId)
          .get()
          .then((value) {
        if (value.docs[0].data()['multiCombo'] != null) {
          if (value.docs[0].data()['multiCombo']) {
            paidCourse.value = value.docs[0].data()['courses'];

            print(' Paid  :: ${value.docs[0].data()['courses']}');
          }
        } else {
          paidCourse.value = temPaid;
          print(' Paid :: ${courseId}');
        }
      });
    });
  }


  getPercentageOfCourse() async {
    try{
       var data = await FirebaseFirestore.instance
        .collection("courseprogress")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

      // tmp.clear();
      // for (var i = 0; i < data.data()!.length; i++) {
      //   try {
      //     if (i != 0) {
      //       tmp.add(data.data()![courses[i] + "percentage"]);
      //     }
      //   } catch (e) {}
      // }
      // for (int i = 1; i < tmp.length; i++) {
      //   if (tmp[i] is int) {
      //     oldModuleProgress.value = true;
      //   }
      // }




 courseData.value = data.data() as Map;
// isLoading.value = false;
    }catch(e){
     // isLoading.value = false;
      print('the progress exception is$e');
    }
   

  }

}
