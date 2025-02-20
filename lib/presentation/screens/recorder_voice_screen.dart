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
import 'package:voie_writer/constant/app_color.dart';
import 'package:voie_writer/logic/cubit/voice/voice_cubit.dart';
import 'package:voie_writer/presentation/widgets/app_bar.dart';

class RecorderVoiceScreen extends StatelessWidget {
  const RecorderVoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VoiceCubit, VoiceState>(
        builder: (context, state) {
          if (state == VoiceState.processing) {
            return _loadingScreen();
          } else if (state == VoiceState.selected) {
            return _fileSelectedScreen(context);
          } else if (state == VoiceState.error) {
            return _errorScreen();
          } else {
            return _mainContent(context);
          }
        },
      ),
    );
  }

  // صفحه نمایش در حال پردازش
  Widget _loadingScreen() {
    return Column(
      children: [
        Container(
          
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.autorenew, size: 50.w, color: Colors.blue),
              SizedBox(height: 20.h),
              Text("در حال پردازش فایل...", style: TextStyle(fontSize: 18.sp)),
            ],
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
  Widget _errorScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 50.w, color: Colors.red),
          SizedBox(height: 20.h),
          Text("❌ دسترسی رد شد!", style: TextStyle(fontSize: 18.sp, color: Colors.red)),
        ],
      ),
    );
  }

  // صفحه اصلی که دکمه انتخاب فایل صوتی را نشان می‌دهد
  Widget _mainContent(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.read<VoiceCubit>().pickAudioFile(); // درخواست انتخاب فایل صوتی
        },
        child: Text(
          "برای انتخاب فایل صوتی روی این دکمه کلیک کنید",
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
    );
  }
}
