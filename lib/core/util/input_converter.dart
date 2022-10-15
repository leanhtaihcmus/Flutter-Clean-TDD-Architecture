// ignore_for_file: depend_on_referenced_packages

import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';

import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<InputConverter>()])
import 'input_converter.mocks.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      return Right(int.parse(str));
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
