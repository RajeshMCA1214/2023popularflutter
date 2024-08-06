import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';

import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  void finish() {
    Constant.backToPrev(context);
  }
  var horSpace = FetchPixels.getPixelHeight(20);
  @override
  Widget build(BuildContext context) {
    FetchPixels(context);

    return WillPopScope(
        child: Scaffold(
          body: SafeArea(
            child: getPaddingWidget(
              EdgeInsets.symmetric(horizontal: horSpace),
              Column(
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(10)),
                  Row(
                    children: [
                      InkWell(
                        child: getSvgImage("back.svg"),
                        onTap: () {
                          finish();
                        },
                      ),
                      getHorSpace(FetchPixels.getPixelHeight(16)),
                      getCustomFont("HELP & SUPPORT", 24, Colors.blue, 1,
                          fontWeight: FontWeight.w700)
                    ],
                  ),
                  getVerSpace(FetchPixels.getPixelHeight(30)),
                  Expanded(
                      flex: 1,
                      child: ListView(
                        primary: true,
                        shrinkWrap: true,
                        children: [
                          getCustomFont("Website : https://www.devazo.co.in", 17,
                              Colors.black, 1,
                              fontWeight: FontWeight.w700),
                          getVerSpace(FetchPixels.getPixelHeight(16)),

                          getCustomFont("WhatsApp : +91 9500051119", 17,
                              Colors.black, 1,
                              fontWeight: FontWeight.w700),
                          getVerSpace(FetchPixels.getPixelHeight(16)),

                          getCustomFont("Phone : 044 40066583",
                              17, Colors.black, 1,
                              fontWeight: FontWeight.w700),
                          getVerSpace(FetchPixels.getPixelHeight(16)),
                          getCustomFont("Email : support@devazo.co.in", 17,
                              Colors.blue, 1,
                              fontWeight: FontWeight.w700),
                          getVerSpace(FetchPixels.getPixelHeight(16)),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          finish();
          return false;
        });
  }
}
