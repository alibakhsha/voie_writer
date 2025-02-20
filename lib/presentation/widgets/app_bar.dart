import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voie_writer/constant/app_color.dart';
import 'package:voie_writer/constant/app_text_style.dart';
import 'package:voie_writer/gen/assets.gen.dart';

PreferredSize appBar(String? title) {
  return PreferredSize(
    preferredSize: Size.fromHeight(58.h),

    child: AppBar(
      elevation: 0,
      backgroundColor: AppColor.appBarColor,
      leading: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 9.h, 12.w, 9.h),
        child: SvgPicture.asset(
          Assets.icons.wifiOff,
          width: 36.w,
          height: 36.h,
          color: AppColor.appBarTextColor,
        ),
      ),
      title: Center(child: Text(title!, style: AppTextStyle.appBarTitleText)),
      actions: [
        Padding(
          padding: EdgeInsets.fromLTRB(12.w, 9.h, 12.w, 9.h),
          child: Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(Assets.icons.iran.path)),
            ),
          ),
        ),
      ],
    ),
  );
}
