// on boarding models

class SliderObject {
  String title;
  String subTtile;
  String image;

  SliderObject(this.title, this.subTtile, this.image);
}

class SliderViewObject {
  // 7atet hena ay 7aga hardcoded mawgoda fl onboarding view screen
  // di data el view(design) byb3tha lel viewmodel 3lshan y3mel process mo3yna w yerga3 lel view
  SliderObject sliderObject;
  int currentIndex;
  int numberOfSliders;

  SliderViewObject(this.sliderObject, this.currentIndex, this.numberOfSliders);
}

class Customer {
  // msh hayenfa3 a3mel el attributes nullable 3lshan mafish 7aga tro7 lel view b null w tedi error el 7al eni a3mel mapper "toDomain"
  String id;
  String name;
  int numOfNotification;
  Customer(
      {required this.id, required this.name, required this.numOfNotification});
}

class Contacts {
  String phone;
  String email;
  String link;
  Contacts({required this.phone, required this.email, required this.link});
}

class Authentication {
  //el custom data types byt7atelha ? 3lshan wared tegi b null 3aks el primitive data types zai el int, string 3adi mmkn akhli maygesh b null fa ma7otesh ?
  Customer? customer;
  Contacts? contacts;
  Authentication({
    required this.customer,
    required this.contacts,
  });
}
