// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voie_writer/logic/cubit/bottom_nav/bottom_nav_cubit.dart';
import 'package:voie_writer/presentation/screens/home_screen.dart';
import 'package:voie_writer/presentation/screens/onboarding_screen.dart';
import 'package:voie_writer/utils/device_utils.dart';
import 'logic/cubit/OnboardingPage_bloc/Onboarding_cubit.dart';
import 'gen/fonts.gen.dart';
import 'logic/cubit/voiceTexts/voiceText_cubit.dart';
import 'logic/cubit/search/search_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? deviceId = await DeviceUtils.getDeviceId();
  runApp(MyApp(deviceId: deviceId));
}

class MyApp extends StatelessWidget {
  final String? deviceId;
  MyApp({this.deviceId}) {
    print("MyApp initialized with deviceId: $deviceId");
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider<BottomNavCubit>(
            create: (context) => BottomNavCubit(),
          ),
          BlocProvider<OnboardingCubit>(
            create: (context) {
              print("Creating OnboardingCubit with deviceId: $deviceId");
              return OnboardingCubit(PageController(),deviceId: deviceId);
            },
          ),
          BlocProvider<VoiceTextCubit>(
            create: (context) => VoiceTextCubit()..fetchVoiceTexts(),
          ),
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(),
          ),
          BlocProvider<MoveBloc>(
            create: (context) => MoveBloc(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: FontFamily.bNazanin),
          home: OnboardingScreen(deviceId: deviceId),
        ),
      ),
    );
  }
}