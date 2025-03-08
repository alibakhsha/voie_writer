import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../constant/app_color.dart';
import '../../gen/assets.gen.dart';
import '../../logic/cubit/voiceTexts/voiceText_cubit.dart';
import '../../logic/event/voiceTextsList/textList_event.dart';
import '../../logic/state/voiceTextsList/Move_Text.dart';

class Listviewfortext extends StatelessWidget {
  final List<dynamic> filteredVoices;
  final List<dynamic> voices;

  const Listviewfortext({
    super.key,
    required this.filteredVoices,
    required this.voices,

  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoveBloc, MoveState>(
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
                child: Container(height:62.w,
                  child: Stack(
                    children: [
                      Positioned(
                        right: 15,
                        child: GestureDetector(
                          onTap: () {
                            context.read<VoiceTextCubit>().deleteVoiceText(item.id.toString());
                            context.read<MoveBloc>().add(ResetMoveEvent());
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
                                    top: 10.w,
                                    left: 10.w,
                                    right: 10.w,
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
                                        item.audio.length > 6 ? "${item.audio.substring(0, 6)}..." : item.audio,
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
                                    bottom: 5.w,
                                    left: 5.w,
                                    right: 5.w,
                                  ),
                                  child: Container(width:330.w,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          item.transcript.length> 34 ? "${  item.transcript.substring(0, 34)}..." :  item.transcript,

                                          style: TextStyle(
                                            color: AppColor
                                                .textHomeColor,
                                            fontSize:10.w,
                                            fontWeight:
                                            FontWeight
                                                .w400,
                                          ),
                                        ),
                                      ],
                                    ),
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
              );
            },
          ),
        );
      },
    );
  }
}
