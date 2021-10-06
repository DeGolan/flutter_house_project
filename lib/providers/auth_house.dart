import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exeption.dart';

class AuthHouse with ChangeNotifier {
  String? _houseId;

  String? get houseId {
    return _houseId;
  }

  bool get isAuth {
    return _houseId != null;
  }

  // Future<void> _authenticate(
  //     String? email, String? password, String urlSegment) async {
  //   final url = Uri.parse(
  //       'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDXhcnQKV98Ula-60S_tQxiOxvyaonC84o');
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: json.encode(
  //         {
  //           'email': email,
  //           'password': password,
  //           'returnSecureToken': true,
  //         },
  //       ),
  //     );
  //     final responseData = json.decode(response.body);
  //     if (responseData['error'] != null) {
  //       throw HttpExeption(responseData['error']['message']);
  //     }
  //     _userName = email;
  //     _token = responseData['idToken'];
  //     _userId = responseData['localId'];
  //     _expiryDate = DateTime.now()
  //         .add(Duration(seconds: int.parse(responseData['expiresIn'])));
  //     _autoLogout();
  //     notifyListeners();
  //     final prefs = await SharedPreferences.getInstance();
  //     final userData = json.encode({
  //       'token': _token,
  //       'userId': _userId,
  //       'expiryDate': _expiryDate!.toIso8601String(),
  //       'userName': _userName
  //     });
  //     prefs.setString('userData', userData);
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  Future<void> signup(String? houseName, String authToken) async {
    final url = Uri.parse(
        'https://house-project-49c61-default-rtdb.europe-west1.firebasedatabase.app/houses/$houseName.json?auth=$authToken');
    try {
      final responseUniqueCheck = await http.get(url);
      print(json.decode(responseUniqueCheck.body));
    } catch (error) {}
  }

//   Future<void> login(String? email, String? password) async {
//     return _authenticate(email, password, 'signInWithPassword');
//   }

//   Future<bool> tryAutoLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (!prefs.containsKey('userData')) {
//       return false;
//     }
//     final extracedUserData = json.decode(prefs.getString('userData')!);

//     final expiryDate = DateTime.parse(extracedUserData['expiryDate']);

//     if (expiryDate.isBefore(DateTime.now())) {
//       return false;
//     }
//     _token = extracedUserData['token'];
//     _userId = extracedUserData['userId'];
//     _userName = extracedUserData['userName'];

//     _expiryDate = expiryDate;
//     notifyListeners();
//     _autoLogout();
//     return true;
//   }

//   Future<void> logout() async {
//     _token = null;
//     _userId = null;
//     _expiryDate = null;
//     if (_authTimer != null) {
//       _authTimer!.cancel();
//       _authTimer = null;
//     }
//     notifyListeners();
//     final prefs = await SharedPreferences.getInstance();
//     prefs.clear(); //or remove
//   }

//   void _autoLogout() {
//     if (_authTimer != null) {
//       _authTimer!.cancel();
//     }
//     // ignore: unused_local_variable
//     final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
//     _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
//   }
}
