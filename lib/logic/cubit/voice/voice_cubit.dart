import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:just_audio/just_audio.dart';
import '../../../data/models/HighlightedText.dart';
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

  Future<String?> pickAudioFile() async {
    if (!await _requestPermission()) {
      emit(VoiceState.error);
      return null;
    }

    emit(VoiceState.selecting);
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result?.files.single.path != null) {
      selectedFilePath = result!.files.single.path!;

      fileName = result.files.single.name;
      fileDuration = await _extractDuration(selectedFilePath!);

      emit(VoiceState.selected);
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

  Future<Duration?> _extractDuration(String filePath) async {
    try {
      await _audioPlayer.setFilePath(filePath);
      fileDuration = _audioPlayer.duration;


      return fileDuration;
    } catch (_) {
      fileDuration = null;

      return null;
    }
  }

  Future<int> _getAndroidVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt;
  }

  Future<void> uploadVoiceFile({String? title}) async {
    emit(VoiceState.processing);
    if (selectedFilePath == null) {
      print("No file selected!");
      return;
    }

    // emit(VoiceState.uploading);
    try {
      var response = await _apiService.uploadVoiceToText(selectedFilePath!,title);
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


  Future<void> saveToFile(HighlightedText highlightedText) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/highlighted_text.json');
    final jsonString = jsonEncode(highlightedText.toJson());
    await file.writeAsString(jsonString);
    print('فایل با موفقیت ذخیره شد: ${file.path}');
  }






}