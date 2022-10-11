import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/platform/network_info.mocks.dart';
import 'package:number_trivia/features/number_trivia/data/datasource/number_trivia_local_data_source.mocks.dart';
import 'package:number_trivia/features/number_trivia/data/datasource/number_trivia_remote_data_source.mocks.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  const tNumber = 1;
  const tNumberTriviaModel =
      NumberTriviaModel(text: 'test trivia', number: tNumber);
  const NumberTrivia tNumberTrivia = tNumberTriviaModel;

  void runTestsOnline(Function body) {
    group('device is online', () {
      // This setUp applies only to the 'device is online' group
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      // Run the body
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      // This setUp applies only to the 'device is offline' group
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      // Run the body
      body();
    });
  }

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    test('should check if device is online', () {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successfully',
          () async {
        // arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successfully',
          () async {
        // arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessfully',
          () async {
        // arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return latest locally cached data when the cached data is present',
          () async {
        // arrange
        when(mockLocalDataSource.getLatestNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLatestNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        // arrange
        when(mockLocalDataSource.getLatestNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLatestNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    test('should check if device is online', () {
      // arrage
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getRandomNumberTrivia();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successfully',
          () async {
        // arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'shoule cache the data locally when the call to remote data source is successfully',
          () async {
        // arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getRandomNumberTrivia();
        // assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return ServerFailure when the call to remote data source is unsuccessfully',
          () async {
        // arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // arrange
        when(mockLocalDataSource.getLatestNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLatestNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        // arrange
        when(mockLocalDataSource.getLatestNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLatestNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
