import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voie_writer/routes/rout_name.dart';
import '../logic/cubit/onboarding_cubit/onboarding_cubit.dart';
import '../main.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/onboarding_screen.dart';

initGoRouter() {
  return GoRouter(initialLocation: "/",routes: [
    GoRoute(
      name: RouteName.onboarding,
      path: "/",
      builder: (context, state) {
        final String? deviceId = state.extra as String? ?? (context.findAncestorWidgetOfExactType<MyApp>() as MyApp?)?.deviceId;
        return BlocProvider(
          create: (context) => OnboardingCubit(PageController(), deviceId: deviceId),
          child: OnboardingScreen(deviceId: deviceId),
        );
      },
    ),
    GoRoute(
        name: RouteName.home,
        path: "/home",
        builder: (context, state) => HomeScreen()),
  ]);
}