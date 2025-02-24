import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voie_writer/constant/app_color.dart';
import 'package:voie_writer/gen/assets.gen.dart';
import 'package:voie_writer/presentation/widgets/app_bar.dart';
import 'package:voie_writer/presentation/widgets/bottom_nav.dart';
import '../../logic/cubit/search/search_cubit.dart';
import '../../logic/cubit/voiceTexts/voiceText_cubit.dart';
import '../../logic/event/search/search_event.dart';
import '../../logic/event/voiceTextsList/textList_event.dart';
import '../../logic/state/search/search_state.dart';
import '../../logic/state/voiceTextsList/textList_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColor.appBackgroundColor,
        appBar: appBar("نام اپ"),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: BlocBuilder<VoiceTextCubit, List<Map<String, String>>>(
            builder: (context, voices) {
              if (voices.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 150.w, horizontal: 30.w),
                  child: Column(
                    children: [
                      Container(
                        width: 330.w,
                        height: 357.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.w),
                          color: Color(0xffE8E8E8),
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
              } else {
                return BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, searchState) {
                    final filteredVoices = voices.where((item) {
                      final title = item["title"]!.toLowerCase();
                      final query = searchState.query.toLowerCase();

                      if (query.isEmpty) return true;

                      return title.contains(query);
                    }).toList();

                    return Column(
                      children: [
                        // فیلد جستجو
                        Padding(
                          padding: EdgeInsets.all(25.w),
                          child: TextField(
                            controller: searchController,
                            onChanged: (query) {
                              context.read<SearchBloc>().add(SearchEvent(query));
                            },
                            decoration: InputDecoration(
                              hintText: "جستجو بر اساس موضوع",
                              hintStyle: TextStyle(
                                color: AppColor.appBarColor,
                                fontSize: 12.w,
                                fontWeight: FontWeight.w400,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColor.appBarColor,
                                  width: 1.w,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              suffixIcon: Padding(
                                padding: EdgeInsets.all(11.w),
                                child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<SearchBloc>()
                                        .add(SearchEvent(searchController.text));
                                    print("جستجو با آیکون انجام شد: ${searchController.text}");
                                  },
                                  child: SvgPicture.asset(Assets.icons.searchIcon),
                                ),
                              ),
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        // لیست فیلترشده یا پیام خالی
                        filteredVoices.isEmpty && searchState.query.isNotEmpty
                            ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 50.w),
                          child: Text(
                            "موردی یافت نشد",
                            style: TextStyle(
                              fontSize: 20.w,
                              fontWeight: FontWeight.w400,
                              color: AppColor.textHomeColor,
                            ),
                          ),
                        )
                            : BlocBuilder<MoveBloc, MoveState>(
                          builder: (context, moveState) {
                            return Container(
                              width: 390.w,
                              height: 550.h,
                              child: ListView.builder(
                                key: ValueKey(filteredVoices.length),
                                padding: EdgeInsets.all(16.w),
                                itemCount: filteredVoices.length,
                                itemBuilder: (context, index) {
                                  var item = filteredVoices[index];
                                  final originalIndex = voices.indexOf(item);

                                  return Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 500.w,
                                          height: 61.w,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                right: 15,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    context
                                                        .read<VoiceTextCubit>()
                                                        .deleteVoiceText(
                                                        originalIndex);
                                                    context
                                                        .read<MoveBloc>()
                                                        .add(ResetMoveEvent());
                                                  },
                                                  child: Container(
                                                    height: 61.w,
                                                    width: 39.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.only(
                                                        topRight:
                                                        Radius.circular(8.w),
                                                        bottomRight:
                                                        Radius.circular(8.w),
                                                      ),
                                                      color: AppColor.trashColor,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                      EdgeInsets.all(9.w),
                                                      child: SvgPicture.asset(
                                                        Assets.icons.icon,
                                                        width: 24.w,
                                                        height: 24.w,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              AnimatedPositioned(
                                                duration: Duration(seconds: 1),
                                                left: moveState
                                                    .positions[originalIndex] ??
                                                    0.0,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    context
                                                        .read<MoveBloc>()
                                                        .add(
                                                        MoveEvent(originalIndex));
                                                  },
                                                  child: Container(
                                                    width: 330.w,
                                                    height: 61.h,
                                                    decoration: BoxDecoration(
                                                      color:
                                                      AppColor.appBarTextColor,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                        !(moveState.selectedIndex ==
                                                            originalIndex)
                                                            ? 8
                                                            : 0.w,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                            top: 5.w,
                                                            left: 15.w,
                                                            right: 15.w,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Container(
                                                                width: 3.w,
                                                                height: 10.w,
                                                                child: SvgPicture.asset(
                                                                    Assets.icons
                                                                        .group3),
                                                              ),
                                                              Text(
                                                                item["title"]!,
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  fontSize: 16.w,
                                                                  color: AppColor
                                                                      .textHomeColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                            bottom: 10.w,
                                                            left: 5.w,
                                                            right: 5.w,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                item["date"]!,
                                                                style: TextStyle(
                                                                  color: AppColor
                                                                      .textHomeColor,
                                                                  fontSize: 10.w,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                ),
                                                              ),
                                                              Text(
                                                                item["description"]!,
                                                                style: TextStyle(
                                                                  color: AppColor
                                                                      .textHomeColor,
                                                                  fontSize: 10.w,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
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