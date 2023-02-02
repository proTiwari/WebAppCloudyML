import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/MyAccount/myaccount.dart';
import 'package:cloudyml_app2/models/UserNotificationModel.dart';
import 'package:intl/intl.dart';

class UserModel {
  static const ID = 'id';
  static const NAME = 'name';
  static const MOBILE = 'mobilenumber';
  static const EMAIL = 'email';
  static const IMAGE = 'image';
  static const USERNOTIFICATIONS = "usernotification";
  static const AUTHTYPE = "authType";
  static const PHONEVERIFIED = "phoneVerified";

  //Question mark is for that the _id can be null also
  String? _id;
  String? _mobile;
  String? _email;
  String? _name;
  String? _image;
  String? _authType;
  bool? _phoneVerified;
  String? _role;

  String? get id => _id;
  String? get mobile => _mobile;
  String? get email => _email;
  String? get name => _name;
  String? get image => _image;
  String? get authType => _authType;
  bool? get phoneVerified => _phoneVerified;
  String? get role => _role;

  List<UserNotificationModel>? userNotificationList;

  UserModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
    
      print("hfsojdfosjdfoi: ${snapshot}");
      _name = (snapshot.data()![NAME] == '')
          ? 'Enter name'
          : snapshot.data()![NAME];
      print("1");
      _email = (snapshot.data()![EMAIL] == '')
          ? 'Enter email'
          : snapshot.data()![EMAIL];
      print("2");
      _mobile = (snapshot.data()![MOBILE] == '')
          ? '__________'
          : snapshot.data()![MOBILE].toString();
      _id = snapshot.data()![ID];
      print("3");
      _authType = snapshot.data()![AUTHTYPE];
      print("4");
      _role = snapshot.data()!['role'];
      print("5");
      _phoneVerified = snapshot.data()![PHONEVERIFIED];
      print("6");
      if (snapshot.data()![IMAGE] != null) {
        _image = (snapshot.data()![IMAGE] == '')
            ? 'https://stratosphere.co.in/img/user.jpg'
            : snapshot.data()![IMAGE];
        print("7");
      } else {
        _image = 'https://stratosphere.co.in/img/user.jpg';
        print("8");
      }
      // userNotificationList=_convertNotificationItems(snapshot.data()?[USERNOTIFICATIONS]??[]);
    } catch (e) {
      print('usermodelll ${e.toString()}');
    }
  }

  List<UserNotificationModel>? _convertNotificationItems(
      List userNotificationList) {
    List<UserNotificationModel> convertedNotificationList = [];
    for (Map notificationItem in userNotificationList) {
      convertedNotificationList
          .add(UserNotificationModel.fromMap(notificationItem));
    }
    return convertedNotificationList;
  }
}
