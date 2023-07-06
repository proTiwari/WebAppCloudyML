import 'package:shared_preferences/shared_preferences.dart';

class GetUnread {
  Future saveunread(Set<String> documnets) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList('myList', documnets.toList());
  }

  
}
