import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkChecker {
  Future<bool> isOnline() async {
    try {
      final result = await InternetConnectionChecker().hasConnection;
      if (result) {
        print("اتصال به اینترنت تأیید شد");
      } else {
        print("دستگاه آفلاین است");
      }
      return result;
    } catch (e) {
      print("خطا در چک کردن اینترنت: $e");
      return false;
    }
  }
}