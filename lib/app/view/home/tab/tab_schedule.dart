import 'dart:async';
import 'dart:convert';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_service_provider/app/data/data_file.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:home_service_provider/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../apiclass/ProfileHistory.dart';
import '../../../../base/color_data.dart';
import '../../../../base/constant.dart';
import '../../../models/model_booking.dart';
import 'package:http/http.dart' as http;

import '../../../routes/app_routes.dart';
import '../../../utils/strings.dart';
import 'dart:developer' as developer;




class TabSchedule extends StatefulWidget {
  const TabSchedule({Key? key}) : super(key: key);

  @override
  State<TabSchedule> createState() => _TabScheduleState();
}

class _TabScheduleState extends State<TabSchedule> {
  bool schedule = true;
  List<ModelBooking> scheduleList = DataFile.scheduleList;
  late String _startDate, _endDate;
  String? from;
  String? to;
  String _empcode = '';
  var _isLoading = true;
  String radioButtonItem = 'Local';
  late double pickCount=0.00;
  String Value='';
  String Picked='';


  // Group Value for Radio Button.
  int id = 1;
  List<TotalCount> totalCount=[];
  List<Categorycount> categorycoun=[];
  final DateRangePickerController _controller=DateRangePickerController();
  String profileHistorycnt = Strings.apipath + "profileHistory_api.php";

  get_sessionData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      _empcode = (logindata.getString('employeeCode')??'');

    });
  }



  Future<void> pickHistory() async {



    final res = await http.post(Uri.parse(profileHistorycnt), headers: {

      "Accept": "application/json"
    }, body: {

      "start_date": _startDate,
      "end_date": _endDate,
      "employeeCode": _empcode
    });
    if (res.statusCode == 200) {
         developer.log(res.body);
      print(json.decode(res.body));
      Map<String,dynamic> map = json.decode(res.body);
      var data = json.decode(res.body);
      if (data["is_success"] == true) {
        try {
          final ProfileHistory = profileHistoryFromJson(res.body);
          totalCount = ProfileHistory.totalCount;
          categorycoun = ProfileHistory.categorycount;
         // print(totalCount[0].totalCount);
          // this like convert json to list


        } catch (e) {
          /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              " Please Pass Correct parameters ${e}",
              textAlign: TextAlign.center,
            ),
            backgroundColor: appbarColor,
            elevation: 10,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(15),
          ));
          throw Future.error(e);*/
        }
      } else if (data["is_success"] == false) {
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







  void initState() {
    get_sessionData();
    super.initState();
    Timer(Duration(seconds: 0), () {
      setState(() {
        _isLoading = false;
        (_isLoading== false)?
        print("true:${_isLoading}"):
        print("false:${_isLoading}");
      });
    });
    Future.delayed(Duration.zero, () {

      final DateTime today = DateTime.now();
      _endDate = DateFormat('yyyy-MM-dd').format(today).toString();
      from=DateFormat('dd-MM-yyyy').format(today).toString();
      to=DateFormat('dd-MM-yyyy').format(today.add(Duration(days: 7))).toString();
      _startDate = DateFormat('yyyy-MM-dd')
          .format(today.add(Duration(days: 7)))
          .toString();
      _controller.selectedRange = PickerDateRange(
          today.subtract(Duration(days: 7)),
          today); //today.add(Duration(days: 7))
      print("init State");
      print(_startDate);
      print(_endDate);
    });
     if(_empcode!='')
      pickHistory();

  }

  @override
  Widget build(BuildContext context) {
    get_sessionData();

    FetchPixels(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
        horizontal: FetchPixels.getDefaultHorSpace(context));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor,
      body:Column(
        children: [
          getVerSpace(FetchPixels.getPixelHeight(20)),
          buildSearchBar(edgeInsets, context),
          schedule == true ? Container() : nullScheduleView(context),
          schedule == true
              ? buildScheduleWidget(edgeInsets, context)
              : Container()
        ],
      ),
    );
  }





  Widget buildSearchBar(EdgeInsets edgeInsets, BuildContext context) {
    return getPaddingWidget(
            edgeInsets,
            withoutleftIconToolbar(context,
                isrightimage: true,
                title: "PICKING REPORT",
                weight: FontWeight.w900,
                textColor: Colors.blue,
                fontsize: 24,
                istext: true,
                rightimage: "", rightFunction: () {

            }));
  }

  Expanded buildScheduleWidget(EdgeInsets edgeInsets, BuildContext context) {
    return Expanded(
                flex: 1,
                child: ListView(
                  primary: true,
                  shrinkWrap: true,
                  children: [
                    getVerSpace(FetchPixels.getPixelHeight(30)),
                    calendar(edgeInsets),

                    //bookingList(),

                    getVerSpace(FetchPixels.getPixelHeight(10)),

                    _isLoading==true ? Center(child:SpinKitFadingCircle(
    color: Colors.indigo,
    size: 50.0,
    )):
                     addReminderButton(context),
                    getVerSpace(FetchPixels.getPixelHeight(10)),

                    totalCount.isEmpty ? Center(child:SpinKitFadingCircle(
                      color: Colors.indigo,
                      size: 50.0,
                    )): buildScheduleList(edgeInsets),

                  ],
                ),
              );
  }



 /*ListView buildScheduleList(EdgeInsets edgeInsets) {
    return ListView.builder(
      itemBuilder: (context, index) {
        TotalCount count = totalCount![index];

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


             Container(
               padding: EdgeInsets.symmetric(
                  vertical: FetchPixels.getPixelHeight(16),
                   horizontal:
                      FetchPixels.getPixelWidth(16)),
               decoration: BoxDecoration(
                   color: Colors.white,
                   boxShadow: const [
                    BoxShadow(
                         color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0.0, 4.0)),
                  ],
                  borderRadius: BorderRadius.circular(
                      FetchPixels.getPixelHeight(12))),
               child: Column(
                 children: [
                  Row(
                     mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                         children: [
                           Container(
                             height:
                                 FetchPixels.getPixelHeight(
                                     91),
                             width:
                                FetchPixels.getPixelHeight(
                                    91),
                             decoration: BoxDecoration(
                               image:
                                   getDecorationAssetImage(
                                     context,
                                      "booking1.png"),
                             ),
                           ),
                           getHorSpace(
        FetchPixels.getPixelWidth(
                                   16)),
                           Column(
                             crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              getCustomFont("Cleaning", 16,
                                  Colors.black, 1,
                                  fontWeight:
                                      FontWeight.w900),
                              getVerSpace(FetchPixels
                                  .getPixelHeight(6)),
                               getCustomFont(
                                "08 July, 2022, 11:00 am",
        14,
                                textColor,
                                 1,
                                 fontWeight: FontWeight.w400,
                              ),
                               getVerSpace(FetchPixels
                                  .getPixelHeight(6)),
                               Row(
                                 children: [
                                   getSvgImage("star.svg",
                                       height: FetchPixels
                                          .getPixelHeight(
                                               16),
                                       width: FetchPixels
                                           .getPixelHeight(
                                               16)),
                                   getHorSpace(FetchPixels
                                       .getPixelWidth(6)),
                                   getCustomFont("4.3", 14,
                                       Colors.black, 1,
                                       fontWeight:
                                          FontWeight.w400),
                                ],
                               )
                           ],
                          )
                         ],
                      ),
                      Column(
                         children: [
                          GestureDetector(
                            onTap: () {},
                             child: getSvgImage("trash.svg",
                                width: FetchPixels
                                     .getPixelHeight(20),
                                 height: FetchPixels
                                     .getPixelHeight(20)),
                          ),
                          getVerSpace(
                              FetchPixels.getPixelHeight(
                                  43)),
                          getCustomFont(
                            "\$20.00",
                          16,
                            blueColor,
                            1,
                            fontWeight: FontWeight.w900,
                          )
                         ],
                       )
                     ],
                   ),
                   getVerSpace(
                       FetchPixels.getPixelHeight(16)),
                   Row(
                    mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
                     children: [
                       Row(
                        children: [
                           getAssetImage(
                              "dot.png",
                               FetchPixels.getPixelHeight(8),
                               FetchPixels.getPixelHeight(
                                   8)),
                           getHorSpace(
                              FetchPixels.getPixelWidth(8)),
                          getCustomFont("By Mendy Wilson",
                               14, textColor, 1,
                               fontWeight: FontWeight.w400),
                        ],
                       ),
                       Wrap(
                         children: [
                           getButton(
                               context,
                               const Color(0xFFEEFCF0),
                              "Active",
                              success,
                              () {},
        16,
        weight: FontWeight.w600,
                               borderRadius: BorderRadius
                                   .circular(FetchPixels
                                       .getPixelHeight(37)),
                               insetsGeometrypadding:
                                  EdgeInsets.symmetric(
                                       vertical: FetchPixels
                                          .getPixelHeight(
                                              6),
                                      horizontal: FetchPixels
                                          .getPixelWidth(
                                               12)))
                        ],
                     )
                    ],
                   )
                ],
              ),
             ),
             getVerSpace(FetchPixels.getPixelHeight(20)),
          ],
        );
      },
      shrinkWrap: true,
      primary: false,
      itemCount: scheduleList.length,
    );
  }*/

 /* Widget bookingList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: FetchPixels.getPixelHeight(0)),
      shrinkWrap: true,
      primary: true,
      itemCount: totalCount!.length,
      itemBuilder: (context, index) {
        //ModelItem modelItem = itemProductLists[index];
        return Column(
          children: [
            //  dateHeader(modelItem, index),
            getVerSpace(FetchPixels.getPixelHeight(10)),

            Container(
                margin: EdgeInsets.only(
                    bottom: FetchPixels.getPixelHeight(20),
                    left: FetchPixels.getDefaultHorSpace(context),
                    right: FetchPixels.getDefaultHorSpace(context)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0.0, 4.0)),
                    ],
                    borderRadius:
                    BorderRadius.circular(FetchPixels.getPixelHeight(12))),
                padding: EdgeInsets.symmetric(
                    horizontal: FetchPixels.getPixelWidth(16),
                    vertical: FetchPixels.getPixelHeight(16)),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      new InkWell(
                      /*  onTap: () {
                          //Navigator.pushNamed(context, Routes.scanPartScreenRoute,arguments:{"PartNo":pickListsDetails![index].partno,"PickId":pickListsDetails![index].pickId}, );
                          Constant.sendToNext(
                              context, Routes.scanPartScreenRoute,
                              arguments: {
                                "PartNo": pickListsDetails![index].partno,
                                "pickId": pickListsDetails![index].pickId,
                                "serialNO":pickListsDetails![index].slno,
                                "category": pickcategory,
                                "pickstatus":
                                pickListsDetails[index].pickStatus
                              });
                        },*/

                      ),
                      getHorSpace(FetchPixels.getPixelWidth(80)),


                      getHorSpace(FetchPixels.getPixelWidth(10)),





                      // _editTitleTextField(pickListsDetails![index].partno),


                      /*   Padding(
                            padding: const EdgeInsets.fromLTRB(10.0,0.0,0.0,0.0),
                            child: Column(
                              children: [
                               Expanded(
                                    flex: 1,
                                    child:getSvgImage("cancel-svgrepo.svg",
                                        width: FetchPixels.getPixelHeight(40),
                                        height: FetchPixels.getPixelHeight(40)),
                               ),
                              ],
                            ),
                          ),
*/
                    ]),
                    getVerSpace(FetchPixels.getPixelHeight(6)),
                    getCustomFont(totalCount![index].totalItem ?? "",
                        14, textColor, 1,
                        fontWeight: FontWeight.w400),

                    getVerSpace(FetchPixels.getPixelHeight(10)),
                    getDivider(dividerColor, 0, 1),
                    getVerSpace(FetchPixels.getPixelHeight(10)),
                    //here
                    Row(
                      children: [
                        Container(
                          width: FetchPixels.getPixelWidth(100),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0.0, 4.0)),
                              ],
                              borderRadius: BorderRadius.circular(
                                  FetchPixels.getPixelHeight(12))),
                          padding: EdgeInsets.only(
                              left: FetchPixels.getPixelWidth(10),
                              right: FetchPixels.getPixelWidth(10),
                              top: FetchPixels.getPixelHeight(10),
                              bottom: FetchPixels.getPixelHeight(10)),
                          margin: EdgeInsets.only(
                            //left: (index % 0 == 0) ? horSpace : 0,
                              bottom: FetchPixels.getPixelHeight(4),
                              right: FetchPixels.getPixelWidth(2)),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: getCustomFont(
                                    "Price",
                                    14,
                                    Colors.black,
                                    1,
                                    fontWeight: FontWeight.w900,
                                  )),
                              getVerSpace(FetchPixels.getPixelHeight(4)),
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: getCustomFont(
                                      totalCount![index].totalCount,
                                      14,
                                      Colors.black,
                                      1,
                                      fontWeight: FontWeight.w400))
                            ],
                          ),
                        ),
                        getHorSpace(FetchPixels.getPixelHeight(10)),
                        Container(
                          width: FetchPixels.getPixelWidth(100),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0.0, 4.0)),
                              ],
                              borderRadius: BorderRadius.circular(
                                  FetchPixels.getPixelHeight(12))),
                          padding: EdgeInsets.only(
                              left: FetchPixels.getPixelWidth(10),
                              right: FetchPixels.getPixelWidth(10),
                              top: FetchPixels.getPixelHeight(10),
                              bottom: FetchPixels.getPixelHeight(10)),
                          margin: EdgeInsets.only(
                            //left: (index % 0 == 0) ? horSpace : 0,
                              bottom: FetchPixels.getPixelHeight(4),
                              right: FetchPixels.getPixelWidth(2)),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: getCustomFont(
                                    "Rack",
                                    14,
                                    Colors.black,
                                    1,
                                    fontWeight: FontWeight.w900,
                                  )),
                              getVerSpace(FetchPixels.getPixelHeight(4)),
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: getCustomFont(
                                      totalCount![index].totalAmt,
                                      14,
                                      Colors.black,
                                      1,
                                      fontWeight: FontWeight.w400))
                            ],
                          ),
                        ),
                        getHorSpace(FetchPixels.getPixelHeight(10)),
                        Container(
                          width: FetchPixels.getPixelWidth(100),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0.0, 4.0)),
                              ],
                              borderRadius: BorderRadius.circular(
                                  FetchPixels.getPixelHeight(12))),
                          padding: EdgeInsets.only(
                              left: FetchPixels.getPixelWidth(10),
                              right: FetchPixels.getPixelWidth(10),
                              top: FetchPixels.getPixelHeight(10),
                              bottom: FetchPixels.getPixelHeight(10)),
                          margin: EdgeInsets.only(
                            //left: (index % 0 == 0) ? horSpace : 0,
                              bottom: FetchPixels.getPixelHeight(4),
                              right: FetchPixels.getPixelWidth(2)),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: getCustomFont(
                                    "Stock",
                                    14,
                                    Colors.black,
                                    1,
                                    fontWeight: FontWeight.w900,
                                  )),
                              getVerSpace(FetchPixels.getPixelHeight(4)),
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: getCustomFont(
                                      totalCount![index].totalAmt,
                                      14,
                                      Colors.black,
                                      1,
                                      fontWeight: FontWeight.w400))
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ))

          ],
        );
      },
    );
  }*/
  ListView buildScheduleList(EdgeInsets edgeInsets) {
    return ListView.builder(
      itemBuilder: (context, index) {
        //  ModelBooking boolModel = scheduleList[index];
        TotalCount count=totalCount[index];

        print(totalCount[0].totalAmt);
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: FetchPixels.getPixelHeight(16),
                  horizontal:
                  FetchPixels.getPixelWidth(16)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0.0, 4.0)),
                  ],
                  borderRadius: BorderRadius.circular(
                      FetchPixels.getPixelHeight(12))),
              child: Column(

                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: FetchPixels.getPixelWidth(100),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0.0, 4.0)),
                            ],
                            borderRadius: BorderRadius.circular(
                                FetchPixels.getPixelHeight(12))),
                        padding: EdgeInsets.only(
                            left: FetchPixels.getPixelWidth(10),
                            right: FetchPixels.getPixelWidth(10),
                            top: FetchPixels.getPixelHeight(10),
                            bottom: FetchPixels.getPixelHeight(10)),
                        margin: EdgeInsets.only(
                          //left: (index % 0 == 0) ? horSpace : 0,
                            bottom: FetchPixels.getPixelHeight(4),
                            right: FetchPixels.getPixelWidth(2)),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: getCustomFont(
                                  "Pick Count",
                                  12,
                                  Colors.black,
                                  1,
                                  fontWeight: FontWeight.w500,
                                )),
                            getVerSpace(FetchPixels.getPixelHeight(4)),
                            Align(
                                alignment: Alignment.topCenter,
                                child: getCustomFont(
                                    totalCount[index].totalCount,
                                    12,
                                    Colors.black,
                                    1,
                                    fontWeight: FontWeight.w400))
                          ],
                        ),
                      ),
                      getHorSpace(FetchPixels.getPixelHeight(10)),
                      Container(
                        width: FetchPixels.getPixelWidth(100),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0.0, 4.0)),
                            ],
                            borderRadius: BorderRadius.circular(
                                FetchPixels.getPixelHeight(12))),
                        padding: EdgeInsets.only(
                            left: FetchPixels.getPixelWidth(10),
                            right: FetchPixels.getPixelWidth(10),
                            top: FetchPixels.getPixelHeight(10),
                            bottom: FetchPixels.getPixelHeight(10)),
                        margin: EdgeInsets.only(
                          //left: (index % 0 == 0) ? horSpace : 0,
                            bottom: FetchPixels.getPixelHeight(4),
                            right: FetchPixels.getPixelWidth(2)),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: getCustomFont(
                                  "Pick Item",
                                  12,
                                  Colors.black,
                                  1,
                                  fontWeight: FontWeight.w500,
                                )),
                            getVerSpace(FetchPixels.getPixelHeight(4)),
                            Align(
                                alignment: Alignment.topCenter,
                                child: getCustomFont(
                                    totalCount[index].totalItem,
                                    12,
                                    Colors.black,
                                    1,
                                    fontWeight: FontWeight.w400))
                          ],
                        ),
                      ),
                      getHorSpace(FetchPixels.getPixelHeight(10)),
                      Container(
                        width: FetchPixels.getPixelWidth(100),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0.0, 4.0)),
                            ],
                            borderRadius: BorderRadius.circular(
                                FetchPixels.getPixelHeight(12))),
                        padding: EdgeInsets.only(
                            left: FetchPixels.getPixelWidth(10),
                            right: FetchPixels.getPixelWidth(10),
                            top: FetchPixels.getPixelHeight(10),
                            bottom: FetchPixels.getPixelHeight(10)),
                        margin: EdgeInsets.only(
                          //left: (index % 0 == 0) ? horSpace : 0,
                            bottom: FetchPixels.getPixelHeight(4),
                            right: FetchPixels.getPixelWidth(2)),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: getCustomFont(
                                  "Pick Value",
                                  12,
                                  Colors.black,
                                  1,
                                  fontWeight: FontWeight.w500,
                                )),
                            getVerSpace(FetchPixels.getPixelHeight(4)),
                            Align(
                                alignment: Alignment.topCenter,
                                child: getCustomFont(
                                    totalCount[index].totalAmt,
                                    12,
                                    Colors.black,
                                    1,
                                    fontWeight: FontWeight.w400))
                          ],
                        ),
                      ),
                    ],
                  ),
                  getVerSpace(FetchPixels.getPixelHeight(10)),


        Row(
        children: <Widget>[
        Expanded(
        child: Divider(
                color:Colors.cyan,
                  indent: 10.0,
                  endIndent: 20.0,
                  thickness: 2,

        )
        ),



        ]
        ),
                  SizedBox(
                    height: FetchPixels.getPixelHeight(90),
                    width: FetchPixels.getPixelWidth(700),


                    child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,

                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount:categorycoun.length ,
                        itemBuilder: (context, index){
                          Categorycount count1=categorycoun[index];
                          return GestureDetector(
                            onTap: () {

                              Constant.sendToNext(context, Routes.reportDetailsScreenRoute,arguments:{"category":categorycoun![index].pickCategory,"startDate":_startDate,"endDate":_endDate,},);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(

                                      width: FetchPixels.getPixelWidth(100),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.blueAccent,
                                                blurRadius: 2,
                                                offset: Offset(0.0, 4.0)),
                                          ],
                                          borderRadius: BorderRadius.circular(
                                              FetchPixels.getPixelHeight(12))),
                                      padding: EdgeInsets.only(
                                          left: FetchPixels.getPixelWidth(10),
                                          right: FetchPixels.getPixelWidth(10),
                                          top: FetchPixels.getPixelHeight(10),
                                          bottom: FetchPixels.getPixelHeight(10)),
                                      margin: EdgeInsets.all(10
                                       ),

                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                      if (categorycoun[index].pickCategory=='Outstation')...[
                                          Align(
                                              alignment: Alignment.topCenter,
                                              child: getCustomFont(
                                               "Booking",
                                                12,
                                                Colors.black,
                                                1,
                                                fontWeight: FontWeight.w500,
                                              )),

                                          getVerSpace(FetchPixels.getPixelHeight(4)),
                                          Align(
                                              alignment: Alignment.topCenter,
                                              child: getCustomFont(
                                                  categorycoun[index].coutn,
                                                  12,
                                                  Colors.black,
                                                  1,
                                                  fontWeight: FontWeight.w400))]
                                          else...[
                                        Align(
                                            alignment: Alignment.topCenter,
                                            child: getCustomFont(
                                              categorycoun[index].pickCategory,
                                              12,
                                              Colors.black,
                                              1,
                                              fontWeight: FontWeight.w500,
                                            )),

                                        getVerSpace(FetchPixels.getPixelHeight(4)),
                                        Align(
                                            alignment: Alignment.topCenter,
                                            child: getCustomFont(
                                                categorycoun[index].coutn,
                                                18,
                                                Colors.black,
                                                1,
                                                fontWeight: FontWeight.w400))


                                      ]
                                        ],
                                      ),

                                    ),

                                  ],
                                ),
                              ],
                            ),
                          );

                        } ),
                  ),
                  Row(
                      children: <Widget>[
                        Expanded(
                            child: Divider(
                              color:Colors.cyan,
                              indent: 10.0,
                              endIndent: 20.0,
                              thickness: 2,

                            )
                        ),


                      ]
                  ),



                ],
              ),
            ),
            getVerSpace(FetchPixels.getPixelHeight(20)),
          ],
        );
      },
      shrinkWrap: true,
      primary: false,
      itemCount:totalCount.length ,
    );
  }




  Widget addReminderButton(BuildContext context) {

    return getButton(context, const Color(0xFFF2F4F8), from!+"-"+to!,
        blueColor, () {}, 18,
        weight: FontWeight.w600,
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
        buttonHeight: FetchPixels.getPixelHeight(60),
        insetsGeometry:
            EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(95)));
  }

 Container calendar(EdgeInsets edgeInsets) {
    return Container(
      height: FetchPixels.getPixelHeight(250),
      margin: edgeInsets,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0.0, 4.0)),
          ],
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(20))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(20)),
        child: SfDateRangePicker(
          controller: _controller,
          monthViewSettings: const DateRangePickerMonthViewSettings(
            dayFormat: "EEE",
          ),
          onSelectionChanged:_onSelectionChanged,
          selectionShape: DateRangePickerSelectionShape.circle,
          showNavigationArrow: true,
          backgroundColor: Colors.white,
          rangeSelectionColor: Colors.white,
          rangeTextStyle: TextStyle(
            color: Colors.black,
            fontSize: FetchPixels.getPixelHeight(14),
            fontWeight: FontWeight.w400,
          ),
          startRangeSelectionColor: blueColor,
          endRangeSelectionColor: blueColor,
          monthCellStyle: DateRangePickerMonthCellStyle(
              todayCellDecoration: BoxDecoration(
                  border: Border.all(color: blueColor), shape: BoxShape.circle),
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: FetchPixels.getPixelHeight(14),
                fontWeight: FontWeight.w400,
              ),
              todayTextStyle: TextStyle(
                color: blueColor,
                fontSize: FetchPixels.getPixelHeight(14),
                fontWeight: FontWeight.w400,
              )),
          selectionTextStyle: TextStyle(
            color: Colors.white,
            fontSize: FetchPixels.getPixelHeight(14),
            fontWeight: FontWeight.w400,
          ),
          selectionMode: DateRangePickerSelectionMode.range,
          headerStyle: DateRangePickerHeaderStyle(
              textAlign: TextAlign.start,
              textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: FetchPixels.getPixelHeight(16))),
        ),
      ),
    );
  }

 Expanded nullScheduleView(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: FetchPixels.getPixelHeight(124),
            width: FetchPixels.getPixelHeight(124),
            decoration: BoxDecoration(
              image: getDecorationAssetImage(context, "schedule.png"),
            ),
          ),
          getVerSpace(FetchPixels.getPixelHeight(40)),
          getCustomFont("No Schedule Yet!", 20, Colors.black, 1,
              fontWeight: FontWeight.w900),
          getVerSpace(FetchPixels.getPixelHeight(10)),
          getCustomFont(
            "Make Schedule for better services. ",
            16,
            Colors.black,
            1,
            fontWeight: FontWeight.w400,
          ),
          getVerSpace(FetchPixels.getPixelHeight(30)),
          getButton(context, backGroundColor, "Make Schedule", blueColor, () {
            setState(() {
              schedule = true;
            });
          }, 18,
              weight: FontWeight.w600,
              buttonHeight: FetchPixels.getPixelHeight(60),
              insetsGeometry: EdgeInsets.symmetric(
                  horizontal: FetchPixels.getPixelWidth(98)),
              borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(14)),
              isBorder: true,
              borderColor: blueColor,
              borderWidth: 1.5)
        ],
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {

    setState(() {
      _startDate =
          DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
      _endDate =
          DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate).toString();
      print("On Select");
      print(_startDate);
      print(_endDate);

      from=DateFormat('dd-MM-yyyy').format(args.value.startDate).toString();
      to=DateFormat('dd-MM-yyyy').format(args.value.endDate ?? args.value.startDate).toString();

    });
    if(_empcode!='')

      pickHistory();

  }

}