import 'dart:async';
import 'dart:convert';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_service_provider/app/routes/app_routes.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiclass/UserDetails.dart';
import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../utils/strings.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String activepicklisturl = Strings.apipath + "editProfile_api.php";
  String _empcode = '';
  var _isLoading = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  get_sessionData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      _empcode = (logindata.getString('employeeCode') ?? '');
    });
  }

  /*get time  */
  dynamic currentTime = DateFormat.Hm().format(DateTime.now());
  var format = DateFormat("HH:mm");


  List<UserDetail> userDetails = [];

  // List<ModelBooking> bookingLists = [];

  //Call Active Pick List Api
  Future<bool> activepicklist() async {
    final res = await http.post(Uri.parse(activepicklisturl), headers: {
      "Accept": "application/json"
    }, body: {

      "employeeCode": _empcode
    });
    if (res.statusCode == 200) {
      developer.log(res.body);
      setState(() {
        _isLoading = false;
        (_isLoading == false) ?
        print("true:${_isLoading}") :
        print("false:${_isLoading}");
      });
      print(json.decode(res.body));
      try {
        final UserDetails = userDetailsFromJson(res.body);
        userDetails = UserDetails.userDetails;
        return true;
      }
      catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            " Please Pass Correct parameters ${e}",
            textAlign: TextAlign.center,
          ),
          backgroundColor: appbarColor,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
        ));
        throw Future.error(e);
      }
    } else {
      return false;
    }
  }


  @override
  void initState() {
    get_sessionData();
    super.initState();
    Timer(Duration(seconds: 2), () {
      setState(() {


      });
      activepicklist();
    });
  }
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          bottomNavigationBar: editProfileButton(context),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: FetchPixels.getDefaultHorSpace(context)),
              child:userDetails.isEmpty ? Center(child:SpinKitFadingCircle(
                color: Colors.indigo,
                size: 50.0,
              )): Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  buildToolbarMenu(context),
                  buildBottomList(context)
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          Constant.backToPrev(context);
          return false;
        });
  }

  Expanded buildBottomList(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ListView(
        children: [
          getVerSpace(FetchPixels.getPixelHeight(30)),
          profilePicture(context),
          getVerSpace(FetchPixels.getPixelHeight(40)),
          getCustomFont("First Name", 16, textColor, 1,
              fontWeight: FontWeight.w400),
          getVerSpace(FetchPixels.getPixelHeight(6)),
          getCustomFont(
            userDetails[0].username,
            16,
            Colors.black,
            1,
            fontWeight: FontWeight.w400,
          ),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          getDivider(dividerColor, 0, 1),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          getCustomFont("Employee Code", 16, textColor, 1,
              fontWeight: FontWeight.w400),
          getVerSpace(FetchPixels.getPixelHeight(6)),
          getCustomFont(
            userDetails[0].employeeCode,
            16,
            Colors.black,
            1,
            fontWeight: FontWeight.w400,
          ),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          getDivider(dividerColor, 0, 1),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          getCustomFont("Email", 16, textColor, 1,
              fontWeight: FontWeight.w400),
          getVerSpace(FetchPixels.getPixelHeight(6)),
          getCustomFont(
            userDetails[0].emailId,
            16,
            Colors.black,
            1,
            fontWeight: FontWeight.w400,
          ),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          getDivider(dividerColor, 0, 1),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          getCustomFont("Phone No", 16, textColor, 1,
              fontWeight: FontWeight.w400),
          getVerSpace(FetchPixels.getPixelHeight(6)),
          getCustomFont(
            userDetails[0].mobileNo,
            16,
            Colors.black,
            1,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

  Widget buildToolbarMenu(BuildContext context) {
    return gettoolbarMenu(context, "back.svg", () {
      Constant.backToPrev(context);
    },
        istext: true,
        title: "Profile",
        weight: FontWeight.w900,
        fontsize: 24,
        textColor: Colors.black);
  }

  Align profilePicture(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: FetchPixels.getPixelHeight(100),
        width: FetchPixels.getPixelHeight(100),
        decoration: BoxDecoration(
          image: getDecorationAssetImage(context, "profile_image.png"),
        ),
      ),
    );
  }

  Container editProfileButton(BuildContext context) {
    return Container(
      color: backGroundColor,
      padding: EdgeInsets.only(
          left: FetchPixels.getPixelWidth(20),
          right: FetchPixels.getPixelWidth(20),
          bottom: FetchPixels.getPixelHeight(30)),
      child: getButton(context, blueColor, "Change Password", Colors.white, () {
        Constant.sendToNext(context, Routes.editProfileRoute);
      }, 18,
          weight: FontWeight.w600,
          buttonHeight: FetchPixels.getPixelHeight(60),
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14))),
    );
  }



  /*ListView buildBottomList(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: userDetails.length,
        itemBuilder: (context, index) {
          UserDetail assignedPickList = userDetails[index];
          // PrefData.setBookingModel(jsonEncode(assignedPickLists[index]));
          return Row(
              children: [


                getDefaultTextFiledWithLabel(
                    context, userDetails[index].employeeCode, nameController, Colors.grey,
                    function: () {},
                    height: FetchPixels.getPixelHeight(60),
                    isEnable: false,
                    withprefix: true,
                    image: "profile.svg",
                    imageWidth: FetchPixels.getPixelHeight(24),
                    imageHeight: FetchPixels.getPixelHeight(24)),
                getVerSpace(FetchPixels.getPixelHeight(20)),
                getDefaultTextFiledWithLabel(
                    context, "Email", emailController, Colors.grey,
                    function: () {},
                    height: FetchPixels.getPixelHeight(60),
                    isEnable: false,
                    withprefix: true,
                    image: "message.svg",
                    imageWidth: FetchPixels.getPixelHeight(24),
                    imageHeight: FetchPixels.getPixelHeight(24)),
                getVerSpace(FetchPixels.getPixelHeight(20)),
                getDefaultTextFiledWithLabel(
                    context, "Phone", phoneController, Colors.grey,
                    function: () {},
                    height: FetchPixels.getPixelHeight(60),
                    isEnable: false,
                    withprefix: true,
                    image: "call.svg",
                    imageWidth: FetchPixels.getPixelHeight(24),
                    imageHeight: FetchPixels.getPixelHeight(24)),


              ]
          );
        }
    );
  }*/






}
