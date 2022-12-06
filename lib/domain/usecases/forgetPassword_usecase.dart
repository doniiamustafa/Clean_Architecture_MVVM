import 'package:clean_architecture/data/failures/failure.dart';
import 'package:clean_architecture/domain/repository/repository.dart';
import 'package:clean_architecture/domain/usecases/base_usecase.dart';
import 'package:dartz/dartz.dart';

class ForgetPasswordUsecase implements BaseUseCase<String, String> {
  final Repository repository;
  ForgetPasswordUsecase(this.repository);
  @override
  Future<Either<Failure, String>> execute(String email) async {
    return await repository.forgetPassword(email);
  }
}
