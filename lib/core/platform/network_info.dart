// ignore_for_file: unused_import, depend_on_referenced_packages
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Annotation which generates the cat.mocks.dart library and the NumberTriviaLocalDataSource class.
@GenerateNiceMocks([MockSpec<NetworkInfo>()])
import 'network_info.mocks.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}
