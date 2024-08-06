import 'package:flutter/material.dart';

import '../../../base/constant.dart';
import '../../../base/resizer/fetch_pixels.dart';
import '../../../base/widget_utils.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  @override
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
                      getCustomFont("DISCLAIMER ", 24, Colors.blue, 1,
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

                          getMultilineCustomFont(
                              "We are doing our best to prepare the content of this app. However, TASCA cannot warranty the expressions and suggestions of the contents, as well as its accuracy. In addition, to the extent permitted by the law, TASCA shall not be responsible for any losses and/or damages due to the usage of the information on our app.",
                              14,
                              Colors.black,
                              fontWeight: FontWeight.w500,
                              txtHeight: FetchPixels.getPixelHeight(1.5)),
                          getVerSpace(FetchPixels.getPixelHeight(30)),


                          getMultilineCustomFont(
                              "By using our app, you hereby consent to our disclaimer and agree to its terms.",
                              14,
                              Colors.black,
                              fontWeight: FontWeight.w500,
                              txtHeight: FetchPixels.getPixelHeight(1.5)),
                          getVerSpace(FetchPixels.getPixelHeight(30)),


                          getMultilineCustomFont(
                              "Any links contained in our app may lead to external sites are provided for convenience only. Any information or statements that appeared in these sites or app are not sponsored, endorsed, or otherwise approved by TASCA. For these external sites, TASCA cannot be held liable for the availability of, or the content located on or through it. Plus, any losses or damages occurred from using these contents or the internet generally.",
                              14,
                              Colors.black,
                              fontWeight: FontWeight.w500,
                              txtHeight: FetchPixels.getPixelHeight(1.5))
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
