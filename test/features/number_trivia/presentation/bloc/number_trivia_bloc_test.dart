import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/core/util/input_converter.mocks.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.mocks.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.mocks.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/bloc/number_trivia_bloc.dart';

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('inititalState should be empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    final tNumberParsed = int.parse(tNumberString);
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should call the InputConverter to validate and convert the string to unsigned integer',
      setUp: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      verify: (bloc) =>
          verify(mockInputConverter.stringToUnsignedInteger(tNumberString)),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emmit [Error] when the input is invalid',
      setUp: () {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(
        const GetTriviaForConcreteNumber(tNumberString),
      ),
      expect: () => [
        // The inital state is always emitted first
        Empty(),
        Loading(),
        const Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get data from the concrete use case',
      build: () => bloc,
      setUp: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      verify: (bloc) =>
          verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed))),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emmit [Loading, Loaded] when data is gotten successfully',
      build: () => bloc,
      setUp: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () => <NumberTriviaState>[
        Empty(),
        Loading(),
        const Loaded(trivia: tNumberTrivia),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emmit [Loading, Error] when getting data fails',
      build: () => bloc,
      setUp: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () => <NumberTriviaState>[
        Empty(),
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emmit [Loading, Error] with a proper message for the error when getting data fails',
      build: () => bloc,
      setUp: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () => <NumberTriviaState>[
        Empty(),
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    blocTest(
      'should get data from the random use case',
      build: () => bloc,
      setUp: () => when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia)),
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      verify: (bloc) => verify(mockGetRandomNumberTrivia(NoPrams())),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () => bloc,
      setUp: () => when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia)),
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => <NumberTriviaState>[
        Empty(),
        Loading(),
        const Loaded(trivia: tNumberTrivia),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails',
      build: () => bloc,
      setUp: () => when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure())),
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => <NumberTriviaState>[
        Empty(),
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () => bloc,
      setUp: () => when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure())),
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => <NumberTriviaState>[
        Empty(),
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });
}
