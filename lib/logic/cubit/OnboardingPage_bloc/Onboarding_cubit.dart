import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../onboarding_logic.dart';
import '../../state/onboarding/Onboarding_state.dart';




class OnboardingCubit extends Cubit<OnboardingState> {
  final PageController pageController;
  final OnboardingLogic _onboardingLogic;
  Timer? _timer;

  OnboardingCubit(this.pageController, {String? deviceId})
      : _onboardingLogic = OnboardingLogic(pageController, deviceId: deviceId),
        super(OnboardingState()) {
    _startAutoSlide();
    _registerDevice();
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      int nextPage = state.pageIndex + 1;
      if (nextPage >= 3) {
        timer.cancel();
        emit(OnboardingState(
          pageIndex: 3,

        ));
      } else {
        emit(OnboardingState(
          pageIndex: nextPage,

        ));
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

  Future<void> _registerDevice() async {
    emit(OnboardingState(
      pageIndex: state.pageIndex,
    ));
    // final String result = await _onboardingLogic.registerDevice();
    emit(OnboardingState(
      pageIndex: state.pageIndex,
      // registrationMessage: result,
    ));
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
    print(change); // برای دیباگ
  }
}