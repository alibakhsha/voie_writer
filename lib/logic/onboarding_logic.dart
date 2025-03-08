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

  }

  Future<void> registerDevice() async {

    if (deviceId != null) {
      final tokenResult = await _deviceRegistration.authenticateDevice(deviceId!);

      if (tokenResult != null) {

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', tokenResult.access);
        await prefs.setString('refresh_token', tokenResult.refresh);


      }
    }

  }
}