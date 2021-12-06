import 'package:e_expense/utils.dart';
import 'package:flutter/material.dart';
class ReceiptDetails extends StatelessWidget {
final String _image;
final int _totalAmount;
final String _vendorName;
ReceiptDetails(this._image,this._totalAmount,this._vendorName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Details"),backgroundColor: Colors.purple,),
      body: Container(
      child: Center(
        child: Column(
        children: [
          textSize(_vendorName, 30.0),
          textSize(_totalAmount.toString(), 20.0),
          Image.network(_image,height: 400,)
          // _image != 'https://cashtosspublic.s3.us-east-2.amazonaws.com/None' ? Image.network(_image,height: 400,) :
          // Image.asset("assets/images/cashtoss.png",height: 400,)

        ],
      ),
      )
    ),
    );
  }
}