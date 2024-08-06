import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:home_service_provider/base/color_data.dart';
import 'package:intl/intl.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../apiclass/ModelActivePicklist.dart';
import '../../../base/widget_utils.dart';
import 'package:home_service_provider/app/utils/strings.dart';


class CourierHistoryScreen extends StatefulWidget {
  const CourierHistoryScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CourierHistoryScreen> createState() => _CourierHistoryScreen();
}

class _CourierHistoryScreen extends State<CourierHistoryScreen> {
  String activepicklisturl = Strings.apipath + "history_api.php";

  //final _current = 0.obs;
  var _isLoading = true;
  String? pickcategory;
  String _empcode = '';


  get_sessionData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      _empcode = (logindata.getString('employeeCode') ?? '');
    });
  }

  /*get time  */
  dynamic currentTime = DateFormat.Hm().format(DateTime.now());
  var format = DateFormat("HH:mm");
  final CarouselController _controller = CarouselController();

  List<AssignedPickList> assignedPickLists = [];

  // List<ModelBooking> bookingLists = [];

  //Call Active Pick List Api

 // DateTime selectedDate = DateTime.now();
  String radioButtonItem = 'ONE';

  // Group Value for Radio Button.
  int id = 1;
  DateTimeRange dateRange=DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now());


  Future<void> pickDateRange() async {
    DateTimeRange? newDateRange =await showDateRangePicker(
        context: context,
        initialDateRange: dateRange,
        firstDate:DateTime(1900),
        lastDate: DateTime(2100));
    if(newDateRange==null) return ;
    setState(() =>dateRange=newDateRange);

  }


  @override
  void initState() {
    get_sessionData();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    final start=dateRange.start;
    final end=dateRange.end;

    return Scaffold(

      body: Column(

        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
         // Text("${selectedDate.toLocal()}".split(' ')[0]),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 20, 0),
            child: Row(
              children: [
                const SizedBox(height: 20.0,),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(

                onPressed:pickDateRange,
              //  child:  Text('${start.year}/${start.month}/${start.day}'),
                child:  Text(DateFormat('yyyy/MM/dd').format(start)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                onPressed:pickDateRange,
                child: Text(DateFormat('yyyy/MM/dd').format(end)),
              ),
            ),
              ],
            ),

          ),
          Center(
            child: Container(
              child:  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          getAssetImage("dot.png", FetchPixels.getPixelHeight(8),
                              FetchPixels.getPixelHeight(8)),
                          getHorSpace(FetchPixels.getPixelWidth(8)),
                          getCustomFont("Total Pick List    :" ?? "", 25, textColor, 1,
                              fontWeight: FontWeight.w500),
                          getCustomFont("18" ?? "", 25, textColor, 1,
                              fontWeight: FontWeight.w500),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          getAssetImage("dot.png", FetchPixels.getPixelHeight(8),
                              FetchPixels.getPixelHeight(8)),
                          getHorSpace(FetchPixels.getPixelWidth(8)),
                          getCustomFont("Total Quantity   :" ?? "", 25, textColor, 1,
                              fontWeight: FontWeight.w500),
                          getCustomFont("18" ?? "", 25, textColor, 1,
                              fontWeight: FontWeight.w500),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          getAssetImage("dot.png", FetchPixels.getPixelHeight(8),
                              FetchPixels.getPixelHeight(8)),
                          getHorSpace(FetchPixels.getPixelWidth(8)),
                          getCustomFont("Total Value         :" ?? "", 25, textColor, 1,
                              fontWeight: FontWeight.w500),
                          getCustomFont("18" ?? "", 25, textColor, 1,
                              fontWeight: FontWeight.w500),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [

                          getHorSpace(FetchPixels.getPixelWidth(120)),
                          getCustomFont("👇Select Type" ?? "", 25, textColor, 1,
                              fontWeight: FontWeight.w500),


                        ],
                      ),
                    ),


                  ],
                )

            ),


          ),
          Column(
          children: <Widget>[
   /* Padding(
    padding: EdgeInsets.all(14.0),
    child: Text('Selected Radio Item = ' + '$radioButtonItem',
    style: TextStyle(fontSize: 21))
    ),*/
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    Radio(
    value: 1,
    groupValue: id,
    onChanged: (val) {
    setState(() {
    radioButtonItem = 'Local';
    id = 1;
    });
    },
    ),
      getCustomFont("Local" ?? "", 15, textColor, 1,
          fontWeight: FontWeight.w400),

    Radio(
    value: 2,
    groupValue: id,
    onChanged: (val) {
    setState(() {
    radioButtonItem = 'Outstation';
    id = 2;
    });
    },
    ),
      getCustomFont("Outstation" ?? "", 15, textColor, 1,
          fontWeight: FontWeight.w400),

    Radio(
    value: 3,
    groupValue: id,
    onChanged: (val) {
    setState(() {
    radioButtonItem = 'Courier';
    id = 3;
    });
    },
    ),
      getCustomFont("Courier" ?? "", 15, textColor, 1,
          fontWeight: FontWeight.w400),
      Radio(
        value: 4,
        groupValue: id,
        onChanged: (val) {
          setState(() {
            radioButtonItem = 'Town';
            id = 4;
          });
        },
      ),
      getCustomFont("Town" ?? "", 15, textColor, 1,
          fontWeight: FontWeight.w400),
    ],
    ),
    ],
    ),
          Row(
            children: [
              const SizedBox(height: 20.0,),



              Padding(
                padding:  EdgeInsets.fromLTRB(150,0,0,0),

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.green, // foreground
                  ),
                  onPressed:pickDateRange,
                  child: Text("Submit"),
                ),
              ),
            ],
          )
        ],

      ),

    );
  }

  
}

