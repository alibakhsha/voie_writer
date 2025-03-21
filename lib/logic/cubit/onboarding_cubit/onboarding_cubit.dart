import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voie_writer/data/services/api_service.dart';
import 'package:voie_writer/logic/device_registration.dart';

import '../../onboarding_logic.dart';
import '../../state/onboarding/Onboarding_state.dart';
import '../voice_text/voice_text_cubit.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final PageController pageController;

  // final OnboardingLogic _onboardingLogic;
  Timer? _timer;

  OnboardingCubit(this.pageController, {String? deviceId})
    : super(OnboardingState()) {
    _startAutoSlide();
    _registerDevice(deviceId!);
  }

  Future<bool> _isOnline() async {
    try {
      final result = await InternetConnectionChecker().hasConnection;
      return result;
    } catch (e) {
      return false;
    }
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      int nextPage = state.pageIndex + 1;
      print("\x1B[31m $nextPage \x1B[0m");
      if (nextPage >= 3) {
        timer.cancel();
        emit(state.copyWith(pageIndex: 3));
      } else {
        emit(state.copyWith(pageIndex: nextPage));
        if (pageController.hasClients) {
          pageController.animateToPage(
            nextPage,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  void stopAutoSlide() {
    _timer?.cancel();
  }

  Future<void> _registerDevice(String deviceId) async {
    try {
      final isOnline = await _isOnline();
      if (isOnline == true) {
        try {
          ApiService _apiService = ApiService();

          await _apiService.check_user(deviceId);
          emit(state.copyWith(isRegistered: true));
        } catch (e) {
          emit(
            state.copyWith(
              isRegistering: false,
              registrationMessage: "خطا در ثبت دستگاه: $e",
            ),
          );
        }
      }
    } catch (e) {
      print("offline");
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    pageController.dispose();
    return super.close();
  }

  @override
  void onChange(Change<OnboardingState> change) {
    super.onChange(change);
  }
}
