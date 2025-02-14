import 'package:home_service_provider/app/data/data_file.dart';
import 'package:home_service_provider/app/models/model_cart.dart';
import 'package:home_service_provider/app/models/model_salon.dart';
import 'package:home_service_provider/base/pref_data.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:home_service_provider/base/widget_utils.dart';
import 'package:flutter/material.dart';
import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../models/model_popular_service.dart';
import '../dialog/color_dialog.dart';


class PickScreen extends StatefulWidget {
  const PickScreen({Key? key}) : super(key: key);

  @override
  State<PickScreen> createState() => _PickScreenState();
}

class _PickScreenState extends State<PickScreen> {
  static List<ModelItem> itemProductLists = DataFile.itemProductList;
  List<ModelPopularService> popularServiceLists = DataFile.popularServiceList;

  // SharedPreferences? selection;
  var index = 0;

 //var pickCat=Get.arguments['hai'];

  getPrefData() async {
    index = await PrefData.getDefIndex();
    setState(() {

    });
  }

  @override
  void initState() {
 //print(pickCat);
    super.initState();
    getPrefData();
  }

  var total = 0.00;


  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    double defSpace = FetchPixels.getDefaultHorSpace(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: defSpace);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          body: SafeArea(
            child: buildPage(edgeInsets, context, index, defSpace),
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
        getPaddingWidget(
            edgeInsets,
            gettoolbarMenu(context, "back.svg", () {
              Constant.backToPrev(context);
            },
                title:"pickCat", // variable from arguments
                weight: FontWeight.w900,
                textColor: Colors.black,
                fontsize: 24,
                istext: true,
                isrightimage: true,
                rightimage: "more.svg",
                rightFunction: () {})),
        getVerSpace(FetchPixels.getPixelHeight(20)),
        getPaddingWidget(edgeInsets, productImage(index)),
        getVerSpace(FetchPixels.getPixelHeight(20)),

        getVerSpace(FetchPixels.getPixelHeight(15)),
        buildListView(defSpace),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        getPaddingWidget(edgeInsets, totalContainer(),),
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
        ModelItem modelItem = itemProductLists[index];
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
                  child: packageDescription(modelItem),
                ),
              ),
              addButton(modelItem, context, index)
            ],
          ),
        );
      },
    );
  }

  // Expanded packageList(BuildContext context) {
  //   return Expanded(
  //     child: SingleChildScrollView(
  //       physics: const BouncingScrollPhysics(),
  //       child: ConstrainedBox(
  //         constraints: const BoxConstraints(),
  //         child: Column(
  //           children: [
  //             ListView.builder(
  //               shrinkWrap: true,
  //               physics: const BouncingScrollPhysics(),
  //               padding: EdgeInsets.zero,
  //               scrollDirection: Axis.vertical,
  //               itemCount: salonProductLists.length,
  //               itemBuilder: (context, index) {
  //                 ModelSalon modelSalon = salonProductLists[index];
  //                 return Container(
  //                   margin:
  //                       EdgeInsets.only(bottom: FetchPixels.getPixelHeight(20)),
  //                   width: FetchPixels.getPixelWidth(374),
  //                   padding: EdgeInsets.only(
  //                       left: FetchPixels.getPixelWidth(16),
  //                       right: FetchPixels.getPixelWidth(16),
  //                       top: FetchPixels.getPixelHeight(16),
  //                       bottom: FetchPixels.getPixelHeight(16)),
  //                   decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       boxShadow: const [
  //                         BoxShadow(
  //                             color: Colors.black12,
  //                             blurRadius: 10,
  //                             offset: Offset(0.0, 4.0)),
  //                       ],
  //                       borderRadius: BorderRadius.circular(
  //                           FetchPixels.getPixelHeight(12))),
  //                   child: Row(
  //                     children: [
  //                       packageImage(context, modelSalon),
  //                       Expanded(
  //                         child: Container(
  //                           padding: EdgeInsets.only(
  //                               left: FetchPixels.getPixelWidth(16)),
  //                           child: packageDescription(modelSalon),
  //                         ),
  //                       ),
  //                       addButton(modelSalon, context, index)
  //                     ],
  //                   ),
  //                 );
  //               },
  //             ),
  //             getVerSpace(FetchPixels.getPixelHeight(10)),
  //             totalContainer(),
  //             viewCartButton(context),
  //             getVerSpace(FetchPixels.getPixelHeight(30))
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget viewCartButton(BuildContext context) {
    return getButton(context, blueColor, "View Cart", Colors.white, () {
      showModalBottomSheet(
          backgroundColor: backGroundColor,
          isDismissible: false,
          isScrollControlled: true,
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(FetchPixels.getPixelHeight(40)),
            ),
          ),
          builder: (context) {
            return const ColorDialog();
          });
    }, 18,
        weight: FontWeight.w600,
        buttonHeight: FetchPixels.getPixelHeight(60),
        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14)),
        insetsGeometry: EdgeInsets.symmetric(
            horizontal: FetchPixels.getDefaultHorSpace(context)));
  }

  Container totalContainer() {
    return Container(
      child: total == 0.00
          ? Container()
          : Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getCustomFont("Total", 24, Colors.black, 1,
                  fontWeight: FontWeight.w900),
              getCustomFont(
                "\$$total",
                24,
                Colors.black,
                1,
                fontWeight: FontWeight.w900,
              )
            ],
          ),
          getVerSpace(FetchPixels.getPixelHeight(30)),
        ],
      ),
    );
  }

  Column addButton(ModelItem modelItem, BuildContext context, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (modelItem.quantity == 0)
          getButton(context, Colors.transparent, "Add", blueColor, () {
            modelItem.quantity = (modelItem.quantity! + 1);
            total = total + (modelItem.price! * 1);
            DataFile.cartList[index.toString()] = ModelCart(
              //  modelSalon.image,
                modelItem.name,
                modelItem.productName,
                modelItem.completed,
                modelItem.price,
                modelItem.quantity);

            setState(() {});
          }, 14,
              weight: FontWeight.w600,
              insetsGeometrypadding: EdgeInsets.symmetric(
                  horizontal: FetchPixels.getPixelWidth(20),
                  vertical: FetchPixels.getPixelHeight(12)),
              borderColor: blueColor,
              borderWidth: 1.5,
              isBorder: true,
              borderRadius:
              BorderRadius.circular(FetchPixels.getPixelHeight(10)))
        else
          Row(
            children: [
              GestureDetector(
                child: getSvgImage("add1.svg",
                    width: FetchPixels.getPixelHeight(30),
                    height: FetchPixels.getPixelHeight(30)),
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
                child: getSvgImage("minus.svg",
                    width: FetchPixels.getPixelHeight(30),
                    height: FetchPixels.getPixelHeight(30)),
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
        getCustomFont("\$${modelItem.price}", 16, blueColor, 1,
            fontWeight: FontWeight.w900)
      ],
    );
  }

  Column packageDescription(ModelItem modelItem) {
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
        getVerSpace(FetchPixels.getPixelHeight(6)),
        Row(
          children: [
            getSvgImage("star.svg",
                height: FetchPixels.getPixelHeight(16),
                width: FetchPixels.getPixelHeight(16)),
            getHorSpace(FetchPixels.getPixelWidth(6)),
            getCustomFont(
              modelItem.completed ?? "",
              14,
              Colors.black,
              1,
              fontWeight: FontWeight.w400,
            )
          ],
        )
      ],
    );
  }
/*
  Container packageImage(BuildContext context, ModelSalon modelSalon) {
    return Container(
      height: FetchPixels.getPixelHeight(104),
      width: FetchPixels.getPixelHeight(104),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(10)),
          color: listColor,
          image: getDecorationAssetImage(context, modelSalon.image ?? "")),
    );
  }

 */

  Column productDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getCustomFont("Test Data", 24, Colors.black, 1,
            fontWeight: FontWeight.w900),
        getVerSpace(FetchPixels.getPixelHeight(17)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                getSvgImage("star.svg",
                    width: FetchPixels.getPixelHeight(25),
                    height: FetchPixels.getPixelHeight(25)),
                getHorSpace(FetchPixels.getPixelWidth(10)),
                getCustomFont(
                  "4.5",
                  16,
                  Colors.black,
                  1,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            getButton(
                context, Colors.white, "10K Bookings", blueColor, () {}, 14,
                weight: FontWeight.w400,
                boxShadow: [
                  const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0.0, 4.0)),
                ],
                borderRadius:
                BorderRadius.circular(FetchPixels.getPixelHeight(20)),
                buttonHeight: FetchPixels.getPixelHeight(40),
                insetsGeometrypadding: EdgeInsets.symmetric(
                    horizontal: FetchPixels.getPixelWidth(18)))
          ],
        ),
        getVerSpace(FetchPixels.getPixelHeight(24)),
        getMultilineCustomFont(
            "There is a distinction between a beauty salon and a hair salon and although many small treatments, beauty salons provide extended services related to skin health.",
            16,
            Colors.black,
            fontWeight: FontWeight.w400,
            txtHeight: 1.3),
      ],
    );
  }

  Hero productImage(int index) {
    return Hero(
        tag: popularServiceLists[index],
        child: getCircularImage(context, FetchPixels.getPixelWidth(374),
            FetchPixels.getPixelHeight(225), FetchPixels.getPixelHeight(16),
            popularServiceLists[index].image ?? "",boxFit: BoxFit.cover));
    // getAssetImage(popularServiceLists[index].image ?? "",
    // FetchPixels.getPixelWidth(374), FetchPixels.getPixelHeight(225),
    // boxFit: BoxFit.fill),);
  }
}
