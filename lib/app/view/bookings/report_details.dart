import 'dart:convert';
import 'dart:core';


import 'package:home_service_provider/base/color_data.dart';

import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';

import '../../../apiclass/Report.dart';


import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

import 'package:http/http.dart' as http;

import 'dart:developer' as developer;

import 'package:home_service_provider/app/utils/strings.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/app_routes.dart';




class ReportDetails extends StatefulWidget {
  const ReportDetails({Key? key}) : super(key: key);

  @override
  State<ReportDetails> createState() => _ReportDetails();
}

class _ReportDetails extends State<ReportDetails> {
  //Future<bool> _future;
  String reportDetails = Strings.apipath+"report_api.php";


  String? pickcategory;
  /*get time  */


  String _empcode='';
  String? startDate;
  String? endDate;
  var _isLoading = true;
  String _binqrcode = '';


  get_sessionData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      _empcode = (logindata.getString('employeeCode')??'');
  //    _binqrcode = (logindata.getString('binqrcode') ?? '');

    });
  }

  List<TotalCount> totalsCount=[];
  List<Total> totals=[];
  // List<ModelBooking> bookingLists = [];

  //Call Active Pick List Api
  Future<bool> reportApi() async {
    print(startDate);
    print(endDate);
    print(pickcategory);
    print(_empcode);

    final res = await http.post(Uri.parse(reportDetails), headers: {
      "Accept": "application/json"
    }, body: {
      "start_date":startDate,
      "end_date":endDate,
      "category":  pickcategory,
      "employeeCode": _empcode,

    });
    if (res.statusCode == 200) {
      developer.log(res.body);
      print(json.decode(res.body));
      var data = json.decode(res.body);
      try {
        final Report = reportFromJson(res.body);
        totals = Report.total!;
        totalsCount = Report.totalCount!;
         print("ki");
        if (totals.isNotEmpty) {
          print(totals[0].pickedRate);
        }
        setState(() {
          _isLoading = false;
        });
        return true;
            } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "  ${e.toString()}",
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



  void initState() {
    print("report");
    get_sessionData();
    super.initState();
    Future.delayed(Duration.zero, () {
     this. setState((){

      Map args = ModalRoute
          .of(context)
          ?.settings
          .arguments as Map;
      startDate = args['startDate'];
      endDate = args['endDate'];
      pickcategory = args['category'];
      reportApi();
      });


    });
  }



  @override
  Widget build(BuildContext context) {
  //  if(startDate!='null')
    //
  /*  return FutureBuilder<String>(
        builder: (context, snapshot) {
          FetchPixels(context);
          return Scaffold(
            appBar:AppBar( backgroundColor: Colors.transparent,centerTitle: true,title: Text(pickcategory!,style: TextStyle(color: Colors.black)),),
            body:(total.isEmpty) ? Center(child:SpinKitFadingCircle(
              color: Colors.indigo,
              size: 50.0,
            )):_bodyWidget(context),);
        }
    );*/
    return FutureBuilder<String>(
   //   future: FetchPixels(context), // Assuming FetchPixels returns a Future<String>
      builder: (context, snapshot) {
        FetchPixels(context);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(pickcategory!, style: TextStyle(color: Colors.black)),
            ),
            body: Center(
              child: SpinKitFadingCircle(
                color: Colors.indigo,
                size: 50.0,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          // Handle error case
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(pickcategory!, style: TextStyle(color: Colors.black)),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          // Future has completed successfully
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(pickcategory!, style: TextStyle(color: Colors.black)),
            ),
            body: totals.isEmpty ? Center(
              child: Text('No data available'), // Display a message when `total` is empty
            ) : _bodyWidget(context),
          );
        }
      }, future: null,
    );

  }
  _bodyWidget(BuildContext context) {
    SizedBox(
      height: FetchPixels.getPixelHeight(80),
      width: FetchPixels.getPixelWidth(500),

      child: ListView.builder(
          shrinkWrap: true,
          primary: false,

          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount:totals.length ,
          itemBuilder: (context, index){
            Total count1=totals[index];
            return GestureDetector(

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
                            Align(
                                alignment: Alignment.topCenter,
                                child: getCustomFont(
                                  count1.pickedRate,
                                  24,
                                  Colors.black,
                                  1,
                                  fontWeight: FontWeight.w900,
                                )),
                            getVerSpace(FetchPixels.getPixelHeight(4)),
                            Align(
                                alignment: Alignment.topCenter,
                                child: getCustomFont(
                                    count1.totalQty,
                                    14,
                                    Colors.black,
                                    1,
                                    fontWeight: FontWeight.w400))
                          ],
                        ),

                      ),

                    ],
                  ),
                ],
              ),
            );

          } ),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0,8.0,10,10),

      child: Container(

        color: backGroundColor,
        child: totals.isEmpty ? nullListView(context) : activeBookingList(),

      ),
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
      itemCount: totalsCount.length,
      itemBuilder: (context, index) {
        TotalCount assignedPickList = totalsCount[index];
        // PrefData.setBookingModel(jsonEncode(assignedPickLists[index]));
        return GestureDetector(
          onTap: () {
            //Constant.sendToNext(context, Routes.completeBookingDetailsScreenRoute,arguments:{"category":pickcategory,"pickId":totalCount[index].pickId,"pickstatus":"Complated",},);
           Constant.sendToNext(context, Routes.bookingRoute,arguments:{"category":pickcategory,"pickId":totalsCount[index].pickId,"pickstatus":totalsCount[index].pickStatus,},);

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
                              assignedPickList.rTimestamp.toString() ?? "",
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
                                    assignedPickList.pickitemCompletedQty ?? "", 14, Colors.black, 1,
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
                            "\u20B9${assignedPickList.pickedRate}",
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
                    Expanded(
                      child: Row(
                        children: [
                          getAssetImage("dot.png", FetchPixels.getPixelHeight(8),
                              FetchPixels.getPixelHeight(8)),
                          getHorSpace(FetchPixels.getPixelWidth(8)),
                          Expanded(
                            child: getCustomFont(assignedPickList.custname  ?? "", 14, textColor, 2,
                                fontWeight: FontWeight.w400),
                          ),
                          getCustomFont(" [ ", 14, textColor, 1,
                              fontWeight: FontWeight.w400),
                          getCustomFont(assignedPickList.custcode  ?? "", 14, textColor, 1,
                              fontWeight: FontWeight.w400),
                          getCustomFont(" ]", 14, textColor, 1,
                              fontWeight: FontWeight.w400),
                        ],
                      ),
                    ),
                    Wrap(
                      children: [
                        getButton(
                            context,
                            Colors.blueAccent,
                            assignedPickList.slno ?? "",
                            Colors.white!,
                                () {},
                            16,
                            weight: FontWeight.w600,
                            borderRadius:
                            BorderRadius.circular(FetchPixels.getPixelHeight(37)),
                            insetsGeometrypadding: EdgeInsets.symmetric(
                                vertical: FetchPixels.getPixelHeight(6),
                                horizontal: FetchPixels.getPixelWidth(12)))
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
              getCustomFont("No Completed Pick List Yet!", 20, Colors.black, 1,
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
