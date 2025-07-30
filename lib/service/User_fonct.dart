import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_page/Provider/UserProvider.dart';
import 'package:screen_page/service/dio.dart';

class UserFonct {
  static Future<void> getAllSerivce(String token, BuildContext context) async {
    try {
      print("token in getallservise$token");
      Response response = await dio().get(
        '/services/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        Provider.of<UserProvider>(
          context,
          listen: false,
        ).Setallservise(response.data);
        print("All service : ${response.data}");
      }
    } catch (e) {
      print(e);
    }
  }
}
