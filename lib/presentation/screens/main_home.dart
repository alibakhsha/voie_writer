import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voie_writer/constant/app_color.dart';
import 'package:voie_writer/gen/assets.gen.dart';
import 'package:voie_writer/presentation/widgets/app_bar.dart';
import 'package:voie_writer/presentation/widgets/bottom_nav.dart';
import '../../data/models/VoiceToText/get_list_voice.dart';
import '../../data/models/voice_to_text_model.dart';
import '../../logic/cubit/search/search_cubit.dart';
import '../../logic/cubit/voice_text/voice_text_cubit.dart';
import '../../logic/state/search/search_state.dart';
import '../../logic/state/voiceTextsList/textList_state.dart';
import '../widgets/ListViewForText.dart';
import '../widgets/Search.dart';
import '../widgets/emty_voice_widget.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<MainHomeScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<VoiceTextCubit>().fetchVoiceList();
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
                    List<VoiceToTextModel> voices = [];

                    if (voiceTextState is VoiceTextLoaded) {
                      voices = voiceTextState.voices;
                    }

                    final filteredVoices = voices.where((item) {
                      final audio = item.title?.toLowerCase();
                      final query = searchState.query.toLowerCase();
                      return query.isEmpty || item.title!.contains(query);
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



      ),
    );
  }
}