import 'dart:convert';

import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import 'package:http/http.dart' as http;

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  const NumberTriviaRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final response = await client.get(
      Uri.parse('http://numbersapi.com/$number'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final response = await client.get(
      Uri.parse('http://numbersapi.com/random'),
      headers: {'Content-Type': 'application/json'},
    );

    if (200 == response.statusCode) {
      return NumberTriviaModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }
}
