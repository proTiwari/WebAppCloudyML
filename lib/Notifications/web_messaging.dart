import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FBMessaging{
  init()async{
    FirebaseMessaging.instance.requestPermission().then((value) {
     FirebaseMessaging.instance.getToken().then((value) {
        print('Tokenn : $value');
        firebaseBgMsg();
    });
    });
  }

  firebaseOnMsg(BuildContext context){
    FirebaseMessaging.onMessage.listen((event) { 
    if(event != null){
      print('MSGGGGGGGGG');
        final title  = event.notification!.title;
      final body = event.notification!.body;
    Fluttertoast.showToast(msg: '$body', gravity: ToastGravity.TOP_RIGHT, timeInSecForIosWeb: 10);}
    });
  }


  firebaseOnMsgOpen(){
    FirebaseMessaging.onMessageOpenedApp.listen((event) { 

    });
  }

firebaseBgMsg(){
  FirebaseMessaging.onBackgroundMessage((message) async{
    
  });
}
  
}