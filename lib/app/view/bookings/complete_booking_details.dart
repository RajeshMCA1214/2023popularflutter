import 'dart:convert';
import 'dart:async';
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
import 'package:shared_preferences/shared_preferences.dart';

bool value=true;

class CompleteBookingDetails extends StatefulWidget {
  const CompleteBookingDetails({Key? key}) : super(key: key);

  @override
  State<CompleteBookingDetails> createState() => _CompleteBookingDetails();
}

class _CompleteBookingDetails extends State<CompleteBookingDetails> {
  //TextEditingController qtyController = TextEditingController();
  //Future<String> _future;
  static const IconData edit = IconData(0xe21a, fontFamily: 'MaterialIcons');
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
  TextEditingController containerQR=TextEditingController();
  TextEditingController pickedDetails = TextEditingController();
  String initialText = "Qty";

  String? pickcategory;
  String? pickid;
  String? pickstatus;
  var _isLoading = true;
  String qrCode='unknow';
  String _binqrcode='';
  String _empcode='';
  String _comcode='';
  String _billtype='';



  dynamic currentTime = DateFormat.Hm().format(DateTime.now());
  var format = DateFormat("HH:mm");

  get_sessionData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      _binqrcode = (logindata.getString('binqrcode')??'');
      _empcode = (logindata.getString('employeeCode')??'');
      _comcode = (logindata.getString('comCode') ?? '');
      _billtype = (logindata.getString('billType') ?? '');

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
        (_isLoading== false)?
        print("true:${_isLoading}"):
        print("false:${_isLoading}");
      });
      print(json.decode(res.body));
      var data = json.decode(res.body);
      if (data["is_success"] == true) {
        try {
          final PickDetailView = pickDetailViewFromJson(res.body);
          pickListsMaster = PickDetailView.pickListMaster;
          pickListsDetails = PickDetailView.pickListDetails;
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
      "compCode": _comcode,
      "category": pickcategory,
      "pickid": pickid,
      "employeeCode": _empcode
    });
    if (res.statusCode == 200) {
      //   developer.log(res.body);
      setState(() {
        _isLoading = false;
        (_isLoading== false)?
        print("true:${_isLoading}"):
        print("false:${_isLoading}");
      });
      print(json.decode(res.body));
      var data = json.decode(res.body);
      if (data["is_success"] == true) {
        try {
          final PickDetailView = pickDetailViewFromJson(res.body);
          pickListsMaster = PickDetailView.pickListMaster;
          pickListsDetails = PickDetailView.pickListDetails;
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
        setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
        });
      }
    }
  }
  Future<void> pickitemcofirm(Slno) async {
    final res = await http.post(Uri.parse(pickitemConfirm), headers: {
      "Accept": "application/json"
    }, body: {
      "slno": Slno
    });
    if (res.statusCode == 200) {
      //   developer.log(res.body);
      setState(() {
        _isLoading = false;
        (_isLoading== false)?
        print("true:${_isLoading}"):
        print("false:${_isLoading}");
      });
      print(json.decode(res.body));
      var data = json.decode(res.body);
      if (data["is_success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar
          (
          content: Text(data["messages"], textAlign: TextAlign.center,),
          backgroundColor: appbarColor,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
        )
        );

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
        setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
        });
      }
    }
  }
  Future<void> pickitemcancel(Slno,PickId) async {
    print(PickId);
    print(Slno);
    final res = await http.post(Uri.parse(pickitemCancel), headers: {
      "Accept": "application/json"
    }, body: {
      "slno": Slno,
      "pickid":PickId
    });
    if (res.statusCode == 200) {
      //   developer.log(res.body);
      setState(() {
        _isLoading = false;
        (_isLoading== false)?
        print("true:${_isLoading}"):
        print("false:${_isLoading}");
      });
      print(json.decode(res.body));
      var data = json.decode(res.body);
      if (data["is_success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar
          (
          content: Text(data["messages"], textAlign: TextAlign.center,),
          backgroundColor: appbarColor,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
        )
        );
      } else if (data["is_success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar
          (
          content: Text(data["messages"], textAlign: TextAlign.center,),
          backgroundColor: appbarColor,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
          duration: const Duration(seconds: 3),
        )
        );
        setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
        });
      }
    }
  }

  @override
  void initState()  {
    get_sessionData();
    super.initState();
    Future.delayed(Duration.zero, () {
      setState((){
        Map args = ModalRoute
            .of(context)
            ?.settings
            .arguments as Map;
        pickcategory = args['category'];
        pickid = args['pickId'];
        pickstatus = args['pickstatus'];
        print(pickcategory);
        print(pickid);
        print(pickstatus);
        print("welcome detatils screen");

      });
      if(pickstatus=='Active')
        pickdetaildata();
      else if(pickstatus=='Completed' || pickstatus=='Cancelled' )
        comppickdetaildata();
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
  Widget build(BuildContext context) {

    FetchPixels(context);
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: (_isLoading == true) ? Center(child:SpinKitFoldingCube(color: Colors.blue)) : _bodyWidget(context),);
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
                buildBottomExpand(context, edgeInsets, defHorSpace,defSpace),
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

  ListView buildPage(EdgeInsets edgeInsets, BuildContext context, int index,
      double defSpace) {
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
              borderRadius: BorderRadius.circular(
                  FetchPixels.getPixelHeight(12))),
          child: Row(
            children: [
              //packageImage(context, modelSalon),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                      left: FetchPixels.getPixelWidth(16)),

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


          (containerQR.text.isNotEmpty) ? bookingList() : getSvgImage(
              "qr-code-svgrepo-com (1).svg",
              width: FetchPixels.getPixelHeight(300),
              height: FetchPixels.getPixelHeight(400)),

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

  Widget buildBottomWidget(EdgeInsets edgeInsets, BuildContext context, double defSpace) {
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

                  ],
                  borderRadius: BorderRadius.circular(
                      FetchPixels.getPixelHeight(12))),
              child: Row(
                children: [
                  //packageImage(context, modelItem),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: FetchPixels.getPixelWidth(16)),
                    
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


 Widget bookingList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: FetchPixels.getPixelHeight(0)),
      shrinkWrap: true,
      primary: true,
      itemCount: pickListsDetails.length,
      itemBuilder: (context, index) {
        //ModelItem modelItem = itemProductLists[index];
        return Column(
          children: [


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

                  Row(
                      children: [

                        new InkWell(

                          onTap: () {
                            //Navigator.pushNamed(context, Routes.scanPartScreenRoute,arguments:{"PartNo":pickListsDetails![index].partno,"PickId":pickListsDetails![index].pickId}, );

                              Constant.sendToNext(context, Routes.scanPartScreenRoute,arguments:{"PartNo":pickListsDetails[index].partno,"pickId":pickListsDetails[index].pickId,"category":pickcategory,"pickstatus":pickListsDetails[index].pickStatus});



                              },
                          child: new Padding(
                            padding: new EdgeInsets.all(10.0),

                            child: new Expanded(
                              flex: 1,
                              child:  getCustomFont(pickListsDetails[index].partno,
                                  16, Colors.black, 1,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                        getHorSpace(FetchPixels.getPixelWidth(150)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: [


                            getCustomFont(
                              pickListsDetails[index].pickedQty +"/"+ pickListsMaster[0].totalItemCount,
                              26,
                              Colors.black,
                              2,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,

                            ),
      ]
                        ),


                      ] ),
                  getVerSpace(FetchPixels.getPixelHeight(6)),
                  getCustomFont(pickListsDetails[index].partname ?? "", 14, textColor, 1,
                      fontWeight: FontWeight.w400),


                  //here

                ],
              ),


            ),


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
                      pickListsMaster[0].custname,
                      20,
                      blueColor,
                      1,
                      fontWeight: FontWeight.w600,
                    )
                  ],
                ),
                getCustomFont(pickListsMaster[0].pickitemCompletedQty+"/"+pickListsMaster[0].totalItemCount, 28, textColor, 1,
                    fontWeight: FontWeight.w900),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: getCustomFont(pickListsMaster[0].billdate.toString(), 14, textColor, 1,
                      fontWeight: FontWeight.w400),
                ),


              ],
            ),

            getVerSpace(FetchPixels.getPixelHeight(20)),
            getDivider(dividerColor, 0, 1),
            getVerSpace(FetchPixels.getPixelHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    getHorSpace(FetchPixels.getPixelWidth(9)),
                    getCustomFont(pickListsMaster[0].totalAmt, 16, blueColor, 1,
                        fontWeight: FontWeight.w900),

                  ],
                ),

              ],
            )
          ],
        ),
      ),
    );
  }


  @override
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


}