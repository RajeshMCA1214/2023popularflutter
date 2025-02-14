import 'dart:convert';

import 'package:home_service_provider/app/routes/app_routes.dart';
import 'package:home_service_provider/base/constant.dart';
import 'package:home_service_provider/base/pref_data.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../base/color_data.dart';
import '../../../../base/widget_utils.dart';
import '../../../utils/strings.dart';
import 'package:http/http.dart' as http;

class TabProfile extends StatefulWidget {
  const TabProfile({Key? key}) : super(key: key);

  @override
  State<TabProfile> createState() => _TabProfileState();
}

class _TabProfileState extends State<TabProfile> {
  @override

  String _empcode = '';
  String logout = Strings.apipath + "logout_api.php";

  get_sessionData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      _empcode = (logindata.getString('employeeCode')??'');

    });
  }



  Future<void> logoutfunction() async {

   // print("hi")
    print(_empcode);
    final res = await http.post(Uri.parse(logout), headers: {

      "Accept": "application/json"
    }, body: {


      "employeeCode": _empcode
    });
    if (res.statusCode == 200) {

      print(json.decode(res.body));
      Map<String,dynamic> map = json.decode(res.body);
      var data = json.decode(res.body);
      print(data);
      if (data["success"] == "TRUE") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            data["messages"],
            textAlign: TextAlign.center,
          ),
          backgroundColor: appbarColor,
          elevation: 10,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
        ));

      } else if (data["success"] == "FALSE") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            data["messages"],
            textAlign: TextAlign.center,
          ),
          backgroundColor: appbarColor,
          elevation: 10,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
        ));

      }
    }
  }

  Widget build(BuildContext context) {
    FetchPixels(context);
    get_sessionData();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor,
      body: Container(
        padding:
            EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
        child: buildProfileWidget(context),
      ),
    );
  }

  ListView buildProfileWidget(BuildContext context) {
    return ListView(
      children: [
        getVerSpace(FetchPixels.getPixelHeight(20)),
        buildToolbarWidget(context),
        getVerSpace(FetchPixels.getPixelHeight(30)),
        Center(child: profilePictureView(context)),
        getVerSpace(FetchPixels.getPixelHeight(46)),
        myProfileButton(context),
        getVerSpace(FetchPixels.getPixelHeight(20)),
        //myCardButton(context),
        //getVerSpace(FetchPixels.getPixelHeight(20)),
       /// myAddressButton(context),
       // getVerSpace(FetchPixels.getPixelHeight(20)),
        settingButton(context),
        getVerSpace(FetchPixels.getPixelHeight(30)),
        logoutButton(context)
      ],
    );
  }

  Widget buildToolbarWidget(BuildContext context) {
    return withoutleftIconToolbar(context,
        isrightimage: true,
        title: "Profile",
        weight: FontWeight.w900,
        textColor: Colors.black,
        fontsize: 24,
        istext: true,
        rightimage: "notification.svg", rightFunction: () {
      Constant.sendToNext(context, Routes.notificationRoutes);
    });
  }

  Widget logoutButton(BuildContext context) {
    return getButton(context, blueColor, "Logout", Colors.white, () {
      PrefData.setLogIn(false);
      logoutfunction();
      Constant.sendToNext(context, Routes.loginRoute);

    }, 18,
        weight: FontWeight.w600,
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
        buttonHeight: FetchPixels.getPixelHeight(60));
  }

  Widget settingButton(BuildContext context) {
    return getButtonWithIcon(context, Colors.white, "Settings", Colors.black,
        () {
      Constant.sendToNext(context, Routes.settingRoute);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "setting.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }
/*
  Widget myAddressButton(BuildContext context) {
    return getButtonWithIcon(context, Colors.white, "My Address", Colors.black,
        () {
      Constant.sendToNext(context, Routes.myAddressRoute);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "location.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }



  Widget myCardButton(BuildContext context) {
    return getButtonWithIcon(context, Colors.white, "My Cards", Colors.black,
        () {
      Constant.sendToNext(context, Routes.cardRoute);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "wallet.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }
*/
  Widget myProfileButton(BuildContext context) {
    return getButtonWithIcon(context, Colors.white, "My Profile", Colors.black,
        () {
      Constant.sendToNext(context, Routes.profileRoute);
    }, 16,
        weight: FontWeight.w400,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
        boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0.0, 4.0)),
        ],
        prefixIcon: true,
        prefixImage: "profile.svg",
        sufixIcon: true,
        suffixImage: "arrow_right.svg");
  }

  Stack profilePictureView(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: FetchPixels.getPixelHeight(100),
          width: FetchPixels.getPixelHeight(100),
          decoration: BoxDecoration(
            image: getDecorationAssetImage(context, "profile_image.png"),
          ),
        ),
        Positioned(
            top: FetchPixels.getPixelHeight(68),
            left: FetchPixels.getPixelHeight(70),
            child: Container(
              height: FetchPixels.getPixelHeight(46),
              width: FetchPixels.getPixelHeight(46),
              padding: EdgeInsets.symmetric(
                  vertical: FetchPixels.getPixelHeight(10),
                  horizontal: FetchPixels.getPixelHeight(10)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0.0, 4.0)),
                  ],
                  borderRadius:
                      BorderRadius.circular(FetchPixels.getPixelHeight(35))),
              child: getSvgImage("camera.svg",
                  height: FetchPixels.getPixelHeight(24),
                  width: FetchPixels.getPixelHeight(24)),
            ))
      ],
    );
  }
}
