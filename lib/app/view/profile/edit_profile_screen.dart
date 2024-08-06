import 'dart:convert';

import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import 'package:http/http.dart' as http;

import '../../utils/strings.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController newPassController = TextEditingController();
  TextEditingController ConfirmController = TextEditingController();
  //TextEditingController phoneController = TextEditingController();
  bool isPass = true;
  late var data;
  String _empcode='';
  String activepicklisturl = Strings.apipath+"userPassUpdate_api.php";

  get_sessionData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      _empcode = (logindata.getString('employeeCode')??'');
    });
  }
  Future<void> sendData(username,password) async {
    print(_empcode);
    print(password);
    final res = await http.post(Uri.parse(activepicklisturl), headers: {
      "Accept": "application/json"
    }, body: {
      "password": password,
      "employeeCode": _empcode
    });
    if (res.statusCode == 200) {
      //   developer.log(res.body);
      setState(() {
       /* _isLoading = false;
        (_isLoading== false)?
        print("true:${_isLoading}"):
        print("false:${_isLoading}");*/
      });
      print(json.decode(res.body));
      var data = json.decode(res.body);
      if (data["is_success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar
          (
          content: Text(data["messages"], textAlign: TextAlign.center,),
          backgroundColor: appbarColor,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
        )

        );
        Constant.backToPrev(context);
      } else if (data["is_success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar
          (
          content: Text(data["messages"], textAlign: TextAlign.center,),
          backgroundColor: appbarColor,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
          duration: const Duration(seconds: 3),
        )
        );

      }
    }
  }
  void loginValidation(){
    String username = newPassController.text;
    String password = ConfirmController.text;
    /**Condition for both are should not be blank*/
    if (username != '' && password != '') {
      /* Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyDashboard()));*/
    //  PrefData.setLogIn(true);
      if(username==password){
        sendData(username,password);
      }
     else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar
          (
          content: Text("Should  Match Confirmpassword!",textAlign: TextAlign.center,),
          backgroundColor: Colors.red,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),

        )

        );
      }
    }

    /**Condition for Email Id Should not be blank*/
    else if(username == '' && password != '')
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar
        (
        content: Text("Employee Should not be blank",textAlign: TextAlign.center,),
        backgroundColor: Colors.red,
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(15),

      )

      );
    }

    /**Condition for Password Should not be blank*/
    else if(username != '' && password == '')
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar
        (
        content: Text("Password Should not be blank",textAlign: TextAlign.center,),
        backgroundColor: Colors.red,
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(15),
      )
      );
    }

    /**Condition for Enter valid Email Id & Password*/
    else if(username == '' && password == '')
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar
        (
        content: Text("Enter valid Employee Code & Password",textAlign: TextAlign.center,),
        backgroundColor: Colors.red,
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        margin: EdgeInsets.all(15),
      )
      );
    }

  }

  void initState() {
    get_sessionData();
    super.initState();

    /*Future.delayed(Duration.zero, () {
      setState((){
        Map args = ModalRoute.of(context)?.settings.arguments as Map;
        pickcategory = args['category'];
        // print(pickcategory);

      });
      activepicklist();
    });*/
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
         // bottomNavigationBar: saveButton(context),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: FetchPixels.getDefaultHorSpace(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  buildToolbar(context),
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  profilePicture(context),
                  getVerSpace(FetchPixels.getPixelHeight(20)),
                  buildExpand(context)
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

  Expanded buildExpand(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ListView(
        primary: true,
        shrinkWrap: true,
        children: [
         profilePictureEdit(context),
          getVerSpace(FetchPixels.getPixelHeight(40)),
          getDefaultTextFiledWithLabel(
              context, "New Password", newPassController, Colors.grey,
              TextStyle(fontSize: 23),
              function: () {},
              height: FetchPixels.getPixelHeight(60),
              isEnable: false,
              withprefix: true,
              image: "lock.svg",
              isPass: isPass,

              withSufix: true,
              suffiximage: "eye.svg", imagefunction: () {
            setState(() {
              isPass = !isPass;
            });

              imageWidth: FetchPixels.getPixelHeight(24);
              imageHeight: FetchPixels.getPixelHeight(24);
          }),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          getDefaultTextFiledWithLabel(
              context, "Confirm Password", ConfirmController, Colors.grey,
              TextStyle(fontSize: 23),
              function: () {},
              height: FetchPixels.getPixelHeight(60),
              isEnable: false,
              withprefix: true,
              image: "lock.svg",

              isPass: isPass,

              withSufix: true,
              suffiximage: "eye.svg", imagefunction: () {
            setState(() {
              isPass = !isPass;
            });

            imageWidth: FetchPixels.getPixelHeight(24);
            imageHeight: FetchPixels.getPixelHeight(24);
          }),
          getVerSpace(FetchPixels.getPixelHeight(100)),
          saveButton(context)

        ],
      ),
    );
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

  Widget buildToolbar(BuildContext context) {
    return gettoolbarMenu(context, "back.svg", () {
      Constant.backToPrev(context);
    },
        istext: true,
        title: "Edit Profile",
        weight: FontWeight.w900,
        fontsize: 24,
        textColor: Colors.black);
  }

  Container saveButton(BuildContext context) {
    return Container(
      color: backGroundColor,
      padding: EdgeInsets.only(
          left: FetchPixels.getPixelWidth(0),
          right: FetchPixels.getPixelWidth(0),
          bottom: FetchPixels.getPixelHeight(30)),
      child: getButton(context, blueColor, "Save", Colors.white, () {
        //Constant.backToPrev(context);

        loginValidation();





      }, 18,
          weight: FontWeight.w600,
          buttonHeight: FetchPixels.getPixelHeight(60),
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14))),
    );
  }

  Align profilePictureEdit(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: FetchPixels.getPixelHeight(100),
            width: FetchPixels.getPixelHeight(100),
            decoration: BoxDecoration(
              image: getDecorationAssetImage(context, "profile_picture.png"),
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
                child: getSvgImage("edit.svg",
                    height: FetchPixels.getPixelHeight(24),
                    width: FetchPixels.getPixelHeight(24)),
              ))
        ],
      ),
    );
  }
}
