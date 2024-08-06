import 'package:home_service_provider/app/data/data_file.dart';
import 'package:home_service_provider/app/models/model_category.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_service_provider/app/models/model_popular_service.dart';
import 'package:home_service_provider/app/routes/app_routes.dart';
import 'package:home_service_provider/base/color_data.dart';
import 'package:home_service_provider/base/constant.dart';
import 'package:home_service_provider/base/pref_data.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:home_service_provider/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../apiclass/HomePage.dart';
import '../../../utils/strings.dart';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:developer' as developer;

class TabHome extends StatefulWidget {
  const TabHome({Key? key}) : super(key: key);

  @override
  State<TabHome> createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> {
  TextEditingController searchController = TextEditingController();
  dynamic CourierCnt ='';
  dynamic LocalCnt ='';
  dynamic OutstationCnt ='';
  dynamic TownCnt ='';
  dynamic SplCnt ='';
  dynamic picked ='';
  dynamic splbooking ='';
  dynamic all ='';

  static List<ModelCategory> categoryLists = [
    ModelCategory("location-map.svg", "ROUTE","f"),
    ModelCategory("truck.svg", "BOOKING","5")
  ];
  static List<ModelCategory> categoryLists2 = [
    ModelCategory("delivery-motorbike.svg", "PRO COURIER","10"),
    ModelCategory("town.svg", "TOWN","12"),
  ];
  static List<ModelCategory> categoryLists3 = [
    ModelCategory("map8.svg", "SPECIAL ROUTE","10"),
    ModelCategory("town.svg", "TOWN","12"),
  ];

  static List<ModelCategory> categoryLists4 = [
    ModelCategory("spacialbooking.svg", "SPECIAL BOOKING","10"),
    ModelCategory("all.svg", "ALL","12"),
  ];
  /*static List<ModelCategory> categoryLists = DataFile.categoryList;
  static List<ModelCategory> categoryLists2 = DataFile.categoryList2;*/
  List<ModelPopularService> popularServiceLists = DataFile.popularServiceList;
  List<Active> active=[];

  ValueNotifier selectedPage = ValueNotifier(0);
  final _controller = PageController();
  var _isLoading = true;
  String _empcode='';
  String _username='';
  String _comcode='';
  String _billtype='';

  late var data;
  String homepageurl = Strings.apipath+"homePage_api.php";
  get_sessionData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      _empcode = (logindata.getString('employeeCode') ?? '');
      _username = (logindata.getString('userName') ?? '');
      _comcode = (logindata.getString('comCode') ?? '');
      _billtype = (logindata.getString('billType') ?? '');

      print(_empcode);
      print(_username);
      print(_comcode);
      print(_billtype);

    });
  }

  Future<void> homepageData() async {
    print('hi');
    print(_comcode);
    print(_billtype);
    final res = await http.post(Uri.parse(homepageurl), headers: {
      "Accept": "application/json"
    }, body: {
      "compCode": _comcode,
      "bill_type":_billtype,
      "employeeCode": _empcode
    });
    developer.log(res.body);
    if (res.statusCode == 200) {
         developer.log(res.body);

      print(json.decode(res.body));
      var data = json.decode(res.body);

      if (data["is_success"] == true) {
        try {
          final HomePage = homePageFromJson(res.body);
          active = HomePage.active;
          CourierCnt=HomePage.courier;
          LocalCnt=HomePage.local;
          OutstationCnt=HomePage.outstation;
          TownCnt=HomePage.town;
          SplCnt=HomePage.special;
          picked=HomePage.pickedcount;
          splbooking=HomePage.SpecialBooking;
          all=HomePage.ALL;


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

  dynamic currentTime = DateFormat.Hm().format(DateTime.now());
  var format = DateFormat("HH:mm");

  @override
  void initState() {
    get_sessionData();
    super.initState();
    get_sessionData();
    Timer(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        (_isLoading== false)?
        print("true:${_isLoading}"):
        print("false:${_isLoading}");
      });
    });
    //homepageData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //double horSpace = FetchPixels.getDefaultHorSpace(context);
    homepageData();
    return Scaffold(
      body:active.isEmpty ? Center(child:SpinKitFadingCircle(
      color: Colors.indigo,
      size: 50.0,
    )):_bodyWidget(context),);

  }

       /* getVerSpace(FetchPixels.getPixelHeight(32)),
        getPaddingWidget(
            EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
            getSearchWidget(context, searchController, () {
              Constant.sendToNext(context, Routes.searchRoute);
            }, (value) {})),*/

 _bodyWidget(BuildContext context) {
   double horSpace = FetchPixels.getDefaultHorSpace(context);
    return Column(
       children: [
       getVerSpace(FetchPixels.getPixelHeight(21)),
       getPaddingWidget(
       EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
       Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
       getSvgImage(
       "menu.svg",
       ),
       Row(
       children: [
       getHorSpace(FetchPixels.getPixelWidth(4)),
       getCustomFont(
        "Welcome ! "+_username+_billtype,
       23,
       Colors.black,
       1,
       fontWeight: FontWeight.w400,
       ),
         getHorSpace(FetchPixels.getPixelWidth(4)),
         GestureDetector(
             onTap: () {


              Constant.sendToNext(context, Routes.profileRoute,arguments:{

                "employeeCode": _empcode},);
             },

              child: getSvgImage("user.svg"),

             ),
       ],
       ),
     /*  GestureDetector(
       onTap: () {
    Constant.sendToNext(context, Routes.notificationRoutes);
    },
    child: getSvgImage(
    "notification.svg",
    ),
    ),*/
    ],
    ),
    ),
        getVerSpace(FetchPixels.getPixelHeight(20)),
        Expanded(
          flex: 1,
          child: ListView(
            primary: true,
            shrinkWrap: true,
            children: [
              pageView(),
              getVerSpace(FetchPixels.getPixelHeight(24)),
              getPaddingWidget(
                EdgeInsets.symmetric(horizontal: horSpace),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getCustomFont("Categories", 25, Colors.black, 1,
                        fontWeight: FontWeight.w900),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: getCustomFont("Picked Count:$picked", 25, Colors.black, 1,
                          fontWeight: FontWeight.w900),
                    ),
             /*  GestureDetector(
                      onTap: () {
                        Constant.sendToNext(context, Routes.categoryRoute);
                      },
                      child: getCustomFont(
                        "Active:=>",
                        14,
                        blueColor,
                        1,
                        fontWeight: FontWeight.w600,

                      ),
                    )*/
                  ],
                ),
              ),
              getVerSpace(FetchPixels.getPixelHeight(16)),

              SizedBox(
                height: FetchPixels.getPixelHeight(215),
                child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    ModelCategory modelCategory = categoryLists[index];
                    return GestureDetector(
                      onTap: () {
                        if(index == 0) {
                          PrefData.setDefIndex(1);
                          Constant.sendToNext(context,
                            Routes.localPickScreenRoute, arguments:{"category":"ROUTE"},);
                        }
                        if(index == 1) {
                          PrefData.setDefIndex(1);
                          Constant.sendToNext(context,
                            Routes.localPickScreenRoute, arguments:{"category":"BOOKING"},);
                          //  Routes.outStationPickScreenRoute, arguments:{"category":"Outstation"},);
                        }

                      },
                      child: Container(
                        width: FetchPixels.getPixelWidth(177),
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
                            left: (index % 2 == 0) ? horSpace : 0,
                            bottom: FetchPixels.getPixelHeight(24),
                            right: FetchPixels.getPixelWidth(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getSvgImage(modelCategory.image ?? "",
                                width: FetchPixels.getPixelHeight(124),
                                height: FetchPixels.getPixelHeight(114)),
                            getVerSpace(FetchPixels.getPixelHeight(10)),
                            if( modelCategory.name=='ROUTE')
                            getCustomFont(

                                modelCategory.name! +" - "+ LocalCnt!+"" , 18, Colors.black, 1,
                                fontWeight: FontWeight.w600),
                            if( modelCategory.name=='BOOKING')
                            getCustomFont(
                                modelCategory.name! +" - "+ OutstationCnt!+"" , 18, Colors.black, 1,
                                fontWeight: FontWeight.w600),


                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: FetchPixels.getPixelHeight(215),
                child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    ModelCategory modelCategory = categoryLists2[index];
                    return GestureDetector(
                      onTap: () {
                        if(index == 0) {
                          PrefData.setDefIndex(1);
                          Constant.sendToNext(context,
                            Routes.localPickScreenRoute,arguments:{"category":"PRO COURIER"},);
                        }
                        if(index == 1) {
                          PrefData.setDefIndex(1);
                          Constant.sendToNext(context,
                            Routes.localPickScreenRoute, arguments:{"category":"TOWN BOOKING"},);
                        }

                      },
                      child: Container(
                        width: FetchPixels.getPixelWidth(177),
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
                            left: (index % 2 == 0) ? horSpace : 0,
                            bottom: FetchPixels.getPixelHeight(24),
                            right: FetchPixels.getPixelWidth(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [

                            getSvgImage(modelCategory.image ?? "",
                                width: FetchPixels.getPixelHeight(124),
                                height: FetchPixels.getPixelHeight(114)),
                            getVerSpace(FetchPixels.getPixelHeight(10)),
                            if(modelCategory.name=='PRO COURIER')
                            getCustomFont(
                                "COURIER/DIRECT" +" - "+ CourierCnt!+"", 18, Colors.black, 2,fontWeight: FontWeight.w600),
                            if(modelCategory.name=='TOWN')
                            getCustomFont(
                                modelCategory.name! +" - "+ TownCnt!+"", 18, Colors.black, 1,
                                fontWeight: FontWeight.w600),


                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
             // if(_comcode=='HOND'&& _billtype=='HEAD')
              SizedBox(
                height: FetchPixels.getPixelHeight(215),
                child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    ModelCategory modelCategory = categoryLists4[index];
                    return GestureDetector(
                      onTap: () {
                        if(index == 0) {
                          PrefData.setDefIndex(1);
                          Constant.sendToNext(context,
                            Routes.localPickScreenRoute,arguments:{"category":"SPL BOOKING"},);
                        }
                        if(index == 1) {
                          PrefData.setDefIndex(1);
                          Constant.sendToNext(context,
                            Routes.localPickScreenRoute, arguments:{"category":"ALL ROUTE"},);
                        }

                      },
                      child: Container(
                        width: FetchPixels.getPixelWidth(177),
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
                            left: (index % 2 == 0) ? horSpace : 0,
                            bottom: FetchPixels.getPixelHeight(24),
                            right: FetchPixels.getPixelWidth(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [

                            getSvgImage(modelCategory.image ?? "",
                                width: FetchPixels.getPixelHeight(124),
                                height: FetchPixels.getPixelHeight(114)),
                            getVerSpace(FetchPixels.getPixelHeight(10)),
                            if(modelCategory.name=='SPECIAL BOOKING')
                              getCustomFont(
                                  "SPECIAL BOOKING" +" - "+splbooking!+"", 18, Colors.black, 2,fontWeight: FontWeight.w600),
                            if(modelCategory.name=='ALL')
                              getCustomFont(
                                  modelCategory.name! +" - "+ all!+"", 18, Colors.black, 1,
                                  fontWeight: FontWeight.w600),


                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: FetchPixels.getPixelHeight(215),
                child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    ModelCategory modelCategory = categoryLists3[index];
                    return GestureDetector(
                      onTap: () {
                        if(index == 0) {
                          PrefData.setDefIndex(1);
                          Constant.sendToNext(context,
                            Routes.localPickScreenRoute,arguments:{"category":"SPL ROUTE"},);
                        }
                        if(index == 1) {
                          PrefData.setDefIndex(1);
                          Constant.sendToNext(context,
                            Routes.localPickScreenRoute, arguments:{"category":"TOWN BOOKING"},);
                        }

                      },
                      child: Container(
                        width: FetchPixels.getPixelWidth(177),
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
                            left: (index % 2 == 0) ? horSpace : 0,
                            bottom: FetchPixels.getPixelHeight(24),
                            right: FetchPixels.getPixelWidth(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [

                            getSvgImage(modelCategory.image ?? "",
                                width: FetchPixels.getPixelHeight(124),
                                height: FetchPixels.getPixelHeight(114)),
                            getVerSpace(FetchPixels.getPixelHeight(10)),
                            if(modelCategory.name=='SPECIAL ROUTE')
                              getCustomFont(
                                  "SPECIAL ROUTE" +" - "+ SplCnt!+"", 18, Colors.black, 2,fontWeight: FontWeight.w600),
                            /* if(modelCategory.name=='TOWN')
                              getCustomFont(
                                  modelCategory.name! +" - "+ TownCnt!+"", 18, Colors.black, 1,
                                  fontWeight: FontWeight.w600),*/


                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        )
      ],
    );

  }

  Column pageView() {
    return Column(
      children: [
        SizedBox(
          height: FetchPixels.getPixelHeight(184),
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (value) {
              selectedPage.value = value;
            },
            itemCount: 1,
            itemBuilder: (context, index) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: FetchPixels.getPixelWidth(374),
                    decoration: BoxDecoration(
                        color: const Color(0xFFD0DDFF),
                        borderRadius: BorderRadius.circular(
                            FetchPixels.getPixelHeight(20)),
                        image: getDecorationAssetImage(context, "maskgroup.png",
                            fit: BoxFit.fill)),
                    alignment: Alignment.center,
                  ),
                  Positioned(
                      child: SizedBox(
                    height: FetchPixels.getPixelHeight(180),
                    width: FetchPixels.getPixelWidth(374),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getPaddingWidget(
                          EdgeInsets.only(
                              left: FetchPixels.getPixelWidth(20),
                              top: FetchPixels.getPixelHeight(20),
                              bottom: FetchPixels.getPixelHeight(20)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(active[index].pickCategory!='')...[




              GestureDetector(
              onTap: () {

              Constant.sendToNext(context, Routes.bookingRoute,arguments:{
                "category":active[index].pickCategory,
              "pickId":active[index].pickId,
              "pickstatus":active[index].pickStatus},);
              },
                                child: SizedBox(
                                    width: FetchPixels.getPixelHeight(100),
                                    child: getMultilineCustomFont(
                                       "Active Pick List In⤵",18, Colors.black,
                                        fontWeight: FontWeight.w400,
                                        txtHeight: 1.3)),
                              ),
                              // getVerSpace(FetchPixels.getPixelHeight(6)),
                              AnimatedTextKit(
                                animatedTexts: [

                                  WavyAnimatedText(active[0].pickCategory,
                                      textStyle: TextStyle(
                                          letterSpacing: 3,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red)),

                                ],
                                isRepeatingAnimation: true,
                                totalRepeatCount: 10,
                                pause: Duration(milliseconds: 1000),
                              ),
                              ]
                              else...[
                                SizedBox(
                                    width: FetchPixels.getPixelHeight(100),
                                    child: getMultilineCustomFont(
                                        "Pick List Not Assigned",23, Colors.black,
                                        fontWeight: FontWeight.w400,
                                        txtHeight: 1.3)),
                                // getVerSpace(FetchPixels.getPixelHeight(6)),

                              ],

                              getCustomFont(
                                "Make your Warehouse Easy",
                                20,
                                Colors.black,
                                1,
                                fontWeight: FontWeight.w400,
                              ),
                              // getVerSpace(FetchPixels.getPixelHeight(16)),
                            /*  getButton(context, blueColor, "Book Now",
                                  Colors.white, () {}, 14,
                                  weight: FontWeight.w600,
                                  buttonWidth: FetchPixels.getPixelWidth(108),
                                  borderRadius: BorderRadius.circular(
                                      FetchPixels.getPixelHeight(12)),
                                  insetsGeometrypadding: EdgeInsets.symmetric(
                                      vertical:
                                          FetchPixels.getPixelHeight(12))),*/
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end, // Adjust the alignment as needed
                          children: [
                          if(_billtype=='PTVS')...[
                            Container(
                              margin: EdgeInsets.only(right: FetchPixels.getPixelWidth(51)),
                              color: Colors.transparent,
                              child:  getAssetImage(
                                "tvs_logo.png",
                                FetchPixels.getPixelHeight(170),
                                FetchPixels.getPixelHeight(188),
                              ),
                            ),]
                            else if(_billtype=='HEAD')...[
                            Container(
                              margin: EdgeInsets.only(right: FetchPixels.getPixelWidth(51)),
                              color: Colors.transparent,
                              child:  getAssetImage(
                                "logo-honda.png",
                                FetchPixels.getPixelHeight(170),
                                FetchPixels.getPixelHeight(188),
                              ),
                            ),
                          ]

                          else if(_billtype=='ROYL')...[
                              Container(
                                margin: EdgeInsets.only(right: FetchPixels.getPixelWidth(51)),
                                color: Colors.transparent,
                                child:  getAssetImage(
                                  "pop.png",
                                  FetchPixels.getPixelHeight(170),
                                  FetchPixels.getPixelHeight(188),
                                ),
                              ),
                            ]

                            else if(_billtype=='NINK')...[
                                Container(
                                  margin: EdgeInsets.only(right: FetchPixels.getPixelWidth(51)),
                                  color: Colors.transparent,
                                  child:  getAssetImage(
                                    "Ninki.png",
                                    FetchPixels.getPixelHeight(170),
                                    FetchPixels.getPixelHeight(188),
                                  ),
                                ),
                              ]
                                else if(_billtype=='YAMA')...[
              Container(
              margin: EdgeInsets.only(right: FetchPixels.getPixelWidth(51)),
              color: Colors.transparent,
              child:  getAssetImage(
              "YAMA.png",
              FetchPixels.getPixelHeight(170),
              FetchPixels.getPixelHeight(188),
              ),
              ),
              ]
                                else if(_billtype=='MOTO')...[
                                    Container(
                                      margin: EdgeInsets.only(right: FetchPixels.getPixelWidth(51)),
                                      color: Colors.transparent,
                                      child:  getAssetImage(
                                        "popular_logo.png",
                                        FetchPixels.getPixelHeight(170),
                                        FetchPixels.getPixelHeight(188),
                                      ),
                                    ),
                                  ]
                                  else if(_billtype=='PIAG')...[
                                      Container(
                                        margin: EdgeInsets.only(right: FetchPixels.getPixelWidth(51)),
                                        color: Colors.transparent,
                                        child:  getAssetImage(
                                          "popular_logo.png",
                                          FetchPixels.getPixelHeight(170),
                                          FetchPixels.getPixelHeight(188),
                                        ),
                                      ),
                                    ]
                                    else ...[
                                        Container(
                                          margin: EdgeInsets.only(right: FetchPixels.getPixelWidth(51)),
                                          color: Colors.transparent,
                                          child:  getAssetImage(
                                            "popular_logo.png",
                                            FetchPixels.getPixelHeight(170),
                                            FetchPixels.getPixelHeight(188),
                                          ),
                                        ),
                                      ]
                            // Add more widgets here if needed
                          ],
                        )

                      ],
                    ),
                  ))
                ],
              );
            },
          ),
        ),
        getVerSpace(FetchPixels.getPixelHeight(14)),
        ValueListenableBuilder(
          valueListenable: selectedPage,
          builder: (context, value, child) {
            return Container(
              height: FetchPixels.getPixelHeight(8),
              width: FetchPixels.getPixelWidth(44),
              alignment: Alignment.center,
              child: ListView.builder(
                itemCount: 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return getPaddingWidget(
                    EdgeInsets.only(right: FetchPixels.getPixelWidth(10)),
                    getAssetImage(
                      "dot.png",
                      FetchPixels.getPixelHeight(8),
                      FetchPixels.getPixelHeight(8),
                      color: selectedPage.value == index
                          ? blueColor
                          : blueColor.withOpacity(0.2),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}


