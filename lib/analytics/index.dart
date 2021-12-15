import 'package:e_expense/utils.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:e_expense/config/global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
class analytics extends StatefulWidget {

  @override
  _analyticsState createState() => _analyticsState();
}
  bool _load = true;
  double _totalSetAmount=0;
  bool isEdit=false;
  double _percent = 0;
  double _percentLabel=0;
  double _currentAmount=0;
  int _id = 0;
class _analyticsState extends State<analytics> {
  static String BASE_URL = ''+Global.url+'/settings';
  static String BASE_URL_RECEIPT = ''+Global.url+'/receipt';
    Future<String> getData() async {
      final prefs = await SharedPreferences.getInstance();
    int _id = prefs.getInt("_id");
 

   final response = await http.get(Uri.parse(BASE_URL+'/'+_id.toString()),headers: {"Content-Type": "application/json"});
  var data=json.decode(response.body);
  print("okay");
  _totalSetAmount = data;
  print(_totalSetAmount);
  print(":mnot");
  setState(() {
  });
  }
   Future<String> totalReceipts() async {
  final prefs = await SharedPreferences.getInstance();
    int _id = prefs.getInt("_id");
   final response = await http.get(Uri.parse(BASE_URL_RECEIPT+'/'+_id.toString()),headers: {"Content-Type": "application/json"});
   var data=json.decode(response.body);
  setState(() {
    _load=false;
    dataMap={"Medication":data['Medication'],"Others":data['Others'],"Food":data['Food'],
    "Groceries":data['Groceries'],"Education":data["Education"],"Transportation":data['Transportation'],"Utilities":data["Utilities"]};
    if(data['total']!=null){
          _currentAmount=data['total'];
        if(data['total']/_totalSetAmount>1.0){
          _percent = 1.0;
        }
        else{
          _percent=_currentAmount/_totalSetAmount;
          _percentLabel=_percent*100;
        }
    }
    else{
      _percent = 0;
    }
  });
  
  }


  TextEditingController _totalAmount= new TextEditingController();
  Map<String, double> dataMap = {
    "Medication": 0,
    "Groceries": 0,
    "Education": 0,
    "Food": 0,
    "Transportation": 0,
    "Others": 0,
    "Utilities":0
  };
    void saveAmount() async {
     final prefs = await SharedPreferences.getInstance();
    int _id = prefs.getInt("_id");
   final response = await http.post(Uri.parse(BASE_URL+'/'+_id.toString()),headers: {"Content-Type": "application/json"},body: json.encode({"totalAmount":_totalAmount.text}));
  }
   void initState(){
     
    this.getData();
    this.totalReceipts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Reports'),
      ),
    body:   _load ?  Center(
      child: Container(
            color: Colors.white10,
            width: 70.0,
            height: 70.0,
            child: new Padding(padding: const EdgeInsets.all(5.0),child: new Center(child: new CircularProgressIndicator())),
          ),
    ) : Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 40),
            child: textSize('Total purchased $_currentAmount', 20),
          ),
          PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 3.2,
              colorList: [Colors.black45,Colors.blue,Colors.red,Colors.pink,Colors.green,Colors.orange,Colors.yellow],
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              centerText: "Total",
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: false,
                showChartValuesOutside: false,
                decimalPlaces: 1,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 50)),
            Container(
              padding: EdgeInsets.only(left: 0,bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textSize("Total Amount:", 20.0),
              textSize(_totalSetAmount.toString(), 20.0),
               !isEdit ? IconButton(onPressed: (){
                  setState(() {
                    isEdit=true;
                  });
                }, icon: Icon(Icons.edit)):Text("")
              ],
            ) ,
            ),
              Container(
                padding: EdgeInsets.only(left: 50,right: 50),
                child:isEdit ? TextField(
                controller: _totalAmount,
                
                decoration: new InputDecoration(
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      isEdit=false;
                      _totalSetAmount=double.parse(_totalAmount.text);
                    });
                    saveAmount();
                  }, icon: Icon(Icons.save)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Colors.black45 , width: 1.0),
                    ),
                    hintText: 'Enter Amount',
                ),
            ):textSize("", 0.0),
              ),
            // Container(
            //   padding: EdgeInsets.only(top: 25),
            //   child: new CircularPercentIndicator(
            //       radius: 150.0,
            //       lineWidth: 20.0,
            //       percent: _percent,
            //       center: new Text(_percentLabel.round().toString()),
            //       progressColor: Colors.green,
            //     ),
            // )
        ],
      ),
      )
    );
  }
}