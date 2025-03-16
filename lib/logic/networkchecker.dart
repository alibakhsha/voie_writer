import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkChecker {
  Future<bool> isOnline() async {
    try {
      final result = await InternetConnectionChecker().hasConnection;
      return result;
    } catch (e) {
      return false;
    }
  }
}
