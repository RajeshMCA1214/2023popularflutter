import 'dart:convert';
import 'dart:async';
import 'package:home_service_provider/app/utils/strings.dart';
import 'package:home_service_provider/app/view/bookings/active_booking_screen.dart';
import 'package:home_service_provider/app/view/bookings/all_booking_screen.dart';
//import 'package:home_service_provider/app/view/bookings/cancel_booking_screen.dart';
import 'package:home_service_provider/app/view/bookings/complete_booking_screen.dart';
import 'package:home_service_provider/base/color_data.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:home_service_provider/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import '../../../../apiclass/ModelActivePicklist.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:get/get.dart';

class LocalPickScreen extends StatefulWidget {
  const LocalPickScreen({Key? key}) : super(key: key);

  @override
  State<LocalPickScreen> createState() => _LocalPickScreen();
}

class _LocalPickScreen extends State<LocalPickScreen>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  late TabController tabController;
  var position = 0;
  String assignpicklisturl = Strings.apipath+"assign_picklist_api.php";
  String? pickcategory;
  String? assignRes;
  String? action;
  String _comcode='';
  String _billtype='';
  List<AssignedPickList> assignedPickLists = [];
  TextEditingController searchController = TextEditingController();
  var horSpace = FetchPixels.getPixelHeight(20);
  //var pickCat=Get.arguments["category"];
  //final routes=ModalRoute.of(context)?.settings.arguments as Map<String,String>;
//Call Active Pick List Api

  onItemChanged(String value) {
    setState(() {
      assignedPickLists
          .where((string) =>
          string.pickId!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
  String _empcode='';

  get_sessionData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      _empcode = (logindata.getString('employeeCode')??'');
      _comcode = (logindata.getString('comCode') ?? '');
      _billtype = (logindata.getString('billType') ?? '');

      print(_empcode);
      print(pickcategory);

    });
  }


  Future<bool> assignpicklist() async {

      final res = await http.post(Uri.parse(assignpicklisturl), headers: {
        "Accept": "application/json"
      }, body: {
        "compCode": _comcode,
        "category": pickcategory,
        "employeeCode": _empcode,
        "action":"assignnew"
      });
      if (res.statusCode == 200) {
        developer.log(res.body);
        print(json.decode(res.body));
        var data = json.decode(res.body);
        try {
         // action = "0";
         assignRes=data["messages"];
          ScaffoldMessenger.of(context).showSnackBar(SnackBar
            (
            content: Text(data["messages"],textAlign: TextAlign.center,),
            backgroundColor: appbarColor,
            elevation: 10,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(15),
            duration: const Duration(milliseconds: 300),
          )

          );

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

    Future.delayed(Duration.zero, () {
      setState((){
        Map args = ModalRoute.of(context)?.settings.arguments as Map;
        pickcategory = args['category'];
        action = args['action'];
        // print(pickcategory);

      });
      if(action=="assignnew" &&  _empcode!='' ) {
        print(action);

        assignpicklist();

      }


    });

    tabController = TabController(length: 4, vsync: this);
    setState(() {});

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    pickcategory = arguments['category'];


    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor,
      body: Column(
        children: [
          getVerSpace(FetchPixels.getPixelHeight(60)),

          getPaddingWidget(
            EdgeInsets.symmetric(
                horizontal: FetchPixels.getDefaultHorSpace(context)),
            withoutleftIconToolbar(context,
                isrightimage: true,

                title: pickcategory=="PRO COURIER"?"PRO COURIER / DIRECT":arguments['category'],
                weight: FontWeight.w900,
                textColor: Colors.blue,
                fontsize: 30,
                istext: true,
                rightimage: "", rightFunction: () {

                }),
          ),

          getVerSpace(FetchPixels.getPixelHeight(10)),
          tabBar(),
          getVerSpace(FetchPixels.getPixelHeight(10)),
          pageViewer()
        ],
      ),
    );
  }

  Expanded pageViewer() {
    return Expanded(
      child: PageView(
        physics: const BouncingScrollPhysics(),
        controller: _controller,
        scrollDirection: Axis.horizontal,
        children: const [
          ActiveBookingScreen(),
          CompleteBookingScreen(),
         // CancelBookingScreen(),
          AllBookingScreen()
        ],
        onPageChanged: (value) {
          tabController.animateTo(value);
          position = value;
          setState(() {});
        },
      ),
    );
  }

  List<String> tabsList = ["Active", "Completed","All"];

  Widget tabBar() {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: FetchPixels.getDefaultHorSpace(context)),
      TabBar(
        indicatorColor: Colors.transparent,
        physics: const BouncingScrollPhysics(),
        controller: tabController,
        labelPadding: EdgeInsets.zero,
        onTap: (index) {
          _controller.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
          position = index;
          setState(() {});
        },
        tabs: List.generate(tabsList.length, (index) {
          return Tab(
            child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    getCustomFont(tabsList[index], 17
                        ,
                        position == index ? blueColor : Colors.black, 1,
                        fontWeight: FontWeight.w700,
                        overflow: TextOverflow.visible),
                    getVerSpace(FetchPixels.getPixelHeight(7)),
                    Container(
                      height: FetchPixels.getPixelHeight(2),
                      color: position == index
                          ? blueColor
                          : const Color(0xFFE5E8F1),
                    )
                  ],
                )),
          );
        }),
        // Tab(
        //   child: Container(
        //       alignment: Alignment.center,
        //       child: Column(
        //         children: [
        //           getCustomFont(
        //               "All", 16, position == 0 ? blueColor : Colors.black, 1,
        //               fontWeight: FontWeight.w400,
        //               overflow: TextOverflow.visible),
        //           getVerSpace(FetchPixels.getPixelHeight(7)),
        //           Container(
        //             height: FetchPixels.getPixelHeight(2),
        //             color:
        //                 position == 0 ? blueColor : const Color(0xFFE5E8F1),
        //           )
        //         ],
        //       )),
        // ),
        // Tab(
        //   child: Container(
        //       alignment: Alignment.center,
        //       child: Column(
        //         children: [
        //           getCustomFont("Active", 16,
        //               position == 1 ? blueColor : Colors.black, 1,
        //
        //               fontWeight: FontWeight.w400,
        //               overflow: TextOverflow.visible),
        //           getVerSpace(FetchPixels.getPixelHeight(7)),
        //           Container(
        //             height: FetchPixels.getPixelHeight(2),
        //             color:
        //                 position == 1 ? blueColor : const Color(0xFFE5E8F1),
        //           )
        //         ],
        //       )),
        // ),
        // Tab(
        //   child: Container(
        //       alignment: Alignment.center,
        //       child: Column(
        //         children: [
        //           getCustomFont("Completed", 16,
        //               position == 2 ? blueColor : Colors.black, 1,
        //
        //               fontWeight: FontWeight.w400,
        //               overflow: TextOverflow.visible),
        //           getVerSpace(FetchPixels.getPixelHeight(7)),
        //           Container(
        //             height: FetchPixels.getPixelHeight(2),
        //             color:
        //                 position == 2 ? blueColor : const Color(0xFFE5E8F1),
        //           )
        //         ],
        //       )),
        // ),
        // Tab(
        //   child: Container(
        //       alignment: Alignment.center,
        //       child: Column(
        //         children: [
        //           getCustomFont("Cancelled", 16,
        //               position == 3 ? blueColor : Colors.black, 1,
        //
        //               fontWeight: FontWeight.w400,
        //               overflow: TextOverflow.visible),
        //           getVerSpace(FetchPixels.getPixelHeight(7)),
        //           Container(
        //             height: FetchPixels.getPixelHeight(2),
        //             color:
        //                 position == 3 ? blueColor : const Color(0xFFE5E8F1),
        //           )
        //         ],
        //       )),
        // )
      ),
    );
  }
}
