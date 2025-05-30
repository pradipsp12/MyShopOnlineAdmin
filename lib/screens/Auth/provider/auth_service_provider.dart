import 'dart:convert';
import 'package:admin/models/api_response.dart';
import 'package:admin/models/user.dart';
import 'package:admin/services/http_services.dart';
import 'package:admin/utility/constants.dart';
import 'package:admin/utility/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../login_screen.dart';

class AuthService extends ChangeNotifier {
  final GetStorage _storage = GetStorage();
  final HttpService _service = HttpService();
  bool _isAuthenticated = false;
  User? _user;
  final String _userInfoBox = USER_INFO_BOX;

  bool get isAuthenticated => _isAuthenticated;
  User? get user => _user;

  Future<void> init() async {
    try {
      print('Initializing GetStorage...');
      await GetStorage.init();
      print('GetStorage initialized');
      final storedUser = _storage.read(_userInfoBox);
      print('Stored user: $storedUser, Type: ${storedUser.runtimeType}');
      if (storedUser != null && storedUser is Map && storedUser['role'] == 'admin') {
        _user = User.fromJson(Map<String, dynamic>.from(storedUser));
        _isAuthenticated = true;
        notifyListeners();
        print('User loaded: ${_user?.name}, Role: ${_user?.role}');
      } else {
        print('No valid admin user found in storage');
      }
    } catch (e) {
      print('Error in AuthService.init: $e');
      SnackBarHelper.showErrorSnackBar('Initialization failed: $e');
    }
  }

  Future<String?> login(String username, String password) async {
    try {
      Map<String, dynamic> loginData = {
        'name': username.toLowerCase(),
        'password': password,
      };
      print('Sending login request: $loginData');
      final response = await _service.addItem(
        endpointUrl: 'users/login',
        itemData: loginData,
      );

      print('API response: ${response.body}, Type: ${response.body.runtimeType}');

      if (response.isOk) {
        final data = response.body is String ? jsonDecode(response.body) : response.body;
        final apiResponse = ApiResponse<User>.fromJson(data, (json) => User.fromJson(json as Map<String, dynamic>));
        if (apiResponse.success == true && apiResponse.data?.role == 'admin') {
          _user = apiResponse.data;
          saveLoginInfo(_user);
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          return null;
        } else if (apiResponse.success == true && apiResponse.data?.role != 'admin') {
          SnackBarHelper.showErrorSnackBar('You are not authorised to access');
          return 'You are not authorised to access';
        } else {
          SnackBarHelper.showErrorSnackBar(apiResponse.message);
          return apiResponse.message;
        }
      } else {
        final errorMessage = response.body is String
            ? jsonDecode(response.body)['message'] ?? response.statusText
            : response.body['message'] ?? response.statusText;
        SnackBarHelper.showErrorSnackBar('Login failed: $errorMessage');
        return 'Login failed: $errorMessage';
      }
    } catch (e) {
      print('Login error: $e');
      SnackBarHelper.showErrorSnackBar('An error occurred during login: $e');
      return 'An error occurred: $e';
    }
  }
 Future<void> saveLoginInfo(User? loginUser) async {
    try {
      if (loginUser != null && loginUser.role == 'admin') {
        _user = loginUser;
        _isAuthenticated = true;
        await _storage.write(_userInfoBox, _user?.toJson());
        notifyListeners();
      } else {
        print('Invalid user data, not saving login info');
      }
    } catch (e) {
      print('Error saving login info: $e');
      SnackBarHelper.showErrorSnackBar('Failed to save login info: $e');
    }
  }
   User? getLoginUsr() {
    try {
      final storedUser = _storage.read(_userInfoBox);
      if (storedUser != null && storedUser is Map && storedUser['role'] == 'admin') {
        return User.fromJson(Map<String, dynamic>.from(storedUser));
      }
    } catch (e) {
      print('Error retrieving user: $e');
    }
    return null;
  }

  Future<void> logout(BuildContext context) async {
    _isAuthenticated = false;
    _user = null;
    await _storage.remove(_userInfoBox);
    notifyListeners();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }
}