import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/platform/network_info.mocks.dart';
import 'package:number_trivia/features/number_trivia/data/datasource/number_trivia_local_data_source.mocks.dart';
import 'package:number_trivia/features/number_trivia/data/datasource/number_trivia_remote_data_source.mocks.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';

void main() {
  NumberTriviaRepositoryImpl repository;
  MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  MockNumberTriviaLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

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
}
