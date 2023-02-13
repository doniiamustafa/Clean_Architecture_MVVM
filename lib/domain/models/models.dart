// on boarding models

import 'package:flutter/cupertino.dart';

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

class Services {
  int id;
  String image;
  String title;

  Services({required this.id, required this.image, required this.title});
}

class BannersAd {
  int id;
  String image;
  String link;
  String title;

  BannersAd(
      {required this.id,
      required this.image,
      required this.link,
      required this.title});
}

class Stores {
  int id;
  String image;
  String title;

  Stores({required this.id, required this.image, required this.title});
}

class HomeData {
  List<BannersAd> bannersAd;

  List<Services> services;

  List<Stores> stores;

  HomeData(
      {required this.bannersAd, required this.services, required this.stores});
}

class Home {
  HomeData homeData;
  Home(this.homeData);
}

class StoreDetails {
  String image;
  int id;
  String title;
  String details;
  String services;
  String about;
  StoreDetails(
      {required this.image,
      required this.id,
      required this.title,
      required this.details,
      required this.services,
      required this.about});
}
