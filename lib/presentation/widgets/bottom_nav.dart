import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voie_writer/constant/app_color.dart';

import '../../logic/cubit/bottom_nav/bottom_nav_cubit.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.h,
      color: AppColor.appBarColor,
      height: 62.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: BlocBuilder<BottomNavCubit, int>(
              builder:
                  (context, state) => Icon(
                    state == 1? Icons.person_outlined: Icons.person,
                    size: 30.w,
                    color: AppColor.appBarTextColor,
                  ),
            ),
            onPressed: () => context.read<BottomNavCubit>().changeTab(0),
          ),
          SizedBox(width: 40),
          IconButton(
            icon: BlocBuilder<BottomNavCubit, int>(
              builder:
                  (context, state) => Icon(
                    state == 1? Icons.home: Icons.home_outlined,
                    size: 30.w,
                    color: AppColor.appBarTextColor,
                  ),
            ),
            onPressed: () => context.read<BottomNavCubit>().changeTab(1),
          ),
        ],
      ),
    );
  }
}
