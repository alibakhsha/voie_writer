// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:voie_writer/constant/app_color.dart';
// import 'package:voie_writer/logic/cubit/voice/voice_cubit.dart';
// import 'package:voie_writer/presentation/widgets/app_bar.dart';
//
// class RecorderVoiceScreen extends StatelessWidget {
//   const RecorderVoiceScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: appBar(""),
//       // backgroundColor: AppColor.appBackgroundColor,
//       body: BlocBuilder<VoiceCubit, VoiceState>(
//         builder: (context, state) {
//           if (state == VoiceState.processing) {
//             return _loadingScreen();
//           } else if (state == VoiceState.selected) {
//             return _fileSelectedScreen(context);
//           } else {
//             return _mainContent(context);
//           }
//         },
//       ),
//     );
//   }
//
//   Widget _loadingScreen() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.autorenew, size: 50.w, color: Colors.blue),
//           SizedBox(height: 20.h),
//           Text("در حال پردازش فایل...", style: TextStyle(fontSize: 18.sp)),
//         ],
//       ),
//     );
//   }
//
//   Widget _fileSelectedScreen(BuildContext context) {
//     final voiceCubit = context.read<VoiceCubit>();
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.audiotrack, size: 50.w, color: Colors.green),
//           SizedBox(height: 20.h),
//           Text("فایل انتخاب شد:", style: TextStyle(fontSize: 18.sp)),
//           SizedBox(height: 10.h),
//           Text(
//             voiceCubit.selectedFilePath ?? "نامشخص",
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _mainContent(BuildContext context) {
//     return Center(
//       child: Text(
//         "برای انتخاب فایل صوتی روی میکروفون کلیک کنید",
//         style: TextStyle(fontSize: 18.sp),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:voie_writer/constant/app_color.dart';
import 'package:voie_writer/constant/app_text_style.dart';
import 'package:voie_writer/gen/assets.gen.dart';
import 'package:voie_writer/logic/cubit/voice/voice_cubit.dart';

import '../../logic/cubit/drop_down/drop_down_cubit.dart';

class RecorderVoiceScreen extends StatelessWidget {
  const RecorderVoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackgroundColor,
      body: Stack(
        children: [
          Expanded(
            child: BlocBuilder<VoiceCubit, VoiceState>(
              builder: (context, state) {
                if (state == VoiceState.processing) {
                  return _loadingScreen(context);
                } else {
                  return _fileSelectedScreen(context);
                }
              },
            ),
          ),
          BlocBuilder<DropDownCubit, bool>(
            builder: (context, isOpen) {
              return isOpen
                  ? Positioned(
                    left: 12.w,
                    right: 158.w,
                    child: _languageDropdown(context),
                  )
                  : SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _languageDropdown(BuildContext context) {
    List<String> languages = [
      "America",
      "Italian",
      "UK",
      "Canada",
      "German",
      "Turkey",
    ];

    return Container(
      width: 223.w,
      height: 366.h,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColor.appBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 1)],
      ),
      child: Column(
        children: [
          ...languages.map((lang) {
            return Column(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.icons.iran.path),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(lang, style: AppTextStyle.dropDownText),
                    ],
                  ),
                  onTap: () {
                    context.read<DropDownCubit>().toggleDropdown();
                  },
                ),
                Divider(height: 0, color: Color.fromRGBO(244, 244, 244, 1)),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _loadingScreen(BuildContext context) {
    final voiceCubit = context.read<VoiceCubit>();
    return Column(
      children: [
        SizedBox(height: 26.h),
        Container(
          width: 356.w,
          height: 70.h,
          decoration: BoxDecoration(
            color: AppColor.voiceContainerColor,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      voiceCubit.fileName!,
                      style: AppTextStyle.voiceNameText,
                    ),
                    Text(
                      voiceCubit.fileDuration.toString(),
                      style: AppTextStyle.voiceNameText,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  Assets.icons.microphone,
                  width: 24.w,
                  height: 24.h,
                  color: AppColor.appTextColor,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      Lottie.asset(
                        Assets.animation.renew,
                        width: 99.w,
                        height: 91.h,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        " در حال ساخت متن شما هستیم."
                        "لطفا منتظر بمانید hdhdhdhdghdghddhddgdhgdhgdghdghrehyryhr",
                        style: AppTextStyle.loadingText,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // صفحه نمایش فایل انتخابی
  Widget _fileSelectedScreen(BuildContext context) {
    final voiceCubit = context.read<VoiceCubit>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.audiotrack, size: 50.w, color: Colors.green),
          SizedBox(height: 20.h),
          Text("فایل انتخاب شد:", style: TextStyle(fontSize: 18.sp)),
          SizedBox(height: 10.h),
          Text(
            voiceCubit.selectedFilePath ?? "نامشخص",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // صفحه نمایش خطا در صورت رد دسترسی‌ها
  // Widget _errorScreen() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(Icons.error, size: 50.w, color: Colors.red),
  //         SizedBox(height: 20.h),
  //         Text(
  //           "❌ دسترسی رد شد!",
  //           style: TextStyle(fontSize: 18.sp, color: Colors.red),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // صفحه اصلی که دکمه انتخاب فایل صوتی را نشان می‌دهد
  // Widget _mainContent(BuildContext context) {
  //   return Center(
  //     child: ElevatedButton(
  //       onPressed: () {
  //         context
  //             .read<VoiceCubit>()
  //             .pickAudioFile(); // درخواست انتخاب فایل صوتی
  //       },
  //       child: Text(
  //         "برای انتخاب فایل صوتی روی این دکمه کلیک کنید",
  //         style: TextStyle(fontSize: 18.sp),
  //       ),
  //     ),
  //   );
  // }
}
