import 'package:clean_architecture/domain/repository/repository.dart';
import 'package:clean_architecture/domain/usecases/base_usecase.dart';
import 'package:dartz/dartz.dart';

import '../../data/failures/failure.dart';
import '../models/models.dart';

class GetStoreDetailsUseCase implements BaseUseCase<void, StoreDetails> {
  final Repository repository;
  GetStoreDetailsUseCase(this.repository);
  @override
  Future<Either<Failure, StoreDetails>> execute(void input) async {
    return await repository.getStoreDetails();
  }
}
