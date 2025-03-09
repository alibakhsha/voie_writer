import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:just_audio/just_audio.dart';
import '../../../data/services/api_service.dart';
import '../../../data/models/voice_to_text_model.dart';

enum VoiceState {
  idle,
  selecting,
  selected,
  processing,
  error,
  uploading,
  uploaded,
  conversionSuccess,
}

class VoiceCubit extends Cubit<VoiceState> {
  final ApiService _apiService;
  String? selectedFilePath;
  String? fileName;
  Duration? fileDuration;
  final AudioPlayer _audioPlayer = AudioPlayer();
  VoiceToTextModel? convertedText;

  VoiceCubit(this._apiService) : super(VoiceState.idle);

  Future<void> pickAudioFile() async {
    if (!await _requestPermission()) {
      emit(VoiceState.error);
      return;
    }

    emit(VoiceState.selecting);
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result?.files.single.path != null) {
      selectedFilePath = result!.files.single.path!;
      fileName = result.files.single.name;
      emit(VoiceState.selected);
      await _extractDuration(selectedFilePath!);
    } else {
      emit(VoiceState.idle);
    }
  }

  Future<bool> _requestPermission() async {
    int androidVersion = await _getAndroidVersion();
    PermissionStatus status = (Platform.isAndroid && androidVersion >= 33)
        ? await Permission.audio.request()
        : await Permission.storage.request();
    return status.isGranted;
  }

  Future<void> _extractDuration(String filePath) async {
    try {
      await _audioPlayer.setFilePath(filePath);
      fileDuration = _audioPlayer.duration;
      emit(VoiceState.selected);
    } catch (_) {
      fileDuration = null;
      emit(VoiceState.error);
    }
  }

  Future<int> _getAndroidVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt;
  }

  Future<void> uploadVoiceFile() async {
    if (selectedFilePath == null) {
      print("No file selected!");
      return;
    }

    emit(VoiceState.uploading);
    try {
      var response = await _apiService.uploadVoiceToText(selectedFilePath!);
      if (response != null) {
        convertedText = response;
        emit(VoiceState.conversionSuccess);
        print("File uploaded and converted successfully: ${response.transcript}");
      } else {
        emit(VoiceState.error);
      }
    } catch (e) {
      emit(VoiceState.error);
      print("Upload Error: $e");
    }
  }
}