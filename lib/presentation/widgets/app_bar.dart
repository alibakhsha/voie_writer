import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voie_writer/constant/app_color.dart';
import 'package:voie_writer/constant/app_text_style.dart';
import 'package:voie_writer/gen/assets.gen.dart';
import 'package:voie_writer/logic/cubit/drop_down/drop_down_cubit.dart';

PreferredSize appBar(String? title,BuildContext context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(62.h),

    child: AppBar(
      elevation: 0,
      backgroundColor: AppColor.appBarColor,
      leading: Text(""),
      flexibleSpace: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 9.h, 12.w, 9.h),
        child:
            title!.isNotEmpty
                ? Row(
                  children: [
                    SvgPicture.asset(
                      Assets.icons.wifiOff,
                      width: 36.w,
                      height: 36.h,
                      color: AppColor.appBarTextColor,
                    ),
                  ],
                )
                : GestureDetector(
              onTap: (){
                context.read<DropDownCubit>().toggleDropdown();
              },
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 27.w,
                        height: 27.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.icons.iran.path),
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text("تغییر زبان", style: AppTextStyle.appBarTitleText),
                      SizedBox(width: 5.w),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColor.appBarTextColor,
                        size: 24.w,
                      ),
                    ],
                  ),
                ),
      ),
      title:
          title.isNotEmpty
              ? Center(child: Text(title, style: AppTextStyle.appBarTitleText))
              : null,
      actions: [
        Padding(
          padding: EdgeInsets.fromLTRB(12.w, 9.h, 12.w, 9.h),
          child:
              title.isNotEmpty
                  ? Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.icons.iran.path),
                      ),
                    ),
                  )
                  : Text(
                    "تبدیل ویس به متن",
                    style: AppTextStyle.appBarTitleText,
                  ),
        ),
      ],
    ),
  );
}

