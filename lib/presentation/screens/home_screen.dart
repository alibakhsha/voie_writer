import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voie_writer/constant/app_color.dart';
import 'package:voie_writer/gen/assets.gen.dart';
import 'package:voie_writer/presentation/screens/main_home_screen.dart';
import 'package:voie_writer/presentation/screens/profile_screen.dart';
import 'package:voie_writer/presentation/screens/recorder_voice_screen.dart';
import 'package:voie_writer/presentation/widgets/app_bar.dart';
import 'package:voie_writer/presentation/widgets/bottom_nav.dart';

import '../../logic/cubit/home_page/home_cubit.dart';
import '../../logic/cubit/voice/voice_cubit.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> pages = [
    ProfileScreen(),
    RecorderVoiceScreen(),
    MainHomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColor.appBackgroundColor,
        appBar: appBar("نام اپ"),
        body: BlocBuilder<HomeCubit, int>(
          builder: (context, state) => pages[state],
        ),
        bottomNavigationBar: const BottomNav(),
        floatingActionButton: _buildFloatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return SizedBox(
      width: 72.w,
      height: 72.h,
      child: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          context.read<HomeCubit>().changePage(1);
          context.read<VoiceCubit>().pickAudioFile();
        },
        backgroundColor: AppColor.appBarColor,
        shape: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            Assets.icons.mic,
            color: AppColor.appBarTextColor,
            width: 38.w,
            height: 52.h,
          ),
        ),
      ),
    );
  }
}
