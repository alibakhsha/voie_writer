import 'package:equatable/equatable.dart';
import '../models/VoiceToText/get_list_voice.dart';

abstract class VoiceTextState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VoiceTextInitial extends VoiceTextState {}

class VoiceTextLoading extends VoiceTextState {}

class VoiceTextLoaded extends VoiceTextState {
  final List<GetListVoice> voices;

  VoiceTextLoaded(this.voices);

  @override
  List<Object?> get props => [voices];
}

class VoiceTextError extends VoiceTextState {
  final String message;

  VoiceTextError(this.message);

  @override
  List<Object?> get props => [message];
}