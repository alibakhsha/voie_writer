import '../data/services/api_service.dart';
import '../data/models/JwtToken.dart';

class DeviceRegistration {
  final ApiService _apiService;

  DeviceRegistration(this._apiService);


  Future<Map<String, dynamic>?> createUser(String deviceId) async {
    try {
      final result = await _apiService.createUserWithDeviceId(deviceId);
      return result;
    } catch (e) {
      return null;
    }
  }


  Future<JwtToken?> authenticateDevice(String deviceId) async {
    try {
      final result = await _apiService.registerDeviceId(deviceId);
      return result;
    } catch (e) {
      return null;
    }
  }
}