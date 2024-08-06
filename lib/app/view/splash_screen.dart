import 'dart:async';

import 'package:home_service_provider/base/color_data.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:home_service_provider/base/widget_utils.dart';
import 'package:flutter/material.dart';

import '../../base/constant.dart';
import '../../base/pref_data.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    PrefData.isLogIn().then((value) {
      Timer(
        const Duration(seconds: 3),
        () {
          (value)
              ? Constant.sendToNext(context, Routes.homeScreenRoute)
              : Constant.sendToNext(context, Routes.introRoute);
        },
      );
    });
  }

  void backClick() {
    Constant.backToPrev(context);
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: buildLogo(),
        ),
        onWillPop: () async {
          backClick();
          return false;
        });
  }

  Container buildLogo() {
    return Container(
          color:whiteColor,
          child: Center(
              child: getAssetImage(
                  "tasca_logo.png",
                  FetchPixels.getPixelHeight(380),
                  FetchPixels.getPixelHeight(380)))
        );
  }
}
