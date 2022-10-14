// ignore_for_file: constant_identifier_names, depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:number_trivia/core/error/failures.dart';

import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);

        inputEither.fold(
          (falure) {
            emit(Empty());
            emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE));
          },
          (integer) async {
            emit(Empty());
            emit(Loading());
            final failureOrTrivia =
                await getConcreteNumberTrivia(Params(number: integer));
            failureOrTrivia.fold(
              (failure) => emit(Error(
                message: failure is ServerFailure
                    ? SERVER_FAILURE_MESSAGE
                    : CACHE_FAILURE_MESSAGE,
              )),
              (trivia) => emit(Loaded(trivia: trivia)),
            );
          },
        );
      }
    });
  }
}
