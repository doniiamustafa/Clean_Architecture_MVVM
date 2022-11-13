
extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return "";
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
