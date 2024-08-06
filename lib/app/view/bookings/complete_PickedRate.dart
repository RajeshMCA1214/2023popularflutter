import 'dart:convert';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../apiclass/PickedListDeatailsRate.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:home_service_provider/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:home_service_provider/app/utils/strings.dart';
import 'package:http/http.dart' as http;
import '../../../base/color_data.dart';

bool value=true;

class CompletePickedRate extends StatefulWidget {
  const CompletePickedRate({Key? key}) : super(key: key);

  @override
  State<CompletePickedRate> createState() => _CompletePickedRate();
}

class _CompletePickedRate extends State<CompletePickedRate> {
  //TextEditingController qtyController = TextEditingController();
  //Future<String> _future;
  var _isLoading = true;
  
  String pickdetailsrate = Strings.apipath + "pick_List_Details_Rate.php";



  List<PickListMaster> pickListMaster=[];
 

 String? PartNo;
 String?  PickId;








  Future<void> pickdetaildata() async {
    final res = await http.post(Uri.parse(pickdetailsrate), headers: {
      "Accept": "application/json"
    }, body: {
      "itemCode": PartNo,
      "pickid": PickId
      
    });
    if (res.statusCode == 200) {
      //   developer.log(res.body);
   
      print(json.decode(res.body));
      var data = json.decode(res.body);
      if (data["is_success"] == true) {
        setState(() {
          _isLoading = false;
          (_isLoading== false)?
          print("true:${_isLoading}"):
          print("false:${_isLoading}");
        });
        try {
          final PickedListDetailsRate = pickedListDetailsRateFromJson(res.body);
          pickListMaster = PickedListDetailsRate.pickListMaster;
         
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
      } else if (data["is_success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar
          (
          content: Text(data["messages"], textAlign: TextAlign.center,),
          backgroundColor: appbarColor,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
        )
        );
       /* setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
        });*/
      }
    }
  }


  @override
  void initState()  {

    super.initState();
    Future.delayed(Duration.zero, () {
    setState((){
      Map args = ModalRoute.of(context)?.settings.arguments as Map;
      PartNo = args['PartNo'];
      PickId = args['pickId'];
       print(PartNo);
      print(PickId);

    });
    pickdetaildata();
    });
  }

  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        builder: (context, snapshot) {
          FetchPixels(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text("Pick List Rate") ,
            ),
            body:(_isLoading==true) ? Center(child:SpinKitFadingCircle(
              color: Colors.indigo,
              size: 50.0,
            )):_bodyWidget(context),);
        }, future: null,
    );


  }
  _bodyWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        color: backGroundColor,
        child:  activeBookingList(),

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
      itemCount: pickListMaster.length,
      itemBuilder: (context, index) {
        PickListMaster assignedPickList = pickListMaster[index];
      //  data=pickListMaster![index].partno;
        // PrefData.setBookingModel(jsonEncode(assignedPickLists[index]));
        return GestureDetector(

          child: Container(
            height: FetchPixels.getPixelHeight(50),
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

                              children: [
                                getSvgImage("check.svg",
                                    height: FetchPixels.getPixelHeight(16),
                                    width: FetchPixels.getPixelHeight(16)),
                                getHorSpace(FetchPixels.getPixelWidth(16)),
                                getCustomFont(
                                    assignedPickList.partno ?? "", 14, Colors.black, 1,
                                    fontWeight: FontWeight.w400),
                                getHorSpace(FetchPixels.getPixelWidth(60)),
                                getCustomFont(
                                    assignedPickList.pickedQty ?? "", 14, Colors.black, 1,
                                    fontWeight: FontWeight.w400),
                                getHorSpace(FetchPixels.getPixelWidth(60)),
                                getCustomFont(
                                    assignedPickList.rate ?? "", 14, Colors.black, 1,
                                    fontWeight: FontWeight.w400),

                              ],
                            ),
                            Expanded(flex: 1,child: getHorSpace(0),),
                          ],
                        ),
                      ),


                    ],
                  ),
                ),

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
            getVerSpace(FetchPixels.getPixelHeight(30)),
            getButton(
                context, backGroundColor, "Make Shcedule", blueColor, () {}, 18,
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
        ));
  }





}








