import 'package:e_expense/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_expense/config/global.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static String BASE_URL = '' + Global.url + '/receipt';
  bool _load = false;
  int _id = 0;
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  void reset() async{
    setState(() {
      _load=true;
    });
    final response = await http.delete(Uri.parse(BASE_URL + '/' + _id.toString()),
        headers: {"Content-Type": "application/json"});
    setState(() {
      _load=false;
    });
    notify(DialogType.SUCCES, 'Successfully Reset', 'Your data has already reset.');
  } 
  void notify(DialogType type, title, desc) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.BOTTOMSLIDE,
      title: title,
      desc: desc,
      btnOkOnPress: () {},
    )..show();
  }

  void Save() async {
    if (_email.text == '' || _email.text == null) {
      notify(DialogType.ERROR, 'Required Field', 'Please fill up the form.');
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    var params = {
      "email": _email.text,
      "password": _password.text,
      "id": prefs.getInt('_id')
    };
    setState(() {
      _load = true;
    });
    final response = await http.put(Uri.parse(Global.url + '/users/' + _id.toString()),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    String jsonsDataString = response.body.toString();
    final _data = jsonDecode(jsonsDataString);
    if (_data['status'] == 'Success') {
      prefs.setString('_email', _email.text);
      setState(() {
        _load = false;
      });
      notify(DialogType.SUCCES, 'Successfully Saved', '');
    } else {
      notify(DialogType.ERROR, 'Account is already exists.',
          "Please user other account.");
      setState(() {
        _load = false;
      });
    }
  }

  void getPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email.text = prefs.getString("_email");
      _id = prefs.getInt("_id");
      print(_email);
    });
  }

  void initState() {
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: textSize("Profile", 20),
          backgroundColor: Colors.purple,
        ),
        body: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.asset("assets/images/mainlogo.png",height: 90,),
              textSize('Profile', 17),
              Container(
                  padding: EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: _email,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Email",
                        fillColor: Colors.white70),
                  )),
              Container(
                  height: 100,
                  padding: EdgeInsets.only(top: 10),
                  child: TextField(
                    obscureText: true,
                    controller: _password,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Password",
                        fillColor: Colors.white70),
                  )),
              textSize('Data', 17),
              Container(
                padding: EdgeInsets.only(top: 15),
                width: 500,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                  child: Text(
                    'Reset Data',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.WARNING,
                        animType: AnimType.BOTTOMSLIDE,
                        title: 'Would you like to reset your receipts ?',
                        desc:
                            "No reverting data. Please make sure that all of your data is being saved or backed up.",
                        btnOkOnPress: () {
                          reset();
                        },
                        btnCancelOnPress: () {})
                      ..show();
                  },
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 120),
                  width: 250,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.purple),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    child: Text('Save'),
                    onPressed: () {
                      Save();
                    },
                  ),
                ),
              ),
              _load
                  ? Center(
                      child: Container(
                      color: Colors.white10,
                      width: 70.0,
                      height: 70.0,
                      child: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Center(
                              child: new CircularProgressIndicator())),
                    ))
                  : textSize('', 0.0)
            ],
          ),
        ));
  }
}
