class OnboardingState {
  final int pageIndex;
  final bool isRegistering; // در حال ثبت‌نام
  final bool isRegistered; // ثبت‌نام موفق
  final String? registrationMessage; // پیام خطا یا موفقیت

  OnboardingState({
    this.pageIndex = 0,
    this.isRegistering = false,
    this.isRegistered = false,
    this.registrationMessage,
  });

  OnboardingState copyWith({
    int? pageIndex,
    bool? isRegistering,
    bool? isRegistered,
    String? registrationMessage,
  }) {
    return OnboardingState(
      pageIndex: pageIndex ?? this.pageIndex,
      isRegistering: isRegistering ?? this.isRegistering,
      isRegistered: isRegistered ?? this.isRegistered,
      registrationMessage: registrationMessage ?? this.registrationMessage,
    );
  }
}