import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:voie_writer/constant/app_color.dart';
import '../../logic/cubit/OnboardingPage/Onboarding_cubit.dart';
import '../../logic/state/onboarding/Onboarding_state.dart';


class OnboardingScreen extends StatelessWidget {
  final String? deviceId;

  OnboardingScreen({this.deviceId}) {
    print("OnboardingScreen initialized with deviceId: $deviceId");
  }

  final List<Map<String, String>> _onboardingData = [
    {
      "image": "assets/icons/Onboarding1.svg",
      "description": "به اپلیکیش تبدیل ویس به متن خوش آمدید",
    },
    {
      "image": "assets/icons/Onboarding2.svg",
      "description": "ویس بده متنش رو تحویل بگیر ",
    },
    {
      "image": "assets/icons/Onboarding3.svg",
      "description": "جزوه ها رو براساس موضوع دسته بندی کن",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state.pageIndex == 3) {
          context.read<OnboardingCubit>().stopAutoSlide();
         context.replace('/home');
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(color:AppColor.appBarTextColor),
            BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                return PageView.builder(
                  controller: context.read<OnboardingCubit>().pageController,
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    return _buildOnboardingPage(
                      _onboardingData[index]["image"]!,
                      _onboardingData[index]["description"]!,
                      state.pageIndex,
                    );
                  },
                );
              },
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_onboardingData.length, (index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        width: 12.w,
                        height: 12,
                        decoration: BoxDecoration(
                          color: state.pageIndex == index
                              ? AppColor.appBarColor
                              : Color(0x7605445e),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(String image, String description, int currentPage) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              image,
              width:  500.w,
              height: 500.w,
            ),
          ),
          Positioned(
            top: 620.w,
            right:  2,
            left:  2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 28.w,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'b_nazanin',
                  height: 1.w,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}