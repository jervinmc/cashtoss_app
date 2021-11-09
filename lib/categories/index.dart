import 'package:flutter/material.dart';
import 'package:e_expense/config/global.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_expense/details/index.dart';
import 'package:page_transition/page_transition.dart';
class receiptList extends StatefulWidget {
  String _category='';
  receiptList(this._category);
  @override
  _receiptListState createState() => _receiptListState(_category);
} 

class _receiptListState extends State<receiptList> {
  
  String _category='';
  static String BASE_URL = ''+Global.url+'/categories';
  
  _receiptListState(this._category);
    List items = [
    {
      "name":"name"
    },
    {
      "name":"name1"
    }
  ];
  
  List data;
  
  Future<String> getData() async {
   final response = await http.get(Uri.parse(BASE_URL+'/'+_category),headers: {"Content-Type": "application/json"});

  this.setState(() {
    data=json.decode(response.body);
    });
  }
    @override
  void initState(){
    this.getData();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(backgroundColor:Colors.purple,title: Text(_category),),
        body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return new ListTile(
            onTap: (){
              Navigator.push(
                  context,
                  PageTransition(
                    curve: Curves.linear,
                    type: PageTransitionType.topToBottom,
                    child: ReceiptDetails(data[index]['image'],data[index]['total'],data[index]['vendor_name']),
                  ),
                );
            },
            title: Text(data[index]['vendor_name']),
            subtitle: Text(data[index]['created_date']),
            trailing: Text('${data[index]['total']}'),
          );
        },
      ),
    );
    
  }
}