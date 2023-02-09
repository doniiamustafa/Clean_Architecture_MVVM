// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:developer';

import 'package:clean_architecture/data/failures/failure.dart';
import 'package:clean_architecture/domain/models/models.dart';
import 'package:clean_architecture/domain/repository/repository.dart';
import 'package:clean_architecture/domain/usecases/base_usecase.dart';
import 'package:dartz/dartz.dart';

class HomeDataUseCase implements BaseUseCase<void, Home> {
  final Repository repository;
  HomeDataUseCase(this.repository);
  @override
  Future<Either<Failure, Home>> execute(void input) async {
    return await repository.getHomeData();
  }
}
