import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../features/number_trivia/domain/entities/number_trivia.dart';

// ignore_for_file: unused_import, depend_on_referenced_packages
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Annotation which generates the cat.mocks.dart library and the NumberTriviaLocalDataSource class.
@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])
import 'number_trivia_repository.mocks.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
