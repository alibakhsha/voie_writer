import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voie_writer/logic/cubit/drop_down/drop_down_cubit.dart';
import 'package:voie_writer/logic/cubit/home_page/home_cubit.dart';
import 'package:voie_writer/presentation/screens/home_screen.dart';

import 'logic/cubit/voice/voice_cubit.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder:
            (context, child) => MultiBlocProvider(
              providers: [
                BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
                BlocProvider<VoiceCubit>(create: (context) => VoiceCubit()),
                BlocProvider<DropDownCubit>(
                  create: (context) => DropDownCubit(),
                ),
              ],
              child: HomeScreen(),
            ),
      ),
    ),
  );
}
