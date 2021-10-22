import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exeption.dart';

class AuthHouse with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _userName;
  String? _houseName = '';
  bool loading = true;

  bool get isAuth {
    print('isAuthHouse HouseName: $_houseName ');
    if (_houseName != '') {
      print('isAuthHouse ifff: $_houseName ');

      return true;
    } else {
      _userConnectedToHouse();
      return false;
    }
  }

  Future<void> _userConnectedToHouse() async {
    print('_userConnectedToHouse:before userId: $_userId');
    final url = Uri.parse(
        'https://house-project-49c61-default-rtdb.europe-west1.firebasedatabase.app/users/$_userId.json?auth=$_token');
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>?;
      print('_userConnectedToHouse raw response data: $responseData');

      if (responseData != null) {
        responseData.forEach((key, value) {
          _houseName = value['houseName'];
          print(value['houseName']);
        });
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }

  String? get token {
    return _token;
  }

  String? get houseName {
    return _houseName;
  }

  void setUserFields(String? token, String? userId, String? userName) {
    _token = token;
    _userId = userId;
    _userName = userName;
    notifyListeners();
  }

  Future<void> houseSigninAndUp(String houseName) async {
    final userUrl = Uri.parse(
        'https://house-project-49c61-default-rtdb.europe-west1.firebasedatabase.app/users/$_userId.json?auth=$_token');
    final url = Uri.parse(
        'https://house-project-49c61-default-rtdb.europe-west1.firebasedatabase.app/houses/$houseName/users/$_userId.json?auth=$_token');
    try {
      //posting the user in the house folder
      final response = await http.post(
        url,
        body: json.encode(
          {
            'userName': _userName,
            'userId': _userId,
          },
        ),
      );
      //posting the house in the user folder
      final responseUsers = await http.post(
        userUrl,
        body: json.encode(
          {
            'houseName': houseName,
            'email': _userName,
          },
        ),
      );
      _houseName = houseName;
      notifyListeners();
    } catch (error) {
      //error handling
      rethrow;
    }
  }

  //check if the providen houseName exists in the db
  Future<void> checkIfHouseExist(String houseName) async {
    final url = Uri.parse(
        'https://house-project-49c61-default-rtdb.europe-west1.firebasedatabase.app/houses/$houseName.json?auth=$_token');
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body);
      print('_checkIfHouseExist: houseName: $houseName');
      print('_checkIfHouseExist: response: $responseData');

      if (responseData == null) {
        throw HttpExeption('HOUSE_DOES_NOT_EXISTS');
      }
    } catch (error) {
      rethrow;
    } //error handling
  }

  //check if the providen houseName exists in the db
  Future<void> checkIfHouseDoesNotExists(String houseName) async {
    final url = Uri.parse(
        'https://house-project-49c61-default-rtdb.europe-west1.firebasedatabase.app/houses/$houseName.json?auth=$_token');
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body);
      print('_checkIfHouseDoesNotExist: houseName: $houseName');
      print('_checkIfHouseDoesNotExist: response: $responseData');

      if (responseData != null) {
        throw HttpExeption('HOUSE_EXISTS');
      }
    } catch (error) {
      rethrow;
    } //error handling
  }

  void resetHouseName() {
    _houseName = '';

    notifyListeners();
  }
}
