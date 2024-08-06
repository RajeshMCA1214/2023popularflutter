import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../apiclass/PickPreview.dart';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_service_provider/app/utils/strings.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '../../../apiclass/getFloor.dart';
import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/resizer/fetch_pixels.dart';
import '../../../base/widget_utils.dart';
import '../../routes/app_routes.dart';

class PickListPreview extends StatefulWidget {
  //final String img;
  const PickListPreview({Key? key}) : super(key: key);

  @override
  State<PickListPreview> createState() => _PickListPreview();
}

class _PickListPreview extends State<PickListPreview> {
  String picklistPreview = Strings.apipath + "pick_List_Preview.php";
  String completeMaster = Strings.apipath + "complete_pick_master.php";

  TextEditingController containerQR = TextEditingController();

//  List<PickPreview> pickPreview=[];
  List<PickPreviewElement> pickPreview=[];
  var _isLoading = true;
  String pickcategory='';
  String pickid='';
  String pickstatus='';
  String _empcode='';
  String Preview='';

/*****************************************popup work**********************************/
  List<FloorLocation> floorLocation=[];
  String floorurl = Strings.apipath + "get_floor_location.php";
  String updateFloor = Strings.apipath + "floorUpdate.php";
  bool _isloading=true;
  var Floor='';
  String _comcode='';
  String _billtype='';
  Future CustomerData() async{
    print("welcomecust");
    final res=await http.post(Uri.parse(floorurl),headers: {"Accept":"Application/Json"},
        body:{
          "comCode":"1"
        });
     print(res.body);
    if(res.statusCode==200){
      // customer=getcustcodeFromJson(res.body);
      var data=json.decode(res.body);
      final Getcustcode =getfloorFromJson(res.body);
      floorLocation=Getcustcode.floorLocation;
      setState(() {
        _isloading=false;
      });
      print(floorLocation[0].floorLocation);
      // customer =cus.map<Getcustcode>((json)=>Getcustcode.fromJson(json)).toList();

      // print("List size:${customer.length}");
      //  return customer;
    }
  }
  Future UpdateFloor() async{
    print("welcomecust");
    final res=await http.post(Uri.parse(updateFloor),headers: {"Accept":"Application/Json"},
        body:{
          "pick_id":pickid,
          "location":Floor
        });
    developer.log(res.body);
    print(res.body);
    if(res.statusCode==200){
      // customer=getcustcodeFromJson(res.body);
      var data=json.decode(res.body);
    //  final Getcustcode =getfloorFromJson(res.body);
     // floorLocation=Getcustcode.floorLocation;
      /*setState(() {
        _isloading=false;
      });*/
     // print(floorLocation[0].floorLocation);
      // customer =cus.map<Getcustcode>((json)=>Getcustcode.fromJson(json)).toList();

      // print("List size:${customer.length}");
      //  return customer;
    }
  }

  Future<String?> selectBin()=>showDialog<String>(context: context,
    builder:(context)=> AlertDialog(
      title: Text("Select Floor Location"),
     /*   content: TextField(decoration: InputDecoration(hintText:"Select Bin"
        ),
          autofocus: true,
          controller:containerQR ,
          onSubmitted: (_)=>submit(),
        ),*/
     content:DropdownButton<String>(
        hint: Floor == ''?Text("Select Customer_Code"):
        Text(Floor,style: TextStyle(color: Colors.blue),),
        isExpanded: true,
        iconSize: 50,
        items: floorLocation.map((e) {
          return DropdownMenuItem<String>(
            value: e.floorLocation,
            child: Text(e.floorLocation),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            print(value);
            Floor=value!;
            UpdateFloor();
            showDialog(
                barrierDismissible: false,
                builder: (context) {
                  return Dialog2(
                      1);
                },
                context: context);
          //  Navigator.of(context).pop(Floor);

          });

        },
      ) ,
      actions: [
        TextButton(
          onPressed:submit,
          child:Text("SUBMIT"),)
      ],
    ),);

  void submit(){

    print(Floor);
    Navigator.of(context).pop(Floor);


   // toPin.clear();
  }
/***************************************************************************************/

  get_sessionData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      _comcode = (logindata.getString('comCode') ?? '');
      _billtype = (logindata.getString('billType') ?? '');
      _empcode = (logindata.getString('employeeCode')??'');

    });
  }


  Future<void> completemasterpick(PickId) async {
    print("Complete");
    print(PickId);

    final res = await http.post(Uri.parse(completeMaster),
        headers: {"Accept": "application/json"},
        body: {"pick_id": PickId});
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
       print(data);
      developer.log(res.body);

      setState(() {
        //  pickdetaildata();
        _isLoading = false;
        (_isLoading == false)
            ? print("true:${_isLoading}")
            : print("false:${_isLoading}");
      });

      print(json.decode(res.body));


      if (data == 'Complete Successfully') {
        print(data);
        print("data");
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
        Constant.sendToNext(context,Routes.homeScreenRoute);
      }

    }
  }

  @override
  void initState() {
    CustomerData();
    print("Preview123");
    super.initState();
    get_sessionData();
    Future.delayed(Duration.zero, () {
      setState(() {
        Map args = ModalRoute.of(context)?.settings.arguments as Map;
        pickcategory = args['category'];
        pickid = args['pickId'];
        pickstatus = args['pickstatus'];
        Preview=args['preview'];
        print("Preview hii");
        print(pickcategory);
        print(pickid);
        print(pickstatus);
        print(Preview);
        _fetchData();

      });

    });

  }
  clearbinqr () async
  {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    logindata.remove("binqrcode");
  }
  void _fetchData() async {
    print(pickcategory);
    print(pickid);
    print(_empcode);
    print("123456789");
    //final response = await http.get(Uri.parse('https://my-api.com/data'));
    final response = await http.post(Uri.parse(picklistPreview), headers: {
      "Accept": "application/json"
    }, body: {
      "compCode":  _comcode,
      "category": pickcategory,
      "pickid": pickid,
      "employeeCode": _empcode
    });
    if(response.statusCode==200){
      // developer.log(response.body);
      setState(() {
        _isLoading = false;
        (_isLoading == false)
            ? print("true:${_isLoading}")
            : print("false:${_isLoading}");
      });
      // developer.log(response.body);
      final pickListPreview=pickPreviewFromJson(response.body);
      pickPreview=pickListPreview.pickPreview;

    }

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:(AppBar(
        title:Text('Pick List Preview Id'+'-'+pickid),
      )

      ),
      bottomNavigationBar:Container(
          padding: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(30)),
          child: GestureDetector(
              onTap: () {
                Constant.sendToNext(context, Routes.signupRoute);
              },

              child:  (Preview == "preview")?SizedBox(

                child: getButton(
                    context, backGroundColor, "Back", blueColor, () {
                  Constant.backToPrev(context);



                }, 25,
                    weight: FontWeight.w600,
                    insetsGeometrypadding: EdgeInsets.symmetric(
                        horizontal: FetchPixels.getPixelWidth(20),
                        vertical: FetchPixels.getPixelHeight(12)),
                    borderColor: whiteColor,
                    borderWidth:0,
                    isBorder: true,
                    borderRadius: BorderRadius.circular(
                        FetchPixels.getPixelHeight(10)
                    )
                ),
              ):
              SizedBox(

                child: getButton(
                    context, Colors.blue, "Complete", Colors.white,
                        () {

                          selectBin();



                    }, 25,
                    weight: FontWeight.w600,
                    insetsGeometrypadding: EdgeInsets.symmetric(
                        horizontal: FetchPixels.getPixelWidth(20),
                        vertical: FetchPixels.getPixelHeight(12)),
                    borderColor: whiteColor,
                    borderWidth:0,
                    isBorder: true,
                    borderRadius: BorderRadius.circular(
                        FetchPixels.getPixelHeight(10)
                    )
                ),
              )


          )
      ),
      body: (_isLoading == true)
          ? Center(child: SpinKitFoldingCube(color: Colors.blue))
          :_getBodyWidget(),

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
                  "Selected Floor:"+Floor, 22, Colors.black,
                  fontWeight: FontWeight.w900,
                  txtHeight: 1.2,
                  textAlign: TextAlign.center),

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
                        clearbinqr();

                        _isLoading = true;
                        Constant.backToPrev(context);
                        // pickdetaildata();

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
  Widget _getBodyWidget(){




    return Container(
      child:HorizontalDataTable(
        leftHandSideColumnWidth:150,
        rightHandSideColumnWidth:2500,
        isFixedHeader:true,
        headerWidgets:_getTitleWidget(),
        leftSideItemBuilder:_generateFristColumnRow,
        rightSideItemBuilder:_generateRightHandSideColumnRow,
        itemCount:pickPreview.length,
        rowSeparatorWidget:const Divider(
          color:Colors.black54,
          height:1.0,
          thickness:0.0,
        ),
      ),
      height:MediaQuery.of(context).size.height,
    );
  }
  List<Widget>_getTitleWidget(){
    return[
      _getTitleItemWidget('PartCode',100),
      _getTitleItemWidget('Pick',100),
      _getTitleItemWidget('Picked',100),
      _getTitleItemWidget('Rate ',100),
      _getTitleItemWidget('Picked Rate',100),
      _getTitleItemWidget('Picked Status',100),
      _getTitleItemWidget('Stock Qty',100),
      _getTitleItemWidget('Bin No',100),
      _getTitleItemWidget('Rack No',300),
    ];
  }
  Widget _getTitleItemWidget(String label,double width){
    return Container(
      child:Text(label,style:TextStyle(fontWeight:FontWeight.bold)),
      width:150,
      height:52,
      color: Colors.orangeAccent,
      padding:EdgeInsets.all(5),
      alignment:Alignment.centerLeft,


    );
  }
  Widget _generateFristColumnRow(BuildContext context, int index){
    return Row(

      children: [

        Container(
          child:Text('$index'),

          width:30,
          height:30,
          padding:EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment:Alignment.center,
          color:Colors.green,
        ),
        Container(
          child:Text(pickPreview[index].partno),

          width:120,
          height:30,
          padding:EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment:Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black12,
                width: 0.5,
              )),
        ),
      ],
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context,int index){
    return Row(
        children:<Widget>[

          /*  Container(

          child:Row(

            children:<Widget> [
              Icon(Icons.add_alert_sharp,color: index % 3==0?Colors.red :Colors.green),
              Text(index % 3==0 ? 'Disable':'Active'),
              Text(pickPreview[index].pickedRate)
            ],
          ),
          width:100,
          height:52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment:Alignment.centerLeft,
        ),*/
          Container(
            child:Text(pickPreview[index].pickQty),
            width:150,
            height:30,
            padding:EdgeInsets.fromLTRB(5,0,0,0),
            alignment:Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black12,
                  width: 0.5,
                )),

          ),
          if(pickPreview[index].pickedQty=="0")...[
            Container(

              child:Text(pickPreview[index].pickedQty),
              width:150,
              height:30,
              padding:EdgeInsets.fromLTRB(5,0,0,0),
              alignment:Alignment.centerLeft,

              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                    width: 1.5,
                  )),

            ),
          ]
          else...[
            Container(
              child:Text(pickPreview[index].pickedQty),
              width:150,
              height:30,
              padding:EdgeInsets.fromLTRB(5,0,0,0),
              alignment:Alignment.centerLeft,

              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 0.5,
                  )),

            ),
          ],
          Container(
              child:Text(pickPreview[index].rate),
              width:150,
              height:30,
              alignment:Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 0.5,
                  )),
              padding:EdgeInsets.fromLTRB(5,0,0,0)

          ),
          Container(
              child:Text(pickPreview[index].pickedRate),
              width:150,
              height:30,
              alignment:Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 0.5,
                  )),
              padding:EdgeInsets.fromLTRB(5,0,0,0)

          ),
          if(pickPreview[index].pickStatus=="Cancelled")...[
            Container(
              child:Text(pickPreview[index].pickStatus),
              width:150,
              height:30,
              padding:EdgeInsets.fromLTRB(5,0,0,0),
              alignment:Alignment.centerLeft,

              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                    width: 1.5,
                  )),
            ),
          ]
          else...[
            Container(
              child:Text(pickPreview[index].pickStatus),
              width:150,
              height:30,
              padding:EdgeInsets.fromLTRB(5,0,0,0),
              alignment:Alignment.centerLeft,

              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 0.5,
                  )),
            ),
          ],

          Container(
              child:Text(pickPreview[index].stockqty),
              width:150,
              height:30,
              alignment:Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 0.5,
                  )),
              padding:EdgeInsets.fromLTRB(5,0,0,0)

          ),
          Container(
              child:Text(pickPreview[index].binQrcode),
              width:50,
              height:30,
              alignment:Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 0.5,
                  )),
              padding:EdgeInsets.fromLTRB(5,0,0,0)
          ),
          Container(
              child:Text(pickPreview[index].rackno),
              width:1500,
              height:30,
              alignment:Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 0.5,
                  )),
              padding:EdgeInsets.fromLTRB(5,0,0,0)
          ),

        ]
    );
  }

}