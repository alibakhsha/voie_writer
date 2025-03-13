import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voie_writer/data/services/api_service.dart';
import 'package:voie_writer/logic/device_registration.dart';

import '../../onboarding_logic.dart';
import '../../state/onboarding/Onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {


  final PageController pageController;
  // final OnboardingLogic _onboardingLogic;
  Timer? _timer;

  OnboardingCubit(this.pageController, {String? deviceId})
      // : _onboardingLogic = OnboardingLogic(pageController, deviceId: deviceId),
      :  super(OnboardingState()) {
    _startAutoSlide();
    _registerDevice(deviceId!);
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      int nextPage = state.pageIndex + 1;
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
    // emit(state.copyWith(isRegistering: true)); // شروع ثبت‌نام
    try {
      ApiService _apiService = ApiService();



      final result1 = await _apiService.check_user(deviceId);
      if (result1){
        var result2 = await _apiService.registerDeviceId(deviceId);
      }
      // var gg = result2?["refresh"];
      // final result1 = await _apiService.createUserWithDeviceId(deviceId);
      print('object');


      // await _onboardingLogic.registerDevice();
      // emit(state.copyWith(
      //   isRegistering: false,
      //   isRegistered: true,
      //   registrationMessage: "دستگاه با موفقیت ثبت شد",
      // ));
    } catch (e) {
      emit(state.copyWith(
        isRegistering: false,
        isRegistered: false,
        registrationMessage: "خطا در ثبت دستگاه: $e",
      ));
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
    print(change);
  }
}