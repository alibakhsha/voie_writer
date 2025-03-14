import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:voie_writer/constant/app_color.dart';
import 'package:voie_writer/constant/app_text_style.dart';
import 'package:voie_writer/gen/assets.gen.dart';
import 'package:voie_writer/logic/cubit/voice/voice_cubit.dart';
import '../../data/models/HighlightedText.dart';
import '../../logic/cubit/color_cubit/color_cubit.dart';
import '../../logic/cubit/color_cubit/color_state.dart';
import '../../logic/cubit/drop_down/drop_down_cubit.dart';
import '../../logic/cubit/home_page/home_cubit.dart';

class RecorderVoiceScreen extends StatelessWidget {
  const RecorderVoiceScreen({super.key});

  void _showSaveDialog(BuildContext context)  {
    _saveHighlightedText(context);
    print("هایلایت‌ها با موفقیت ذخیره شدند");
    context.read<HomeCubit>().changePage(3);
  }

  void _saveHighlightedText(BuildContext context) {
    final colorCubit = context.read<ColorCubit>();
    final voiceCubit = context.read<VoiceCubit>();
    final state = colorCubit.state;

    String text = voiceCubit.convertedText?.transcript ?? "متن در دسترس نیست";
    List<HighlightRange> highlights = List<HighlightRange>.from(state.highlights);

    // اگه انتخاب جدیدی هست، اضافه کن
    if (state.selectedText != null && state.selectedColor != null) {
      highlights.add(HighlightRange(
        start: state.selectedText!.start,
        end: state.selectedText!.end,
        color: state.selectedColor!,
      ));
    }

    HighlightedText highlightedText = HighlightedText(text: text, highlights: highlights);
    context.read<VoiceCubit>().saveToFile(highlightedText);
    // saveToFile(highlightedText);
  }

  Future<String?> showSaveDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    String? title1;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.appBarTextColor,
        title: Text("Title", style: AppTextStyle.dropDownText),
        actions: [
          const Text("لطفا اسم فابل را وارد کنید "),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            textAlign: TextAlign.right,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // title1 = controller.text.isNotEmpty ? controller.text : null;
              title1 = controller.text ;
              // -------------------------- _saveHighlightedText(context);
              Navigator.pop(context);
            },
            child: const Text("ذخیره"),
          ),
        ],
      ),
    );

    return title1; // برگرداندن مقدار title
  }

  List<TextSpan> _buildTextSpans(
      BuildContext context,
      String text,
      List<HighlightRange> highlights,
      ) {
    List<TextSpan> spans = [];
    for (int i = 0; i < text.length; i++) {
      Color? backgroundColor;

      for (var highlight in highlights) {
        if (i >= highlight.start && i < highlight.end) {
          backgroundColor = highlight.color;
          break;
        }
      }
      spans.add(
        TextSpan(
          text: text[i],
          style: TextStyle(
            backgroundColor: backgroundColor ?? Colors.transparent,
          ),
        ),
      );
    }
    return spans;
  }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: AppColor.appBackgroundColor,
  //     body: Stack(
  //       children: [
  //         BlocBuilder<VoiceCubit, VoiceState>(
  //           builder: (context, state) {
  //             if (state == VoiceState.processing) {
  //               return _loadingScreen(context);
  //             } else if (state == VoiceState.conversionSuccess) {
  //               return _conversionSuccessScreen(context);
  //             } else {
  //               return SingleChildScrollView(child: _fileSelectedScreen(context));
  //             }
  //           },
  //         ),
  //         BlocBuilder<DropDownCubit, bool>(
  //           builder: (context, isOpen) => isOpen
  //               ? Positioned(
  //             left: 12.w,
  //             right: 158.w,
  //             child: _languageDropdown(context),
  //           )
  //               : const SizedBox.shrink(),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackgroundColor,
      body: Stack(
        children: [
          BlocListener<VoiceCubit, VoiceState>(
            listener: (context, state) {

              if (state == VoiceState.selected ) {
                _handleFileSelection(context);
              }
            },
            child: BlocBuilder<VoiceCubit, VoiceState>(
              builder: (context, state) {
                if (state == VoiceState.processing) {
                  return _loadingScreen(context);
                } else if (state == VoiceState.conversionSuccess) {
                  return _conversionSuccessScreen(context);
                } else {
                  return SingleChildScrollView(child: _fileSelectedScreen(context));
                }
              },
            ),
          ),
          BlocBuilder<DropDownCubit, bool>(
            builder: (context, isOpen) => isOpen
                ? Positioned(
              left: 12.w,
              right: 158.w,
              child: _languageDropdown(context),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Future<void> _handleFileSelection(BuildContext context) async {
    final title = await showSaveDialog(context);
    if (title != null) {
      await context.read<VoiceCubit>().uploadVoiceFile(title: title);
    } else {
      print("کاربر title وارد نکرد");
    }
  }

// بقیه توابع مثل _loadingScreen، _conversionSuccessScreen و _fileSelectedScreen رو نگه دارید


  Widget _languageDropdown(BuildContext context) {
    final languages = ["America", "Italian", "UK", "Canada", "German", "Turkey"];

    return Container(
      width: 223.w,
      height: 366.h,
      padding: EdgeInsets.all(10.w),
      decoration: _dropdownDecoration(),
      child: Column(
        children: languages.map((lang) => _languageTile(context, lang)).toList(),
      ),
    );
  }

  BoxDecoration _dropdownDecoration() {
    return BoxDecoration(
      color: AppColor.appBackgroundColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 1)],
    );
  }

  Widget _languageTile(BuildContext context, String lang) {
    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              Image.asset(Assets.icons.iran.path, width: 36.w, height: 36.h),
              SizedBox(width: 8.w),
              Text(lang, style: AppTextStyle.dropDownText),
            ],
          ),
          onTap: () => context.read<DropDownCubit>().toggleDropdown(),
        ),
        const Divider(height: 0, color: Color(0xFFF4F4F4)),
      ],
    );
  }

  Widget _loadingScreen(BuildContext context) {
    print("Rendering loading screen");
    final voiceCubit = context.read<VoiceCubit>();
    return Column(
      children: [
        SizedBox(height: 26.h),
        _voiceInfoContainer(voiceCubit),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(Assets.animation.renew, width: 99.w, height: 91.h),
                SizedBox(height: 20.h),
                SizedBox(
                  width: 230.w,
                  child: Text(
                    ".در حال ساخت متن شما هستیم\nلطفا منتظر بمانید",
                    style: AppTextStyle.loadingText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _voiceInfoContainer(VoiceCubit voiceCubit) {
    return Container(
      width: 356.w,
      height: 70.h,
      decoration: BoxDecoration(
        color: AppColor.voiceContainerColor,
        borderRadius: BorderRadius.circular(12),
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
                Text(voiceCubit.fileName!, style: AppTextStyle.voiceNameText),
                Text(voiceCubit.fileDuration.toString(), style: AppTextStyle.voiceNameText),
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
                  // GestureDetector(
                  //   onTap: () {
                  //      _saveHighlightedText(context);
                  //   },
                  //   child: SvgPicture.asset(
                  //     width: 24.w,
                  //     height: 24.h,
                  //     Assets.icons.download02,
                  //     color: Color.fromRGBO(40, 40, 40, 1),
                  //   ),
                  // ),
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
                    voiceCubit.convertedText?.transcript ?? "",
                    state.highlights,
                  ),
                ),
                style: TextStyle(fontSize: 16.sp, color: Colors.black),
                textAlign: TextAlign.right,
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

  Widget _actionIcons(BuildContext context) {
    return Row(
      children: [
        _iconButton(context, Assets.icons.palette, () => context.read<ColorCubit>().togglePalette()),
        // _iconButton(context, Assets.icons.share, () {}),
        _iconButton(context, Assets.icons.download02, () => _showSaveDialog(context)),
      ],
    );
  }

  Widget _iconButton(BuildContext context, String asset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: SvgPicture.asset(asset, width: 24.w, height: 24.h, color: const Color(0xFF282828)),
      ),
    );
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

  Widget _conversionSuccessScreen(BuildContext context) {
    final colorCubit = context.read<ColorCubit>();
    final voiceCubit = context.read<VoiceCubit>();
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "150 کلمه / 231 کاراکتر",
                  style: AppTextStyle.voiceCharacterText,
                ),
                _actionIcons(context),
              ],
            ),
            SizedBox(height: 20.h),
            BlocBuilder<ColorCubit, ColorState>(
              builder: (context, state) => state.isPaletteOpen ? _buildColorPalette(context) : const SizedBox.shrink(),
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColor.voiceContainerColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: BlocBuilder<ColorCubit, ColorState>(
                builder: (context, state) {
                  return SelectableText.rich(
                    TextSpan(
                      children: _buildTextSpans(
                        context,
                        voiceCubit.convertedText?.transcript ?? "",
                        state.highlights,
                      ),
                    ),
                    style: AppTextStyle.voiceNameText.copyWith(fontSize: 16.sp),
                    textAlign: TextAlign.right,
                    onSelectionChanged: (selection, cause) {
                      colorCubit.setSelection(selection);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }





}

