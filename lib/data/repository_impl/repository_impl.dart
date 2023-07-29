
import 'package:clean_architecture/data/data_source/local_data_source.dart';
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
  final LocalDataSource localDataSource;

  RepositoryImpl(this.networkInfo, this.remoteDataSource, this.localDataSource);

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
          return Left(Failure(response.status ?? ResponseCode.DEFAULT,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (e) {
        return left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.register(registerRequest);
        if (response.status == ApiInternalStatus.SUCCESS) {
          // nafs el response bta3 el login howa bta3 el register
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
  Future<Either<Failure, Home>> getHomeData() async {
    // first i tried to get home response from cached data
    try {
      final response = await localDataSource.getHomeData();
      return Right(response.toDomain());
    } catch (cacheError) {
      // if the cache is not valid or empty i have to get home response from API
      if (await networkInfo.isConnected) {
        try {
          final response = await remoteDataSource.getHomeData();
          if (response.status == ApiInternalStatus.SUCCESS) {
            // store homeResponse in runtime cache
            localDataSource.storeHomeData(response);
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
  }

  @override
  Future<Either<Failure, StoreDetails>> getStoreDetails() async {
    try {
      final response = await localDataSource.getItemDetails();
      // hya gya response with data type StoreDetailsResponse
      // w ana 3iza aghyrha lel Store Details model fa hab3tha lel mapper 3lshan trga3 model zay ma el return type bta3 el function (model)
      return Right(response.toDomain());
    } catch (cacheError) {

      if (await networkInfo.isConnected) {
        try {
          final response = await remoteDataSource.getStoreDetails();
          if (response.status == ApiInternalStatus.SUCCESS) {
            localDataSource.storeItemDetails(response);
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
  }
}
