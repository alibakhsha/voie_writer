import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../logic/cubit/OnboardingPage_bloc/Onboarding_cubit.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
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
    return BlocProvider(
      create: (context) => OnboardingCubit(PageController()),
      child: BlocListener<OnboardingCubit, int>(
        listener: (context, state) {
          print("BlocListener state: $state");
          if (state == 3) {
            context.read<OnboardingCubit>().stopAutoSlide();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              Container(color: Color(0xffD4F1F4)),
              BlocBuilder<OnboardingCubit, int>(
                builder: (context, currentPage) {
                  return PageView.builder(
                    controller: context.read<OnboardingCubit>().pageController,
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return _buildOnboardingPage(
                        _onboardingData[index]["image"]!,
                        _onboardingData[index]["description"]!,
                        currentPage,
                      );
                    },
                  );
                },
              ),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: BlocBuilder<OnboardingCubit, int>(
                  builder: (context, currentPage) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_onboardingData.length, (index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          width: 12.w,
                          height: 12,
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? Color(0xff05445E)
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
              width: currentPage == 1 ? 408.w : 500.w,
              height: currentPage == 1 ? 408.w : 500.w,
            ),
          ),
          Positioned(
            top: currentPage == 1
                ? 600.w
                : currentPage == 0
                ? 620.w
                : 620.w,
            right: currentPage == 0 ? 1 : 2,
            left: currentPage == 0 ? 1 : 2,
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