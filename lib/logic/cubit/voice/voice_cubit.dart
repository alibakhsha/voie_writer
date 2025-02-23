import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:just_audio/just_audio.dart';

enum VoiceState { idle, selecting, processing, selected, error }

class VoiceCubit extends Cubit<VoiceState> {
  String? selectedFilePath;
  String? fileName;
  Duration? fileDuration;
  final AudioPlayer _audioPlayer = AudioPlayer();

  VoiceCubit() : super(VoiceState.idle);

  Future<void> pickAudioFile() async {
    int androidVersion = await _getAndroidVersion();

    PermissionStatus status;
    if (Platform.isAndroid && androidVersion >= 33) {
      status = await Permission.audio.request();
    } else {
      status = await Permission.storage.request();
    }

    if (!status.isGranted) {
      emit(VoiceState.error);
      return;
    }

    emit(VoiceState.selecting);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.single.path != null) {
      selectedFilePath = result.files.single.path!;
      fileName = result.files.single.name;

      await _extractDuration(selectedFilePath!);

      emit(VoiceState.processing);
      await Future.delayed(Duration(seconds: 3));
      emit(VoiceState.selected);
    } else {
      emit(VoiceState.idle);
    }
  }

  Future<void> _extractDuration(String filePath) async {
    try {
      await _audioPlayer.setFilePath(filePath);
      fileDuration = _audioPlayer.duration;
    } catch (e) {
      fileDuration = null;
    }
  }

  Future<int> _getAndroidVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt;
  }
}
