import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:e_expense/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pie_chart/pie_chart.dart';
// import 'package:pdf/widgets.dart';

import 'package:e_expense/config/global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
class analytics extends StatefulWidget {
  @override
  _analyticsState createState() => _analyticsState();
}
  bool _load = true;
  double _totalSetAmount=0;
  bool isEdit=false;
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  double _percent = 0;
  double _percentLabel=0;
  double _currentAmount=0;
  int _id = 0;
class _analyticsState extends State<analytics> {
 
 Future<void> main_test() async {
     double totals = 0.0;
    List<TableRow> rows = [];
    for (int i = 0; i < receipts_data.length; ++i) {
      rows.add(TableRow(children: [
        Text(receipts_data[i][2].toString()),
        Text("Php ${receipts_data[i][6]}" ),
      ]));
      
     totals = totals + receipts_data[i][6];
    }
  //  String csv = const ListToCsvConverter().convert([]);
  //   final output = await getTemporaryDirectory();
    
  // print(output.path);
  // print(output.path);
  // File file = File('/storage/emulated/0/Download/example.pdf');
// String file = "$dir";

// file.writeAsString(csv);
  final pdf = pw.Document();
// final Uint8List fontData = File('assets/OpenSans.ttf').readAsBytesSync();
// final ttf = pw.Font.ttf(fontData.buffer.asByteData());
    final font = await rootBundle.load("assets/OpenSans.ttf");
  final ttf =   pw.Font.ttf(font);
  pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(children:[
            pw.Center(
             child: pw.Text("Cashtoss Report", style:pw.TextStyle(font:ttf,fontSize: 20))
            ),
           for (int i = 0; i < receipts_data.length; ++i)
           pw.Text('${receipts_data[i][2]} - Php ${receipts_data[i][6]}', style:pw.TextStyle(font:ttf,fontSize: 20)),

           pw.Text("Total: ${totals}", style:pw.TextStyle(font:ttf,fontSize: 20))
        ]);
      }));


      
  final output = await getTemporaryDirectory();
  // print(output.path);
  final file = File('/storage/emulated/0/Download/test.pdf');
  await file.writeAsBytes(await pdf.save());
  print(pdf);
}
  static String BASE_URL = ''+Global.url+'/settings';
  static String BASE_URL_RECEIPT = ''+Global.url+'/receipt';
  static String BASE_URL_RECEIPTS = ''+Global.url+'/receipts';
  int total = 0;
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
  List receipts_data =[];
  List receipts_data_permanent =[];
   Future<String> getDataReceipts() async {
    final prefs = await SharedPreferences.getInstance();
    _id = prefs.getInt("_id");
    final response = await http.get(
        Uri.parse(BASE_URL_RECEIPTS + '/'  + _id.toString()),
        headers: {"Content-Type": "application/json"});

    this.setState(() {
      try {
        _load = false;
        receipts_data = json.decode(response.body);
       receipts_data_permanent = json.decode(response.body);
        print(receipts_data);
      } finally {
        _load = false;
      }
    });
  }
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('yyyy-MM-dd').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
      receipts_data=[];
      for(int x=0;x<receipts_data_permanent.length;x++){
        // if(DateFormat('yyyy-MM-dd').format(receipts_data_permanent[x][3])==DateFormat('yyyy-MM-dd').format(args.value.startDate))
        // receipts_data.add(receipts_data_permanent[x]);
       if(DateTime.tryParse(receipts_data_permanent[x][3]).compareTo(DateTime.tryParse(DateFormat('yyyy-MM-dd').format(args.value.startDate)))==1 && DateTime.tryParse(receipts_data_permanent[x][3]).compareTo(DateTime.tryParse(DateFormat('yyyy-MM-dd').format(args.value.endDate)))==-1){
          receipts_data.add(receipts_data_permanent[x]);
          setState(() {
            
          });
       }
      //  print(DateTime.tryParse(receipts_data_permanent[x][3]));
      //  print(DateTime.tryParse(receipts_data_permanent[x][3]).compareTo(DateTime.tryParse(DateFormat('yyyy-MM-dd').format(args.value.endDate))));
      }
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
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
    this.getDataReceipts();
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
    ) : ListView(
      children: [
        Container(
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
              Container(
                padding: EdgeInsets.all(50),
                child:Column(
                  children: [
                    Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Selected range: $_range'),
                    ],
                  ),
              SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: PickerDateRange(
                        DateTime.now().subtract(const Duration(days: 4)),
                        DateTime.now().add(const Duration(days: 3))),
                  ),
                 createTable(receipts_data),
                 Padding(padding: EdgeInsets.only(top:15)),
                    InkWell(
                      child: Text('Download'),
                      onTap:() => {
                      
                        main_test()
               
                      },
                    )
                  ],
                )
              )
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
      ],
    )
    );
    
  }
   Widget createTable(List receipts) {
    
    List<TableRow> rows = [];
    for (int i = 0; i < receipts.length; ++i) {
      rows.add(TableRow(children: [
        Text(receipts[i][2].toString()),
        Text("Php ${receipts[i][6]}" ),
      ]));
    }
    return Table(children: rows);
  }
}
 