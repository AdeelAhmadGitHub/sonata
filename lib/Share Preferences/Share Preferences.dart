import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _loginStatus = 'loginSta';
  static const _data = 'loginSta';
  setLoginStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loginStatus, value);
  }

  Future<bool> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginStatus) ?? false;
  }
  setData(final data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_data, data);
  }
  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_data) ?? false;
  }
}
