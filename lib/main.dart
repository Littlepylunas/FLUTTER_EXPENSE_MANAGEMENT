import './redux/store.dart';
import './redux/view.dart';
import './screens/authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import './screens/expense_management_screen.dart';
import 'package:redux/redux.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final Store<AppState> store = Store<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
    );

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Expense Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.blueGrey,
          primaryColorLight: Colors.lightBlueAccent,
          primaryColorDark: Color(0xAAFF6666),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) =>
              AuthenticationScreen(title: 'Validate your fingerprint'),
          '/expense_management': (context) =>
              StoreConnector<AppState, ViewModel>(
                converter: (Store<AppState> store) => ViewModel.create(store),
                builder: (BuildContext ctx, ViewModel model) =>
                    ExpenseManagementScreen(model),
              ),
        },
      ),
    );
  }
}
