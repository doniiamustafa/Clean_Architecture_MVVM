import 'dart:ffi';

import 'package:clean_architecture/application/app_constants.dart';
import 'package:clean_architecture/presentation/resources/language_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String PREFS_KEY_ONBOARDING_VIEWED = "PREFS_KEY_ONBOARDING_VIEWED";
const String PREFS_KEY_LOGIN_VIEWED = "PREFS_KEY_LOGIN_VIEWED";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(Constant.appLanguage);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.english.getValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String? currentLanguage = await getAppLanguage();

    if (currentLanguage == LanguageType.arabic.getValue()) {
      // set english
      _sharedPreferences.setString(
          Constant.appLanguage, LanguageType.english.getValue());
    } else {
      // set arabic
      _sharedPreferences.setString(
          Constant.appLanguage, LanguageType.arabic.getValue());
    }
  }

  Future<Locale> getLocale() async {
    String? currentLanguage = await getAppLanguage();

    if (currentLanguage == LanguageType.arabic.getValue()) {
      return arabicLocale;
    } else {
      return englishLocale;
    }
  }

  Future<void> setOnBoardingViewed() async {
    _sharedPreferences.setBool(PREFS_KEY_ONBOARDING_VIEWED, true);
  }

  Future<bool> isOnBoardingViewed() async {
    return _sharedPreferences.getBool(PREFS_KEY_ONBOARDING_VIEWED) ?? false;
  }

  Future<void> setUserLoggedIn() async {
    _sharedPreferences.setBool(PREFS_KEY_LOGIN_VIEWED, true);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(PREFS_KEY_LOGIN_VIEWED) ?? false;
  }

  Future<bool> logout() async {
    return _sharedPreferences.remove(PREFS_KEY_LOGIN_VIEWED);
  }
}
