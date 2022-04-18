import 'package:e_expense/categories/index.dart';
import 'package:e_expense/config/global.dart';
import 'package:e_expense/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
class ReceiptDetails extends StatefulWidget {
  final String _image;
  final double _totalAmount;
  final String _vendorName;
  final int _id;
  ReceiptDetails(this._image, this._totalAmount, this._vendorName,this._id);
  @override
  _ReceiptDetailsState createState() => _ReceiptDetailsState(this._image,this._totalAmount,this._vendorName,this._id);
}

class _ReceiptDetailsState extends State<ReceiptDetails> {

  final String _image;
  final double _totalAmount;
  final String _vendorName;
  final int _id;
  _ReceiptDetailsState(this._image, this._totalAmount, this._vendorName,this._id);
  bool _load = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        backgroundColor: Colors.purple,
      ),
      body: Container(
          child: Center(
        child: Column(
          children: [
            textSize(_vendorName, 30.0),
            textSize(_totalAmount.toString(), 20.0),
         Image.network(
                    _image,
                    height: 400,
                  ),
            // _image != 'https://cashtosspublic.s3.us-east-2.amazonaws.com/None' ? Image.network(_image,height: 400,) :
            // Image.asset("assets/images/cashtoss.png",height: 400,)
            ElevatedButton(
              onPressed: () {
                 AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Are you sure you want to delete this item?',
                  desc: '',
                  btnOkOnPress: ()async {
                      setState(() {
                        _load=true;
                      });
                      final response = await http.put(Uri.parse(Global.url + '/receipt/' + _id.toString()));
                      Navigator.pop(context);
                      Get.toNamed('/receipt');
                  },
                  btnCancelOnPress: (){

                  }
                )..show();
                //  uploadImage();
              },
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
              ),
            ),
            _load ? CircularProgressIndicator() : Text('')
          ],
        ),
      )),
    );
  }
}

