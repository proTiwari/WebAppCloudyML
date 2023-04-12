import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloudyml_app2/global_variable.dart' as globals;
import 'model/certificatemodel.dart';

class certificateApi {
  static getCertificate(CertificateModel certificateInfo) async {
    print(certificateInfo.toJson());
    var url = Uri.parse(
        'https://us-central1-cloudyml-app.cloudfunctions.net/certificate/certificate');
    var response = await http.post(url, body: certificateInfo.toJson());
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(jsonString);
      globals.downloadCertificateLink = jsonString;
    } else {
      print(response.statusCode);
      print(response.body);
      
      throw Exception('Failed to load certificate');
    }
  }
}
