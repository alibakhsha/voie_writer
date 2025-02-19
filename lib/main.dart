import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voie_writer/logic/cubit/home_page/home_cubit.dart';
import 'package:voie_writer/presentation/screens/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder:
            (context, child) => MultiBlocProvider(
              providers: [
                BlocProvider<HomeCubit>(
                  create: (context) => HomeCubit(),
                ),
              ],
              child: HomeScreen(),
            ),
      ),
    ),
  );
}
