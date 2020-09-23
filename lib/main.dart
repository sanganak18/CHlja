import 'package:flutter/material.dart';
import './widgets/category.dart';
import './widgets/iconName.dart';
import './screens/AccountList.dart';
import './providers/AccountProvider.dart';
import './screens/AccountForm.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (ctx) => AccountProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: MyApp(),
        ),
        routes: {
          AccountsList.routeName: (ctx) => AccountsList(),
          AccountForm.routeName: (ctx) => AccountForm(),
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Banks'),
        ),
        body: Center(
          child: Container(
            height: 400,
            width: 255,
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.values[4],
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Ink(
                          height: 66,
                          width: 66,
                          decoration: const ShapeDecoration(
                            shape: CircleBorder(),
                            color: Color(0x124A6075),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AccountsList(),
                                ),
                              );
                            },
                            icon: Image.asset(
                              "assets/images/Banks.png",
                              color: Color(0xFF4A6075),
                              height: 25,
                              width: 28,
                            ),
                          ),
                        ),
                        IconName('Account'),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Category("assets/images/loans.png"),
                        IconName('Loans'),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.values[4],
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Category("assets/images/passwords.png"),
                        IconName('Password'),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Category("assets/images/bills.png"),
                        IconName('Bills'),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Category("assets/images/fastag.png"),
                        IconName('Fastags'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
