import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voie_writer/constant/app_color.dart';

import '../../logic/cubit/home_page/home_cubit.dart';
import '../../logic/cubit/voice_text/voice_text_cubit.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 4.h,
      color: AppColor.appBarColor,
      height: 62.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: BlocBuilder<HomeCubit, int>(
              builder: (context, state) => Icon(
                state == 0 ? Icons.person : Icons.person_outline,
                size: 30.w,
                color: AppColor.appBarTextColor,
              ),
            ),
            onPressed: () => context.read<HomeCubit>().changePage(0),
          ),
          const SizedBox(width: 40),
          IconButton(
            icon: BlocBuilder<HomeCubit, int>(
              builder: (context, state) => Icon(
                state == 2 ? Icons.home : Icons.home_outlined,
                size: 30.w,
                color: AppColor.appBarTextColor,
              ),
            ),
            onPressed: () {

                  context.read<HomeCubit>().changePage(2);
         context.read<VoiceTextCubit>().fetchVoiceList();
            },
          ),
        ],
      ),
    );
  }
}
