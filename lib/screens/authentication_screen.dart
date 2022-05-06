import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:async';

class AuthenticationScreen extends StatefulWidget {
  AuthenticationScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  String _error = '';

  final LocalAuthentication _localAuthentication = LocalAuthentication();

  void _cancelAuthentication() {
    _localAuthentication.stopAuthentication();
  }

  Future<void> _handleAuthenticate() async {
    print('_handleAuthenticate()');
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate to show account balance",
        useErrorDialogs: false,
        stickyAuth: true,
      );
    } catch (e) {
      _error = e.toString();
    }
    if (!mounted) return;
    if (authenticated) {
      _cancelAuthentication();
      Navigator.pushReplacementNamed(context, '/expense_management');
    }
  }

  Future<void> _getBiometricsSupport() async {
    print('_getBiometricsSupport()');
    LocalAuthentication _localAuthentication = new LocalAuthentication();
    bool hasFingerPrintSupport = false;
    try {
      hasFingerPrintSupport = await _localAuthentication.canCheckBiometrics;
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
    if (!mounted) return;
    if (hasFingerPrintSupport) {
      await _handleAuthenticate();
    } else {
      setState(() {
        _error = 'Device does not support fingerprint';
      });
    }
  }

  void _gotoDashBoard() {
    Navigator.pushReplacementNamed(context, '/expense_management');
  }

  @override
  void initState() {
    _getBiometricsSupport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Container(
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/login_background.jpg"),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'One-touch Sign In',
                style: TextStyle(color: Colors.black87, fontSize: 30),
              ),
              Container(
                child: Text(
                  'Please place your fingertip on the scanner to verify your identity',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                padding: EdgeInsets.all(50),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 25, right: 5),
                child: IconButton(
                  icon: Icon(
                    Icons.fingerprint,
                    size: 50,
                  ),
                  color: Colors.black,
                  onPressed: _handleAuthenticate,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  '(Press on icon above to reopen touch sensor)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      '$_error',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red[500]),
                    ),
                    Visibility(
                      visible: _error != '',
                      // visible: true,
                      child: RaisedButton(
                        child: Text('Continue without indentity'),
                        onPressed: _gotoDashBoard,
                      ),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(15),
              ),
              Container(
                child: Text(
                  '(Fingerprint sign in makes your app login much faster. Your device should have at least one fingerprint registered in device settings)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                padding: EdgeInsets.all(35),
              ),
            ],
          ),
        ),
      ),
      // bottomSheet: Container(
      //   child: Text(
      //     '(Fingerprint sign in makes your app login much faster. Your device should have at least one fingerprint registered in device settings)',
      //     textAlign: TextAlign.center,
      //     style: TextStyle(
      //       color: Colors.grey[500],
      //     ),
      //   ),
      //   padding: EdgeInsets.all(35),
      // ),
    );
  }
}
