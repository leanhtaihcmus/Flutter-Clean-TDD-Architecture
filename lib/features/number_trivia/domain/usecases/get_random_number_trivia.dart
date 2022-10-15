// ignore_for_file: depend_on_referenced_packages

import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../repositories/number_trivia_repository.dart';

import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<GetRandomNumberTrivia>()])
import 'get_random_number_trivia.mocks.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoPrams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoPrams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
