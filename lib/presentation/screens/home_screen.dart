import 'package:device_info_plus/device_info_plus.dart';
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
import '../../logic/state/textList_state.dart';
import '../../logic/state/voiceTextsList/textList_state.dart';
import '../widgets/Search.dart';
import '../widgets/emty_voice_widget.dart';
import 'dart:io' show Platform;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<VoiceTextCubit>().fetchVoiceTexts();
  }


  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColor.appBackgroundColor,
        appBar: appBar("Voice Writer"),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: BlocBuilder<VoiceTextCubit, VoiceTextState>(
            builder: (context, voiceState) {
              if (voiceState is VoiceTextLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (voiceState is VoiceTextError) {
                return Center(child: Text(voiceState.message));
              } else if (voiceState is VoiceTextLoaded) {
                final voices = voiceState.voices;
                if (voices.isEmpty) {
                  return const EmptyVoiceWidget();
                }
                return BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, searchState) {
                    final filteredVoices = voices.where((item) {
                      final audio = item.audio.toLowerCase();
                      final query = searchState.query.toLowerCase();
                      return query.isEmpty || audio.contains(query);
                    }).toList();

                    return Column(
                      children: [
                       Search(),
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
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          right: 15,
                                          child: GestureDetector(
                                            onTap: () {
                                              // context
                                              //     .read<VoiceTextCubit>()
                                              //     .deleteVoiceText(
                                              //     originalIndex);
                                              // context
                                              //     .read<MoveBloc>()
                                              //     .add(ResetMoveEvent());
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
                                              context.read<MoveBloc>().add(
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
                                                          child: SvgPicture
                                                              .asset(Assets
                                                              .icons
                                                              .group3),
                                                        ),
                                                        Text(
                                                          item.audio,
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
                                                          item.createdAt,
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
                                                          item.transcript,
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
              return Container();
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