
import 'package:shared_preferences/shared_preferences.dart';

class cache{


  static late  SharedPreferences  prefs;

  static init()async{
    prefs=await SharedPreferences.getInstance();
  }



  static Future<bool> setData({
  required String key,
    required dynamic value,
   })async
  {
    if(value is int)
      {
        return await prefs.setInt(key, value);
     }
    if(value is String)
    {
      return await prefs.setString(key, value);
    }
    if(value is bool)
    {
      return await prefs.setBool(key, value);
    }
    else
    {
      return prefs.setDouble(key, value);
    }

  }


  static dynamic getBool({
  required String key,
   })
  {
    return  prefs.getBool(key);
  }

  static String? getString({
    required String key,
  })
  {
    return  prefs.getString(key);
  }

  static Future<bool> removeData({required String key})async
  {
    return await prefs.remove(key);
  }


}