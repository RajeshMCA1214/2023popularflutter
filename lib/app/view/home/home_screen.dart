import 'package:home_service_provider/app/view/home/tab/tab_count.dart';
import 'package:home_service_provider/app/view/home/tab/tab_home.dart';
import 'package:home_service_provider/app/view/home/tab/tab_profile.dart';
import 'package:home_service_provider/app/view/home/tab/tab_schedule.dart';
import 'package:home_service_provider/base/color_data.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:home_service_provider/base/widget_utils.dart';
import 'package:flutter/material.dart';
import '../../../base/constant.dart';


class HomeScreen extends StatefulWidget {
 final int index;

  const HomeScreen(this.index, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> bottomBarList = [
    "home.svg",
    "search.svg",
    "calender.svg",
    "profile.svg"
  ];

  int? index;
  List<Widget> tabList = [
    const TabHome(),
    const TapCount(),
    const TabSchedule(),
    const TabProfile(),
  ];

  @override
  void initState() {
    super.initState();
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    double size = FetchPixels.getPixelHeight(40);
    double iconSize = FetchPixels.getPixelHeight(25);
    return WillPopScope(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: backGroundColor,
            body:
            SafeArea(
              child: tabList[index!],
            ),
            bottomNavigationBar: buildBottomBar(size, iconSize)),
        onWillPop: () async {
          Constant.closeApp();
          return false;
        });
  }

  Container buildBottomBar(double size, double iconSize) {
    return Container(
            height: FetchPixels.getPixelHeight(100),
            color: Colors.white,
            child:Row(
              children:
                  List.generate(bottomBarList.length, (index1) {
                    return Expanded(
                    flex: 1,
                    child:  InkWell(
                      onTap: () {

                        setState(() {
                          index
                          =index1;
                        });
                      },
                      child: Center(
                        child: Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                              color:
                              index == index1 ? blueColor : Colors.transparent,
                              shape: BoxShape.circle),
                          child: Center(
                            child: getSvgImage(bottomBarList[index1],
                                width: iconSize,
                                height: iconSize,
                                color: index == index1 ? Colors.white : null),
                          ),
                        ),
                      ),
                    )
                    ,
                      );
                  })
            )
          );
  }



}
