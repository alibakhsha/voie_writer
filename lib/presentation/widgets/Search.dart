import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../constant/app_color.dart';
import '../../gen/assets.gen.dart';
import '../../logic/cubit/search/search_cubit.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose(); // جلوگیری از نشت حافظه
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25.w),
      child: TextField(
        controller: _searchController,
        onChanged: (query) {
          context.read<SearchCubit>()..updateQuery(query); // ارسال رویداد با هر تغییر
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
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          suffixIcon: Padding(
            padding: EdgeInsets.all(11.w),
            child: GestureDetector(
              onTap: () {
                context.read<SearchCubit>().updateQuery(_searchController.text);
                print("جستجو با آیکون انجام شد: ${_searchController.text}");
              },
              child: SvgPicture.asset(Assets.icons.searchIcon),
            ),
          ),
          prefixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, size: 20.w, color: AppColor.appBarColor),
            onPressed: () {
              _searchController.clear();
              context.read<SearchCubit>().updateQuery(''); // پاک کردن جستجو
            },
          )
              : null,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}