import 'package:chat/localization/set_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


String? getTranslated(BuildContext context, String key)
{
  return SetLocalization.of(context)!.getTranslateValue(key);
}


String? getLangCode(BuildContext context) {
  return SetLocalization.of(context)!.getCurrentCod();
}

const String ENGLISH = 'en';
const String ARABIC = 'ar';
const String LANG_CODE = 'LANG_CODE';


Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _preferences = await SharedPreferences.getInstance();
  await _preferences.setString(LANG_CODE, languageCode);
  return _locale(languageCode);
}

Locale _locale(String langCode) {
  Locale _temp;
  switch (langCode) {
    case ENGLISH:
      _temp = Locale(langCode, 'US');
      break;
    case ARABIC:
      _temp = Locale(langCode, 'EG');
      break;
    default:
      _temp = Locale(ENGLISH, 'US');
      break;
  }
  return _temp;
}

Future<Locale> getLocale() async {
  SharedPreferences _preferences = await SharedPreferences.getInstance();
  String languageCode = _preferences.getString(LANG_CODE) ?? ENGLISH;
  return _locale(languageCode);
}