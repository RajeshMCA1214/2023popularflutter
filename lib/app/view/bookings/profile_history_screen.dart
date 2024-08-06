import 'dart:convert';

import 'package:home_service_provider/app/routes/app_routes.dart';
import 'package:home_service_provider/base/constant.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:home_service_provider/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

import '../../../../base/color_data.dart';
import '../../../apiclass/ProfileHistory.dart';
import '../../utils/strings.dart';


class ProfileHistory extends StatefulWidget {
  const ProfileHistory({Key? key}) : super(key: key);

  @override
  State<ProfileHistory> createState() => _ProfileHistory();
}

class _ProfileHistory extends State<ProfileHistory> {
  bool schedule = true;
  late String _startDate, _endDate;
  String _empcode = '';
  List<TotalCount> totalCount=[];
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

      "start_date": "2023-02-01",
      "end_date": "2023-02-28",
      "employeeCode": _empcode
    });
    if (res.statusCode == 200) {
      //   developer.log(res.body);
      print(json.decode(res.body));
      var data = json.decode(res.body);
      if (data["is_success"] == true) {
        try {
          final ProfileHistory = profileHistoryFromJson(res.body);
          totalCount = ProfileHistory.totalCount;

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



  @override
  void initState() {
    get_sessionData();
    super.initState();
      Future.delayed(Duration.zero, () {

        final DateTime today = DateTime.now();
        _endDate = DateFormat('yyyy-MM-dd').format(today).toString();
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
  /*  if(_empcode!='')
      pickHistory();*/

  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    pickHistory();
    EdgeInsets edgeInsets = EdgeInsets.symmetric(
        horizontal: FetchPixels.getDefaultHorSpace(context));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor,
      body: Column(
        children: [
          getVerSpace(FetchPixels.getPixelHeight(20)),
          buildSearchBar(edgeInsets, context),
         // schedule == true ? Container() : nullScheduleView(context),
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
            title: "Picking Schedule",
            weight: FontWeight.w900,
            textColor: Colors.black,
            fontsize: 24,
            istext: true,
            rightimage: "notification.svg", rightFunction: () {
              Constant.sendToNext(context, Routes.notificationRoutes);
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
          getVerSpace(FetchPixels.getPixelHeight(30)),
          addReminderButton(context),
          getVerSpace(FetchPixels.getPixelHeight(20)),

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
      });

  }


  Widget addReminderButton(BuildContext context) {
    return getButton(context, const Color(0xFFF2F4F8), "+ Add Reminder",
        blueColor, () {}, 18,
        weight: FontWeight.w600,
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
        buttonHeight: FetchPixels.getPixelHeight(60),
        insetsGeometry:
        EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(95)));
  }

  Container calendar(EdgeInsets edgeInsets) {
    return Container(
      height: FetchPixels.getPixelHeight(363),
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
          selectionMode: DateRangePickerSelectionMode.range,
       //   onSelectionChanged: _onSelectionChanged,
          allowViewNavigation: false,
          monthViewSettings: const DateRangePickerMonthViewSettings(
            dayFormat: "EEE",
          ),


          onCancel: (){
            _controller.selectedRanges = null;
          },
          selectionShape: DateRangePickerSelectionShape.circle,
          showNavigationArrow: true,
          showActionButtons: true,
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
       //   selectionMode: DateRangePickerSelectionMode.multiRange,
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

  /*Expanded nullScheduleView(BuildContext context) {
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
  } */
}
