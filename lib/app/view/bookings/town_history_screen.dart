import 'dart:convert';
import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:home_service_provider/base/color_data.dart';
import 'package:intl/intl.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../apiclass/ModelActivePicklist.dart';
import '../../../base/widget_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:home_service_provider/app/utils/strings.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class TownHistoryScreen extends StatefulWidget {
  const TownHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TownHistoryScreen> createState() => _TownHistoryScreen();
}

class _TownHistoryScreen extends State<TownHistoryScreen> {
  String activepicklisturl = Strings.apipath+"history_api.php";

  //final _current = 0.obs;
  var _isLoading = true;
  String? pickcategory;
  String _empcode='';
  String _comcode='';
  String _billtype='';
  get_sessionData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      _empcode = (logindata.getString('employeeCode')??'');
      _comcode = (logindata.getString('comCode') ?? '');
      _billtype = (logindata.getString('billType') ?? '');
    });
  }
  /*get time  */
  dynamic currentTime = DateFormat.Hm().format(DateTime.now());
  var format = DateFormat("HH:mm");
  final CarouselController _controller = CarouselController();

  List<AssignedPickList> assignedPickLists = [];
  // List<ModelBooking> bookingLists = [];

  //Call Active Pick List Api
  Future<bool> activepicklist() async {
    final res = await http.post(Uri.parse(activepicklisturl), headers: {
      "Accept": "application/json"
    }, body: {
      "compCode": _comcode,
      "category": "Courier",
      "employeeCode":_empcode
    });
    if (res.statusCode == 200) {
      developer.log(res.body);
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

  @override
  Widget build(BuildContext context) {

    FetchPixels(context);
    return Scaffold(
      body:(_isLoading==true) ? Center(child:SpinKitFadingCircle(
        color: Colors.indigo,
        size: 50.0,
      )):_bodyWidget(context),);

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
        return GestureDetector(
          onTap: () {
           // Constant.sendToNext(context, Routes.bookingRoute,arguments:{"category":pickcategory,"pickId":assignedPickList.pickId,"pickstatus":assignedPickLists[index].pickStatus,},);
          },
          child: Container(
            height: FetchPixels.getPixelHeight(171),
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
                      getHorSpace(FetchPixels.getPixelWidth(16)),

                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(flex: 1,child: getHorSpace(0),),
                            getCustomFont(
                                assignedPickList.pickId ?? "", 16, Colors.black, 1,
                                fontWeight: FontWeight.w900),
                            getVerSpace(FetchPixels.getPixelHeight(12)),
                            getCustomFont(
                              assignedPickList.billdate ?? "",
                              14,
                              textColor,
                              1,
                              fontWeight: FontWeight.w400,
                            ),
                            getVerSpace(FetchPixels.getPixelHeight(12)),
                            Row(
                              children: [
                                getSvgImage("check.svg",
                                    height: FetchPixels.getPixelHeight(16),
                                    width: FetchPixels.getPixelHeight(16)),
                                getHorSpace(FetchPixels.getPixelWidth(6)),
                                getCustomFont(
                                    assignedPickList.itemCnt ?? "", 14, Colors.black, 1,
                                    fontWeight: FontWeight.w400),
                                getCustomFont(
                                    " Items", 14, Colors.black, 1,
                                    fontWeight: FontWeight.w400),
                              ],
                            ),
                            Expanded(flex: 1,child: getHorSpace(0),),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          /*   GestureDetector(
                      onTap: () {
                        funDelete();
                      },
                       child: getSvgImage("trash.svg",
                           width: FetchPixels.getPixelHeight(20),
                           height: FetchPixels.getPixelHeight(20)),
                     ),*/
                          getPaddingWidget(EdgeInsets.only(bottom:FetchPixels.getPixelHeight(10) ),  getCustomFont(
                            "\u20B9${assignedPickList.totalAmt}",
                            16,
                            blueColor,
                            1,
                            fontWeight: FontWeight.w900,
                          ))
                        ],
                      )

                    ],
                  ),
                ),
                getVerSpace(FetchPixels.getPixelHeight(16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        getAssetImage("dot.png", FetchPixels.getPixelHeight(8),
                            FetchPixels.getPixelHeight(8)),
                        getHorSpace(FetchPixels.getPixelWidth(8)),
                        getCustomFont(assignedPickList.custname  ?? "", 14, textColor, 1,
                            fontWeight: FontWeight.w400),
                        getCustomFont(" [ ", 14, textColor, 1,
                            fontWeight: FontWeight.w400),
                        getCustomFont(assignedPickList.custcode  ?? "", 14, textColor, 1,
                            fontWeight: FontWeight.w400),
                        getCustomFont(" ]", 14, textColor, 1,
                            fontWeight: FontWeight.w400),
                      ],
                    ),

                    Wrap(

                      children: [

                        if (assignedPickList.pickStatus=='Cancelled')...[
                          getButton(
                              context,
                              Color(assignedPickList.bgError!.toInt()),
                              assignedPickList.pickStatus ?? "",
                              assignedPickList.errortextColor!,
                                  () {},
                              16,
                              weight: FontWeight.w600,
                              borderRadius:
                              BorderRadius.circular(FetchPixels.getPixelHeight(37)),
                              insetsGeometrypadding: EdgeInsets.symmetric(
                                  vertical: FetchPixels.getPixelHeight(6),
                                  horizontal: FetchPixels.getPixelWidth(12)))
                        ]
                        else...[

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
                                  horizontal: FetchPixels.getPixelWidth(12)))



                        ]
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
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getSvgImage("clipboard.svg",
                  height: FetchPixels.getPixelHeight(124),
                  width: FetchPixels.getPixelHeight(124)),
              getVerSpace(FetchPixels.getPixelHeight(40)),
              getCustomFont("No Pick List Available Yet!", 20, Colors.black, 1,
                  fontWeight: FontWeight.w900),
              getVerSpace(FetchPixels.getPixelHeight(10)),
              getCustomFont(
                "Go to services and book the best services. ",
                16,
                Colors.black,
                1,
                fontWeight: FontWeight.w400,
              ),


            ],
          ),
        ));
  }
}
