import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = new Dio();
  dio.options.baseUrl = 'http://192.168.155.8:5000/api';
  dio.options.headers = {
    'accept': 'application/json', // Tell the server to return JSON data
    'Content-Type': 'application/json', // Sending JSON data
    // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // If authentication is required
  };
  return dio;
}
