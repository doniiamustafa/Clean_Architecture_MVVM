// ignore_for_file: unnecessary_this

import 'package:clean_architecture/application/app_constants.dart';
import 'package:clean_architecture/data/responses/response.dart';
import 'package:clean_architecture/domain/models/models.dart';
import 'package:clean_architecture/application/extensions.dart';

extension CustomerResponseMapper on CustomerResponse {
  //convert APIs response to model for domain layer
  Customer toDomain() {
    return Customer(
        id: id.orEmpty(),
        name: name.orEmpty(),
        // name: name ?? Constant.empty,
        numOfNotification: numOfNotification.orZero());
  }
}

extension ContactsResponseMapper on ContactResponse {
  //convert APIs response to model for domain layer
  Contacts toDomain() {
    return Contacts(
        email: email.orEmpty(), link: link.orEmpty(), phone: phone.orEmpty());
  }
}

extension AuthenticationMapper on AuthenticationResponse {
  //convert APIs response to model for domain layer
  Authentication toDomain() {
    return Authentication(
      customer: customer?.toDomain(),
      contacts: contacts?.toDomain(),
    );
  }
}

extension ForgetPasswordMapper on ForgetPasswordResponse {
  String toDomain() {
    return support.orEmpty();
  }
}

extension ServicesResponseMapper on ServicesResponse {
  Services toDomain() {
    return Services(
        id: id ?? Constant.zero,
        image: image.orEmpty(),
        title: title.orEmpty());
  }
}

extension BannersResponseMapper on BannersResponse {
  BannersAd toDomain() {
    return BannersAd(
      id: id ?? Constant.zero,
      image: image.orEmpty(),
      title: title.orEmpty(),
      link: link.orEmpty(),
    );
  }
}

extension StoresResponseMapper on StoresResponse {
  Stores toDomain() {
    return Stores(
        id: id ?? Constant.zero,
        image: image.orEmpty(),
        title: title.orEmpty());
  }
}

extension HomeResponseMapper on HomeResponse {
  Home toDomain() {
    List<Services> services = (this
                .data
                ?.servicesResponse
                ?.map((servicesResponse) => servicesResponse.toDomain()) ??
            const Iterable.empty())
        .cast<Services>()
        .toList();
    // hena b2olo hat el services kolha 7otha f list hygebha ezay ?
    // hygeb el data eli gowa HomeResponse w ygeb el ServicesResponse eli gowaha y7otha f map w ay service response dakhla y3melha toDomain()
    // in case en el data gaya b null hab3at empty list of services

    List<BannersAd> banners = (this
                .data
                ?.bannersResponse
                ?.map((bannerResponse) => bannerResponse.toDomain()) ??
            const Iterable.empty())
        .cast<BannersAd>()
        .toList();

    List<Stores> stores = (this
                .data
                ?.storesResponse
                ?.map((storesResponse) => storesResponse.toDomain()) ??
            const Iterable.empty())
        .cast<Stores>()
        .toList();

    var data = HomeData(services: services, bannersAd: banners, stores: stores);
    return Home(data);
  }
}

extension StoreDetailsResponseMapper on StoreDetailsResponse {
  StoreDetails toDomain() {
    return StoreDetails(
      id: id ?? Constant.zero,
      image: image.orEmpty(),
      about: about.orEmpty(),
      details: details.orEmpty(),
      services: details.orEmpty(),
      title: title.orEmpty(),
    );
  }
}
