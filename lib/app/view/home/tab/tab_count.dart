
import 'package:home_service_provider/app/routes/app_routes.dart';
import 'package:home_service_provider/base/constant.dart';

import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';

import '../../../../apiclass/ModelActivePicklist.dart';
import '../../../../base/color_data.dart';
import '../../../../base/widget_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:convert';
import 'dart:async';

import '../../../utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TapCount extends StatefulWidget {
  const TapCount({Key? key}) : super(key: key);

  @override
  State<TapCount> createState() => _TapCount();
}

class _TapCount extends State<TapCount> {
  @override
  String activepicklisturl = Strings.apipath+"search_picklist_api.php";
  List filteredTempCropList = [];
 // List<CropList> cropListTemp = [];
  List<AssignedPickList> assignedPickLists = [];
  TextEditingController _textEditingController = TextEditingController();
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

  Future<bool> activepicklist() async {
    final res = await http.post(Uri.parse(activepicklisturl), headers: {
      "Accept": "application/json"
    }, body: {
      "bill_type":_billtype,
      "compCode": _comcode,
      "employeeCode":_empcode
    });
    if (res.statusCode == 200) {
      developer.log(res.body);

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

    });
    activepicklist();

  }
  void filterCrop(value) {
    setState(() {
      filteredTempCropList = assignedPickLists
          .where((croplist) =>
          croplist.pickId!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
  Widget build(BuildContext context) {
    FetchPixels(context);
  //  get_sessionData();
    activepicklist();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor,
    //  appBar: AppBar(title:),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextFormField(
              controller: _textEditingController,
              onChanged: (value) {
                filterCrop(value);
              },
              decoration: InputDecoration(
                labelText: 'Search PICK ID',
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.fromLTRB(8, 5, 10, 5),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: _textEditingController.text.isNotEmpty &&
                filteredTempCropList.isEmpty
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.search_off,
                        size: 80,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          'No results found,\nPlease try different keyword',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                : filteredTempCropList.isNotEmpty
                ?ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: filteredTempCropList.length,
            itemBuilder: (context, index) {
              AssignedPickList assignedPickList = filteredTempCropList[index];
              // PrefData.setBookingModel(jsonEncode(assignedPickLists[index]));
              return GestureDetector(
                onTap: () {
                  Constant.sendToNext(context, Routes.bookingRoute,arguments:{"category":assignedPickList.pick_category,"pickId":assignedPickList.pickId,"pickstatus":assignedPickLists[index].pickStatus,},);
                },
                child: Container(
                  height: FetchPixels.getPixelHeight(200),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      getCustomFont(
                                          "#"+assignedPickList.pickId.toString() ?? "", 24, Colors.black, 1,
                                          fontWeight: FontWeight.w900),
                                      getHorSpace(FetchPixels.getPixelHeight(80)),
                                      getButton(
                                          context,
                                          Colors.black12,
                                          assignedPickList.pick_category ?? "",
                                          Colors.blueAccent,
                                              () {},
                                          16,
                                          weight: FontWeight.w400,

                                          borderRadius:
                                          BorderRadius.circular(FetchPixels.getPixelHeight(37)),
                                          insetsGeometrypadding: EdgeInsets.symmetric(
                                              vertical: FetchPixels.getPixelHeight(6),
                                              horizontal: FetchPixels.getPixelWidth(12)))
                                    ],
                                  ),
                                  getVerSpace(FetchPixels.getPixelHeight(12)),
                                  Row(
                                    children: [
                                      getSvgImage("check.svg",
                                          height: FetchPixels.getPixelHeight(16),
                                          width: FetchPixels.getPixelHeight(16)),
                                      getHorSpace(FetchPixels.getPixelWidth(6)),
                                      getCustomFont(
                                          assignedPickList.itemCnt ?? "", 24, Colors.black, 1,
                                          fontWeight: FontWeight.w400),
                                      getCustomFont(
                                          " Items", 24, Colors.black, 1,
                                          fontWeight: FontWeight.w400),
                                    ],
                                  ),
                                  getVerSpace(FetchPixels.getPixelHeight(12)),

                                  Row(
                                    children: [

                                      getCustomFont(
                                          assignedPickList.rTimestamp ?? "", 14, Colors.black, 1,
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
                                getPaddingWidget(EdgeInsets.only(bottom:FetchPixels.getPixelHeight(10) ),
                                    getCustomFont(
                                      "\u20B9${assignedPickList.totalAmt}",
                                      24,
                                      blueColor,
                                      1,
                                      fontWeight: FontWeight.w900,
                                    )),
                                SizedBox(

                                  child: getButton(
                                      context, Colors.orangeAccent, "Preview", blueColor,
                                          () {
                                        // Constant.sendToNext(context, Routes.scanBinRoute);
                                        Constant.sendToNext(context, Routes.pickListPreviewScreenRoute,arguments:{"category":assignedPickList.pick_category,"pickId":assignedPickList.pickId,"pickstatus":assignedPickList.pickStatus,"preview":'preview'},);

                                      }, 25,

                                      weight: FontWeight.w600,
                                      insetsGeometrypadding: EdgeInsets.symmetric(
                                          horizontal: FetchPixels.getPixelWidth(10),
                                          vertical: FetchPixels.getPixelHeight(10)),
                                      borderColor:Colors.transparent,
                                      borderWidth: 0,
                                      isBorder: true,
                                      borderRadius: BorderRadius.circular(
                                          FetchPixels.getPixelHeight(10))),
                                ),
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
                            flex: 1,
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
          )
                : ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: assignedPickLists.length,
              itemBuilder: (context, index) {
                AssignedPickList assignedPickList = assignedPickLists[index];
                // PrefData.setBookingModel(jsonEncode(assignedPickLists[index]));
                return GestureDetector(
                  onTap: () {
                    Constant.sendToNext(context, Routes.bookingRoute,arguments:{"category":assignedPickList.pick_category,"pickId":assignedPickList.pickId,"pickstatus":assignedPickList.pickStatus,},);
                  },
                  child: Container(
                    height: FetchPixels.getPixelHeight(200),
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        getCustomFont(
                                            "#"+assignedPickList.pickId.toString() ?? "", 24, Colors.black, 1,
                                            fontWeight: FontWeight.w900),
                                        getHorSpace(FetchPixels.getPixelHeight(80)),
                                        getButton(
                                            context,
                                            Colors.black12,
                                            assignedPickList.pick_category ?? "",
                                            Colors.blueAccent,
                                                () {},
                                            16,
                                            weight: FontWeight.w400,

                                            borderRadius:
                                            BorderRadius.circular(FetchPixels.getPixelHeight(37)),
                                            insetsGeometrypadding: EdgeInsets.symmetric(
                                                vertical: FetchPixels.getPixelHeight(6),
                                                horizontal: FetchPixels.getPixelWidth(12)))
                                      ],
                                    ),
                                    getVerSpace(FetchPixels.getPixelHeight(12)),
                                    Row(
                                      children: [
                                        getSvgImage("check.svg",
                                            height: FetchPixels.getPixelHeight(16),
                                            width: FetchPixels.getPixelHeight(16)),
                                        getHorSpace(FetchPixels.getPixelWidth(6)),
                                        getCustomFont(
                                            assignedPickList.itemCnt ?? "", 24, Colors.black, 1,
                                            fontWeight: FontWeight.w400),
                                        getCustomFont(
                                            " Items", 24, Colors.black, 1,
                                            fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                    getVerSpace(FetchPixels.getPixelHeight(12)),

                                    Row(
                                      children: [

                                        getCustomFont(
                                            assignedPickList.rTimestamp ?? "", 12, Colors.black, 1,
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
                                  getPaddingWidget(EdgeInsets.only(bottom:FetchPixels.getPixelHeight(10) ),
                                      getCustomFont(
                                        "\u20B9${assignedPickList.totalAmt}",
                                        24,
                                        blueColor,
                                        1,
                                        fontWeight: FontWeight.w900,
                                      )),
                                  SizedBox(

                                    child: getButton(
                                        context, Colors.orangeAccent, "Preview", blueColor,
                                            () {
                                          // Constant.sendToNext(context, Routes.scanBinRoute);
                                          Constant.sendToNext(context, Routes.pickListPreviewScreenRoute,arguments:{"category":"BOOKING","pickId":assignedPickList.pickId,"pickstatus":assignedPickList.pickStatus,"preview":'preview'},);

                                        }, 25,

                                        weight: FontWeight.w600,
                                        insetsGeometrypadding: EdgeInsets.symmetric(
                                            horizontal: FetchPixels.getPixelWidth(10),
                                            vertical: FetchPixels.getPixelHeight(10)),
                                        borderColor:Colors.transparent,
                                        borderWidth: 0,
                                        isBorder: true,
                                        borderRadius: BorderRadius.circular(
                                            FetchPixels.getPixelHeight(10))),
                                  ),
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
                              flex: 1,
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
            )


          ),

        ],
      )
    );
  }


}
