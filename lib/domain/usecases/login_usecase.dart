// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:clean_architecture/data/failures/failure.dart';
import 'package:clean_architecture/data/requests/requests.dart';
import 'package:clean_architecture/domain/models/models.dart';
import 'package:clean_architecture/domain/repository/repository.dart';
import 'package:clean_architecture/domain/usecases/base_usecase.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Authentication> {
  final Repository repository;
  LoginUseCase(this.repository);
  @override
  Future<Either<Failure, Authentication>> execute(
      LoginUseCaseInput input) async {
    return await repository.login(LoginRequest(input.email, input.password));
  }
}

class LoginUseCaseInput {
  String email;
  String password;
  LoginUseCaseInput(this.email, this.password);
}
