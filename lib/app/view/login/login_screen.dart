import 'package:home_service_provider/app/routes/app_routes.dart';
import 'package:home_service_provider/base/color_data.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:home_service_provider/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../base/constant.dart';
import '../../../base/pref_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:home_service_provider/app/utils/strings.dart';
import 'dart:async';
import 'dart:developer' as developer;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void finishView() {
    Constant.closeApp();
  }

  TextEditingController employeecodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPass = true;

  late SharedPreferences logindata;

  late bool newuser;

  String? session_userId;
  String? session_employeeCode;
  String? session_userName;
  String? session_EmailId;
  String? session_warehouseId;
  String? session_companyId;
  String? session_comcode;
  String? session_billType;
  String? session_designation;
  String? session_userGroup;


//write function for seve_sessionData
  save_sessionData()async{

    SharedPreferences logindata = await SharedPreferences.getInstance();
    //Login Value Set False
    logindata.setBool('login', false);
    logindata.setString("userId",session_userId!);
    logindata.setString("employeeCode",session_employeeCode!);
    logindata.setString("userName",session_userName!);
    logindata.setString("warehouseId",session_warehouseId!);
    logindata.setString("companyId",session_companyId!);
    logindata.setString("designation",session_designation!);
    logindata.setString("userGroup",session_userGroup!);
    logindata.setString("emailId",session_EmailId!);
    logindata.setString("comCode",session_comcode!);
    logindata.setString("billType",session_billType!);

    if (logindata.getString("userGroup") =="Picker")
    {
     // Get.toNamed(Routes.homeScreenRoute);
      PrefData.setLogIn(true);
      Constant.sendToNext(context, Routes.homeScreenRoute);

    } else {
      Constant.sendToNext(context, Routes.homeScreenRoute);
    }
  }
//write function for login validation
  void loginValidation(){
    String username = employeecodeController.text;
    String password = passwordController.text;
    /**Condition for both are should not be blank*/
    if (username != '' && password != '') {
      /* Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyDashboard()));*/
      PrefData.setLogIn(true);
      sendData();
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
// initState function used for initial start function from this first start
  void initState() {
    error = false;
    sending = false;
    success = false;
    msg = "";
    //sevegroup();
    super.initState();

  }
  //dispose function used for user input value clear
  void dispose() {
    // Clean up the controller when the widget is disposed.
    employeecodeController.dispose();
    passwordController.dispose();
    super.dispose();
  }
//API post Function
  late bool error, sending, success;
  late String msg;
  // String? getUserName;
  String phpurl = Strings.apipath+"login_api.php";
  @override
  Future<void> sendData() async {
    setState((){

    });
    var res = await http.post(Uri.parse(phpurl),
        body: {
          "employeeCode": employeecodeController.text,
          "password": passwordController.text,
         // "usergroup":group,
          // "rollno": rollnoctl.text,
        }); //sending post request with header data
    developer.log(res.body);
    if (res.statusCode == 200) {
      print(res.body);//print raw response on console

      var data = json.decode(res.body);
      print (data["is_success"]);//decoding json to array

      //toast showSnackBar
      if(data["is_success"]==true){
        //get json data asign global variable
        setState(() {

          session_userId= data["user"]["userID"];
          session_employeeCode= data["user"]["employeeCode"];
          session_userName= data["user"]["userName"];
          session_warehouseId= data["user"]["warehouseId"];
          session_companyId= data["user"]["companyId"];
          session_designation= data["user"]["designation"];
          session_userGroup= data["user"]["userGroup"];//getUserName
          session_EmailId= data["user"]["emailId"];//getUserName
          session_comcode=data["user"]["comp_code"];
          session_billType=data["user"]["bill_type"];
          print("welcome bill type sfdmasnfkl");
          print(session_billType);

        });
        save_sessionData();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar
          (
          content: Text(data["messages"],textAlign: TextAlign.center,),
          backgroundColor: appbarColor,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
        )
        );
        setState(() {
          sending = true;
        }

        );
        //getUserName= data["user"]["userName"];//getUserName
      }

      else if(data["is_success"]==false){
        employeecodeController.text = "";
        employeecodeController.text = "";
       // getUserGroup = "";
        // rollnoctl.text = "";
        //after write success, make fields empty
        //toast showSnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar

          (
          content: Text(data["messages"],textAlign: TextAlign.center,),
          backgroundColor: appbarColor,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
        )



        );
        setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
        });
      }

    }else{
      //there is error
      setState(() {
        error = true;
        msg = "Error occured while sending data.";
        sending = false;
        //mark error and refresh UI with setState
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(

          body: SingleChildScrollView(
            reverse: true,
            child: SafeArea(
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: FetchPixels.getDefaultHorSpace(context)),
                alignment: Alignment.topCenter,
                child: buildWidgetList(context),
              ),
            ),
          ),
        ),
        onWillPop: () async {
          finishView();
          return false;
        });
  }

  ListView buildWidgetList(BuildContext context) {
    return ListView(
              shrinkWrap: true,
              primary: true,
              children: [
                getVerSpace(FetchPixels.getPixelHeight(10)),
                profileLogo(context),
                getVerSpace(FetchPixels.getPixelHeight(1)),
                getCustomFont("Login", 24, Colors.black, 1,
                    fontWeight: FontWeight.w900, ),
                getVerSpace(FetchPixels.getPixelHeight(1)),
                getCustomFont("Glad to meet you again! ", 16, Colors.black, 1,
                    fontWeight: FontWeight.w400, ),
                getVerSpace(FetchPixels.getPixelHeight(20)),

                TextField(
                    controller: employeecodeController,
                    decoration: InputDecoration(

                    //  labelText: "Employee Code", //babel text

                      hintText: "Employee Code", //hint text
                      prefixIcon: Icon(Icons.people), //prefix iocn
                      hintStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600), //hint text style
                      labelStyle: TextStyle(fontSize: 12, color: Colors.indigo), //label style
                    )
                ),
                getVerSpace(FetchPixels.getPixelHeight(20)),
                TextField(
                    controller: passwordController,
                    obscureText: true,
                    enableSuggestions: false,

                    decoration: InputDecoration(

                     // labelText: "Employee Code", //babel text
                      hintText: "Password", //hint text
                      prefixIcon: Icon(Icons.lock), //prefix iocn
                      hintStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600), //hint text style
                      labelStyle: TextStyle(fontSize: 12, color: Colors.indigo), //label style

                    )

                ),
                getVerSpace(FetchPixels.getPixelHeight(20)),

                Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Constant.sendToNext(context, Routes.forgotRoute);
                      },
                      child: getCustomFont("Forgot Password?", 16, blueColor, 1,
                          fontWeight: FontWeight.w900, ),
                    )),
                getVerSpace(FetchPixels.getPixelHeight(49)),
                getButton(context, blueColor, "Login", Colors.white, () {
                 // PrefData.setLogIn(true);
                 // Constant.sendToNext(context, Routes.homeScreenRoute);
                  loginValidation();
                }, 18,
                    weight: FontWeight.w600,
                    buttonHeight: FetchPixels.getPixelHeight(60),
                    borderRadius:
                        BorderRadius.circular(FetchPixels.getPixelHeight(15))),
                getVerSpace(FetchPixels.getPixelHeight(30)),
              /*  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getCustomFont("Don’t have an account?", 14, Colors.black, 1,
                        fontWeight: FontWeight.w400, ),
                    GestureDetector(
                      onTap: () {
                        Constant.sendToNext(context, Routes.signupRoute);
                      },
                      child: getCustomFont(" Sign Up", 16, blueColor, 1,
                          fontWeight: FontWeight.w900, ),
                    )
                  ],
                ),
*/
              ],
            );
  }
  Align profileLogo(BuildContext context) {
    return Align(
      alignment:  Alignment(0.1, 0.6),
      child: Container(
        height: FetchPixels.getPixelHeight(200),
        width: FetchPixels.getPixelHeight(250),
        decoration: BoxDecoration(
          image: getDecorationAssetImage(context, "popular_logo.png"),
        ),
      ),
    );
  }
}
