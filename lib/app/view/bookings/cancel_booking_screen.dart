import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../apiclass/ModelActivePicklist.dart';
import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../routes/app_routes.dart';
import '../../utils/strings.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class CancelBookingScreen extends StatefulWidget {
  const CancelBookingScreen({Key? key}) : super(key: key);

  @override
  State<CancelBookingScreen> createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  //List<ModelBooking> bookingLists = DataFile.bookingList;
 // SharedPreferences? booking;

  var _isLoading = true;
  String? pickcategory;
  String _comcode='';
  String _billtype='';
  /*get time  */
  dynamic currentTime = DateFormat.Hm().format(DateTime.now());
  var format = DateFormat("HH:mm");
  final CarouselController _controller = CarouselController();

  String cancelPickList = Strings.apipath+"cancelPickList.php";
  String _empcode='';

  get_sessionData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      _empcode = (logindata.getString('employeeCode')??'');
      _comcode = (logindata.getString('comCode') ?? '');
      _billtype = (logindata.getString('billType') ?? '');
    });
  }

  List<AssignedPickList> assignedPickLists = [];
  // List<ModelBooking> bookingLists = [];

  //Call Active Pick List Api
  Future<bool> cancelpicklist() async {
    print(_empcode);
    print(pickcategory);
    final res = await http.post(Uri.parse(cancelPickList), headers: {
      "Accept": "application/json"
    }, body: {
      "compCode": _comcode,
      "category": pickcategory,
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
    super.initState();
    get_sessionData();
    Future.delayed(Duration.zero, () {
      setState((){
        Map args = ModalRoute.of(context)?.settings.arguments as Map;
        pickcategory = args['category'];
         print(pickcategory);

      });
      cancelpicklist();
    });
    /*SharedPreferences.getInstance().then((SharedPreferences sp) {
      booking = sp;
      setState(() {});
    });*/
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Container(
      color: backGroundColor,
      child:assignedPickLists.isEmpty ? nullListView(context) : cancelBookingList(),

    );
  }

 /* ListView () {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: cancelPickList!.length,
      itemBuilder: (context, index) {
        CancelPickList modelBooking = cancelPickList![index];
        return modelBooking.pickStatus == "Cancelled"
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
  }*/
  ListView cancelBookingList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: assignedPickLists.length,
      itemBuilder: (context, index) {
        AssignedPickList assignedPickList = assignedPickLists[index];
        // PrefData.setBookingModel(jsonEncode(assignedPickLists[index]));
        return GestureDetector(
          onTap: () {
            Constant.sendToNext(context, Routes.bookingRoute,arguments:{"category":pickcategory,"pickId":assignedPickList.pickId,"pickstatus":assignedPickLists[index].pickStatus},);
          },
          child: Container(
            height: FetchPixels.getPixelHeight(240),
            margin: EdgeInsets.only(
                bottom: FetchPixels.getPixelHeight(8),
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
                                "#"+assignedPickList.pickId.toString() ?? "", 24, Colors.black, 1,
                                fontWeight: FontWeight.w900),
                            getVerSpace(FetchPixels.getPixelHeight(12)),
                            getCustomFont(
                              assignedPickList.billdate ?? "",
                              24,
                              textColor,
                              1,
                              fontWeight: FontWeight.w400,
                            ),
                            getVerSpace(FetchPixels.getPixelHeight(12)),
                            Expanded(
                              child: Row(
                                children: [
                                  getSvgImage("check.svg",
                                      height: FetchPixels.getPixelHeight(10),
                                      width: FetchPixels.getPixelHeight(10)),
                                  getHorSpace(FetchPixels.getPixelWidth(6)),
                                  getCustomFont(
                                      assignedPickList.billno ?? "", 24, Colors.black, 1,
                                      fontWeight: FontWeight.w400),
                                  getCustomFont(
                                      " Items", 24, Colors.black, 1,
                                      fontWeight: FontWeight.w400),
                                ],
                              ),
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
                            24,
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
                        getAssetImage("dot.png", FetchPixels.getPixelHeight(5),
                            FetchPixels.getPixelHeight(5)),
                        getHorSpace(FetchPixels.getPixelWidth(5)),
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
                        getButton(
                            context,
                            Color(assignedPickList.bgError!.toInt()),
                            assignedPickList.pickStatus ?? "",
                            assignedPickList.errortextColor!,
                                () {},
                            16,
                            weight: FontWeight.w600,
                            borderRadius:
                            BorderRadius.circular(FetchPixels.getPixelHeight(7)),
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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getSvgImage("clipboard.svg",
                height: FetchPixels.getPixelHeight(124),
                width: FetchPixels.getPixelHeight(124)),
            getVerSpace(FetchPixels.getPixelHeight(40)),
            getCustomFont("No Cancelled Pick List!", 20, Colors.black, 1,
                fontWeight: FontWeight.w900),
            getVerSpace(FetchPixels.getPixelHeight(10)),
            getCustomFont(
              "Assign New Pick List for the best services. ",
              16,
              Colors.black,
              1,
              fontWeight: FontWeight.w400,
            ),
            getVerSpace(FetchPixels.getPixelHeight(30)),
          /*  getButton(
                context, backGroundColor, "Go to Service", blueColor, () {}, 18,
                weight: FontWeight.w600,
                buttonHeight: FetchPixels.getPixelHeight(60),
                insetsGeometry: EdgeInsets.symmetric(
                    horizontal: FetchPixels.getPixelWidth(106)),
                borderRadius:
                    BorderRadius.circular(FetchPixels.getPixelHeight(14)),
                isBorder: true,
                borderColor: blueColor,
                borderWidth: 1.5) */
          ],
        ));
  }
}
