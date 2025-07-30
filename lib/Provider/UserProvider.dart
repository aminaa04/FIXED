import 'package:flutter/material.dart';
import 'package:screen_page/Model/User.dart';

class UserProvider extends ChangeNotifier {
  bool isClientMode = true;
  bool get getisClientMode => isClientMode;
  void SetisClientMode(bool isClientMode) {
    this.isClientMode = isClientMode;
    notifyListeners();
  }

  late User _user;
  var allservise;
  get getallservise => allservise;
  void Setallservise(var allservise) {
    this.allservise = allservise;
    notifyListeners();
  }

  User get get_user => _user;
  set setUser(Map<String, dynamic> data) {
    _user = User.formJson(data);
    notifyListeners(); // optional, if you want to rebuild widgets
  }

  bool isLogedIn = false;
  late String _token;
  String get get_token => _token;
  void Set_token(String token) {
    _token = token;
    notifyListeners();
  }

  bool get autheenticated => isLogedIn;
  void setAutheenticated() => {isLogedIn = true, notifyListeners()};
}
