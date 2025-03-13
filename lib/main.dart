import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voie_writer/data/database/database_helper.dart';
import 'package:voie_writer/data/services/api_service.dart';
import 'package:voie_writer/presentation/screens/home_screen.dart';
import 'package:voie_writer/presentation/screens/onboarding_screen.dart';
import 'logic/cubit/color_cubit/color_cubit.dart';
import 'logic/cubit/drop_down/drop_down_cubit.dart';
import 'logic/cubit/home_page/home_cubit.dart';
import 'logic/cubit/onboarding_cubit/onboarding_cubit.dart';
import 'logic/cubit/voice/voice_cubit.dart';
import 'logic/cubit/voice_text/voice_text_cubit.dart';
import 'logic/cubit/search/search_cubit.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) {
        final String? deviceId = state.extra as String? ?? (context.findAncestorWidgetOfExactType<MyApp>() as MyApp?)?.deviceId;
        return BlocProvider(
          create: (context) => OnboardingCubit(PageController(), deviceId: deviceId),
          child: OnboardingScreen(deviceId: deviceId),
        );
      },
    ),
    GoRoute(path: "/home", builder: (context, state) => HomeScreen()),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? deviceId = await ApiService().getDeviceId();
  // deviceId = "test2";
  print("\x1B[31m deviceId1: $deviceId \x1B[0m");      // return throw Exception("Device ID is null");

  // DatabaseHelper.instance.database;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
        BlocProvider<VoiceCubit>(create: (context) => VoiceCubit(ApiService())),
        BlocProvider<DropDownCubit>(create: (context) => DropDownCubit()),
        BlocProvider<ColorCubit>(create: (context) => ColorCubit()),
        BlocProvider(create: (context) => VoiceTextCubit()),
        BlocProvider<SearchCubit>(create: (context) => SearchCubit()),
        BlocProvider<MoveCubit>(
          create: (context) => MoveCubit(),
        ),
      ],
      child: MyApp(deviceId: deviceId),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? deviceId;

  MyApp({this.deviceId});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) => MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        locale: const Locale('fa'),
      ),
    );
  }
}