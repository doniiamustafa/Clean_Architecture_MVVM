import 'package:clean_architecture/data/failures/failure.dart';
import 'package:clean_architecture/data/requests/requests.dart';
import 'package:clean_architecture/domain/models/models.dart';
import 'package:dartz/dartz.dart';

abstract class Repository {
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest);
  Future<Either<Failure, String>> forgetPassword(String email);
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest);
  Future<Either<Failure, Home>> getHomeData();
}
