import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voie_writer/constant/app_color.dart';
import 'package:voie_writer/gen/assets.gen.dart';
import 'package:voie_writer/presentation/widgets/app_bar.dart';
import 'package:voie_writer/presentation/widgets/bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColor.appBackgroundColor,
        appBar: appBar("نام اپ"),
        body: Container(),
        bottomNavigationBar: BottomNav(),
        floatingActionButton: SizedBox(
          width: 72.w,
          height: 72.h,
          child: FloatingActionButton(
            elevation: 0,
            onPressed: () {},
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
