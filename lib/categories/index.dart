import 'package:flutter/material.dart';
import 'package:e_expense/config/global.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_expense/details/index.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class receiptList extends StatefulWidget {
  String category = Get.arguments;

  @override
  _receiptListState createState() => _receiptListState(category);
}

class _receiptListState extends State<receiptList> {
  bool _load = true;
  int _id = 0;
  var _category = '';
  static String BASE_URL = '' + Global.url + '/categories';

  _receiptListState(this._category);
  List items = [
    {"name": "name"},
    {"name": "name1"}
  ];

  void getPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      print(_id);
    });
  }

  List data;

  Future<String> getData() async {
    final prefs = await SharedPreferences.getInstance();
    _id = prefs.getInt("_id");
    final response = await http.get(
        Uri.parse(BASE_URL + '/' + _category + '/' + _id.toString()),
        headers: {"Content-Type": "application/json"});

    this.setState(() {
      try {
        _load = false;
        data = json.decode(response.body);
      } finally {
        _load = false;
      }
    });
  }

  @override
  void initState() {
    this.getPref();
    this.getData();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(_category),
      ),
      body: _load
          ? Center(
              child: Container(
                color: Colors.white10,
                width: 70.0,
                height: 70.0,
                child: new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Center(child: new CircularProgressIndicator())),
              ),
            )
          : new ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return new ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        curve: Curves.linear,
                        type: PageTransitionType.topToBottom,
                        child: ReceiptDetails(data[index]['image'],
                            data[index]['total'], data[index]['vendor_name']),
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
