import 'package:e_expense/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:e_expense/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:io';
import 'package:exif/exif.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:spincircle_bottom_bar/modals.dart';
import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:convert';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:http/http.dart' as http;
import 'analytics/index.dart';
import 'package:path_provider/path_provider.dart';
import 'package:e_expense/config/global.dart';
import 'package:e_expense/receipt.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:io';
import 'package:image/image.dart' as im;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'utils/helpers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:telephony/telephony.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile/index.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:csv/csv.dart';
onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate = DateTime.now();
  var myFormat = DateFormat('yyyy-MM-dd');
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        _date.text = myFormat.format(picked).toString();
      });
  }

  String _message = "";
  final telephony = Telephony.instance;
  String _ocrText = '';
  int _selectedIndex = 0;
  String _ocrHocr = '';
  String _email = '';
  TextEditingController _vendorName = new TextEditingController();
  TextEditingController _categoryName = new TextEditingController();
  TextEditingController _totalAmount = new TextEditingController();
  TextEditingController _date = new TextEditingController();
  final List<Map<String, dynamic>> _items = [
    {
      'value': 'Medication',
      'label': 'Medication',
    },
    {
      'value': 'Food',
      'label': 'Food',
    },
    {
      'value': 'Transportation',
      'label': 'Transportation',
    },
    {
      'value': 'Groceries',
      'label': 'Groceries',
    },
    {
      'value': 'Utilities',
      'label': 'Utilities',
    },
    {
      'value': 'Others',
      'label': 'Others',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _changeIndex(int index) {
    setState(() {
      selectedImage = null;
      _vendorName.text = '';
      _date.text = '';
      _totalAmount.text = '';
      _addIndex = index;
    });
  }

  String dropdownValue = 'Medication';
  bool _load = false;
  var LangList = ["kor", "eng", "deu", "chi_sim"];
  var selectList = ["eng", "kor"];
  String path = "";
  bool bload = false;

  bool bDownloadtessFile = false;
  // "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FqCviW%2FbtqGWTUaYLo%2FwD3ZE6r3ARZqi4MkUbcGm0%2Fimg.png";
  var urlEditController = TextEditingController()
    ..text = "https://tesseract.projectnaptha.com/img/eng_bw.png";

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  int _addIndex = 0;
  void runFilePiker() async {
    // android && ios only
    final imageFile = await ImagePicker().getImage(source: ImageSource.gallery);

    File pickedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    selectedImage = File(pickedFile.path);
    if (pickedFile != null) {
      _ocr(pickedFile.path);
    }
  }

  File selectedImage;
  void captureImage() async {
    // android && ios only
    final imageFile = await ImagePicker().getImage(source: ImageSource.camera);

    File pickedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      _ocr(pickedFile.path);
    }
    print(pickedFile);
  }

  static String BASE_URL = '' + Global.url + '/receipt';
  static String BASE_URL_UPLOAD = '' + Global.url + '/upload';
  uploadImage(id) async {
    final request = http.MultipartRequest(
        "POST", Uri.parse(BASE_URL_UPLOAD + '/' + id.toString()));
    final headers = {"Content-type": "multipart/form-data"};
    request.fields['user'] = "test";
    request.files.add(http.MultipartFile('image',
        selectedImage.readAsBytes().asStream(), selectedImage.lengthSync(),
        filename: selectedImage.path.split("/").last));
    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    var message = resJson['message'];
    setState(() {
      selectedImage = null;
    });
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

  String toOriginalFormatString(DateTime dateTime) {
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    final y = dateTime.year.toString().padLeft(4, '0');
    return "$m$d$y";
  }

  String _textMessage = '';
  void addReceipt() async {
    try {
      final date = DateTime.parse(_date.text);
      final originalFormatString = toOriginalFormatString(date);
    } catch (e) {
      notify(DialogType.ERROR, 'Invalid Date',
          'Please make sure your amount format.');
      return;
    }
    if (double.tryParse(_totalAmount.text) == null) {
      notify(DialogType.ERROR, 'Invalid Input',
          'Please make sure your amount format.');
      return;
    }
    if (_vendorName.text == null ||
        _totalAmount.text == null ||
        _vendorName.text == '' ||
        _totalAmount.text == '') {
      notify(
          DialogType.ERROR, 'Field is required.', 'Please fill up the form.');

      return;
    }
    setState(() {
      _load = true;
    });
    final prefs = await SharedPreferences.getInstance();
    int _id = prefs.getInt("_id");
    var params = {
      "date": _date.text,
      "id": _id,
      "category_name": dropdownValue,
      "vendor_name": _vendorName.text,
      "total": _totalAmount.text
    };
    final response = await http.post(Uri.parse(BASE_URL + '/' + '1'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    final data = json.decode(response.body);
    print(data);
    uploadImage(data['id']);

    notify(DialogType.SUCCES, 'Successfully added',
        'You added a new receipt successfully');
    setState(() {
      dropdownValue = 'Others';
      _vendorName.text = '';
      _totalAmount.text = '';
      _load = false;
      _date.text = '';
      selectedImage = null;
    });
    if ("exceed" == data['status']) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        title: 'You already exceed the total set amount.',
        desc: 'Please check your settings. Thank you !',
        btnOkOnPress: () {},
      )..show();
    }
  }

  void _ocr(url) async {
    setState(() {
      _load = true;
    });
    if (selectList.length <= 0) {
      return;
    }
    path = url;
    var langs = selectList.join("+");
    bload = true;
    setState(() {});
    print("okay");
    _ocrText =
        await FlutterTesseractOcr.extractText(url, language: langs, args: {
      "preserve_interword_spaces": "0",
    });
    bload = false;
    setState(() {});
    String BASE_URL = '' + Global.url + '/chat';
    var getVal = true;
    // print(_ocrText.split('\n'));
    var text = _ocrText.split('\n');
    _vendorName.text = text[0];
    print(text);
    text.forEach((item) {
      if (getVal) {
        if (item.toLowerCase().contains('total')) {
          var val = text[text.indexOf(item)];
          print(val.runtimeType == double);
          print(val);
          var _splittedAmount = val.split(' ');
          _totalAmount.text =
              _splittedAmount.last.replaceAll(RegExp('[^0-9.0-9]'), '');
          print(_totalAmount.text.replaceAll("[^\\d.]", ""));
          getVal = false;
        } else if (item.toLowerCase().contains('amount')) {
          var val = text[text.indexOf(item)];
          var _splittedAmount = val.split(' ');
          print(val);
          _totalAmount.text =
              _splittedAmount.last.replaceAll(RegExp('[^0-9.0-9]'), '');
          print(_totalAmount.text.replaceAll("[^\\d.]", ""));
          getVal = false;
        }
         else if (item.toLowerCase().contains('date')) {
          var val = text[text.indexOf(item)];
          var _splittedDate = val.split(' ');
          if(_splittedDate.length>0){
            _splittedDate.forEach((itemDate) {
                if(item.toLowerCase().contains('date')){
                  _date.text=_splittedDate[_splittedDate.indexOf(itemDate)];
                }
            });
          
          }
          
        }
      }
    });
    final response = await http.post(Uri.parse(BASE_URL),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"value": _ocrText}));
    final data = json.decode(response.body);
    setState(() {
      dropdownValue = data['data'];
      _load = false;
    });
  }

  void convertMessage() async {
    var getVal = true;
    var text = _message.split(' ');
    _vendorName.text = text[0];
    text.forEach((item) {
      if (getVal) {
        if (item.toLowerCase().contains('total')) {
          var val = text[text.indexOf(item) + 1];
          var _splittedAmount = val;
          _totalAmount.text =
              _splittedAmount.replaceAll(RegExp('[^0-9.0-9]'), '');
          getVal = false;
        } else if (item.toLowerCase().contains('amount')) {
          var val = text[text.indexOf(item) + 1];
          var _splittedAmount = val;
          print(val);
          _totalAmount.text =
              _splittedAmount.replaceAll(RegExp('[^0-9.0-9]'), '');
          getVal = false;
        }
      }
    });
    // final response = await http.post(Uri.parse(BASE_URL),
    //     headers: {"Content-Type": "application/json"},
    //     body: json.encode({"value": _ocrText}));
    // final data = json.decode(response.body);
    setState(() {
      dropdownValue = 'Utilities';
      _addIndex = 1;
    });
  }

  void getPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString("_email");
      if (prefs.getBool('isExceeded80'))
        notify(DialogType.WARNING, 'Purchased Items Exceeding 80 percent for utilities.',
            'You notified this because you purchased 80 percent of your set price threshold.');
      print(_email);
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getPref();
  }

  onMessage(SmsMessage message) async {
    setState(() {
      _message = message.body ?? "Error reading message body.";
    });
    convertMessage();
  }

  Future<void> initPlatformState() async {
    final bool result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    }

    if (!mounted) return;
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                _email,
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
            ),
            ListTile(
              trailing: Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Get.toNamed('/profile');
              },
            ),
            Divider(),
            ListTile(
              trailing: Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.QUESTION,
                    animType: AnimType.BOTTOMSLIDE,
                    title: "Are you sure you want to logout ?",
                    btnOkOnPress: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('isLoggedIn', false);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        PageTransition(
                          curve: Curves.linear,
                          type: PageTransitionType.topToBottom,
                          child: Login(),
                        ),
                      );

                      // runApp(());
                    },
                    btnCancelOnPress: () {})
                  ..show();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(widget.title),
      ),
      body: SpinCircleBottomBarHolder(
        bottomNavigationBar: SCBottomBarDetails(
            circleColors: [Colors.white, Colors.orange, Colors.purple],
            iconTheme: IconThemeData(color: Colors.black45),
            activeIconTheme: IconThemeData(color: Colors.purple),
            backgroundColor: Colors.white,
            titleStyle: TextStyle(color: Colors.black45, fontSize: 12),
            activeTitleStyle: TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
            actionButtonDetails: SCActionButtonDetails(
                color: Colors.purple,
                icon: Icon(
                  Icons.expand_less,
                  color: Colors.white,
                ),
                elevation: 2),
            elevation: 2.0,
            items: [
              // Suggested count : 4
              SCBottomBarItem(
                  icon: Icons.receipt,
                  title: "Receipts",
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        curve: Curves.linear,
                        type: PageTransitionType.topToBottom,
                        child: receipt(),
                      ),
                    );
                  }),
              SCBottomBarItem(
                  icon: Icons.bar_chart,
                  title: "Analytics",
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        curve: Curves.linear,
                        type: PageTransitionType.topToBottom,
                        child: analytics(),
                      ),
                    );
                  }),
            ],
            circleItems: [
              //Suggested Count: 3
              SCItem(
                  icon: Icon(Icons.photo_album),
                  onPressed: () {
                    runFilePiker();
                    _addIndex = 2;
                  }),
              SCItem(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    captureImage();
                    _addIndex = 2;
                  }),
              SCItem(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    print("okayy");
                    _changeIndex(1);
                    _ocrText = '';
                  }),
            ],
            bnbHeight: 80 // Suggested Height 80
            ),
        child: _addIndex == 0
            ? Container(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textSize("Capture expense below.", 20.0),
                  CustomPaint(
                    painter: MyPainter(),
                  ),
                  CustomPaint(
                    painter: DrawCurveLeft(),
                  ),
                  CustomPaint(
                    painter: DrawCurveRight(),
                  ),
                ],
              ))
            : _addIndex != 1
                ? Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _load
                                ? Container(
                                    color: Colors.white10,
                                    width: 70.0,
                                    height: 70.0,
                                    child: new Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: new Center(
                                            child:
                                                const CircularProgressIndicator())),
                                  )
                                : Text(''),
                            textSize('Receipt', 25.0),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: TextField(
                                controller: _vendorName,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black45, width: 1.0),
                                  ),
                                  hintText: 'Enter Vendor',
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: _totalAmount,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black45, width: 1.0),
                                  ),
                                  hintText: 'Enter Amount',
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: TextField(
                                readOnly: true,
                                maxLength: 10,
                                keyboardType: TextInputType.number,
                                controller: _date,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black45, width: 1.0),
                                  ),
                                  hintText: 'Date ex: yyyy-MM-dd',
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  // ignore: deprecated_member_use
                                  RaisedButton(
                                    onPressed: () => _selectDate(context),
                                    child: Text('Select date'),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(top: 10),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.black,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'Medication',
                                    'Education',
                                    'Food',
                                    'Transportation',
                                    'Utilities',
                                    'Groceries',
                                    'Others'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                )),
                            Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    new SizedBox(
                                        width: 350.0,
                                        height: 50.0,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            addReceipt();
                                            //  uploadImage();
                                          },
                                          child: Text('Save'),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.purple,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12), // <-- Radius
                                            ),
                                          ),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 15)),
                                    new SizedBox(
                                        width: 350.0,
                                        height: 50.0,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedImage = null;
                                              _vendorName.text = '';
                                              _totalAmount.text = '';
                                              _date.text = '';
                                            });
                                          },
                                          child: Text(
                                            'Cancel',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12), // <-- Radius
                                            ),
                                          ),
                                        ))
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.black26,
                        child: bDownloadtessFile
                            ? Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  Text('download Trained language files')
                                ],
                              ))
                            : SizedBox(),
                      )
                    ],
                  )
                : Container(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        _load
                            ? Container(
                                color: Colors.white10,
                                width: 70.0,
                                height: 70.0,
                                child: new Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: new Center(
                                        child:
                                            new CircularProgressIndicator())),
                              )
                            : Text(''),
                        textSize('Receipt', 25.0),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: _vendorName,
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black45, width: 1.0),
                              ),
                              hintText: 'Enter Vendor',
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _totalAmount,
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black45, width: 1.0),
                              ),
                              hintText: 'Enter Amount',
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                            readOnly: true,
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            controller: _date,
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black45, width: 1.0),
                              ),
                              hintText: 'Date ex: YYYY-MM-DD',
                            ),
                          ),
                        ),    
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // ignore: deprecated_member_use
                              RaisedButton(
                                onPressed: () => _selectDate(context),
                                child: Text('Select date'),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 10),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValue,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(
                                height: 2,
                                color: Colors.black,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: <String>[
                                'Medication',
                                'Education',
                                'Food',
                                'Transportation',
                                'Utilities',
                                'Groceries',
                                'Others'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )),
                        Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                new SizedBox(
                                    width: 350.0,
                                    height: 50.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        addReceipt();
                                      },
                                      child: Text('Save'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.purple,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              12), // <-- Radius
                                        ),
                                      ),
                                    )),
                                Padding(padding: EdgeInsets.only(bottom: 15)),
                                new SizedBox(
                                    width: 350.0,
                                    height: 50.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedImage = null;
                                          _vendorName.text = '';
                                          _totalAmount.text = '';
                                          _date.text = '';
                                        });
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              12), // <-- Radius
                                        ),
                                      ),
                                    )),
                                _load
                                    ? Container(
                                        color: Colors.white10,
                                        width: 70.0,
                                        height: 70.0,
                                        child: new Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: new Center(
                                                child:
                                                    new CircularProgressIndicator())),
                                      )
                                    : Text('')
                              ],
                            ))
                      ],
                    ),
                  ),
      ),

      // floatingActionButton: kIsWeb
      //     ? Container()
      //     : FloatingActionButton(
      //         onPressed: () {
      //           runFilePiker();
      //           // _ocr("");
      //         },
      //         tooltip: 'OCR',
      //         child: Icon(Icons.add),
      //       ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
