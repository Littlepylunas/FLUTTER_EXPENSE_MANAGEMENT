import 'package:flutter/material.dart';
import '../styles/AppStyles.dart';

class OthersPage extends StatefulWidget {
  OthersPage({Key key}) : super(key: key);

  @override
  _OthersPageState createState() => _OthersPageState();
}

class _OthersPageState extends State<OthersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/3.jpg"),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.only(bottom: 400),
            child: Text(
              'Comming soon',
              style: AppStyles.optionStyle,
            ),
          ),
        ),
      ),
    );
  }
}
