import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:house_project/providers/auth_house.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exeption.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  // ignore: unused_field
  String? _userId;
  String? _userName;
  Timer? _authTimer;
  bool _houseExists = false;
  bool _userHasHouse = false;

  bool get houseExists {
    return _houseExists;
  }

  bool get isAuth {
    print('isAuth token: $token');
    return token != null;
  }

  bool get isHouseAuth {
    return (_houseExists || _userHasHouse);
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  String? get userName {
    return _userName;
  }

  Future<void> _authenticate(String? email, String? password, String urlSegment,
      BuildContext context) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDXhcnQKV98Ula-60S_tQxiOxvyaonC84o');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpExeption(responseData['error']['message']);
      }
      var index = email!.indexOf('@');
      index > 0 ? _userName = email.substring(0, index) : _userName = email;
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      Provider.of<AuthHouse>(context, listen: false)
          .setUserFields(_token, _userId, _userName);
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout(context);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
        'userName': _userName
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(
      String? email, String? password, BuildContext context) async {
    return _authenticate(email, password, 'signUp', context);
  }

  Future<void> login(
      String? email, String? password, BuildContext context) async {
    return _authenticate(email, password, 'signInWithPassword', context);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extracedUserData = json.decode(prefs.getString('userData')!);

    final expiryDate = DateTime.parse(extracedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    return false;
    // _token = extracedUserData['token'];
    // _userId = extracedUserData['userId'];
    // _userName = extracedUserData['userName'];

    // _expiryDate = expiryDate;
    // notifyListeners();
    // _autoLogout();
    // return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    _houseExists = false;
    _userHasHouse = false;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear(); //or remove
  }

  void _autoLogout(BuildContext context) {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }

    // ignore: unused_local_variable
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
