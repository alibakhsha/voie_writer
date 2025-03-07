
import 'package:device_info_plus/device_info_plus.dart';


class DeviceUtils {
  static Future<String?> getDeviceId() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print("Device ID: ${androidInfo.id}"); // برای دیباگ
      return androidInfo.id ?? "test5678"; // اگه null بود، یه مقدار تستی
    } catch (e) {
      print("خطا در گرفتن شناسه دستگاه: $e");
      return "test5678"; // مقدار تستی برای شبیه‌ساز
    }
  }
}

