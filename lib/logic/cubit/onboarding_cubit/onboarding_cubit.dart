import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<int> {
  final PageController pageController;
  Timer? _timer;

  OnboardingCubit(this.pageController) : super(0) {
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel(); // تایمر قبلی رو لغو کن
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      int nextPage = state + 1;
      print("Timer triggered: Moving to page $nextPage (current: $state)");
      if (nextPage >= 3) {
        timer.cancel();
        emit(3); // به آخر خط برسه
      } else {
        emit(nextPage);
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

  @override
  Future<void> close() {
    _timer?.cancel();
    pageController.dispose(); // کنترلر رو اینجا dispose می‌کنیم
    return super.close();
  }
}