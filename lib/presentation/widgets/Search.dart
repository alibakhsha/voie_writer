import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../constant/app_color.dart';
import '../../gen/assets.gen.dart';
import '../../logic/cubit/search/search_cubit.dart';
import '../../logic/event/search/search_event.dart';


class Search extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Padding(
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
          contentPadding:
          EdgeInsets.symmetric(horizontal: 10),
          suffixIcon: Padding(
            padding: EdgeInsets.all(11.w),
            child: GestureDetector(
              onTap: () {
                context
                    .read<SearchBloc>()
                    .add(SearchEvent(searchController.text));
                print(
                    "جستجو با آیکون انجام شد: ${searchController.text}");
              },
              child: SvgPicture.asset(Assets.icons.searchIcon),
            ),
          ),
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}
