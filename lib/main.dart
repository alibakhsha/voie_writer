import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voie_writer/logic/cubit/bottom_nav/bottom_nav_cubit.dart';
import 'package:voie_writer/presentation/screens/home_screen.dart';
import 'package:voie_writer/presentation/screens/onboarding_screen.dart';
import 'logic/cubit/OnboardingPage_bloc/Onboarding_cubit.dart';
import 'gen/fonts.gen.dart';
import 'logic/cubit/voiceTexts/voiceText_cubit.dart';
import 'logic/cubit/search/search_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
            create: (context) => OnboardingCubit(PageController()),
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
          home: OnboardingScreen(),
        ),
      ),
    );
  }
}