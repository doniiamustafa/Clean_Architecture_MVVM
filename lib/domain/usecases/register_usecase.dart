// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:clean_architecture/data/failures/failure.dart';
import 'package:clean_architecture/data/requests/requests.dart';
import 'package:clean_architecture/domain/models/models.dart';
import 'package:clean_architecture/domain/repository/repository.dart';
import 'package:clean_architecture/domain/usecases/base_usecase.dart';
import 'package:dartz/dartz.dart';

class RegisterUseCase
    implements BaseUseCase<RegisterUseCaseInput, Authentication> {
  final Repository repository;
  RegisterUseCase(this.repository);
  @override
  Future<Either<Failure, Authentication>> execute(
      RegisterUseCaseInput input) async {
    return await repository.register(RegisterRequest(
        input.email,
        input.password,
        input.userName,
        input.mobileCode,
        input.mobileNumber,
        input.profilePicture));
  }
}

class RegisterUseCaseInput {
  String userName;
  String email;
  String password;
  String mobileCode;
  String mobileNumber;
  String profilePicture;
  RegisterUseCaseInput(this.userName, this.email, this.password,
      this.mobileNumber, this.mobileCode, this.profilePicture);
}
