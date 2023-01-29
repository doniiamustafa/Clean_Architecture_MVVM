// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:developer';

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
    log(" UseCase username ${input.userName}, password ${input.password}, email ${input.email}, mobileCode${input.mobileCode}, mobileNumber ${input.mobileNumber}");
    return await repository.register(RegisterRequest(
        email: input.email,
        password: input.password,
        userName: input.userName,
        mobileCode: input.mobileCode,
        mobileNumber: input.mobileNumber,
        profilePicture: input.profilePicture));
  }
}

class RegisterUseCaseInput {
  String userName;
  String email;
  String password;
  String mobileCode;
  String mobileNumber;
  String profilePicture;
  // lazem named parameters 3lshan el values matkhoshesh f b3d lma n3melha call
  RegisterUseCaseInput(
      {required this.userName,
      required this.password,
      required this.email,
      required this.mobileCode,
      required this.mobileNumber,
      required this.profilePicture});
}
