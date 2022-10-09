// ignore_for_file: unused_import, depend_on_referenced_packages
import '../models/number_trivia_model.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Annotation which generates the cat.mocks.dart library and the NumberTriviaLocalDataSource class.
@GenerateNiceMocks([MockSpec<NumberTriviaLocalDataSource>()])
import 'number_trivia_local_data_source.mocks.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaModel> getLatestNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}
