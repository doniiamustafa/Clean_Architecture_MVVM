import 'package:clean_architecture/application/app_constants.dart';
import 'package:clean_architecture/presentation/resources/constants_manager.dart';
import 'package:clean_architecture/presentation/resources/strings_manager.dart';

extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return Constant.empty;
    } else {
      return this!;
    }
  }
}

extension NonNullInt on int? {
  int orZero() {
    if (this == null) {
      return 0;
    } else {
      return this!;
    }
  }
}

// void test() {
//   String? data = null;
//   int? num;

//   debugPrint(data.orEmpty()); // ""
//   debugPrint(num.orZero().toString());
// }
