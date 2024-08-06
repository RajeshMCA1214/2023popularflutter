import 'dart:convert';
import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:home_service_provider/base/color_data.dart';
import 'package:intl/intl.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import '../../../apiclass/ModelActivePicklist.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../routes/app_routes.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:home_service_provider/app/utils/strings.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ActiveBookingScreen extends StatefulWidget {
  const ActiveBookingScreen({Key? key}) : super(key: key);

  @override
  State<ActiveBookingScreen> createState() => _ActiveBookingScreenState();
}

class _ActiveBookingScreenState extends State<ActiveBookingScreen> {
  //Future<bool> _future;
  String activepicklisturl = Strings.apipath+"active_picklist_api.php";
  String assignpicklisturl = Strings.apipath+"assign_picklist_api.php";
  //final _current = 0.obs;
  var _isLoading = true;
  String? pickcategory;
  /*get time  */
  dynamic currentTime = DateFormat.Hm().format(DateTime.now());
  var format = DateFormat("HH:mm");
  final CarouselController _controller = CarouselController();
  TextEditingController containerQR = TextEditingController();
  String _empcode='';
  String? action;
  String? assignRes;
  String _binqrcode = '';
  String _comcode='';
  String _billtype='';
  get_sessionData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      _empcode = (logindata.getString('employeeCode')??'');
      _binqrcode = (logindata.getString('binqrcode') ?? '');
      _comcode = (logindata.getString('comCode') ?? '');
      _billtype = (logindata.getString('billType') ?? '');
      containerQR.text = _binqrcode;
    });
  }
  List<AssignedPickList> assignedPickLists = [];
 // List<ModelBooking> bookingLists = [];

  //Call Active Pick List Api
  Future<bool> assignpicklist() async {
    print(pickcategory);

    final res = await http.post(Uri.parse(assignpicklisturl), headers: {

      "Accept": "application/json"
    }, body: {
      "bill_type":_billtype,
      "compCode": _comcode,
      "category": pickcategory,
      "employeeCode": _empcode,
      "action":"assignnew"
    });
    developer.log(res.body);
    if (res.statusCode == 200) {
      activepicklist();
      developer.log(res.body);
      print(json.decode(res.body));
      var data = json.decode(res.body);
      try {
        // action = "0";
        assignRes=data["messages"];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar
          (
          content: Text(data["messages"],textAlign: TextAlign.center,),
          backgroundColor: appbarColor,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
          duration: const Duration(milliseconds: 300),
        )

        );

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
  Future<bool> activepicklist() async {

    final res = await http.post(Uri.parse(activepicklisturl), headers: {
      "Accept": "application/json"
    }, body: {
      "bill_type":_billtype,
      "compCode": _comcode,
      "category": pickcategory,
      "employeeCode":_empcode
    });
    if (res.statusCode == 200) {
     // developer.log(res.body);
      setState(() {
        _isLoading = false;
        (_isLoading== false)?
        print("true:${_isLoading}"):
        print("false:${_isLoading}");
      });
      print(json.decode(res.body));
      try {
        final ModelActivePicklist = modelActivePicklistFromJson(res.body);
        assignedPickLists=ModelActivePicklist.assignedPickList;

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
    }
    else {
      return false;
    }
  }


  @override
  void initState() {
    get_sessionData();
    super.initState();

    Future.delayed(Duration.zero, () {
    setState((){
      Map args = ModalRoute.of(context)?.settings.arguments as Map;
      pickcategory = args['category'];
      print(pickcategory);

    });
    activepicklist();

    });
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<String>(
        builder: (context, snapshot) {
    FetchPixels(context);
    return Scaffold(
      body:(_isLoading==true) ? Center(child:SpinKitFadingCircle(
        color: Colors.indigo,
        size: 50.0,
      )):_bodyWidget(context),);
        }, future: null,
    );

  }
  _bodyWidget(BuildContext context) {
    return Container(
      color: backGroundColor,
      child: assignedPickLists.isEmpty ? nullListView(context) : activeBookingList(),

    );
  }
/*
  ListView activeBookingList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: bookingLists.length,
      itemBuilder: (context, index) {
        ModelBooking modelBooking = bookingLists[index];
        return modelBooking.tag == "Active"
            ? buildBookingListItem(modelBooking, context, index, () {
          ModelBooking booking = ModelBooking(
              modelBooking.name ?? "",
              modelBooking.date ?? "",
              modelBooking.rating ?? "",
              modelBooking.price ?? 0.0,
              modelBooking.owner ?? "",
              modelBooking.tag,
              0,
              null);
          PrefData.setBookingModel(jsonEncode(booking));
          Constant.sendToNext(context, Routes.bookingRoute);
        }, () {
          setState(() {
            bookingLists.removeAt(index);
          });
        })
            : Container();
      },
    );
  }
*/

  ListView activeBookingList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: assignedPickLists.length,
      itemBuilder: (context, index) {
        AssignedPickList assignedPickList = assignedPickLists[index];
       // PrefData.setBookingModel(jsonEncode(assignedPickLists[index]));
       String? pid= assignedPickList.pickId;
        return GestureDetector(
            onTap: () {

             Constant.sendToNext(context, Routes.activeDetailsScreenRoute,arguments:{"category":pickcategory,"pickId":pid,"pickstatus":assignedPickLists[index].pickStatus,},);
             // Constant.sendToNext(context, Routes.pickListPreviewScreenRoute,arguments:{"category":pickcategory,"pickId":pid,"pickstatus":assignedPickLists[index].pickStatus,},);
        },
        child: Container(
          height: FetchPixels.getPixelHeight(250),
          margin: EdgeInsets.only(
              bottom: FetchPixels.getPixelHeight(20),
              left: FetchPixels.getDefaultHorSpace(context),
              right: FetchPixels.getDefaultHorSpace(context)),
          padding: EdgeInsets.symmetric(
              vertical: FetchPixels.getPixelHeight(16),
              horizontal: FetchPixels.getPixelWidth(16)),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0.0, 4.0)),
              ],
              borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12))),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    getHorSpace(FetchPixels.getPixelWidth(8)),

                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 1,child: getHorSpace(0),),
                          getCustomFont(
                            "#" + assignedPickList.pickId.toString() ?? "" ,
                            24,
                            Colors.black,
                            1,
                            fontWeight: FontWeight.w900,
                          ),
                          getCustomFont(
                            "Tele Caller:" + assignedPickList.Rapcode.toString() ?? "",
                            20,
                            Colors.black,
                            1,
                            fontWeight: FontWeight.w400,
                          ),
                          getVerSpace(FetchPixels.getPixelHeight(8)),
                          getCustomFont(
                              assignedPickList.custname ?? "", 16, Colors.black, 1,
                              fontWeight: FontWeight.w900),
                          getVerSpace(FetchPixels.getPixelHeight(8)),
                          getCustomFont(
                            assignedPickList.custcode ?? "",
                            20,
                            textColor,
                            1,
                            fontWeight: FontWeight.w400,
                          ),
                          getVerSpace(FetchPixels.getPixelHeight(8)),

                          Row(
                            children: [
                              getSvgImage("check.svg",
                                  height: FetchPixels.getPixelHeight(20),
                                  width: FetchPixels.getPixelHeight(20)),

                              getHorSpace(FetchPixels.getPixelWidth(6)),
                              getCustomFont(
                                  assignedPickList.itemCnt ?? "", 20, Colors.black, 1,
                                  fontWeight: FontWeight.w400),
                              getCustomFont(
                                  " Items", 20, Colors.black, 1,
                                  fontWeight: FontWeight.w400),

                            ],
                          ),
                          Expanded(flex: 1,child: getHorSpace(0),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,40,0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          getPaddingWidget(EdgeInsets.only(bottom:FetchPixels.getPixelHeight(10) ),
                              getCustomFont(
                                "${assignedPickList.pick_category}",
                                15,
                                Colors.blue,
                                1,
                                fontWeight: FontWeight.w900,
                              )),

                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        /*   GestureDetector(
                      onTap: () {
                        funDelete();
                      },
                       child: getSvgImage("trash.svg",
                           width: FetchPixels.getPixelHeight(20),
                           height: FetchPixels.getPixelHeight(20)),
                     ),*/
                        getPaddingWidget(EdgeInsets.only(bottom:FetchPixels.getPixelHeight(0) ),  getCustomFont(
                          "\u20B9${assignedPickList.totalAmt}",
                          20,
                          blueColor,
                          1,
                          fontWeight: FontWeight.w900,
                        )),

                      ],
                    )

                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Row(
                    children: [
                      getAssetImage("date.png", FetchPixels.getPixelHeight(25),
                          FetchPixels.getPixelHeight(25)),

                      getCustomFont(assignedPickList.picklisttime  ?? "", 20, textColor, 1,
                          fontWeight: FontWeight.w400),

                    ],
                  ),
                 Wrap(
                children: [
                  getButton(
                      context,
                      Color(assignedPickList.bgColor!.toInt()),
                      assignedPickList.pickStatus ?? "",
                      assignedPickList.textColor!,
                          () {},
                      16,
                      weight: FontWeight.w600,
                      borderRadius:
                      BorderRadius.circular(FetchPixels.getPixelHeight(37)),
                      insetsGeometrypadding: EdgeInsets.symmetric(
                          vertical: FetchPixels.getPixelHeight(6),
                          horizontal: FetchPixels.getPixelWidth(12)
                      )
                  )
                ],
              )
                ],
              )
            ],
          ),

        ),
        );
      },
    );
  }


  Widget nullListView(BuildContext context) {
    return getPaddingWidget(
        EdgeInsets.symmetric(
            horizontal: FetchPixels.getDefaultHorSpace(context)),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getSvgImage("clipboard.svg",
                height: FetchPixels.getPixelHeight(124),
                width: FetchPixels.getPixelHeight(124)),
            getVerSpace(FetchPixels.getPixelHeight(40)),
            getCustomFont("No Active Pick List Yet!", 20, Colors.black, 1,
                fontWeight: FontWeight.w900),
            getVerSpace(FetchPixels.getPixelHeight(10)),
            getCustomFont(
              "Go to services and book the best services. ",
              16,
              Colors.black,
              1,
              fontWeight: FontWeight.w400,
            ),
            getVerSpace(FetchPixels.getPixelHeight(30)),
            getButton(
                context, backGroundColor, "Make Shcedule", blueColor, () {
            //  Constant.sendToNext(context, Routes.localPickScreenRoute, arguments:{"category":pickcategory,"action":"assignnew",},);
              if(_empcode!='' ) {
              //  print(_empcode);
                assignpicklist();
                setState(() {
               // activepicklist();
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => activepicklist());
                });

              }
            }, 18,
                weight: FontWeight.w600,
                buttonHeight: FetchPixels.getPixelHeight(60),
                insetsGeometry: EdgeInsets.symmetric(
                    horizontal: FetchPixels.getPixelWidth(106)),
                borderRadius:
                    BorderRadius.circular(FetchPixels.getPixelHeight(14)),
                isBorder: true,
                borderColor: blueColor,
                borderWidth: 1.5)
          ],
        )
    );
  }

}
