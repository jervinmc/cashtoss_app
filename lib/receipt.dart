import 'package:flutter/material.dart';
import 'package:e_expense/categories/index.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:page_transition/page_transition.dart';

class receipt extends StatefulWidget {

  @override
  _receiptState createState() => _receiptState();
}

class _receiptState extends State<receipt> {
  final List items = [{
    'title'
  }];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:Colors.purple,
          title: const Text('Categories'),
        ),
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.r
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children:[
            Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: InkWell(
                    splashColor: Colors.amber[800].withAlpha(30),
                    onTap: () {
                     Get.toNamed('/receiptList',arguments: 'Medication');
                    },
                    child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      Icon(Icons.medication,size: 75,color: Colors.purple,),
                      Text('Medication',style: TextStyle(color: Colors.black87),)
                  ],
                )
              )
                        
                ),
                Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: InkWell(
                    splashColor: Colors.purple.withAlpha(30),
                    onTap: () {
                   Get.toNamed('/receiptList',arguments: 'Groceries');
                    },
                    child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      Icon(Icons.store,size: 75,color: Colors.purple,),
                      Text('Groceries',style: TextStyle(color: Colors.black87),)
                  ],
                )
              )
                        
                ),
                Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: InkWell(
                    splashColor: Colors.purple.withAlpha(30),
                    onTap: () {
                    Get.toNamed('/receiptList',arguments: 'Education');
                    },
                    child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      Icon(Icons.book,size: 75,color: Colors.purple,),
                      Text('Education',style: TextStyle(color: Colors.black87),)
                  ],
                )
              )
                        
                ),
                Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: InkWell(
                    splashColor: Colors.purple.withAlpha(30),
                    onTap: () {
                      Get.toNamed('/receiptList',arguments: 'Food');
                    },
                    child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      Icon(Icons.food_bank,size: 75,color: Colors.purple,),
                      Text('Food',style: TextStyle(color: Colors.black87),)
                  ],
                )
              )
                        
                ),
                Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: InkWell(
                    splashColor: Colors.purple.withAlpha(30),
                    onTap: () {
                     Get.toNamed('/receiptList',arguments: 'Utilities');
                    },
                    child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      Icon(Icons.design_services,size: 75,color: Colors.purple,),
                      Text('Utilities',style: TextStyle(color: Colors.black87),)
                  ],
                )
              )
                        
                ),
                Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: InkWell(
                    splashColor: Colors.purple.withAlpha(30),
                    onTap: () {
                      Get.toNamed('/receiptList',arguments: 'Transportation');
                    },
                    child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      Icon(Icons.emoji_transportation,size: 75,color: Colors.purple,),
                      Text('Transportation',style: TextStyle(color: Colors.black87),)
                  ],
                )
              )
                        
                ),
                Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: InkWell(
                    splashColor: Colors.purple.withAlpha(30),
                    onTap: () {
                      Get.toNamed('/receiptList',arguments: 'Others');
                    },
                    child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      Icon(Icons.other_houses,size: 75,color: Colors.purple,),
                      Text('Others',style: TextStyle(color: Colors.black87),)
                  ],
                )
              )
                        
                )
          ],
        ),

    );
  }
}