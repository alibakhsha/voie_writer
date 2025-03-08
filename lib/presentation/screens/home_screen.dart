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
import '../../logic/models/VoiceToText/get_list_voice.dart';
import '../../logic/state/search/search_state.dart';
import '../../logic/state/voiceTextsList/textList_state.dart';
import '../widgets/ListViewForText.dart';
import '../widgets/Search.dart';
import '../widgets/emty_voice_widget.dart';

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
                  return  EmptyVoiceWidget();
                }
                return BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, searchState) {
                    final voiceTextState = context.watch<VoiceTextCubit>().state;
                    List<GetListVoice> voices = [];

                    if (voiceTextState is VoiceTextLoaded) {
                      voices = voiceTextState.voices;
                    }

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
                            : Listviewfortext(filteredVoices: filteredVoices, voices: voices),
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