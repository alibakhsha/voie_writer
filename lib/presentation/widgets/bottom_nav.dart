import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voie_writer/constant/app_color.dart';


class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 4.h,
      color: AppColor.appBarColor,
      height: 62.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              builder:
                  (context, state) => Icon(
                    state == 1 ? Icons.person_outlined : Icons.person,
                    size: 30.w,
                    color: AppColor.appBarTextColor,
                  ),
            ),
          ),
          IconButton(
              builder:
                  (context, state) => Icon(
                    state == 1 ? Icons.home : Icons.home_outlined,
                    size: 30.w,
                    color: AppColor.appBarTextColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
