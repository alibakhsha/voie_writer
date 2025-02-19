import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voie_writer/constant/app_color.dart';
import 'package:voie_writer/presentation/widgets/app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.appBackgroundColor,
        appBar: appBar("نام اپ"),
        body: Container(),
      ),
    );
  }
}
