import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  static final FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal() {
    initializePersistedState();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _editImage = '';
  String get editImage => _editImage;
  set editImage(String _value) {
    _editImage = _value;
  }

  String _optionaimage = '';
  String get optionaimage => _optionaimage;
  set optionaimage(String _value) {
    _optionaimage = _value;
  }

  String _optionbimage = '';
  String get optionbimage => _optionbimage;
  set optionbimage(String _value) {
    _optionbimage = _value;
  }

  String _optioncimage = '';
  String get optioncimage => _optioncimage;
  set optioncimage(String _value) {
    _optioncimage = _value;
  }

  String _optiondimage = '';
  String get optiondimage => _optiondimage;
  set optiondimage(String _value) {
    _optiondimage = _value;
  }
}
