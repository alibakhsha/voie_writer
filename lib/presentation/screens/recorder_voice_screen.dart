import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:voie_writer/constant/app_color.dart';
import 'package:voie_writer/constant/app_text_style.dart';
import 'package:voie_writer/gen/assets.gen.dart';
import 'package:voie_writer/logic/cubit/voice/voice_cubit.dart';

import '../../logic/cubit/color_cubit/color_cubit.dart';
import '../../logic/cubit/color_cubit/color_state.dart';
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
                return _buildBodyBasedOnState(context, state);
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

  Widget _buildBodyBasedOnState(BuildContext context, VoiceState state) {
    switch (state) {
      case VoiceState.processing:
        return _loadingScreen(context);
      case VoiceState.uploaded:
        return SingleChildScrollView(child: _fileSelectedScreen(context));
      default:
        return _initialScreen();
    }
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
                      SizedBox(
                        width: 230.w,
                        height: 60.h,
                        child: Text(
                          ".در حال ساخت متن شما هستیم\n"
                          "لطفا منتظر بمانید",
                          style: AppTextStyle.loadingText,
                          textAlign: TextAlign.center,
                        ),
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

  Widget _fileSelectedScreen(BuildContext context) {
    final voiceCubit = context.read<VoiceCubit>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "150 کلمه / 231 کاراکتر",
                    style: AppTextStyle.voiceCharacterText,
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.read<ColorCubit>().togglePalette(),
                    child: SvgPicture.asset(
                      width: 24.w,
                      height: 24.h,
                      Assets.icons.palette,
                      color: Color.fromRGBO(40, 40, 40, 1),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  SvgPicture.asset(
                    width: 24.w,
                    height: 24.h,
                    Assets.icons.share,
                    color: Color.fromRGBO(40, 40, 40, 1),
                  ),
                  SizedBox(width: 6.w),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: AppColor.appBarTextColor,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "ذخیره متن",
                                  style: AppTextStyle.dropDownText,
                                ),
                                SvgPicture.asset(
                                  Assets.icons.download02,
                                  width: 24.w,
                                  height: 24.h,
                                ),
                              ],
                            ),
                            actions: [
                              Text(":موضوع / دسته بندی متن "),
                              SizedBox(height: 8.h,),
                              TextField(
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none
                                  )
                                ),
                              ),
                              SizedBox(height: 8.h,),
                              Container(
                                width: 93.w,
                                height: 34.h,
                                decoration: BoxDecoration(
                                  color: AppColor.loadingColor,
                                  borderRadius: BorderRadius.all(Radius.circular(8))
                                ),
                                child: Center(
                                  child: Text("ذخیره",style: AppTextStyle.voiceNameText2,),
                                ),
                              ),
                            ],   );
                        },

                      );
                    },
                    child: SvgPicture.asset(
                      width: 24.w,
                      height: 24.h,
                      Assets.icons.download02,
                      color: Color.fromRGBO(40, 40, 40, 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: BlocBuilder<ColorCubit, ColorState>(
            builder: (context, state) {
              return state.isPaletteOpen
                  ? _buildColorPalette(context)
                  : SizedBox.shrink();
            },
          ),
        ),

        SizedBox(height: 20.h),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocBuilder<ColorCubit, ColorState>(
            builder: (context, state) {
              return SelectableText.rich(
                TextSpan(
                  children: _buildTextSpans(
                    context,
                    state.selectedText,
                    state.selectedColor,
                  ),
                ),
                style: TextStyle(fontSize: 16.sp, color: Colors.black),
                onSelectionChanged: (selection, cause) {
                  context.read<ColorCubit>().setSelection(selection);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  List<TextSpan> _buildTextSpans(
    BuildContext context,
    TextSelection? selection,
    Color? selectedColor,
  ) {
    String text = "متنی که قابلیت هایلایت شدن دارد.";
    List<TextSpan> spans = [];
    for (int i = 0; i < text.length; i++) {
      spans.add(
        TextSpan(
          text: text[i],
          style: TextStyle(
            backgroundColor:
                (selection != null && i >= selection.start && i < selection.end)
                    ? selectedColor ?? Colors.transparent
                    : Colors.transparent,
          ),
        ),
      );
    }
    return spans;
  }

  Widget _buildColorPalette(BuildContext context) {
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];
    return Container(
      width: 236.w,
      height: 36,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            colors.map((color) {
              return GestureDetector(
                onTap: () {
                  context.read<ColorCubit>().highlightSelection(color);
                },
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _initialScreen() {
    return Container();
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:lottie/lottie.dart';
// import 'package:voie_writer/constant/app_color.dart';
// import 'package:voie_writer/constant/app_text_style.dart';
// import 'package:voie_writer/gen/assets.gen.dart';
// import 'package:voie_writer/logic/cubit/voice/voice_cubit.dart';
// import '../../logic/cubit/color_cubit/color_cubit.dart';
// import '../../logic/cubit/color_cubit/color_state.dart';
// import '../../logic/cubit/drop_down/drop_down_cubit.dart';
//
// class RecorderVoiceScreen extends StatelessWidget {
//   const RecorderVoiceScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.appBackgroundColor,
//       body: Stack(
//         children: [
//           BlocBuilder<VoiceCubit, VoiceState>(
//             builder: (context, state) {
//               return state == VoiceState.processing
//                   ? _loadingScreen(context)
//                   : SingleChildScrollView(child: _fileSelectedScreen(context));
//             },
//           ),
//           BlocBuilder<DropDownCubit, bool>(
//             builder: (context, isOpen) => isOpen
//                 ? Positioned(
//               left: 12.w,
//               right: 158.w,
//               child: _languageDropdown(context),
//             )
//                 : const SizedBox.shrink(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _languageDropdown(BuildContext context) {
//     final languages = ["America", "Italian", "UK", "Canada", "German", "Turkey"];
//
//     return Container(
//       width: 223.w,
//       height: 366.h,
//       padding: EdgeInsets.all(10.w),
//       decoration: _dropdownDecoration(),
//       child: Column(
//         children: languages.map((lang) => _languageTile(context, lang)).toList(),
//       ),
//     );
//   }
//
//   BoxDecoration _dropdownDecoration() {
//     return BoxDecoration(
//       color: AppColor.appBackgroundColor,
//       borderRadius: BorderRadius.circular(12),
//       boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 1)],
//     );
//   }
//
//   Widget _languageTile(BuildContext context, String lang) {
//     return Column(
//       children: [
//         ListTile(
//           title: Row(
//             children: [
//               Image.asset(Assets.icons.iran.path, width: 36.w, height: 36.h),
//               SizedBox(width: 8.w),
//               Text(lang, style: AppTextStyle.dropDownText),
//             ],
//           ),
//           onTap: () => context.read<DropDownCubit>().toggleDropdown(),
//         ),
//         const Divider(height: 0, color: Color(0xFFF4F4F4)),
//       ],
//     );
//   }
//
//   Widget _loadingScreen(BuildContext context) {
//     final voiceCubit = context.read<VoiceCubit>();
//     return Column(
//       children: [
//         SizedBox(height: 26.h),
//         _voiceInfoContainer(voiceCubit),
//         Expanded(
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Lottie.asset(Assets.animation.renew, width: 99.w, height: 91.h),
//                 SizedBox(height: 20.h),
//                 SizedBox(
//                   width: 230.w,
//                   child: Text(
//                     ".در حال ساخت متن شما هستیم\nلطفا منتظر بمانید",
//                     style: AppTextStyle.loadingText,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _voiceInfoContainer(VoiceCubit voiceCubit) {
//     return Container(
//       width: 356.w,
//       height: 70.h,
//       decoration: BoxDecoration(
//         color: AppColor.voiceContainerColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(voiceCubit.fileName!, style: AppTextStyle.voiceNameText),
//                 Text(voiceCubit.fileDuration.toString(), style: AppTextStyle.voiceNameText),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SvgPicture.asset(
//               Assets.icons.microphone,
//               width: 24.w,
//               height: 24.h,
//               color: AppColor.appTextColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _fileSelectedScreen(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("150 کلمه / 231 کاراکتر", style: AppTextStyle.voiceCharacterText),
//               _actionIcons(context),
//             ],
//           ),
//         ),
//         SizedBox(height: 20.h),
//         BlocBuilder<ColorCubit, ColorState>(
//           builder: (context, state) => state.isPaletteOpen ? _buildColorPalette(context) : const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
//
//
//
//   Widget _actionIcons(BuildContext context) {
//     return Row(
//       children: [
//         _iconButton(context, Assets.icons.palette, () => context.read<ColorCubit>().togglePalette()),
//         _iconButton(context, Assets.icons.share, () {}),
//         _iconButton(context, Assets.icons.download02, () => _showSaveDialog(context)),
//       ],
//     );
//   }
//
//   Widget _iconButton(BuildContext context, String asset, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 6.0),
//         child: SvgPicture.asset(asset, width: 24.w, height: 24.h, color: const Color(0xFF282828)),
//       ),
//     );
//   }
//
//   void _showSaveDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: AppColor.appBarTextColor,
//         title: Text("ذخیره متن", style: AppTextStyle.dropDownText),
//         actions: [
//           const Text(":موضوع / دسته بندی متن"),
//           const SizedBox(height: 8),
//           const TextField(textAlign: TextAlign.right, decoration: InputDecoration(filled: true, fillColor: Colors.white)),
//           const SizedBox(height: 8),
//           ElevatedButton(onPressed: () {}, child: const Text("ذخیره")),
//         ],
//       ),
//     );
//   }
//   Widget _buildColorPalette(BuildContext context) {
//     final colors = [
//       Colors.red,
//       Colors.green,
//       Colors.blue,
//       Colors.yellow,
//       Colors.purple,
//       Colors.orange,
//     ];
//     return Container(
//       width: 236.w,
//       height: 36,
//       padding: EdgeInsets.all(6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2)],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children:
//             colors.map((color) {
//               return GestureDetector(
//                 onTap: () {
//                   context.read<ColorCubit>().highlightSelection(color);
//                 },
//                 child: Container(
//                   width: 36.w,
//                   height: 36.h,
//                   decoration: BoxDecoration(
//                     color: color,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.black, width: 1),
//                   ),
//                 ),
//               );
//             }).toList(),
//       ),
//     );
//   }
// }