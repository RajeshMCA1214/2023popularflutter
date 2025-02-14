import 'dart:nativewrappers/ui/ui.dart';

import 'package:home_service_provider/base/constant.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:home_service_provider/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base/color_data.dart';
import '../../data/data_file.dart';
import '../../models/model_address.dart';

class AcceptDialog extends StatefulWidget {
  const AcceptDialog({Key? key}) : super(key: key);

  @override
  State<AcceptDialog> createState() => _AcceptDialogState();
}


class _AcceptDialogState extends State<AcceptDialog> {
  List<ModelAddress> addressList = DataFile.addressList;

  SharedPreferences? selection;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      selection = sp;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  "Are you Confirm the Pick Item?",
                  22,
                  Colors.black,
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
                      child: getButton(
                          context, blueColor, "Yes", Colors.white, () {
                        addressList.removeAt(selection!.getInt("index")!);
                        setState(() {});
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
