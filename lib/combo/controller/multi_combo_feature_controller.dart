import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class MultiComboFeatureController extends GetxController{
final String? courseId;
MultiComboFeatureController({this.courseId});

  var courses = [].obs;
  var courseList = [].obs;




  loadCourses()async{
    try {
      await FirebaseFirestore.instance.collection('courses').where('id', isEqualTo: courseId).get().then((value){
 courses.value = value.docs.first.get('courses');

 courses.forEach((element) async {
await FirebaseFirestore.instance.collection('courses').where('id', isEqualTo: element).get().then((val) {
 courseList.add(val.docs.first.data());
});

  });
      });
    } catch (e) {
      print('Error in loadCourse : $e');
    }
  }


  @override
  void onInit() {
    loadCourses();
    super.onInit();
  }
}