import 'package:dio/dio.dart';
import 'package:screen_page/service/dio.dart';

class Worker {
  static Future<void> addService(
    String _token,
    Map<String, dynamic> creds,
  ) async {
    try {
      Response response = await dio().post(
        '/services',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
          },
        ),
        data: creds,
      );
      print('addService code: ${response.statusCode}');
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  static Future<void> getWorkerServices(String _token) async {
    try {
      Response response = await dio().post(
        '/services/my-services',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
          },
        ),
      );
      print('${response}');
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  static Future<void> deleteService(String id, String _token) async {
    try {
      print("token in delet $_token");
      print('Id in delet  /services/$id');
      Response response = await dio().delete(
        '/users',
        options: Options(headers: {'Authorization': 'Bearer $_token'}),
      );
      print('Delet_services ${response.data}');
    } catch (e) {
      print(e);
    }
  }
}
