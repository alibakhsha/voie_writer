



import '../data/services/api_service.dart';
import '../data/models/JwtToken.dart';

class DeviceRegistration {
  final ApiService _apiService;

  DeviceRegistration(this._apiService);


  Future<Map<String, dynamic>?> createUser(String deviceId) async {
    try {
      print("Sending create user request with deviceId: $deviceId");
      final result = await _apiService.createUserWithDeviceId(deviceId);
      print("Create user response: $result");
      return result;
    } catch (e) {
      print('hata dar sabte karbar: $e');
      return null;
    }
  }


  Future<JwtToken?> authenticateDevice(String deviceId) async {
    try {
      print("Sending auth request with deviceId: $deviceId");
      final result = await _apiService.registerDeviceId(deviceId);
      print("Auth response: $result");
      return result;
    } catch (e) {
      print('khata dar ehraz hoviat: $e');
      return null;
    }
  }
}