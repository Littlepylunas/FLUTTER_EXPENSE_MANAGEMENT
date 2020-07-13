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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'One-touch Sign In',
              style: Theme.of(context).textTheme.headline4,
            ),
            Container(
              child: Text(
                'Please place your fingertip on the scanner to verify your identity',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              padding: EdgeInsets.all(50),
            ),
            Ink(
              decoration: const ShapeDecoration(
                color: Colors.lightBlue,
                shape: CircleBorder(),
              ),
              child: IconButton(
                  icon: Icon(Icons.fingerprint),
                  color: Colors.white,
                  onPressed: _handleAuthenticate),
              // padding: EdgeInsets.all(25),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                '(Press on icon above to reopen touch sensor)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
                    child: RaisedButton(
                      child: Text('Continue without indentity'),
                      onPressed: _gotoDashBoard,
                    ),
                  ),
                ],
              ),
              padding: EdgeInsets.all(15),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        child: Text(
          '(Fingerprint sign in makes your app login much faster. Your device should have at least one fingerprint registered in device settings)',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[500],
          ),
        ),
        padding: EdgeInsets.all(35),
      ),
    );
  }
}
