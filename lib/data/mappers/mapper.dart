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
