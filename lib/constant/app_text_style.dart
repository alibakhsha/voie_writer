import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voie_writer/constant/app_color.dart';

class AppTextStyle{
  static TextStyle onBoardingText = TextStyle(
    fontFamily: 'b_nazanin',
    fontSize: 28.w,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
  static TextStyle appBarTitleText = TextStyle(
    fontFamily: 'b_nazanin',
    fontSize: 20.w,
    fontWeight: FontWeight.w400,
    color: AppColor.appBarTextColor,
  );
  static TextStyle voiceNameText = TextStyle(
    fontFamily: 'b_nazanin',
    fontSize: 14.w,
    fontWeight: FontWeight.w400,
    color: AppColor.appTextColor,
  );
  static TextStyle loadingText = TextStyle(
    fontFamily: 'b_nazanin',
    fontSize: 20.w,
    fontWeight: FontWeight.w400,
    color: AppColor.loadingColor,
  );
}