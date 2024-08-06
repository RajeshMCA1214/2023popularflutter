import 'package:home_service_provider/app/routes/app_routes.dart';
import 'package:home_service_provider/base/resizer/fetch_pixels.dart';
import 'package:home_service_provider/base/color_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../../base/TextFieldWithNoKeyboard.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
bool value=true;


class ScanPartScreen extends StatefulWidget {
  ScanPartScreen({Key? key}) : super(key: key);

  @override
  State<ScanPartScreen> createState() => _ScanPartScreen();
}

class _ScanPartScreen extends State<ScanPartScreen> {
  String qrCode='unknow';
/*  var get_container_no=Get.arguments["container_no"];
  var get_material_code=Get.arguments["material_code"];
  var get_put_id=Get.arguments["put_id"];
  var get_company_id=Get.arguments["comapany_id"];
  var get_warehouse_id=Get.arguments["warehouse_id"];
  List<TripCount> QRUpdate=[];

  String containerQrUpdatephpurl = Strings.apipath+"update_containerQr_api.php";
  Future<bool> loadContainerQR() async{
    final res=await http.post(Uri.parse(containerQrUpdatephpurl),headers: {
      "Accept": "application/json"
    },body: {
      "container_no":get_container_no,//get_container_no,
      "material_code":get_material_code,//get_material_code,
      "put_id":get_put_id,//get_put_id,
      "container_qrcode":qrCode,//get_container_qrcode,

    });
    if (res.statusCode == 200) {
      developer.log(res.body);
      print(json.decode(res.body));

      print("svg file");

      try {
        // final planmasterResult =containerQrupdateFromJson(res.body);
        // QRUpdate= planmasterResult.tripCount;
        return true;
      }
      catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            " Please Pass Correct parameters ${e}",
            textAlign: TextAlign.center,
          ),
          backgroundColor: CustomColor.appbarColor,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
        ));
        throw Future.error(e);
      }
    } else {
      return false;
    }
  }*/

  TextEditingController containerQR=TextEditingController();
  TextEditingController locationQR = TextEditingController();



  late FocusNode flocationQR;
  late FocusNode fcontainerQR;


  //final player = AudioCache();

  @override
  void initState() {


    flocationQR=FocusNode();
    fcontainerQR=FocusNode();
    super.initState();

  }



  void dispose(){
    flocationQR.dispose();
    fcontainerQR.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
        backgroundColor: Color(0xFF8ea9b4),
        appBar: AppBar(
          leadingWidth: 0,
          backgroundColor: appbarColor,
          leading: const SizedBox(),
          title: Row(
            children: [
              InkWell(
                onTap: () {
                 // Get.back();
                },
                child: SizedBox(
                    width: 13.5,
                    height: 23.62,
                    child: const Icon(Icons.arrow_back_ios)),
              ),
              //addHorizontalSpace(20.5.w),
              Text(
                "Qr Code Scanner",
                //Strings.withdraw,
                //style: CustomStyle.appbarTitleStyle,
              ),
            ],
          ),
        ),
        body: _bodyWidget(context),

      );
  }


  _bodyWidget(BuildContext context) {
    final focus = FocusScope.of(context);
    return SingleChildScrollView(

      child: Container(
        child: SizedBox(

          width: 414,
          height: 750,

          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                SizedBox(
                  width: 250,
                  height: 80,
                  child: getButton(context, blueColor, "Scan Part QR", Colors.white, () {
                    if(containerQR.text.isEmpty)
                    {
                      scanQRCode();

                    }

                    else {
                      Constant.sendToNext(context, Routes.editProfileRoute);
                    }
                  }, 18,
                      weight: FontWeight.w600,
                      buttonHeight: FetchPixels.getPixelHeight(60),
                      borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(14))),
                ),
                Visibility(
                    visible: true,
                    child: TextFieldWithNoKeyboard(
                      controller: containerQR,
                      //autofocus: true,
                      focusNode: fcontainerQR,
                      cursorColor:Color(0xFF8ea9b4),
                      onValueUpdated:(value) {
                        this.qrCode=containerQR.text;
                        if (containerQR.text.isNotEmpty){
                         // loadContainerQR();
                       //  Get.toNamed(Routes.scanLocationQR,arguments: {"container_no":get_container_no,
                     //       "material_code":get_material_code,"put_id":get_put_id,"company_id":get_company_id,"warehouse_id":get_warehouse_id
                      //    });
                        }
                        if (containerQR.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar
                            (
                            content: Text('Container Code Wrong Try Again',textAlign: TextAlign.center,),
                            backgroundColor: appbarColor,
                            elevation: 10,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(15),
                          )
                          );
                          containerQR.clear();
                        //  FlutterBeep.beep(false);
                        }



                      },
                      selectionColor:Colors.black,
                      style: TextStyle(color: Color(0xFF8ea9b4)),
                    )),
                SizedBox(
                  width: 850,
                  height: 500,

                  child: Container(child: ConstrainedBox(
                      constraints: BoxConstraints.expand(),

                      child: 	TextButton(
                          onPressed: (){
                            if(containerQR.text.isEmpty)
                            {
                              scanQRCode();
                            }
                          },

                          child: Image.asset("assets/images/scanstage.png",
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity,

                            alignment: Alignment.center,)))),
                ),


              ],
            ),
          ),
        ),
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





}

