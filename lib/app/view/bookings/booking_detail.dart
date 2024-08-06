import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:shared_preferences/shared_preferences.dart';


bool value = true;

class BookingDetail extends StatefulWidget {
  const BookingDetail({Key? key}) : super(key: key);

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  //TextEditingController qtyController = TextEditingController();
  //Future<String> _future;
  int _counter = 0;
  String pickdetails = Strings.apipath + "pickdetails_api.php";
  String comppickdetails = Strings.apipath + "completedpickdetails_api.php";
  String pickitemConfirm = Strings.apipath + "pickitem_confirm.php";
  String pickitemCancel = Strings.apipath + "pickitem_cancelled.php";

  static List<ModelItem> itemProductLists = DataFile.itemProductList;
  List<PickListMaster> pickListsMaster = [];
  List<PickListDetails> pickListsDetails = [];
  List<TextEditingController> _controller = [];

  bool _isEditingText = false;
  TextEditingController qtyController = TextEditingController();
  TextEditingController containerQR = TextEditingController();
  TextEditingController pickedDetails = TextEditingController();
  String initialText = "Qty";

  String? pickcategory;
  String? pickid;
  String? pickstatus;
  String? pckdQty;
  String? ConfirmStatus;
  var _isLoading = true;
  String qrCode = 'unknow';
  String _binqrcode = '';
  String _empcode = '';
  String _companyCode = '';
  String _comcode='';
  String _billtype='';

  dynamic currentTime = DateFormat.Hm().format(DateTime.now());
  var format = DateFormat("HH:mm");

  get_sessionData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      _binqrcode = (logindata.getString('binqrcode') ?? '');
      _comcode = (logindata.getString('comCode') ?? '');
      _billtype = (logindata.getString('billType') ?? '');

      _empcode = (logindata.getString('employeeCode')??'');
      _companyCode = (logindata.getString('companyId')??'');
      containerQR.text = _binqrcode;
      print(_companyCode);
    });
  }

  Future<void> pickdetaildata() async {
    final res = await http.post(Uri.parse(pickdetails), headers: {
      "Accept": "application/json"
    }, body: {
      "compCode": _comcode,
      "category": pickcategory,
      "pickid": pickid,
      "employeeCode": _empcode
    });
    if (res.statusCode == 200) {
      //   developer.log(res.body);
      setState(() {
        _isLoading = false;
        (_isLoading == false)
            ? print("true:${_isLoading}")
            : print("false:${_isLoading}");
      });
      print(json.decode(res.body));
      var data = json.decode(res.body);
      if (data["is_success"] == true) {
        try {
          final PickDetailView = pickDetailViewFromJson(res.body);
          pickListsMaster = PickDetailView.pickListMaster;
          pickListsDetails = PickDetailView.pickListDetails;
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
        setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
        });
      }
    }
  }

  Future<void> comppickdetaildata() async {
    final res = await http.post(Uri.parse(comppickdetails), headers: {
      "Accept": "application/json"
    }, body: {
      "compCode":  "MOTO",
      "category": pickcategory,
      "pickid": pickid,
      "employeeCode": _empcode
    });
    if (res.statusCode == 200) {
      //   developer.log(res.body);
      setState(() {
        _isLoading = false;
        (_isLoading == false)
            ? print("true:${_isLoading}")
            : print("false:${_isLoading}");
      });
      print(json.decode(res.body));
      var data = json.decode(res.body);
      if (data["is_success"] == true) {
        try {
          final PickDetailView = pickDetailViewFromJson(res.body);
          pickListsMaster = PickDetailView.pickListMaster;
          pickListsDetails = PickDetailView.pickListDetails;
        } catch (e) {
       /*   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
    print(_binqrcode);
    print(PickedQty);
    final res = await http.post(Uri.parse(pickitemConfirm),
        headers: {"Accept": "application/json"},
        body: {"slno": Slno,"pickid": pickID, "pickedQty": PickedQty, "binQR": _binqrcode});
    if (res.statusCode == 200) {
      //   developer.log(res.body);
      setState(() {
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
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(15),
          ));
          Constant.sendToNext(context, Routes.homeScreenRoute);
        }
        else {
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
      }else if (data["is_success"] == false) {
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
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(15),
          ));
          Constant.sendToNext(context, Routes.homeScreenRoute);
        }
        else{

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
          duration: const Duration(seconds: 3),
        ));
        setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
        });
      }
    }
  }

  @override
  void initState() {

    get_sessionData();
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        Map args = ModalRoute.of(context)?.settings.arguments as Map;
        pickcategory = args['category'];
        pickid = args['pickId'];
        pickstatus = args['pickstatus'];
        ConfirmStatus=args['Confirm'];
        print(pickcategory);
        print(pickid);
        print(pickstatus);
      //  if (pickstatus == 'Active')

          pickdetaildata();
       // else if (pickstatus == 'Completed' || pickstatus == 'Cancelled')
          comppickdetaildata();

      });

    });

    error = false;
    sending = false;
    success = false;
    msg = "";
    qtyController = TextEditingController(text: initialText);

    /*Timer(Duration(seconds: 2), () {
    /*  setState(() {
        _isLoading = false;
        (_isLoading == false) ?
        print("true:${_isLoading}") :
        print("false:${_isLoading}");
      });*/
    });*/
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
      body: (_isLoading == true)
          ? Center(child: SpinKitFoldingCube(color: Colors.blue))
          : _bodyWidget(context),
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
      scrollDirection: Axis.vertical,
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
          // buildTopWidget(edgeInsets, context),
          getVerSpace(FetchPixels.getPixelHeight(30)),
          // buildAboutCleaningWidget(defHorSpace),
          //buildBottomWidget(edgeInsets, context, defSpace)

          bookingList()

        ],
      ),
    );
  }

/*
  Container buildAboutCleaningWidget(double defHorSpace) {
    return Container(
      color: const Color(0xFFF2F4F8),
      padding: EdgeInsets.only(
          left: defHorSpace,
          right: defHorSpace,
          top: FetchPixels.getPixelHeight(20),
          bottom: FetchPixels.getPixelHeight(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: FetchPixels.getPixelHeight(52),
                width: FetchPixels.getPixelHeight(52),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(FetchPixels.getPixelHeight(35)),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0.0, 4.0)),
                  ],
                ),
                padding: EdgeInsets.all(FetchPixels.getPixelHeight(14)),
                child: getSvgImage("wallet.svg"),
              ),
              getHorSpace(FetchPixels.getPixelWidth(15)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getCustomFont("Know about cleaning", 16, Colors.black, 1,
                      fontWeight: FontWeight.w900),
                  getVerSpace(FetchPixels.getPixelHeight(4)),
                  getCustomFont(
                    "Cleaning Service Required",
                    16,
                    Colors.black,
                    1,
                    fontWeight: FontWeight.w400,
                  )
                ],
              )
            ],
          ),
          getSvgImage("arrow_right.svg")
        ],
      ),
    );
  }

 */

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

  Widget buildTopWidget(EdgeInsets edgeInsets, BuildContext context) {
    return getPaddingWidget(
      edgeInsets,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* getButtonWithIcon(
            context,
            Colors.white,
            "Assigning Pro",
            blueColor,
            () {},
            18,
            weight: FontWeight.w600,
            buttonHeight: FetchPixels.getPixelHeight(60),
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(12)),
            boxShadow: [
              const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0.0, 4.0)),
            ],
            sufixIcon: true,
            suffixImage: "arrow_right.svg",
          ),*/

          /* getCustomFont("About Your Service", 20, Colors.black, 1,
              fontWeight: FontWeight.w900),

          getVerSpace(FetchPixels.getPixelHeight(10)),
          getButtonWithIcon(
              context, Colors.white, "Fixstore Care", Colors.black, () {}, 16,
              weight: FontWeight.w900,
              buttonHeight: FetchPixels.getPixelHeight(72),
              borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(12)),
              boxShadow: [
                const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0.0, 4.0)),
              ],
              prefixIcon: true,
              prefixImage: "headset.svg",
              sufixIcon: true,
              suffixImage: "arrow_right.svg"),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          getButtonWithIcon(
              context, Colors.white, "UC Warrenty", Colors.black, () {}, 16,
              weight: FontWeight.w900,
              buttonHeight: FetchPixels.getPixelHeight(72),
              borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(12)),
              boxShadow: [
                const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0.0, 4.0)),
              ],
              prefixIcon: true,
              prefixImage: "safe.svg",
              sufixIcon: true,
              suffixImage: "arrow_right.svg"),
          getVerSpace(FetchPixels.getPixelHeight(20)),
          getButtonWithIcon(context, Colors.white, "Standard Rate Card",
              Colors.black, () {}, 16,
              weight: FontWeight.w900,
              buttonHeight: FetchPixels.getPixelHeight(72),
              borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(12)),
              boxShadow: [
                const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0.0, 4.0)),
              ],
              prefixIcon: true,
              prefixImage: "starts.svg",
              sufixIcon: true,
              suffixImage: "arrow_right.svg"),*/
        ],
      ),
    );
  }

  Column packageDescription(ModelItem modelItem) {
    double horSpace = FetchPixels.getDefaultHorSpace(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getCustomFont(
          modelItem.name ?? '',
          24,
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
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: FetchPixels.getPixelHeight(0)),
      shrinkWrap: true,
      primary: true,
      itemCount: pickListsDetails.length,
      itemBuilder: (context, index) {
       // ModelItem modelItem = pickListsDetails![index];
       /* return Column(
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
                child:  Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                            Row(children: [
                              new InkWell(
                                onTap: () {
                                  //Navigator.pushNamed(context, Routes.scanPartScreenRoute,arguments:{"PartNo":pickListsDetails![index].partno,"PickId":pickListsDetails![index].pickId}, );
                                  Constant.sendToNext(
                                      context, Routes.scanPartScreenRoute,
                                      arguments: {
                                        "PartNo":
                                            pickListsDetails![index].partno,
                                        "pickId":
                                            pickListsDetails![index].pickId,
                                        "category": pickcategory,
                                        "pickstatus":
                                            pickListsDetails[index].pickStatus
                                      });
                                },
                                child: new Padding(

                                  padding: new EdgeInsets.all(10.0),
                                  child: new Expanded(

                                    flex: 1,
                                    child: getCustomFont(
                                        pickListsDetails![index].partno,
                                        18,
                                        Colors.black,
                                        1,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
                              getHorSpace(FetchPixels.getPixelWidth(80)),
                              GestureDetector(
                                  child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/cart.png"),
                                        ),
                                      )),
                                  onTap: () {
                                    showDialog(
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return Dialog(
                                              pickListsDetails![index].slno,
                                              pickListsDetails![index].pickId,
                                              pckdQty);
                                        },
                                        context: context);
                                  }),
                              getHorSpace(FetchPixels.getPixelWidth(10)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  getCustomFont(
                                    pickListsDetails![index].pickedQty +
                                        "/" +
                                        pickListsDetails![index].quantity,
                                    18,
                                    Colors.black,
                                    2,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ]),

                          getVerSpace(FetchPixels.getPixelHeight(6)),
                          getCustomFont(pickListsDetails![index].partname ?? "",
                              18, textColor, 1,
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
                                            "Date",
                                            18,
                                            Colors.black,
                                            1,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      getVerSpace(
                                          FetchPixels.getPixelHeight(4)),
                                      Align(
                                          alignment: Alignment.topCenter,
                                          child: getCustomFont(
                                              pickListsDetails![index]
                                                  .pickedDate
                                                  .toString(),
                                              18,
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
                                            "Time",
                                            18,
                                            Colors.black,
                                            1,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      getVerSpace(
                                          FetchPixels.getPixelHeight(4)),
                                      Align(
                                          alignment: Alignment.topCenter,
                                          child: getCustomFont(
                                              pickListsDetails![index]
                                                  .pickedTime,
                                              18,
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
                                            "Status",
                                            18,
                                            Colors.black,
                                            1,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      getVerSpace(
                                          FetchPixels.getPixelHeight(4)),
                                      Align(
                                          alignment: Alignment.topCenter,
                                          child: (pickListsDetails![index].pickStatus == "Active")
                                              ? getCustomFont(
                                                  pickListsDetails![index].pickStatus, 14, Colors.blue, 1,
                                                  fontWeight: FontWeight.w400)
                                              : ((pickListsDetails![index].pickStatus ==
                                                      "Cancelled")
                                                  ? getCustomFont(
                                                      pickListsDetails![index]
                                                          .pickStatus,
                                              18,
                                                      Colors.redAccent,
                                                      1,
                                                      fontWeight:
                                                          FontWeight.w400)
                                                  : getCustomFont(
                                                      pickListsDetails![index].pickStatus,
                                              18,
                                                      Colors.green,
                                                      1,
                                                      fontWeight: FontWeight.w400)))
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ]

                      )),
          ],
        );*/
       return Column(
          children: [
            //  dateHeader(modelItem, index),
            // getVerSpace(FetchPixels.getPixelHeight(5)),

            Container(
                margin: EdgeInsets.only(
                    bottom: FetchPixels.getPixelHeight(5),
                    left: FetchPixels.getDefaultHorSpace(context),
                    right: FetchPixels.getDefaultHorSpace(context)),

                decoration: BoxDecoration(

                    color:Colors.white,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          new InkWell(
                            onTap: () {
                              //Navigator.pushNamed(context, Routes.scanPartScreenRoute,arguments:{"PartNo":pickListsDetails![index].partno,"PickId":pickListsDetails![index].pickId}, );

                              /*Constant.sendToNext(
                                  context, Routes.scanPartScreenRoute,
                                  arguments: {
                                    "serialNO": pickListsDetails![index].slno,
                                    "PartNo": pickListsDetails![index].partno,
                                    "pickId": pickListsDetails![index].pickId,
                                    "category": pickcategory,
                                    "pickstatus": pickListsDetails[index].pickStatus
                                  });*/
                            },
                            child: new Padding(
                              padding: new EdgeInsets.all(10.0),
                              child: Container(
                                width: 180,
                                child: new Expanded(
                                  flex: 1,
                                  child: getCustomFont(
                                      pickListsDetails[index].partno,
                                      18,
                                      Colors.black,
                                      2,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ),
                          getHorSpace(FetchPixels.getPixelWidth(50)),
                          Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/cart.png"),
                                ),
                              )),

                          getHorSpace(FetchPixels.getPixelWidth(100)),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getCustomFont(
                                pickListsDetails[index].pickedQty +
                                    "/" +
                                    pickListsDetails[index].quantity,
                                18,
                                Colors.black,
                                2,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
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

                     /*     GestureDetector(
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
                                          pickListsDetails![index].slno,
                                          pickListsDetails![index].pickId);
                                    },
                                    context: context);
                              }),*/
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
                                    "Time",
                                    13,
                                    Colors.black,
                                    1,
                                    fontWeight: FontWeight.w800,
                                  )),
                              getVerSpace(FetchPixels.getPixelHeight(4)),
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: getCustomFont(
                                      pickListsDetails[index].pickedTime,
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
                                    "Picked Rate",
                                    13,
                                    Colors.black,
                                    1,
                                    fontWeight: FontWeight.w800,
                                  )),
                              getVerSpace(FetchPixels.getPixelHeight(4)),
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: getCustomFont(
                                      pickListsDetails[index].pickedRate,
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
                                    "Status",
                                    13,
                                    Colors.black,
                                    1,
                                    fontWeight: FontWeight.w800,
                                  )),
                              getVerSpace(FetchPixels.getPixelHeight(4)),
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: (pickListsDetails[index].pickStatus == "Active")
                                      ? getCustomFont(
                                      pickListsDetails[index].pickStatus, 14, Colors.blue, 1,
                                      fontWeight: FontWeight.w400)
                                      : ((pickListsDetails[index].pickStatus ==
                                      "Cancelled")
                                      ? getCustomFont(
                                      pickListsDetails[index]
                                          .pickStatus,
                                      14,
                                      Colors.redAccent,
                                      1,
                                      fontWeight:
                                      FontWeight.w400)
                                      : getCustomFont(
                                      pickListsDetails[index].pickStatus,
                                      14,
                                      Colors.green,
                                      1,
                                      fontWeight: FontWeight.w400)))
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
  }

  Column addButton(ModelItem modelItem, BuildContext context, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
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
        getVerSpace(FetchPixels.getPixelHeight(40)),
        getCustomFont("\u20B9${modelItem.price}", 16, blueColor, 1,
            fontWeight: FontWeight.w900),
      ],
    );
  }

  Widget buildTopContainer(BuildContext context, EdgeInsets edgeInsets) {
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
                Row(
                  children: [
                    getCustomFont(
                      "#" + pickListsMaster[0].pickId,
                      16,
                      blueColor,
                      1,
                      fontWeight: FontWeight.w600,
                    )
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    getCustomFont(
                      pickListsMaster[0].custname,
                      16,
                      blueColor,
                      1,
                      fontWeight: FontWeight.w600,
                    )
                  ],
                ),
                getCustomFont(
                    pickListsMaster[0].pickitemCompletedQty +
                        "/" +
                        pickListsMaster[0].totalItemCount,
                    20,
                    textColor,
                    1,
                    fontWeight: FontWeight.w900),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: getCustomFont(pickListsMaster[0].totalAmt,
                      16, blueColor, 1,
                      fontWeight: FontWeight.w600),
                ),

              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: getCustomFont(pickListsMaster[0].pickCompletedDate,
                      16, textColor, 1,
                      fontWeight: FontWeight.w400),
                ),
                Wrap(
                  children: [
                    getButton(
                        context,
                        Colors.green,
                        pickListsMaster[0].pickStatus ?? "",
                        Colors.black,
                            () {},
                        16,
                        weight: FontWeight.w600,
                        borderRadius:
                        BorderRadius.circular(FetchPixels.getPixelHeight(12)),
                        insetsGeometrypadding: EdgeInsets.symmetric(
                            vertical: FetchPixels.getPixelHeight(6),
                            horizontal: FetchPixels.getPixelWidth(12)))
                  ],
                )
              ],
            ),
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
                  "Are you Confirm the Pick Item?" + slno, 22, Colors.black,
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
                    pickdetaildata();

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
      EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
      gettoolbarMenu(context, "back.svg", () {
        Constant.backToPrev(context);
      },
          title: "Pick List Detail View" ?? "",
          fontsize: 24,
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
              duration: const Duration(seconds: 3),
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
