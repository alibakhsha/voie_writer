import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voie_writer/data/services/api_service.dart';
import 'package:voie_writer/presentation/screens/home_screen.dart';
import 'package:voie_writer/presentation/screens/onboarding_screen.dart';

import 'logic/cubit/color_cubit/color_cubit.dart';
import 'logic/cubit/drop_down/drop_down_cubit.dart';
import 'logic/cubit/home_page/home_cubit.dart';
import 'logic/cubit/onboarding_cubit/onboarding_cubit.dart';
import 'logic/cubit/search/search_cubit.dart';
import 'logic/cubit/voice/voice_cubit.dart';
import 'logic/cubit/voice_text/voice_text_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
        BlocProvider<VoiceCubit>(create: (context) => VoiceCubit(ApiService())),
        BlocProvider<DropDownCubit>(create: (context) => DropDownCubit()),
        BlocProvider<ColorCubit>(create: (context) => ColorCubit()),
        BlocProvider<OnboardingCubit>(
          create: (context) => OnboardingCubit(PageController()),
        ),
        // BlocProvider<VoiceTextCubit>(
        //   create: (context) => VoiceTextCubit()..fetchVoiceTexts(),
        // ),
        BlocProvider(create: (context) => VoiceTextCubit(ApiService())),
        BlocProvider<SearchBloc>(create: (context) => SearchBloc()),
        // BlocProvider<MoveBloc>(create: (context) => MoveBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('fa'),
      home: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, child) {
          return BlocBuilder<OnboardingCubit, int>(
            builder: (context, state) {
              if (state >= 3) {
                return HomeScreen();
              } else {
                return OnboardingScreen();
              }
            },
          );
        },
      ),
    );
  }
}
