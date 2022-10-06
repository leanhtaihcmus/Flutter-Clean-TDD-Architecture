import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  const NumberTrivia(this.text, this.number);

  final String text;
  final int number;

  @override
  List<Object?> get props => [text, number];
}
