import 'package:home_service_provider/app/routes/app_routes.dart';
import 'package:home_service_provider/app/view/bookings/active_booking_screen.dart';
import 'package:home_service_provider/app/view/bookings/all_booking_screen.dart';
import 'package:home_service_provider/app/view/bookings/cancel_booking_screen.dart';
import 'package:home_service_provider/app/view/bookings/complete_booking_screen.dart';
import 'package:home_service_provider/base/color_data.dart';
import 'package:home_service_provider/base/constant.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:home_service_provider/base/widget_utils.dart';
import 'package:flutter/material.dart';

class TownPickScreen extends StatefulWidget {
  const TownPickScreen({Key? key}) : super(key: key);

  @override
  State<TownPickScreen> createState() => _TownPickScreen();
}

class _TownPickScreen extends State<TownPickScreen>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  late TabController tabController;
  var position = 0;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor,
      body: Column(
        children: [
          getVerSpace(FetchPixels.getPixelHeight(20)),
          getPaddingWidget(
            EdgeInsets.symmetric(
                horizontal: FetchPixels.getDefaultHorSpace(context)),
            withoutleftIconToolbar(context,
                isrightimage: true,
                title: "Town",
                weight: FontWeight.w900,
                textColor: Colors.black,
                fontsize: 24,
                istext: true,
                rightimage: "notification.svg", rightFunction: () {
                  Constant.sendToNext(context, Routes.notificationRoutes);
                }),
          ),
          getVerSpace(FetchPixels.getPixelHeight(30)),
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
          AllBookingScreen(),
          ActiveBookingScreen(),
          CompleteBookingScreen(),
          CancelBookingScreen()
        ],
        onPageChanged: (value) {
          tabController.animateTo(value);
          position = value;
          setState(() {});
        },
      ),
    );
  }

  List<String> tabsList = ["All", "Active", "Completed", "Cancelled"];

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
                    getCustomFont(tabsList[index], 16,
                        position == index ? blueColor : Colors.black, 1,
                        fontWeight: FontWeight.w400,
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
