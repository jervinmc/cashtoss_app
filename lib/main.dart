import 'package:e_expense/categories/index.dart';
import 'package:e_expense/home.dart';
import 'package:e_expense/login.dart';
import 'package:e_expense/profile/index.dart';
import 'package:e_expense/reset_password/views/reset_password.dart';
import 'package:e_expense/signup/index.dart';
import 'package:e_expense/starting/views/starting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async{
 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter',
      theme: ThemeData(
      ),
      getPages: [
        GetPage(name: "/starting", page:()=>StartingPage()),
        GetPage(name: "/login", page:()=>Login()),
        GetPage(name: "/home", page:()=>Home()),
        GetPage(name: "/signup", page:()=>SignUp()),
        GetPage(name: "/profile", page:()=>Profile()),
        GetPage(name: "/resetPassword", page:()=>ResetPassword()),
        GetPage(name: "/receiptList", page:()=>receiptList()),
        // GetPage(name: "/products", page:()=>Products()),
        // GetPage(name: "/cart", page:()=>Cart()),
        // GetPage(name: "/favorites", page:()=>Favorites()),
        // GetPage(name: "/product_details", page:()=>ProductDetails()),
      ],
      initialRoute: "/starting"  ,
    );
  }
}
