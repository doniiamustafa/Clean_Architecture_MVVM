import 'package:clean_architecture/data/data_source/remote_data_source.dart';
import 'package:clean_architecture/data/failures/error_handler.dart';
import 'package:clean_architecture/data/mappers/mapper.dart';
import 'package:clean_architecture/data/network/network_info.dart';
import 'package:clean_architecture/domain/models/models.dart';
import 'package:clean_architecture/data/requests/requests.dart';
import 'package:clean_architecture/data/failures/failure.dart';
import 'package:clean_architecture/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

class RepositoryImpl implements Repository {
  final NetworkInfo networkInfo;
  final RemoteDataSource remoteDataSource;
  RepositoryImpl(this.networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.login(loginRequest);
        if (response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgetPassword(String email) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.forgetPassword(email);
        if (response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          return Left(Failure(response.status?? ResponseCode.DEFAULT,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (e) {
        return left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
