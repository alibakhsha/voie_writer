import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voie_writer/presentation/screens/profile_screen.dart';
import 'package:voie_writer/presentation/screens/recorder_voice_screen.dart';

import '../../constant/app_color.dart';
import '../../gen/assets.gen.dart';
import '../../logic/cubit/home_page/home_cubit.dart';
import '../../logic/cubit/voice/voice_cubit.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_nav.dart';
import 'main_home_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> pages = [
    ProfileScreen(),
    RecorderVoiceScreen(),
    MainHomeScreen(),
  ];

  final List<String> pageTitles = ["voice_writer", "", "voice_writer"];

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.watch<HomeCubit>(); // مقدار `HomeCubit` را در متغیر ذخیره کن
    final currentPageIndex = homeCubit.state;

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColor.appBackgroundColor,
        appBar: appBar(pageTitles[currentPageIndex], context),
        body: pages[currentPageIndex],
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
          context.read<VoiceCubit>().uploadVoiceFile();
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
