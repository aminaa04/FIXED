import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_page/service/dio.dart';
import 'package:screen_page/service/User_fonct.dart';
import 'package:screen_page/Provider/UserProvider.dart';

class Auth {
  static Future<int> login(
    Map<String, dynamic> creds,
    BuildContext context,
  ) async {
    try {
      Response response = await dio().post(
        '/users/login', // or your local server URL
        data: creds,
      );
      String token = response.data['token'];
      Provider.of<UserProvider>(context, listen: false).Set_token(token);
      Provider.of<UserProvider>(context, listen: false).setAutheenticated();
      print('Response_login: ${response.data}');
      await get_user_account(context, token);
      await UserFonct.getAllSerivce(token, context);
      return 200;
    } catch (error) {
      if (error is DioException && error.response?.statusCode == 401) {
        print('Unauthorized: ${error.response?.data['message']}');
        return 401;
      } else if (error is DioException && error.response?.statusCode == 402) {
        print('Unauthorized: ${error.response?.data['message']}');
        return 402;
      } else {
        print('Other error occurred');
        return 500;
      }
    }
  }

  static Future<int> singup(Map creds, BuildContext context) async {
    try {
      Response response = await dio().post(
        '/users/register', // or your local server URL
        data: creds,
      );
      if (response.statusCode == 201) {
        if (response.data['user']['token'] != null) {
          String token = response.data['user']['token'];
          Provider.of<UserProvider>(context, listen: false).Set_token(token);
          Provider.of<UserProvider>(context, listen: false).setAutheenticated();
          print("${response.data['message']}");
        }
        return 200;
      } else {
        print('Error during signup: ${response.statusCode}');
        return response.statusCode ?? 500;
      }
    } catch (e) {
      print('Signup error: $e');
      return 500;
    }
  }

  static Future<void> get_user_account(
    BuildContext context,
    String _token,
  ) async {
    try {
      Response response = await dio().get(
        '/users/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        print(response.data);
        Map<String, dynamic> userData = response.data;
        if (userData.containsKey('user')) {
          userData = userData['user'];
        }
        Provider.of<UserProvider>(context, listen: false).setUser = userData;
      }
    } catch (e) {
      print("Error user_user_account: $e");
      if (e is DioException && e.response?.statusCode == 404) {
        print('Error 404: API endpoint not found');
      }
    }
  }

  static Future<bool> verify_otp(
    BuildContext context,
    Map<String, dynamic> creds,
  ) async {
    try {
      print("in verify_otp : $creds");
      Response response = await dio().post('/users/verify-otp', data: creds);
      print('response Otp :${response}');
      String token =
          Provider.of<UserProvider>(context, listen: false).get_token;
      await get_user_account(context, token);
      await UserFonct.getAllSerivce(token, context);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
