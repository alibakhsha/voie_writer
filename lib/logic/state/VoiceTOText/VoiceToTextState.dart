import 'package:equatable/equatable.dart';
import '../../../data/models/voice_to_text_model.dart';

abstract class VoiceTextState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VoiceTextInitial extends VoiceTextState {}

class VoiceTextLoading extends VoiceTextState {}

class VoiceTextLoaded extends VoiceTextState {
  final List<VoiceToTextModel> voices;
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