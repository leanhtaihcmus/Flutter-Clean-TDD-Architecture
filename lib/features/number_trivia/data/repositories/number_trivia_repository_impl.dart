import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../../domain/entities/number_trivia.dart';
import '../datasource/number_trivia_local_data_source.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    // Finally doing something with the value of isConnected
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia =
            await remoteDataSource.getConcreteNumberTrivia(number);
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLatestNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await remoteDataSource.getRandomNumberTrivia();
        await localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLatestNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
