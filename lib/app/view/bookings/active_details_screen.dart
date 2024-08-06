import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../apiclass/BinName.dart';
import '../../../apiclass/PickDetailView.dart';
import 'package:home_service_provider/app/data/data_file.dart';
import 'package:home_service_provider/app/models/model_salon.dart';

import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:home_service_provider/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:home_service_provider/app/utils/strings.dart';
import 'package:http/http.dart' as http;
import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../routes/app_routes.dart';
import 'dart:developer' as developer;

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:shared_preferences/shared_preferences.dart';


bool value = true;
bool selected=false;

class ActiveDetails extends StatefulWidget {
  const ActiveDetails({Key? key}) : super(key: key);

  @override
  State<ActiveDetails> createState() => _ActiveDetails();
}

class _ActiveDetails extends State<ActiveDetails> with TickerProviderStateMixin {
  late  final AnimationController _acontroller =AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,)..repeat();
 /*void dispose(){
   _acontroller.dispose();
   this.dispose();
 }*/
  //TextEditingController qtyController = TextEditingController();
  //Future<String> _future;
  int _counter = 0;
    String pickdetails = Strings.apipath + "pickdetails_api.php";
  String comppickdetails = Strings.apipath + "completedpickdetails_api.php";
  String pickitemConfirm = Strings.apipath + "pickitem_confirm.php";
  String pickitemCancel = Strings.apipath + "pickitem_cancelled.php";
  String completeMaster = Strings.apipath + "complete_pick_master.php";
  String BINMASTER = Strings.apipath + "bin_list_api.php";

  static List<ModelItem> itemProductLists = DataFile.itemProductList;
  List<PickListMaster> pickListsMaster = [];
  List<PickListDetails> pickListsDetails = [];
  List<TextEditingController> _controller = [];
  List<BinNameElement> binName=[];

  bool _isEditingText = false;
  TextEditingController qtyController = TextEditingController();
  TextEditingController containerQR = TextEditingController();
  TextEditingController pickedDetails = TextEditingController();
  String initialText = "Qty";

  String? pickcategory;
  String? pickid;
  String? pickstatus;
  String? pckdQty;
  var _isLoading = true;
  String qrCode = 'unknow';
  String _binqrcode = '';
  String _empcode = '';
  String selectedValue = "";
  String _comcode='';
  String _billtype='';


  dynamic currentTime = DateFormat.Hm().format(DateTime.now());
  var format = DateFormat("HH:mm");

  List<DropdownMenuItem<dynamic>> get dropdownItems{
    List<DropdownMenuItem<dynamic>> menuItems = [
      DropdownMenuItem(child: Text("Select Bin"),value: "Select Bin"),
      DropdownMenuItem(child: Text("1"),value: "1"),
      DropdownMenuItem(child: Text("2"),value: "2"),
      DropdownMenuItem(child: Text("3"),value: "3"),
      DropdownMenuItem(child: Text("4"),value: "4"),
    ];
    return menuItems;
  }

  get_sessionData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      _binqrcode = (logindata.getString('binqrcode') ?? '');
    //  selectedValue = "Select Bin";
      _empcode = (logindata.getString('employeeCode')??'');
      _comcode = (logindata.getString('comCode') ?? '');
      _billtype = (logindata.getString('billType') ?? '');
      containerQR.text = _binqrcode;
    });
  }

  Future<void> binNameList() async {
    print("hi welcome ppick list");
    print(pickcategory);
    print(pickid);
    print(_empcode);
    final res = await http.post(Uri.parse(BINMASTER), headers: {
      "Accept": "application/json"
    }, body: {
      "compCode": _comcode,
      "bill_type": _billtype,

    });
    if (res.statusCode == 200) {
     // developer.log(res.body);

   //   print(json.decode(res.body));
      var data = json.decode(res.body);
      if (data["is_success"] == true) {
        try {
          final BinNameList = binNameFromJson(res.body);
          binName = BinNameList.binName;
        } catch (e) {
          /*    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              " Please Pass Correct parameters ${e}",
              textAlign: TextAlign.center,
            ),
            backgroundColor: appbarColor,
            elevation: 10,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(15),
          )); */
          throw Future.error(e);
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
        setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
        });
      }
    }
  }
  Future<void> pickdetaildata() async {
    print("hi welcome ppick list");
    print(pickcategory);
    print(pickid);
    print(_empcode);
    final res = await http.post(Uri.parse(pickdetails), headers: {
      "Accept": "application/json"
    }, body: {
      "compCode": _comcode,
      "bill_type": _billtype,
      "category": pickcategory,
      "pickid": pickid,
      "employeeCode": _empcode
    });
    if (res.statusCode == 200) {
        developer.log(res.body);

      print(json.decode(res.body));
      var data = json.decode(res.body);
      if (data["is_success"] == true) {
        try {
          final PickDetailView = pickDetailViewFromJson(res.body);
          pickListsMaster = PickDetailView.pickListMaster;

          pickListsDetails = PickDetailView.pickListDetails;

          setState(() {
            var items=pickListsDetails.map<String>((item){
              final number=item.pickId;
              return 'Item $number';
            }).toList();

            _isLoading = false;
            (_isLoading == false)
                ? print("true:${_isLoading}")
                : print("false:${_isLoading}");
          });
        } catch (e) {
       /*    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              " Please Pass Correct parameters ${e}",
              textAlign: TextAlign.center,
            ),
            backgroundColor: appbarColor,
            elevation: 10,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(15),
          )); */
          throw Future.error(e);
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
        setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
        });
      }
    }
  }



  Future<void> pickitemcofirm(Slno, pickID, PickedQty,) async {
    print("Pick Item Confirm API Start");
    print(pickID);
    print(Slno);
    print(PickedQty);

    final res = await http.post(Uri.parse(pickitemConfirm),
        headers: {"Accept": "application/json"},
        body: {"slno": Slno,"pickid": pickID, "pickedQty": PickedQty, "binQR": _binqrcode});
    if (res.statusCode == 200) {
      //   developer.log(res.body);

      setState(() {
        pickdetaildata();
        _isLoading = false;
        (_isLoading == false)
            ? print("true:${_isLoading}")
            : print("false:${PickedQty}");
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
            Constant.sendToNext(context, Routes.pickListPreviewScreenRoute,arguments:{"category":pickcategory,"pickId":pickListsMaster[0].pickId,"pickstatus":pickListsMaster[0].pickStatus,"preview":'view'},);

         /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              data["messages"],
              textAlign: TextAlign.center,
            ),
            backgroundColor: appbarColor,
            elevation: 10,
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(15),
          )); */
         // Constant.sendToNext(context, Routes.homeScreenRoute);
        }
        else {
         /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              data["messages"],
              textAlign: TextAlign.center,
            ),
            backgroundColor: appbarColor,
            elevation: 10,
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(15),
          )); */
        }
      }else if (data["is_success"] == false) {
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
        setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
        });
      }
    }
  }

  Future<void> pickitemcancel(Slno, PickId) async {
    print("Pick Item Delete API Start");
    print(PickId);
    print(Slno);
    final res = await http.post(Uri.parse(pickitemCancel),
        headers: {"Accept": "application/json"},
        body: {"slno": Slno, "pickid": PickId});
    if (res.statusCode == 200) {
      var data = json.decode(res.body);

      //   developer.log(res.body);

      setState(() {
        pickdetaildata();
        _isLoading = false;
        (_isLoading == false)
            ? print("true:${_isLoading}")
            : print("false:${_isLoading}");
      });

      print(json.decode(res.body));

      if (data["is_success"] == true) {
        if (data["messages"] == 'Last Item Cancelled') {
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
          Constant.sendToNext(context, Routes.pickListPreviewScreenRoute,arguments:{"category":pickcategory,"pickId":pickListsMaster[0].pickId,"pickstatus":pickListsMaster[0].pickStatus,"preview":'view'},);
        }

        else{

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
      }else if (data["is_success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            data["messages"],
            textAlign: TextAlign.center,
          ),
          backgroundColor: appbarColor,
          elevation: 10,

          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
          duration: const Duration(seconds: 1),
        ));
        setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
        });
      }
    }
  }
  Future<void> completemasterpick(PickId) async {
    print("Complete");
    print(PickId);

    final res = await http.post(Uri.parse(completeMaster),
        headers: {"Accept": "application/json"},
        body: {"pick_id": PickId});
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
     // print(data);
       // developer.log(res.body);

      setState(() {
        pickdetaildata();
        _isLoading = false;
        (_isLoading == false)
            ? print("true:${_isLoading}")
            : print("false:${_isLoading}");
      });

   //  print(json.decode(res.body));


        if (data == 'Complete Successfully') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              data,
              textAlign: TextAlign.center,
            ),
            backgroundColor: appbarColor,
            elevation: 10,
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(15),
          ));
          Constant.sendToNext(context,Routes.homeScreenRoute);
        }
        else{

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              data,
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
  Future refresh()async{
    setState(() {

    });
  }

  @override
  void initState() {

    get_sessionData();


    //pickdetaildata();
    selectedValue = "Nepal";
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        Map args = ModalRoute.of(context)?.settings.arguments as Map;
        pickcategory = args['category'];
        pickid = args['pickId'];
        pickstatus = args['pickstatus'];
        if (pickstatus == 'Active')
          pickdetaildata();
        binNameList();

      });

    });

    error = false;
    sending = false;
    success = false;
    msg = "";
    qtyController = TextEditingController(text: initialText);

    Timer(Duration(seconds: 2), () {
     setState(() {
        _isLoading = false;
        (_isLoading == false) ?
        print("true:${_isLoading}") :
        print("false:${_isLoading}");
      });
    });

  }

  void _reloadPage() {
    setState(() {
      _counter = _counter + 1;
      print("SetState");
      print(_counter);
    });
  }

  var index = 0;
  var total = 0.00;
  late bool error, sending, success;
  late String msg;
  @override
  void dispose() {
    qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(
      BuildContext context,
      ) {


    FetchPixels(context);
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: pickListsMaster.isEmpty? Center(child:SpinKitFadingCircle(
        color: Colors.indigo,
        size: 50.0,
      )) :_bodyWidget(context),
    );
  }

  _bodyWidget(BuildContext context) {
    double defHorSpace = FetchPixels.getDefaultHorSpace(context);
    double defSpace = FetchPixels.getDefaultHorSpace(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: defHorSpace);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.blueGrey.shade50,
          body: SafeArea(
            child: Column(
              children: [
                getVerSpace(FetchPixels.getPixelHeight(10)),
                buildToolbar(context),
                getVerSpace(FetchPixels.getPixelHeight(10)),
                buildBottomExpand(context, edgeInsets, defHorSpace, defSpace),
                getVerSpace(FetchPixels.getPixelHeight(10)),
                //buildPage(edgeInsets, context, index, defSpace),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          Constant.backToPrev(context);
          return false;
        });
  }

  ListView buildPage(
      EdgeInsets edgeInsets, BuildContext context, int index, double defSpace) {
    return ListView(
      primary: true,
      shrinkWrap: true,
      children: [
        getVerSpace(FetchPixels.getPixelHeight(20)),
        buildListView(defSpace),
        // viewCartButton(context),
        getVerSpace(FetchPixels.getPixelHeight(30))
        // packageList(context)
      ],
    );
  }

  ListView buildListView(double defSpace) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      primary: false,
      itemCount: itemProductLists.length,
      itemBuilder: (context, index) {
        ModelItem modelSalon = itemProductLists[index];
        return Container(
          margin: EdgeInsets.only(
              bottom: FetchPixels.getPixelHeight(20),
              left: defSpace,
              right: defSpace),
          width: FetchPixels.getPixelWidth(374),
          padding: EdgeInsets.only(
              left: FetchPixels.getPixelWidth(16),
              right: FetchPixels.getPixelWidth(16),
              top: FetchPixels.getPixelHeight(16),
              bottom: FetchPixels.getPixelHeight(16)),
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
          child: Row(
            children: [
              //packageImage(context, modelSalon),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(16)),
                  child: packageDescription(modelSalon),
                ),
              ),
              addButton(modelSalon, context, index)
            ],
          ),
        );
      },
    );
  }

  Expanded buildBottomExpand(BuildContext context, EdgeInsets edgeInsets,
      double defHorSpace, double defSpace) {
    return Expanded(
      flex: 1,
      child: ListView(
        primary: true,
        shrinkWrap: true,
        children: [
          buildTopContainer(context, edgeInsets),

          getVerSpace(FetchPixels.getPixelHeight(15)),


          (containerQR.text.isNotEmpty)
              ? bookingList()
              : getSvgImage("qr-code-svgrepo-com (1).svg",
              width: FetchPixels.getPixelHeight(300),
              height: FetchPixels.getPixelHeight(400)),
        ],
      ),
    );
  }



  Widget buildBottomWidget(
      EdgeInsets edgeInsets, BuildContext context, double defSpace) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      primary: false,
      itemCount: itemProductLists.length,
      itemBuilder: (context, index) {
        ModelItem modelItem = itemProductLists[index];
        return GestureDetector(
            onTap: () {
              /*   Constant.sendToNext(context, Routes.scanPartnoRoute);*/
            },
            child: Container(
              margin: EdgeInsets.only(
                  bottom: FetchPixels.getPixelHeight(20),
                  left: defSpace,
                  right: defSpace),
              width: FetchPixels.getPixelWidth(374),
              padding: EdgeInsets.only(
                  left: FetchPixels.getPixelWidth(16),
                  right: FetchPixels.getPixelWidth(16),
                  top: FetchPixels.getPixelHeight(16),
                  bottom: FetchPixels.getPixelHeight(16)),
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
              child: Row(
                children: [
                  //packageImage(context, modelItem),
                  Expanded(
                    child: Container(
                      padding:
                      EdgeInsets.only(left: FetchPixels.getPixelWidth(16)),
                      child: packageDescription(modelItem),
                    ),
                  ),
                  addButton(modelItem, context, index)
                ],
              ),
            ));
      },
    );
  }


  Column packageDescription(ModelItem modelItem) {
    double horSpace = FetchPixels.getDefaultHorSpace(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getCustomFont(
          modelItem.name ?? '',
          16,
          Colors.black,
          1,
          fontWeight: FontWeight.w900,
        ),
        getVerSpace(FetchPixels.getPixelHeight(4)),
        getCustomFont(modelItem.productName ?? "", 14, textColor, 1,
            fontWeight: FontWeight.w400),
        getVerSpace(FetchPixels.getPixelHeight(12)),
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
                  borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(12))),
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
                  getDefaultTextFiledWithLabel(
                    context,
                    "Employee Code",
                    qtyController,
                    Colors.grey,
                    TextStyle(fontSize: 23),
                    function: () {},
                    height: FetchPixels.getPixelHeight(60),
                    isEnable: false,
                    withprefix: true,
                    image: "message.svg",
                  ),
                  /*  Align(
                      alignment: Alignment.topCenter,
                      child: getCustomFont(
                       "Qty",
                        14,
                        Colors.black,
                        1,
                        fontWeight: FontWeight.w900,
                      )),*/
                  getVerSpace(FetchPixels.getPixelHeight(4)),
                  Align(
                      alignment: Alignment.topCenter,
                      child: getCustomFont("120", 14, Colors.black, 1,
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
                  borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(12))),
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
                        "Rack",
                        14,
                        Colors.black,
                        1,
                        fontWeight: FontWeight.w900,
                      )),
                  getVerSpace(FetchPixels.getPixelHeight(4)),
                  Align(
                      alignment: Alignment.topCenter,
                      child: getCustomFont("L1/R1/A1", 14, Colors.black, 1,
                          fontWeight: FontWeight.w400))
                ],
              ),
            ),
          ],
        ),
        getVerSpace(FetchPixels.getPixelHeight(12)),
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
                  borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(12))),
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
                        14,
                        Colors.black,
                        1,
                        fontWeight: FontWeight.w900,
                      )),
                  getVerSpace(FetchPixels.getPixelHeight(4)),
                  Align(
                      alignment: Alignment.topCenter,
                      child: getCustomFont("1290", 14, Colors.black, 1,
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
                  borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(12))),
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
                        "Pending",
                        14,
                        Colors.black,
                        1,
                        fontWeight: FontWeight.w900,
                      )),
                  getVerSpace(FetchPixels.getPixelHeight(4)),
                  Align(
                      alignment: Alignment.topCenter,
                      child: getCustomFont("30", 14, Colors.black, 1,
                          fontWeight: FontWeight.w400))
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget bookingList() {
    return RefreshIndicator(
      onRefresh: pickdetaildata,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: FetchPixels.getPixelHeight(0)),
        shrinkWrap: true,
        primary: true,
        itemCount: pickListsDetails.length,
        itemBuilder: (context, index) {
          //ModelItem modelItem = itemProductLists[index];
          return Column(
            children: [
              //  dateHeader(modelItem, index),
             // getVerSpace(FetchPixels.getPixelHeight(5)),
          //&&&&&&&&&&&&&&&&  Animation work sart$$$$$$$$$$$$$$$$$$$$$$$
           /*   pickListsDetails![index].compulsory=='0'?Container(
                 width: 250,
                  height: 250.0,
                  color: Colors.blue,
                  child:
                  AnimatedBuilder(
                    animation: _acontroller,
                    child: const FlutterLogo(size: 50.0,),
                    builder: (BuildContext context,Widget?child){
                      return Transform.rotate(angle: _acontroller.value * 2.0 * math.pi,
                      child: child,);
                    },
                  )):*/
          ///&&&&&&&&&&&&&&&&&&&&&&&&&&& Animation work&&&&&&&&&&&&&&&&&&&&&&&&&&//
              pickListsDetails[index].compulsory=='1'?  FadeTransition(
            opacity: _acontroller,
            child: Container(
                    margin: EdgeInsets.only(
                        bottom: FetchPixels.getPixelHeight(5),
                        left: FetchPixels.getDefaultHorSpace(context),
                        right: FetchPixels.getDefaultHorSpace(context)),

                    decoration: BoxDecoration(

                        color:(pickListsDetails[index].pickStatus=='Completed')? Colors.greenAccent:
                        (pickListsDetails[index].pickStatus=='Active')?Colors.white:Colors.amberAccent,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0.0, 4.0)),
                        ],
                        borderRadius:
                        BorderRadius.circular(FetchPixels.getPixelHeight(12))),
                    padding: EdgeInsets.symmetric(
                        horizontal: FetchPixels.getPixelWidth(10),
                        vertical: FetchPixels.getPixelHeight(7)),
                    child:
                    Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new InkWell(
                                onTap: () {
                                  //Navigator.pushNamed(context, Routes.scanPartScreenRoute,arguments:{"PartNo":pickListsDetails![index].partno,"PickId":pickListsDetails![index].pickId}, );

                                  Constant.sendToNext(
                                      context, Routes.scanPartScreenRoute,
                                      arguments: {
                                        "serialNO": pickListsDetails[index].slno,
                                        "PartNo": pickListsDetails[index].partno,
                                        "pickId": pickListsDetails[index].pickId,
                                        "category": pickcategory,
                                        "pickstatus": pickListsDetails[index].pickStatus
                                      });
                                },
                                child: new Padding(
                                  padding: new EdgeInsets.all(10.0),
                                  child:  Container(
                                    width: 250,
                                    child: Expanded(
                                      flex: 1,
                                      child:getCustomFont(
                                      pickListsDetails[index].partno,
            18,
            Colors.red,
            2,
            fontWeight: FontWeight.w900),
            )
                                    ),
                                  ),

                                ),


                              getHorSpace(FetchPixels.getPixelWidth(50)),
                              GestureDetector(
                                  child: Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/checked-svgrepo.png"),
                                        ),
                                      )),

                                  onTap: () {
                                    showDialog(
                                        barrierDismissible: false,
                                        builder: (context) {
                                          if (pickListsDetails[index]
                                              .pickedQty ==
                                              '0') {
                                            pckdQty =
                                                pickListsDetails[index].quantity;
                                          } else {
                                            pckdQty = pickListsDetails[index]
                                                .pickedQty;
                                          }
                                          return Dialog(
                                              pickListsDetails[index].slno,
                                              pickListsDetails[index].pickId,
                                              pckdQty);
                                        },
                                        context: context);
                                  }),

                              getHorSpace(FetchPixels.getPixelWidth(10)),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if ((pickListsDetails[index].pickedQty) !=
                                      '0') ...[
                                    getCustomFont(
                                      pickListsDetails[index].pickedQty,
                                      26,
                                      Colors.black,
                                      2,
                                      fontWeight: FontWeight.w600,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ] else ...[
                                    getCustomFont(
                                      pickListsDetails[index].quantity,
                                      26,
                                      Colors.black,
                                      2,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ],
                              ),

                              /* getDefaultTextFiledWithLabel(
                                context, "Name", qtyController, Colors.grey,
                                function: () {},
                                height: FetchPixels.getPixelHeight(10),
                                isEnable: false,
                                withprefix: true),*/

                              // _editTitleTextField(pickListsDetails![index].partno),

                              GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      20,
                                      0,
                                      0,
                                      0,
                                    ),
                                    child: Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/cancel-svgrepo.png"),
                                          ),
                                        )),
                                  ),
                                  onTap: () {
                                    showDialog(
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return Dialog1(
                                              pickListsDetails[index].slno,
                                              pickListsDetails[index].pickId);
                                        },
                                        context: context);
                                  }),
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

                        getVerSpace(FetchPixels.getPixelHeight(3)),
                        getHorSpace(FetchPixels.getPixelWidth(6)),
                        getCustomFont(pickListsDetails[index].partname ?? "",
                            12, Colors.red, 2,
                            fontWeight: FontWeight.w500),

                        getVerSpace(FetchPixels.getPixelHeight(5)),
                        getDivider(dividerColor, 0, 1),
                        getVerSpace(FetchPixels.getPixelHeight(5)),
                        //here
                        Row(
                          children: [
                            Container(
                              width: FetchPixels.getPixelWidth(110),
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
                                  top: FetchPixels.getPixelHeight(5),
                                  bottom: FetchPixels.getPixelHeight(5)),
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
                                        13,
                                        Colors.black,
                                        1,
                                        fontWeight: FontWeight.w800,
                                      )),
                                  getVerSpace(FetchPixels.getPixelHeight(4)),
                                  Align(
                                      alignment: Alignment.topCenter,
                                      child: getCustomFont(
                                          pickListsDetails[index].rate,
                                          14,
                                          Colors.black,
                                          1,
                                          fontWeight: FontWeight.w400))
                                ],
                              ),
                            ),
                            getHorSpace(FetchPixels.getPixelHeight(10)),
                            Container(
                              width: FetchPixels.getPixelWidth(110),
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
                                  top: FetchPixels.getPixelHeight(5),
                                  bottom: FetchPixels.getPixelHeight(5)),
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
                                        "Rack",
                                        13,
                                        Colors.black,
                                        1,
                                        fontWeight: FontWeight.w800,
                                      )),
                                  getVerSpace(FetchPixels.getPixelHeight(4)),
                                  Align(
                                      alignment: Alignment.topCenter,
                                      child: getCustomFont(
                                          pickListsDetails[index].rackno,
                                          14,
                                          Colors.black,
                                          1,
                                          fontWeight: FontWeight.w400))
                                ],
                              ),
                            ),
                            getHorSpace(FetchPixels.getPixelHeight(10)),
                            Container(
                              width: FetchPixels.getPixelWidth(110),
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
                                  top: FetchPixels.getPixelHeight(5),
                                  bottom: FetchPixels.getPixelHeight(5)),
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
                                        13,
                                        Colors.black,
                                        1,
                                        fontWeight: FontWeight.w800,
                                      )),
                                  getVerSpace(FetchPixels.getPixelHeight(4)),
                                  Align(
                                      alignment: Alignment.topCenter,
                                      child: getCustomFont(
                                          pickListsDetails[index].stockqty,
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
                    )),
          ):Container(
                  margin: EdgeInsets.only(
                      bottom: FetchPixels.getPixelHeight(5),
                      left: FetchPixels.getDefaultHorSpace(context),
                      right: FetchPixels.getDefaultHorSpace(context)),

                  decoration: BoxDecoration(

                      color:(pickListsDetails[index].pickStatus=='Completed')? Colors.greenAccent:
                      (pickListsDetails[index].pickStatus=='Active')?Colors.white:Colors.amberAccent,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0.0, 4.0)),
                      ],
                      borderRadius:
                      BorderRadius.circular(FetchPixels.getPixelHeight(12))),
                  padding: EdgeInsets.symmetric(
                      horizontal: FetchPixels.getPixelWidth(10),
                      vertical: FetchPixels.getPixelHeight(7)),
                  child:
                  Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            new InkWell(
                              onTap: () {
                                //Navigator.pushNamed(context, Routes.scanPartScreenRoute,arguments:{"PartNo":pickListsDetails![index].partno,"PickId":pickListsDetails![index].pickId}, );

                                Constant.sendToNext(
                                    context, Routes.scanPartScreenRoute,
                                    arguments: {
                                      "serialNO": pickListsDetails[index].slno,
                                      "PartNo": pickListsDetails[index].partno,
                                      "pickId": pickListsDetails[index].pickId,
                                      "category": pickcategory,
                                      "pickstatus": pickListsDetails[index].pickStatus
                                    });
                              },
                              child: new Padding(
                                padding: new EdgeInsets.all(10.0),
                                child:  Container(
                                    width: 250,
                                    child: Expanded(
                                      flex: 1,
                                      child:getCustomFont(
                                          pickListsDetails[index].partno,
                                          18,
                                          Colors.black,
                                          2,
                                          fontWeight: FontWeight.w900),
                                    )
                                ),
                              ),

                            ),


                            getHorSpace(FetchPixels.getPixelWidth(50)),
                            GestureDetector(
                                child: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/checked-svgrepo.png"),
                                      ),
                                    )),

                                onTap: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      builder: (context) {
                                        if (pickListsDetails[index]
                                            .pickedQty ==
                                            '0') {
                                          pckdQty =
                                              pickListsDetails[index].quantity;
                                        } else {
                                          pckdQty = pickListsDetails[index]
                                              .pickedQty;
                                        }
                                        return Dialog(
                                            pickListsDetails[index].slno,
                                            pickListsDetails[index].pickId,
                                            pckdQty);
                                      },
                                      context: context);
                                }),

                            getHorSpace(FetchPixels.getPixelWidth(10)),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if ((pickListsDetails[index].pickedQty) !=
                                    '0') ...[
                                  getCustomFont(
                                    pickListsDetails[index].pickedQty,
                                    26,
                                    Colors.black,
                                    2,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ] else ...[
                                  getCustomFont(
                                    pickListsDetails[index].quantity,
                                    26,
                                    Colors.black,
                                    2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ],
                            ),

                            /* getDefaultTextFiledWithLabel(
                                context, "Name", qtyController, Colors.grey,
                                function: () {},
                                height: FetchPixels.getPixelHeight(10),
                                isEnable: false,
                                withprefix: true),*/

                            // _editTitleTextField(pickListsDetails![index].partno),

                            GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    20,
                                    0,
                                    0,
                                    0,
                                  ),
                                  child: Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/cancel-svgrepo.png"),
                                        ),
                                      )),
                                ),
                                onTap: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return Dialog1(
                                            pickListsDetails[index].slno,
                                            pickListsDetails[index].pickId);
                                      },
                                      context: context);
                                }),
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

                      getVerSpace(FetchPixels.getPixelHeight(3)),
                      getHorSpace(FetchPixels.getPixelWidth(6)),
                      getCustomFont(pickListsDetails[index].partname ?? "",
                          12, Colors.black, 2,
                          fontWeight: FontWeight.w500),

                      getVerSpace(FetchPixels.getPixelHeight(5)),
                      getDivider(dividerColor, 0, 1),
                      getVerSpace(FetchPixels.getPixelHeight(5)),
                      //here
                      Row(
                        children: [
                          Container(
                            width: FetchPixels.getPixelWidth(110),
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
                                top: FetchPixels.getPixelHeight(5),
                                bottom: FetchPixels.getPixelHeight(5)),
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
                                      13,
                                      Colors.black,
                                      1,
                                      fontWeight: FontWeight.w800,
                                    )),
                                getVerSpace(FetchPixels.getPixelHeight(4)),
                                Align(
                                    alignment: Alignment.topCenter,
                                    child: getCustomFont(
                                        pickListsDetails[index].rate,
                                        14,
                                        Colors.black,
                                        1,
                                        fontWeight: FontWeight.w400))
                              ],
                            ),
                          ),
                          getHorSpace(FetchPixels.getPixelHeight(10)),
                          Container(
                            width: FetchPixels.getPixelWidth(110),
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
                                top: FetchPixels.getPixelHeight(5),
                                bottom: FetchPixels.getPixelHeight(5)),
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
                                      "Rack",
                                      13,
                                      Colors.black,
                                      1,
                                      fontWeight: FontWeight.w800,
                                    )),
                                getVerSpace(FetchPixels.getPixelHeight(4)),
                                Align(
                                    alignment: Alignment.topCenter,
                                    child: getCustomFont(
                                        pickListsDetails[index].rackno,
                                        14,
                                        Colors.black,
                                        1,
                                        fontWeight: FontWeight.w400))
                              ],
                            ),
                          ),
                          getHorSpace(FetchPixels.getPixelHeight(10)),
                          Container(
                            width: FetchPixels.getPixelWidth(110),
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
                                top: FetchPixels.getPixelHeight(5),
                                bottom: FetchPixels.getPixelHeight(5)),
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
                                      13,
                                      Colors.black,
                                      1,
                                      fontWeight: FontWeight.w800,
                                    )),
                                getVerSpace(FetchPixels.getPixelHeight(4)),
                                Align(
                                    alignment: Alignment.topCenter,
                                    child: getCustomFont(
                                        pickListsDetails[index].stockqty,
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
      ),
    );
  }

  Column addButton(ModelItem modelItem, BuildContext context, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.only(
              top: FetchPixels.getPixelHeight(16),
              bottom: FetchPixels.getPixelHeight(16),
              left: FetchPixels.getPixelWidth(16),
              right: FetchPixels.getPixelWidth(16)),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Colors.blueGrey,
                    blurRadius: 10,
                    offset: Offset(0.0, 4.0)),
              ],
              borderRadius:
              BorderRadius.circular(FetchPixels.getPixelHeight(12))),
          child: Row(
            children: [
              GestureDetector(
                child: getSvgImage("checked-svgrepo.svg",
                    width: FetchPixels.getPixelHeight(40),
                    height: FetchPixels.getPixelHeight(40)),
                onTap: () {
                  modelItem.quantity = (modelItem.quantity! + 1);
                  total = total + (modelItem.price! * 1);

                  DataFile.cartList[index.toString()]!.quantity =
                      modelItem.quantity;

                  setState(() {});
                },
              ),
              getHorSpace(FetchPixels.getPixelWidth(10)),
               getCustomFont(
                modelItem.quantity.toString(),
                14,
                Colors.black,
                1,
                fontWeight: FontWeight.w400,
              ),
              getHorSpace(FetchPixels.getPixelWidth(10)),
              GestureDetector(
                child: getSvgImage("cancel-svgrepo.svg",
                    width: FetchPixels.getPixelHeight(40),
                    height: FetchPixels.getPixelHeight(40)),
                onTap: () {
                  modelItem.quantity = (modelItem.quantity! - 1);
                  total = total - (modelItem.price! * 1);

                  // print(
                  //     "cartList12===${cartLists.length}===${cartLists[index.toString()]!.quantity}");

                  if (modelItem.quantity! > 0) {
                    DataFile.cartList[index.toString()]!.quantity =
                        modelItem.quantity;
                  } else {
                    DataFile.cartList.remove(index.toString());
                  }

                  setState(() {});
                },
              ),
            ],
          ),
        ),
        getVerSpace(FetchPixels.getPixelHeight(40)),
        getCustomFont("\u20B9${modelItem.price}", 16, blueColor, 1,
            fontWeight: FontWeight.w900),
      ],
    );
  }

  Widget buildTopContainer(BuildContext context, EdgeInsets edgeInsets) {
    binNameList();
    return getPaddingWidget(
      edgeInsets,
      Container(
        padding: EdgeInsets.only(
            top: FetchPixels.getPixelHeight(16),
            bottom: FetchPixels.getPixelHeight(16),
            left: FetchPixels.getPixelWidth(16),
            right: FetchPixels.getPixelWidth(16)),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.blueGrey,
                  blurRadius: 10,
                  offset: Offset(0.0, 4.0)),
            ],
            borderRadius:
            BorderRadius.circular(FetchPixels.getPixelHeight(12))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.7,
                  child: Row(

                    children: [
                      Expanded(
                        child: getCustomFont(
                          "# " + pickListsMaster[0].pickId+"-"+pickListsMaster[0].custname,
                          16,
                          blueColor,
                          1,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 500,
                  child: Row(
                    children: [
                      Expanded(
                        child: getCustomFont(
                          pickListsMaster[0].pickRate +
                        "/" +
                         pickListsMaster[0].totalAmt,
                         18,
                          blueColor,
                          1,
                          fontWeight: FontWeight.w800,

                        ),
                      ),
                      Expanded(
                        child: getCustomFont(
                          pickListsMaster[0].pickAssignDate.toString(),
                          16,
                          blueColor,
                          1,
                          fontWeight: FontWeight.w600,

                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: getCustomFont(
                      pickListsMaster[0].pickitemCompletedQty +
                          "/" +
                          pickListsMaster[0].totalItemCount,
                      20,
                      textColor,
                      1,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 500,
                  child: Row(

                    children: [
                      Expanded(
                        child: getCustomFont(
                          pickListsMaster[0].totalbinqr.toString(),
                          18,
                          textColor,
                          1,
                          fontWeight: FontWeight.w600,



                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                if (pickstatus == "Active") ...[
                  Expanded(
                    child: getCustomFont(
                     "CURRENT BIN: "+ _binqrcode,
                      18,
                      Colors.orangeAccent,
                      1,
                      fontWeight: FontWeight.w600,



                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height:60,
                    child: DecoratedBox(

                                decoration:BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.redAccent,
                                      Colors.blueAccent,
                                      Colors.purpleAccent
                                    ]
                                  ),

                                    borderRadius: BorderRadius.circular(
                                        FetchPixels.getPixelHeight(10)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                                        blurRadius: 5
                                    )
                                  ]
                                ),


                                child: Padding(

                                padding: EdgeInsets.only(left:30, right:30),
                                child:
                                Container(
                                  height: 100,
                                    child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                        menuMaxHeight: 400,
                                  // value: selectedValue,
                                    hint: Text("Select Bin"),

                                  items: binName.map((e){
                                    return DropdownMenuItem(
                                      child: Text(e.binId),
                                      value: e.binId,
                                    );
                                  }).toList(),
                                  onChanged:  (dynamic value) {
                                    setState(() async {
                                      SharedPreferences logindata = await SharedPreferences.getInstance();
                                      selectedValue = value!;
                                      _binqrcode= selectedValue;
                                      logindata.setString("binqrcode", selectedValue);
                                      get_sessionData();
                                    });
                                  },

                                  isExpanded: false, //make true to take width of parent widget
                                  underline: Container(), //empty line
                                  style: TextStyle(fontSize: 20, color:Colors.black),
                                  alignment: Alignment.center,
                                  dropdownColor: Colors.white,
                                  iconEnabledColor: Colors.black,
                                    itemHeight: 50, // Set the desired height here  //Icon color
                                  ),
    )
                                )
                                )

                                    ),
                  ),




      /*            (_binqrcode.isEmpty)? SizedBox(
                    child: getButton(
                        context, Colors.transparent, "Scan New Bin", blueColor,
                            () {
                          // Constant.sendToNext(context, Routes.scanBinRoute);
                          scanQRCode();
                        }, 20,
                        weight: FontWeight.w600,
                        insetsGeometrypadding: EdgeInsets.symmetric(
                            horizontal: FetchPixels.getPixelWidth(20),
                            vertical: FetchPixels.getPixelHeight(12)),
                        borderColor: blueColor,
                        borderWidth: 1.5,
                        isBorder: true,
                        borderRadius: BorderRadius.circular(
                            FetchPixels.getPixelHeight(10))),
                  ):SizedBox(
                    child: getButton(
                        context, Colors.green, "Add Bin", blueColor,
                            () {
                          // Constant.sendToNext(context, Routes.scanBinRoute);
                          scanQRCode();
                        }, 20,
                        weight: FontWeight.w600,
                        insetsGeometrypadding: EdgeInsets.symmetric(
                            horizontal: FetchPixels.getPixelWidth(20),
                            vertical: FetchPixels.getPixelHeight(10)),
                        borderColor: whiteColor,
                        borderWidth:0,
                        isBorder: true,
                        borderRadius: BorderRadius.circular(
                            FetchPixels.getPixelHeight(10))),
                  ),*/
                ],
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(50,0,0,0),
                    child: getButton(
                        context, Colors.orangeAccent, "Preview", blueColor,
                            () {
                          // Constant.sendToNext(context, Routes.scanBinRoute);
                          Constant.sendToNext(context, Routes.pickListPreviewScreenRoute,arguments:{"category":pickcategory,"pickId":pickListsMaster[0].pickId,"pickstatus":pickListsMaster[0].pickStatus,"preview":'view'},);

                        }, 20,

                        weight: FontWeight.w600,
                        insetsGeometrypadding: EdgeInsets.symmetric(
                            horizontal: FetchPixels.getPixelWidth(12),
                            vertical: FetchPixels.getPixelHeight(10)),
                        borderColor:Colors.transparent,
                        borderWidth: 0,
                        isBorder: true,
                        borderRadius: BorderRadius.circular(
                            FetchPixels.getPixelHeight(10))),
                  ),
                )
              ],
            ),

           // getVerSpace(FetchPixels.getPixelHeight(20)),
           // getDivider(dividerColor, 0, 1),
            //getVerSpace(FetchPixels.getPixelHeight(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    getHorSpace(FetchPixels.getPixelWidth(1)),
     /* SizedBox(
        child: getButton(
            context, Colors.blue, "Complete", Colors.white,
                () {

                    showDialog(
                        barrierDismissible: false,
                        builder: (context) {
                          return Dialog2(
                              pickListsDetails![index].pickId);
                        },
                        context: context);


            }, 25,
            weight: FontWeight.w600,
            insetsGeometrypadding: EdgeInsets.symmetric(
                horizontal: FetchPixels.getPixelWidth(20),
                vertical: FetchPixels.getPixelHeight(12)),
            borderColor: whiteColor,
            borderWidth:0,
            isBorder: true,
            borderRadius: BorderRadius.circular(
                FetchPixels.getPixelHeight(10))),
      ),*/

                  ],
                ),

              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _editTitleTextField(partno) {
    if (_isEditingText)
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            setState(() {
              initialText = newValue;
              _isEditingText = false;
            });
          },
          autofocus: true,
          controller: qtyController,
        ),
      );
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingText = true;
        });
      },
      child: Text(
        initialText,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
      ),
    );
  }

  @override
  Dialog(slno, pickid, pickqty) {
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
                            pickitemcofirm(slno, pickid, pickqty);
                            _isLoading = true;
                            setState(() {}); // Trigger a rebuild

                            pickdetaildata();
                            _reloadPage();
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

  Dialog1(slno, PickId) {
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
                  "Are you want to Cancel ", 22, Colors.black,
                  fontWeight: FontWeight.w900,
                  txtHeight: 1.2,
                  textAlign: TextAlign.center),
              getVerSpace(FetchPixels.getPixelHeight(31)),
              Row(
                children: [
                  Expanded(
                      child: getButton(context, Colors.red, "No", Colors.white,
                              () {
                            Constant.backToPrev(context);
                          }, 18,
                          weight: FontWeight.w600,
                          buttonHeight: FetchPixels.getPixelHeight(60),
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(14)),
                          borderColor: Colors.red,
                          isBorder: true,
                          borderWidth: 1.5)),
                  getHorSpace(FetchPixels.getPixelWidth(20)),
                  Expanded(
                      child: getButton(
                          context, Colors.green, "Yes", Colors.white, () {
                        pickitemcancel(slno, PickId);
                        _isLoading = true;
                        Constant.backToPrev(context);


                        // addressList.removeAt(selection!.getInt("index")!);
                        setState(() {});
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

  Dialog2(PickId) {
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
                  "Are you want to Complete? ", 22, Colors.black,
                  fontWeight: FontWeight.w900,
                  txtHeight: 1.2,
                  textAlign: TextAlign.center),
              getVerSpace(FetchPixels.getPixelHeight(31)),
              Row(
                children: [
                  Expanded(
                      child: getButton(context, Colors.red, "No", Colors.white,
                              () {

                            Constant.backToPrev(context);
                          }, 18,
                          weight: FontWeight.w600,
                          buttonHeight: FetchPixels.getPixelHeight(60),
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(14)),
                          borderColor: Colors.red,
                          isBorder: true,
                          borderWidth: 1.5)),
                  getHorSpace(FetchPixels.getPixelWidth(20)),
                  Expanded(
                      child: getButton(
                          context, Colors.green, "Yes", Colors.white, () {
                        completemasterpick(pickid);
                        pickdetaildata();
                        _isLoading = true;

                        Constant.backToPrev(context);
                       // pickdetaildata();
                       // completemasterpick();
                        // addressList.removeAt(selection!.getInt("index")!);
                        setState(() {});
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

  Widget buildToolbar(BuildContext context) {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(25)),
      gettoolbarMenu(context, "back.svg", () {
        Constant.backToPrev(context);
      },
          title: "Pick List Detail View-[$_empcode]" ?? "",
          fontsize: 25,
          weight: FontWeight.w900,
          textColor: Colors.black,
          istext: true),
    );
  }

  Future<void> scanQRCode() async {
    try {
      final qrCode1 = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (!mounted) return;
      SharedPreferences logindata = await SharedPreferences.getInstance();
      setState(() {
        print(qrCode1);
        this.qrCode = qrCode1;
        containerQR.text = qrCode;
        print(containerQR.text);
        if (containerQR.text.isNotEmpty && containerQR.text != '-1') {
          if (containerQR.text.isNotEmpty) {
            logindata.setString("binqrcode", qrCode);
            get_sessionData();
            //   loadContainerQR();
            //  Get.toNamed(Routes.scanLocationQR,arguments: {"container_no":get_container_no,
            //    "material_code":get_material_code,"put_id":get_put_id,"company_id":get_company_id,"warehouse_id":get_warehouse_id
            //  });
          }

          if (containerQR.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Container Code Wrong Try Again',
                textAlign: TextAlign.center,
              ),
              backgroundColor: appbarColor,
              elevation: 10,
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(15),
            ));
          }
          if (containerQR.text.isEmpty) {
            containerQR.clear();
            FlutterBeep.beep(false);
          }
          ;
        } else {
          containerQR.clear();
          FlutterBeep.beep(false);
        }
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version';
    }
  }

}


