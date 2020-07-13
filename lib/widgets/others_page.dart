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
      body: Center(
        child: Text(
          'Index 2: Comming soon',
          style: AppStyles.optionStyle,
        ),
      ),
    );
  }
}
