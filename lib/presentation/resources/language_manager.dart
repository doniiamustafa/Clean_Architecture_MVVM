import 'package:clean_architecture/application/app_constants.dart';

enum LanguageType { english, arabic }

extension LanguageTypeExtension on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.english:
        return Constant.english;
      case LanguageType.arabic:
        return Constant.arabic;
    }
  }
}
