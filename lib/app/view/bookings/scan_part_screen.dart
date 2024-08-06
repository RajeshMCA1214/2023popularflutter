import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:home_service_provider/app/data/data_file.dart';
import 'package:home_service_provider/app/models/model_booking.dart';
import 'package:home_service_provider/base/pref_data.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:home_service_provider/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../routes/app_routes.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../apiclass/PickedDetails.dart';
import 'package:home_service_provider/app/utils/strings.dart';

class ScanPartScreen extends StatefulWidget {
  //final String img;
  const ScanPartScreen({Key? key}) : super(key: key);

  @override
  State<ScanPartScreen> createState() => _ScanPartScreenState();
}

class _ScanPartScreenState extends State<ScanPartScreen> {
  FocusNode myfocus = FocusNode();
  getPrefData() async {
    index = await PrefData.getDefIndex();
    setState(() {});
  }

  TextEditingController pickedItemController = TextEditingController(text: '1');
  TextEditingController priceController = TextEditingController();
  TextEditingController containerQR = TextEditingController();
  TextEditingController hideController = TextEditingController();
  String? partNo;
  String? pickId;
  String? picStatus;
  String? Sno;
  String? pckdQty;
  String? pckdRat;
  String _binqrcode='';
  String confirmsg='';
  String qrCode='unknow';
  var _isLoading = true;
  String? pickcategory;
  String _empcode='';

  String pickedetails = Strings.apipath + "pickitem_api.php";
  String insertPrice = Strings.apipath + "pickeditem_insert_api.php";
  String deletePickedDetails = Strings.apipath + "pickeditem_delete_api.php";
  String pickedDetailsUpdate = Strings.apipath + "pickeditem_item_update.php";
  String pickitemConfirm = Strings.apipath + "details_pickitem_confirm.php";

  List<PickItem> pickItem=[];
  List<PickedList> pickedList=[];
  late TextEditingController _controller;

  get_sessionData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      _binqrcode = (logindata.getString('binqrcode')??'');
      print(_binqrcode);
      _empcode = (logindata.getString('employeeCode')??'');
      print(_empcode);
      containerQR.text=_binqrcode;
    });
  }
  Future<void> pickedetaildata() async {

    final res = await http.post(Uri.parse(pickedetails), headers: {
      "Accept": "application/json"
    }, body: {

      "itemCode": partNo,
      "pickid": pickId

    });
    if (res.statusCode == 200) {
      //   developer.log(res.body);
      print(json.decode(res.body));
      var data = json.decode(res.body);
      if (data["is_success"] == true) {
        setState(() {
          _isLoading = false;
          _controller = TextEditingController(text: 'Default Value');
        });
        try {
          final PickedDetailView = pickedDetailViewFromJson(res.body);
          pickedList = PickedDetailView.pickedList;
          pickItem = PickedDetailView.pickItem;
          setState(() {
            pickedItemController.text = pickItem[index].quantity;
            priceController.text = pickItem[index].rate;
          });
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

      }
    }
  }

  Future<void> insertQty_Price() async {

    final res = await http.post(Uri.parse(insertPrice), headers: {
      "Accept": "application/json"
    }, body: {
      "itemCode": partNo,
      "pickid": pickId,
      'pickedrate':priceController.text,
      'picked_qty':pickedItemController.text,
      "binQR":_binqrcode,
      "PartQRcode":qrCode
    });
    if (res.statusCode == 200) {
      pickedetaildata();
     // developer.log(res.body);
      // print(json.decode(res.body));
      var data = json.decode(res.body);
      if (data["is_success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar
          (
          content: Text(data["messages"], textAlign: TextAlign.center,),
          backgroundColor: appbarColor,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 600,left: 20,right: 20),
        )
        );
      } else if (data["is_success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar
          (
          content: Text(data["messages"], textAlign: TextAlign.center,),
          backgroundColor: appbarColor,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 600,left: 20,right: 20),
        )
        );

      }
    }
  }
  Future<void> delete_PickedDetails(slno, pickId, partNo) async {
    final res = await http.post(Uri.parse(deletePickedDetails), headers: {
      "Accept": "application/json"
    }, body: {
      "Slno":slno,
      "pickid":pickId,
      "itemCode":partNo
    });
    if (res.statusCode == 200) {
      pickedetaildata();
      //     developer.log(res.body);
      // print(json.decode(res.body));
      var data = json.decode(res.body);
      if (data["is_success"] == true) {
        if(confirmsg=="Delete Successfully!"){
          //  Constant.sendToNext(context, Routes.scanPartScreenRoute,arguments:{"category":pickcategory,"pickId":pickId,"pickstatus":picStatus,"PartNo":partNo},);
        }
        /* ScaffoldMessenger.of(context).showSnackBar(SnackBar
          (
          content: Text(data["messages"], textAlign: TextAlign.center,),
          backgroundColor: appbarColor,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          margin: EdgeInsets.only(bottom: 600,left: 20,right: 20),
        ),

        );*/

      } else if (data["is_success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar
          (
          content: Text(data["messages"], textAlign: TextAlign.center,),
          backgroundColor: appbarColor,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 600,left: 20,right: 20),
        )
        );
        myfocus.requestFocus();
      }
    }
  }
  Future<void> pickedDetails_update() async {
    final res = await http.post(Uri.parse(pickedDetailsUpdate), headers: {
      "Accept": "application/json"
    }, body: {
      "itemCode": partNo,
      "pickid": pickId
    });
    if (res.statusCode == 200) {
      pickedetaildata();
      //   developer.log(res.body);
      print(json.decode(res.body));
      var data = json.decode(res.body);

      if (data["is_success"] == true) {
        confirmsg=data["messages"];
        print(confirmsg);
        if(confirmsg=="New Picked Confirmed"){
          // Constant.sendToNext(context, Routes.scanPartScreenRoute,arguments:{"category":pickcategory,"pickId":pickId,"pickstatus":picStatus,"PartNo":partNo},);
        }else{

        }
        /*  ScaffoldMessenger.of(context).showSnackBar(SnackBar
          (
          content: Text(data["messages"], textAlign: TextAlign.center,),
          backgroundColor: appbarColor,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 600,left: 20,right: 20),
        )
        );*/
      } else if (data["is_success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar
          (
          content: Text(data["messages"], textAlign: TextAlign.center,),
          backgroundColor:Colors.deepOrangeAccent,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 600,left: 20,right: 20),
          duration: const Duration(seconds: 2),
        )
        );

      }
    }
  }

  Future<void> pickitemcofirm() async {

    print(pickId);
    print(Sno);
    print(pickItem[index].pickedQty);
    print(pickItem[0].pickedQty);
    print(_binqrcode);
    pckdQty= pickItem[0].pickedQty;
    pckdRat= pickItem[0].pickedRate;
    final res = await http.post(Uri.parse(pickitemConfirm),
        headers: {"Accept": "application/json"},
        body: {
          "slno": Sno,
          "pickid": pickId,
          "pickedRate": pckdRat,
          "pickedQty": pckdQty,
          "binQR": _binqrcode
        });
    if (res.statusCode == 200) {
      pickedetaildata();
      //   developer.log(res.body);
      setState(() {
        _isLoading = false;
        (_isLoading == false)
            ? print("true:${_isLoading}")
            : print("false:${pckdQty}");
      });
      print(json.decode(res.body));
      var data = json.decode(res.body);
      if (data["is_success"] == true) {
        if (data["messages"] == 'Last Item Completed') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              data["messages"],
              textAlign: TextAlign.center,
            ),
            backgroundColor: appbarColor,
            elevation: 10,
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(15),
          ));
          print(pickcategory);
          print(pickId);
          print(picStatus);
       //   print(Preview);
    //      Constant.sendToNext(context, Routes.pickListPreviewScreenRoute,arguments:{"category":pickcategory,"pickId":pickListsMaster![0].pickId,"pickstatus":pickListsMaster![0].pickStatus,"preview":'view'},);
          Constant.sendToNext(context, Routes.pickListPreviewScreenRoute,arguments:{"category":pickcategory,"pickId":pickId,"pickstatus":picStatus,"preview":'view'},);
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              data["messages"],
              textAlign: TextAlign.center,
            ),
            backgroundColor: appbarColor,
            elevation: 10,
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(15),
          ));
          Constant.sendToNext(context, Routes.activeDetailsScreenRoute,
            arguments: {
              "category": pickcategory,
              "pickId": pickId,
              "pickstatus": picStatus,
              "PartNo": partNo
            },);
        }
      } else if (data["is_success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            data["messages"],
            textAlign: TextAlign.center,
          ),
          backgroundColor: appbarColor,
          elevation: 10,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
        ));
      }
    }

  }
  @override
  void initState() {
    setState(() {
      myfocus.requestFocus();

    });
    get_sessionData();
    super.initState();
    Timer(Duration(seconds: 0), () {
      this.setState(() {

        Map args = ModalRoute
            .of(context)
            ?.settings
            .arguments as Map;
        partNo = args['PartNo'];
        pickId = args['pickId'];
        pickcategory = args['category'];
        picStatus =args['pickstatus'];
        Sno=args['serialNO'];


        pickedetaildata();

      });

    });

    //getPrefData();
  }


  void clearText() {
    priceController.clear();
    pickedItemController.clear();
  }

  List<ModelBooking> bookingLists = DataFile.bookingList;
  var index = 0;

  @override
  Widget build(BuildContext context) {
    ModelBooking modelBooking = bookingLists[index];
    FetchPixels(context);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          bottomNavigationBar: buttons(context),
          body:SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(),
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: FetchPixels.getDefaultHorSpace(context)),
                child:  (_isLoading == true) ? Center(child: Center(child: CircularProgressIndicator(color: Colors.blueAccent))) : buildBookingDetail(context, modelBooking),

              ),
            ),
          ),
        ),
        onWillPop: () async {
          Constant.backToPrev(context);
          return false;
        });
  }

  Column buildBookingDetail(BuildContext context, ModelBooking modelBooking) {
    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        getVerSpace(FetchPixels.getPixelHeight(20)),
        gettoolbarMenu(context, "back.svg", () {
          Constant.backToPrev(context);
        },
            title:"Part No : $partNo",
            weight: FontWeight.w500,
            istext: true,
            textColor: Colors.black,
            fontsize: 30),
        getVerSpace(FetchPixels.getPixelHeight(20)),
        bookingList(),
        getVerSpace(FetchPixels.getPixelHeight(20)),
      //  if(picStatus=="Active")
          pick_rate(),
       // if(picStatus=="Active")

          getVerSpace(FetchPixels.getPixelHeight(10)),
        pickedList1(),



      ],
    );
  }

  Widget bookingList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),

      shrinkWrap: true,
      primary: true,
      itemCount: pickItem.length,
      itemBuilder: (context, index) {
        // ModelItem modelItem = itemProductLists[index];
        return Column(
          children: [
            //  dateHeader(modelItem, index),
            //getVerSpace(FetchPixels.getPixelHeight(10)),

            Container(
              margin: EdgeInsets.only(
                  bottom: FetchPixels.getPixelHeight(10),
                  left: FetchPixels.getPixelHeight(5),
                  right: FetchPixels.getPixelHeight(5)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 1,
                        offset: Offset(0.0, 1.0)),
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
                  Row(
                      children: [


                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: FetchPixels.getPixelWidth(330),
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                          alignment: Alignment.topCenter,
                                          child: getCustomFont(
                                            "Part Description",
                                            18,
                                            Colors.black,
                                            1,
                                            fontWeight: FontWeight.w800,
                                          )),
                                      getVerSpace(FetchPixels.getPixelHeight(4)),
                                      Align(
                                          alignment: Alignment.topCenter,
                                          child: getCustomFont(
                                              pickItem[index].partname,

                                              18,
                                              Colors.black,
                                              2,
                                              fontWeight: FontWeight.w400))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),


                        /* getDefaultTextFiledWithLabel(
                            context, "Name", qtyController, Colors.grey,
                            function: () {},
                            height: FetchPixels.getPixelHeight(10),
                            isEnable: false,
                            withprefix: true),*/

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
                      ] ),
                  getVerSpace(FetchPixels.getPixelHeight(16)),
                  Row(
                      children: [


                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: FetchPixels.getPixelWidth(150),
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                      Align(
                                          alignment: Alignment.topCenter,
                                          child: getCustomFont(
                                            "Pick Qty",
                                            18,
                                            Colors.black,
                                            1,
                                            fontWeight: FontWeight.w700,
                                          )),
                                      getVerSpace(FetchPixels.getPixelHeight(4)),
                                      Align(
                                          alignment: Alignment.topCenter,
                                          child: getCustomFont(
                                              pickItem[index].quantity,

                                              18,
                                              Colors.black,
                                              2,
                                              fontWeight: FontWeight.w400))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        getHorSpace(FetchPixels.getPixelHeight(10)),
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: FetchPixels.getPixelWidth(150),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 10,
                                            offset: Offset(0.0, 1.0)),
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                          alignment: Alignment.topCenter,
                                          child: getCustomFont(
                                            "Rack" ,
                                            18,
                                            Colors.black,
                                            1,
                                            fontWeight: FontWeight.w700,
                                          )),
                                      getVerSpace(FetchPixels.getPixelHeight(4)),
                                      Align(
                                          alignment: Alignment.topCenter,
                                          child: getCustomFont(
                                              pickItem[index].rackno ,

                                              18,
                                              Colors.black,
                                              2,
                                              fontWeight: FontWeight.w400))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        /* getDefaultTextFiledWithLabel(
                            context, "Name", qtyController, Colors.grey,
                            function: () {},
                            height: FetchPixels.getPixelHeight(10),
                            isEnable: false,
                            withprefix: true),*/

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
                      ] ),
                  getVerSpace(FetchPixels.getPixelHeight(16)),

                  // getVerSpace(FetchPixels.getPixelHeight(10)),
                  getDivider(dividerColor, 0, 1),
                  getVerSpace(FetchPixels.getPixelHeight(16)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Align(
                                alignment: Alignment.topCenter,
                                child: getCustomFont(

                                  "Picked" ,
                                  18,
                                  Colors.black,
                                  1,
                                  fontWeight: FontWeight.w700,

                                )),
                            getVerSpace(FetchPixels.getPixelHeight(4)),

                            Align(
                                alignment: Alignment.topCenter,
                                child: getCustomFont(
                                    pickItem[index].pickedQty,



                                    18,
                                    Colors.black,
                                    2,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: getCustomFont(
                                  "Stock",
                                  18,
                                  Colors.black,
                                  1,
                                  fontWeight: FontWeight.w700,
                                )),
                            getVerSpace(FetchPixels.getPixelHeight(4)),
                            Align(
                                alignment: Alignment.topCenter,
                                child: getCustomFont(
                                    pickItem[index].stockqty,

                                    23,
                                    Colors.black,
                                    2,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: getCustomFont(
                                  "Price",
                                  18,
                                  Colors.black,
                                  1,
                                  fontWeight: FontWeight.w700,
                                )),
                            getVerSpace(FetchPixels.getPixelHeight(4)),
                            Align(
                                alignment: Alignment.topCenter,
                                child: getCustomFont(
                                    pickItem[index].rate,

                                    23,
                                    Colors.black,
                                    2,
                                    fontWeight: FontWeight.w400))
                          ],
                        ),
                      ),

                    ],
                  )
                ],
              ),


            ),


          ],
        );
      },
    );
  }
  Widget pick_rate() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),

      shrinkWrap: true,
      primary: true,
      itemCount: 1,
      itemBuilder: (context, index) {
        // ModelItem modelItem = itemProductLists[index];
        return Column(
          children: [
            //  dateHeader(modelItem, index),
            //getVerSpace(FetchPixels.getPixelHeight(10)),

            Container(
              margin: EdgeInsets.only(
                  bottom: FetchPixels.getPixelHeight(10),
                  left: FetchPixels.getPixelHeight(5),
                  right: FetchPixels.getPixelHeight(5)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 1,
                        offset: Offset(0.0, 1.0)),
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

                  Row(
                      children: [


                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: FetchPixels.getPixelWidth(120),
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      TextField(
                                        // focusNode: myfocus,
//                                        initialValue: '1',
                                        controller: pickedItemController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'PickedQty',

                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        getHorSpace(FetchPixels.getPixelHeight(10)),
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: FetchPixels.getPixelWidth(120),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 10,
                                            offset: Offset(0.0, 1.0)),
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
                                      bottom: FetchPixels.getPixelHeight(2),
                                      right: FetchPixels.getPixelWidth(2)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextField(

                                          controller: priceController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),

                                            labelText: 'Price',
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],

                        ),
                        getHorSpace(FetchPixels.getPixelHeight(10)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              splashColor: Colors.green,
                              highlightColor: Colors.blue,
                              child: getSvgImage("check_complete.svg",
                                  width: FetchPixels.getPixelHeight(60),
                                  height: FetchPixels.getPixelHeight(60)),
                              onTap: () {
                                if(pickedItemController.text!=''&& priceController.text!='')
                                {
                                  insertQty_Price();
                                  //pickedDetails_update();
                                  clearText();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  /*  this.setState(() {
                                    myfocus.requestFocus();
                                  });*/
                                  setState(() {
                                    // activepicklist();
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) => pickedetaildata());
                                  });
                                }
                                else
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar
                                    (
                                    content: Text("Should Fill Data", textAlign: TextAlign.center,),
                                    backgroundColor: Colors.deepOrange,
                                    elevation: 100,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(bottom: 600,left: 20,right: 20),
                                  )
                                  );
                                }


                                setState(() {

                                  // _volume += 2;
                                });
                              },
                            ),

                          ],
                        ),







                      ] ),


                  //here

                ],
              ),


            ),


          ],
        );
      },
    );
  }
  Widget pick_rate1() {
    return Visibility(
      visible: false,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),

        shrinkWrap: true,
        primary: true,
        itemCount: 1,
        itemBuilder: (context, index) {
          // ModelItem modelItem = itemProductLists[index];
          return Column(
            children: [
              //  dateHeader(modelItem, index),
              //getVerSpace(FetchPixels.getPixelHeight(10)),

              Container(
                margin: EdgeInsets.only(
                    bottom: FetchPixels.getPixelHeight(10),
                    left: FetchPixels.getPixelHeight(5),
                    right: FetchPixels.getPixelHeight(5)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1,
                          offset: Offset(0.0, 1.0)),
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

                    Row(
                        children: [


                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: FetchPixels.getPixelWidth(120),
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextField(
                                          focusNode: myfocus,
                                          controller: hideController,
                                          keyboardType: TextInputType.none,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'PickedQty',
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),








                        ] ),


                    //here

                  ],
                ),


              ),


            ],
          );
        },
      ),
    );
  }


  Widget pickedList1() {
    return ListView.builder(
      physics:  ScrollPhysics(),
      shrinkWrap: true,
      primary: true,
      itemCount: pickedList.length,
      itemBuilder: (context, index) {
        // ModelItem modelItem = itemProductLists[index];
        return Column(
          children: [
            //  dateHeader(modelItem, index),
            //getVerSpace(FetchPixels.getPixelHeight(10)),

            Container(
              margin: EdgeInsets.only(
                  bottom: FetchPixels.getPixelHeight(10),
                  top: FetchPixels.getPixelHeight(10),
                  left: FetchPixels.getPixelHeight(5),
                  right: FetchPixels.getPixelHeight(5)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 1,
                        offset: Offset(0.0, 1.0)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        InkWell(
                          splashColor: Colors.white,
                          highlightColor: Colors.blue,
                          child:Container(
                            width: 50.0,
                            height: 30.0,
                            child: Center(
                              child: getSvgImage("delete.svg",
                                  width: FetchPixels.getPixelHeight(40),
                                  height: FetchPixels.getPixelHeight(40)),
                            ),
                          ),
                          onTap:() {
                            setState(() {
                              {
                                delete_PickedDetails(
                                    pickedList[index].slno,
                                    pickedList[index].pickId,
                                    pickedList[index].partno);
                                _isLoading == true;

                              }
                              setState(() {
                              });

                            });
                          },
                          /*onTap: () {

                            setState(() {
                              // activepicklist();
                              if(picStatus=="Active") {
                                delete_PickedDetails(
                                  pickedList![index].slno,
                                  pickedList![index].pickId,
                                  pickedList![index].partno,);

                              }


                            });
                          },*/

                        ),
                        Text(
                          pickedList[index].pickedQty  +'       \u{1F6D2}',

                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                        Text(
                          '\u{20B9} '+pickedList[index].pickedRate,

                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                        ),

                        Text(
                          pickedList[index].pickstatus,

                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                        ),


                        /* getDefaultTextFiledWithLabel(
                            context, "Name", qtyController, Colors.grey,
                            function: () {},
                            height: FetchPixels.getPixelHeight(10),
                            isEnable: false,
                            withprefix: true),*/

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
                      ] ),

                  //here

                ],
              ),


            ),




          ],
        );
      },
    );
  }




  Container buttons(BuildContext context) {
    return Container(
      color: backGroundColor,
      padding: EdgeInsets.only(
          left: FetchPixels.getPixelWidth(20),
          right: FetchPixels.getPixelWidth(20),
          bottom: FetchPixels.getPixelHeight(20)),
      child: Row(
        children: [
          /*   Expanded(
              child: getButton(context, Colors.white, "Back", blueColor,
                      () {
                    Constant.backToPrev(context);
                  }, 18,
                  weight: FontWeight.w600,
                  buttonHeight: FetchPixels.getPixelHeight(60),
                  borderColor: blueColor,
                  borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(14)),
                  isBorder: true,
                  borderWidth: 1.5)),*/
          getHorSpace(FetchPixels.getPixelWidth(20)),
          Expanded(
              child: getButton(context, blueColor, "Back", Colors.white, () {
                //  Constant.sendToNext(context, Routes.scanBinRoute);
                // addressList.removeAt(selection!.getInt("index")!);
                // setState(() {});
                //scanQRCode();
                Constant.backToPrev(context);

              }, 18,
                  weight: FontWeight.w600,
                  buttonHeight: FetchPixels.getPixelHeight(60),
                  borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(14)))),
          getHorSpace(FetchPixels.getPixelWidth(20)),
          Expanded(
            child: GestureDetector(
              child:getButton(context, Colors.green, "Confirm", Colors.white,() {
                //  Constant.sendToNext(context, Routes.scanBinRoute);
                // addressList.removeAt(selection!.getInt("index")!);
                // setState(() {});
                // scanQRCode();
                {
                  showDialog(
                      barrierDismissible: false,
                      builder: (context) {



                        return Dialog();
                      },
                      context: context);
                }


              }, 18,
                  weight: FontWeight.w600,
                  buttonHeight: FetchPixels.getPixelHeight(60),
                  borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(14))),
            ),
          ),
          /*   Expanded(
              child: getButton(context, Colors.green, "Confirm", Colors.white, () {
                // addressList.removeAt(selection!.getInt("index")!);
               // pickedDetails_update();


              }, 18,
                  weight: FontWeight.w600,
                  buttonHeight: FetchPixels.getPixelHeight(60),
                  borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(14)))
         ),*/

        ],
      ),
    );
  }
  Future<void> scanQRCode()async{
    try{
      final qrCode1=await FlutterBarcodeScanner.scanBarcode(
          '#ff6666',
          'Cancel',
          true,
          ScanMode.QR);
      if(!mounted)return;
      setState(() {
        print(qrCode1);
        this.qrCode=qrCode1;
        containerQR.text=qrCode;
        print(containerQR.text);
        if(containerQR.text.isNotEmpty&&containerQR.text!='-1'){
          if(containerQR.text.isNotEmpty){
            //   loadContainerQR();
            //  Get.toNamed(Routes.scanLocationQR,arguments: {"container_no":get_container_no,
            //    "material_code":get_material_code,"put_id":get_put_id,"company_id":get_company_id,"warehouse_id":get_warehouse_id
            //  });
          }

          if(containerQR.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar
              (
              content: Text(
                'Container Code Wrong Try Again', textAlign: TextAlign.center,),
              backgroundColor: appbarColor,
              elevation: 10,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(15),
            )
            );
          }
          if(containerQR.text.isEmpty)
          {
            containerQR.clear();
            FlutterBeep.beep(false);
          };
        }
        else{
          containerQR.clear();
          FlutterBeep.beep(false);
        }


      });
    } on PlatformException{
      qrCode='Failed to get platform version';
    }


  }
  Dialog() {
    FetchPixels(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(20))),
      backgroundColor: backGroundColor,
      content: Builder(
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              getVerSpace(FetchPixels.getPixelHeight(20)),
              getMultilineCustomFont(
                  "Are you Confirm the Pick Item?", 22, Colors.black,
                  fontWeight: FontWeight.w900,
                  txtHeight: 1.2,
                  textAlign: TextAlign.center),
              getVerSpace(FetchPixels.getPixelHeight(31)),
              Row(
                children: [
                  Expanded(
                      child: getButton(
                          context, backGroundColor, "No", blueColor, () {
                        Constant.backToPrev(context);
                      }, 18,
                          weight: FontWeight.w600,
                          buttonHeight: FetchPixels.getPixelHeight(60),
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(14)),
                          borderColor: blueColor,
                          isBorder: true,
                          borderWidth: 1.5)),
                  getHorSpace(FetchPixels.getPixelWidth(20)),
                  Expanded(
                      child: getButton(context, blueColor, "Yes", Colors.white,
                              () {
                            if(pickItem[0].pickedQty!=''&&pickItem[0].pickedQty!=0){
                              pickitemcofirm();
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  "pick Item Empty",
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: Colors.red,
                                elevation: 10,
                                duration: const Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(15),
                              ));
                            }
                            _isLoading = true;
                            //  pickdetaildata();
                            // _reloadPage();
                            Constant.backToPrev(context);
                          }, 18,
                          weight: FontWeight.w600,
                          buttonHeight: FetchPixels.getPixelHeight(60),
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(14)))),
                ],
              ),
              getVerSpace(FetchPixels.getPixelHeight(20)),
            ],
          );
        },
      ),
    );
  }


}
