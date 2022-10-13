# Setup steps
- Install flutter following up to this document [https://docs.flutter.dev/get-started/install]
- Command to create flutter app with swift for iOS and Kotlin for Android platform to current directory
```
flutter create --org com.yourdomain -a kotlin -i swift .
```

# Setup Mockito Test
## Let's create mocks 
Mockito 5.0.0 supports Dart's new null safety language feature in Dart 2.12, primarily with code generation.

To use Mockito's generated mock classes, add a build_runner dependency in your package's pubspec.yaml file, under dev_dependencies; something like build_runner: ^1.11.0.

For alternatives to the code generation API, see the NULL_SAFETY_README.

Let's start with a Dart library, cat.dart:
```
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Annotation which generates the cat.mocks.dart library and the MockCat class.
@GenerateNiceMocks([MockSpec<Cat>()])
import 'cat.mocks.dart';

// Real class
class Cat {
  String sound() => "Meow";
  bool eatFood(String food, {bool? hungry}) => true;
  Future<void> chew() async => print("Chewing...");
  int walk(List<String> places) => 7;
  void sleep() {}
  void hunt(String place, String prey) {}
  int lives = 9;
}

void main() {
  // Create mock object.
  var cat = MockCat();
}
```
By annotating the import of a .mocks.dart library with @GenerateNiceMocks, you are directing Mockito's code generation to write a mock class for each "real" class listed, in a new library.

The next step is to run build_runner in order to generate this new library:
```
flutter pub run build_runner build
# OR
dart run build_runner build
```
build_runner will generate a file with a name based on the file containing the @GenerateNiceMocks annotation. In the above cat.dart example, we import the generated library as cat.mocks.dart.

The generated mock class, MockCat, extends Mockito's Mock class and implements the Cat class, giving us a class which supports stubbing and verifying.

## Tools
VSCode extensions [https://resocoder.com/2019/07/04/vs-code-extensions-every-flutter-developer-should-have/]

BLoC deeply explaination [https://resocoder.com/2019/06/12/bloc-library-updated-painless-state-management-for-flutter/]

Enable Guide Lines in Visual Studio Code with Flutter
```
GoTo VS code setting => search: PreviewUI => check Dart:Preview flutter Ui Guides and Dart: Preview Flutter Ui Guides Custom Tracking
```

Install extension of BLoC in vscode [https://marketplace.visualstudio.com/items?itemName=FelixAngelov.bloc]

## Learn about new BLoC Library
Read at [https://resocoder.com/2019/10/26/flutter-bloc-library-tutorial-1-0-0-stable-reactive-state-management/]

### Unit Test in BLoC
At this version I can't use test and expectLater from Mockito, so I installed library called bloc_test at [https://pub.dev/packages/bloc_test]

Here's example of BLoC unit test with list of expectLater
```
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
    const Error(message: INVALID_INPUT_FAILURE_MESSAGE),
  ],
);
```
