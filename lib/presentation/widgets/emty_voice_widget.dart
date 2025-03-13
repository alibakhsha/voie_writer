import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyVoiceWidget extends StatelessWidget {
  const EmptyVoiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 150.w, horizontal: 30.w),
      child: Column(
        children: [
          Container(
            width: 330.w,
            height: 357.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.w),
              color: const Color(0xffE8E8E8),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.w),
            child: Text(
              "هنوز فایلی اینجا ندارید",
              style: TextStyle(fontSize: 28.w, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            "شروع کنیم؟",
            style: TextStyle(fontSize: 28.w, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}