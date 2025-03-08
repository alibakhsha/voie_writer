import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voie_writer/logic/cubit/bottom_nav/bottom_nav_cubit.dart';
import 'package:voie_writer/presentation/screens/home_screen.dart';
import 'package:voie_writer/presentation/screens/onboarding_screen.dart';
import 'package:voie_writer/utils/device_utils.dart';
import 'logic/cubit/OnboardingPage/Onboarding_cubit.dart';
import 'gen/fonts.gen.dart';
import 'logic/cubit/voiceTexts/voiceText_cubit.dart';
import 'logic/cubit/search/search_cubit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'logic/models/VoiceToText/get_list_voice.dart';
import 'package:go_router/go_router.dart';

final GoRouter router =GoRouter(
  routes: [
    GoRoute(path: "/",builder: (context,state){
      final String? deviceId = state.extra as String?;
      return OnboardingScreen(deviceId: deviceId);
    }),
    GoRoute(path: "/home",builder: (context,state)=>HomeScreen())
  ]
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GetListVoiceAdapter());
  await Hive.openBox<GetListVoice>('voice_texts');
  String? deviceId = await DeviceUtils.getDeviceId();
  runApp(MyApp(deviceId: deviceId));
}

class MyApp extends StatelessWidget {
  final String? deviceId;
  MyApp({this.deviceId}) ;

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
              return OnboardingCubit(PageController(),deviceId: deviceId);
            },
          ),
          BlocProvider<VoiceTextCubit>(
            create: (context) => VoiceTextCubit()..fetchVoiceTexts(),
          ),
          BlocProvider<SearchCubit>(
            create: (context) => SearchCubit(),
          ),
          BlocProvider<MoveCubit>(
            create: (context) => MoveCubit(),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: FontFamily.bNazanin),
        ),
      ),
    );
  }
}