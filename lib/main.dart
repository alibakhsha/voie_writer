import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voie_writer/presentation/screens/home_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ScreenUtilInit(
      designSize: const Size(393,852),
      child: HomeScreen(),
    ),
  ));
}
