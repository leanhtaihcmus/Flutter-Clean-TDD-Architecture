// ignore_for_file: depend_on_referenced_packages, unused_import

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mockito/annotations.dart';

import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../repositories/number_trivia_repository.dart';

@GenerateNiceMocks([MockSpec<GetConcreteNumberTrivia>()])
import 'get_concrete_number_trivia.mocks.dart';

class GetConcreteNumberTrivia extends UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
