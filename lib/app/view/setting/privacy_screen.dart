import 'package:flutter/material.dart';

import '../../../base/constant.dart';
import '../../../base/resizer/fetch_pixels.dart';
import '../../../base/widget_utils.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
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
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  Row(
                    children: [
                      InkWell(
                        child: getSvgImage("back.svg"),
                        onTap: () {
                          finish();
                        },
                      ),
                      getHorSpace(FetchPixels.getPixelHeight(20)),
                      getCustomFont("PRIVACY POLICY", 24, Colors.blue, 1,
                          fontWeight: FontWeight.w700,
                      textAlign:TextAlign.center )
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
                              "At TASCA, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by TASCA and how we use it.",
                              14,
                              Colors.black,
                              fontWeight: FontWeight.w500,
                              txtHeight: FetchPixels.getPixelHeight(1.5)),
                          getVerSpace(FetchPixels.getPixelHeight(30)),

                          getMultilineCustomFont(
                              "If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us",
                              14,
                              Colors.black,
                              fontWeight: FontWeight.w500,
                              txtHeight: FetchPixels.getPixelHeight(1.5)),
                          getVerSpace(FetchPixels.getPixelHeight(30)),
                          getCustomFont("Log Files",
                              17, Colors.blue, 1,
                              fontWeight: FontWeight.w700),
                          getVerSpace(FetchPixels.getPixelHeight(16)),
                          getMultilineCustomFont(
                              "TASCA follows a standard procedure of using log files. These files log visitors when they use app. The information collected by log files include internet protocol (IP) addresses, browser type, Internet Service Provider (ISP), date and time stamp, referring/exit pages, and possibly the number of clicks. These are not linked to any information that is personally identifiable. The purpose of the information is for analyzing trends, administering the app, tracking users' movement on the app, and gathering demographic information.",
                              14,
                              Colors.black,
                              fontWeight: FontWeight.w500,
                              txtHeight: FetchPixels.getPixelHeight(1.5)),
                          getVerSpace(FetchPixels.getPixelHeight(30)),
                          getCustomFont("Our Advertising Partners",
                              17, Colors.blue, 1,
                              fontWeight: FontWeight.w700),
                          getVerSpace(FetchPixels.getPixelHeight(16)),
                          getMultilineCustomFont(
                              "Some of advertisers in our app may use cookies and web beacons. Our advertising partners are listed below. Each of our advertising partners has their own Privacy Policy for their policies on user data. For easier access, we hyperlinked to their Privacy Policies below.",
                              14,
                              Colors.black,
                              fontWeight: FontWeight.w500,
                              txtHeight: FetchPixels.getPixelHeight(1.5)),
                          getVerSpace(FetchPixels.getPixelHeight(30)),
                          getCustomFont("Google",
                              17, Colors.blue, 1,
                              fontWeight: FontWeight.w700),
                          getVerSpace(FetchPixels.getPixelHeight(16)),
                          getMultilineCustomFont(
                              "https://policies.google.com/technologies/ads",
                              14,
                              Colors.black,
                              fontWeight: FontWeight.w500,
                              txtHeight: FetchPixels.getPixelHeight(1.5)),
                          getVerSpace(FetchPixels.getPixelHeight(30)),
                          getCustomFont("Privacy Policies",
                              17, Colors.blue, 1,
                              fontWeight: FontWeight.w700),
                          getVerSpace(FetchPixels.getPixelHeight(16)),
                          getMultilineCustomFont(
                              "You may consult this list to find the Privacy Policy for each of the advertising partners of TASCA.",
                              14,
                              Colors.black,
                              fontWeight: FontWeight.w500,
                              txtHeight: FetchPixels.getPixelHeight(1.5)),
                          getVerSpace(FetchPixels.getPixelHeight(10)),
                          getMultilineCustomFont(
                              "Third-party ad servers or ad networks uses technologies like cookies, JavaScript, or Beacons that are used in their respective advertisements and links that appear on TASCA. They automatically receive your IP address when this occurs. These technologies are used to measure the effectiveness of their advertising campaigns and/or to personalize the advertising content that you see on this app or other apps or websites.",
                              14,
                              Colors.black,
                              fontWeight: FontWeight.w500,
                              txtHeight: FetchPixels.getPixelHeight(1.5)),

                          getVerSpace(FetchPixels.getPixelHeight(10)),
                          getMultilineCustomFont(
                              "Note that TASCA has no access to or control over these cookies that are used by third-party advertisers.",
                              14,
                              Colors.black,
                              fontWeight: FontWeight.w500,
                              txtHeight: FetchPixels.getPixelHeight(1.5)),
                          getVerSpace(FetchPixels.getPixelHeight(30)),
                          getCustomFont("Third Party Privacy Policies",
                              17, Colors.blue, 1,
                              fontWeight: FontWeight.w700),
                          getVerSpace(FetchPixels.getPixelHeight(16)),
                          getMultilineCustomFont(
                              "TASCA's Privacy Policy does not apply to other advertisers or websites. Thus, we are advising you to consult the respective Privacy Policies of these third-party ad servers for more detailed information. It may include their practices and instructions about how to opt-out of certain options",
                              14,
                              Colors.black,
                              fontWeight: FontWeight.w500,
                              txtHeight: FetchPixels.getPixelHeight(1.5)),
                          getVerSpace(FetchPixels.getPixelHeight(30)),
                          getCustomFont("Children's Information",
                              17, Colors.blue, 1,
                              fontWeight: FontWeight.w700),
                          getVerSpace(FetchPixels.getPixelHeight(16)),
                          getMultilineCustomFont(
                              "Another part of our priority is adding protection for children while using the internet. We encourage parents and guardians to observe, participate in, and/or monitor and guide their online activity.",
                              14,
                              Colors.black,
                              fontWeight: FontWeight.w500,
                              txtHeight: FetchPixels.getPixelHeight(1.5)),
                          getVerSpace(FetchPixels.getPixelHeight(16)),
                          getMultilineCustomFont(
                              "TASCA does not knowingly collect any Personal Identifiable Information from children under the age of 13. If you think that your child provided this kind of information on our App, we strongly encourage you to contact us immediately and we will do our best efforts to promptly remove such information from our records.",
                              14,
                              Colors.black,
                              fontWeight: FontWeight.w500,
                              txtHeight: FetchPixels.getPixelHeight(1.5)),
                          getVerSpace(FetchPixels.getPixelHeight(30)),
                          getCustomFont("Online Privacy Policy Only",
                              17, Colors.blue, 1,
                              fontWeight: FontWeight.w700),
                          getVerSpace(FetchPixels.getPixelHeight(16)),
                          getMultilineCustomFont(
                              "This Privacy Policy applies only to our online activities and is valid for visitors to our App with regards to the information that they shared and/or collect in TASCA. This policy is not applicable to any information collected offline or via channels other than this app. Our Privacy Policy was created with the help of the App Privacy Policy Generator from App-Privacy-Policy.com",
                              14,
                              Colors.black,
                              fontWeight: FontWeight.w500,
                              txtHeight: FetchPixels.getPixelHeight(1.5)),
                          getVerSpace(FetchPixels.getPixelHeight(30)),
                          getCustomFont("Consent",
                              17, Colors.blue, 1,
                              fontWeight: FontWeight.w700),
                          getVerSpace(FetchPixels.getPixelHeight(16)),
                          getMultilineCustomFont(
                              "By using our app, you hereby consent to our Privacy Policy and agree to its Terms and Conditions",
                              14,
                              Colors.black,
                              fontWeight: FontWeight.w500,
                              txtHeight: FetchPixels.getPixelHeight(1.5)),
                          getVerSpace(FetchPixels.getPixelHeight(50)),
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
