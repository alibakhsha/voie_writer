// lib/logic/onboarding_logic.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'device_registration.dart';


class OnboardingLogic {
  final PageController pageController;
  final String? deviceId;
  final DeviceRegistration _deviceRegistration;

  OnboardingLogic(this.pageController, {this.deviceId})
      : _deviceRegistration = DeviceRegistration(ApiService()) {
    print("OnboardingLogic initialized with deviceId: $deviceId");
  }

  Future<String> registerDevice() async {

    if (deviceId != null) {
      final userResult = await _deviceRegistration.createUser(deviceId!);
      // if (userResult != null) {
      //   print("کاربر با موفقیت ثبت شد: $userResult");
      // } else {
      //   print("ثبت کاربر ناموفق بود,صبر کنید...");
      // }

      final tokenResult = await _deviceRegistration.authenticateDevice(deviceId!);

      if (tokenResult != null) {

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', tokenResult.access);
        await prefs.setString('refresh_token', tokenResult.refresh);

        return 'احراز هویت با موفقیت انجام شد!';
      } else {
        return 'خطا در احراز هویت! (ممکنه imei ثبت نشده باشه)';
      }
    }
    return 'نمی‌تونم شناسه دستگاه رو بگیرم!';
  }
}