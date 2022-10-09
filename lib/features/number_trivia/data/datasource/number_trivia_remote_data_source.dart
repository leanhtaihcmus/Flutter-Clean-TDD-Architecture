// ignore_for_file: unused_import, depend_on_referenced_packages
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Annotation which generates the cat.mocks.dart library and the NumberTriviaLocalDataSource class.
@GenerateNiceMocks([MockSpec<NumberTriviaRemoteDataSource>()])
import 'number_trivia_remote_data_source.mocks.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  // Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
