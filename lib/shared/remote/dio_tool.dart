

import 'package:dio/dio.dart';

class dioTool
{
  static late Dio dio;
  static void init()async
  {
    dio = await Dio(
        BaseOptions(
          baseUrl: 'https://fcm.googleapis.com/fcm/',
          receiveDataWhenStatusError: true,
          connectTimeout: 10000,
          receiveTimeout: 10000,
        ),
    );
  }


  static Future<Response> postData ({
    required Map<String,dynamic>? data,
    Map<String,dynamic>? query,
  }) async{
    dio.options.headers={
      "Content-Type": "application/json",
      "Authorization": "key=AAAAtvzMPgo:APA91bHT-AJ_bVKQhNkrXhjgWRFN2phG4l3Mhtr-TIIY6UpwoaNtY9aVRG36_kdeDsV_NK8JE9ZvlSmELQucKrwixJtMoHKDup8DbZX4d_tSS-jyREJP4LwHu9HwJY__6OvUbcmcfKYa"
    };

    return await dio.post(
      'send',
      queryParameters: query,
      data: data,
    );
  }

}