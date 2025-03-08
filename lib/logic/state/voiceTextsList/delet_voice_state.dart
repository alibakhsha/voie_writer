import 'package:equatable/equatable.dart';

import '../../models/VoiceToText/get_list_voice.dart';

abstract class DeleteVoiceState extends Equatable {
  @override
  List<Object?> get props => [];
}


class DeleteVoiceInitial extends DeleteVoiceState {}


class DeleteVoiceLoading extends DeleteVoiceState {}


class DeleteVoiceSuccess extends DeleteVoiceState {
  final List<GetListVoice>? updatedList;

  DeleteVoiceSuccess(this.updatedList);

  @override
  List<Object?> get props => [updatedList];
}


class DeleteVoiceFailure extends DeleteVoiceState {
  final String error;

  DeleteVoiceFailure(this.error);

  @override
  List<Object?> get props => [error];
}