import 'package:flutter/material.dart';
import 'package:haweyati/models/temp-model.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/widgits/stackButton.dart';

import 'orders-listing.dart';

class OrderPlace extends StatefulWidget {
  ConstructionService constructionService;
  OrderPlace({this.constructionService});
  @override
  _OrderPlaceState createState() => _OrderPlaceState();
}

class _OrderPlaceState extends State<OrderPlace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HaweyatiAppBar(context: context,),
        body: Stack(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.check,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Thank You",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      loremIpsum.substring(0,40),
                      style: TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          print(widget.constructionService);
                          CustomNavigator.navigateTo(
                              context,
                              ViewAllOrders(
                               // constructionService: widget.constructionService,
                              ));
                        },
                        child: Text(
                          "View Order Detail",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 18),
                          textAlign: TextAlign.center,
                        ))
                  ],
                ),
              ),
            ),
            StackButton(
              onTap: () {
                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(builder: (context) => AppHomePage()),
                //     (Route<dynamic> route) => false);
              },
              buttonName: "Home",
            )
          ],
        ));
  }
}