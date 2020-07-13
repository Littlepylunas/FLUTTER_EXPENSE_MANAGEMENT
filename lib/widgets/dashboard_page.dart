import '../redux/view.dart';
import '../screens/list_expense_screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../utils/global.dart';
import 'dashboard_widgets/MyBarChart.dart';
import 'package:flutter/material.dart';
import 'dashboard_widgets/MyLineChart.dart';
import 'dashboard_widgets/MyPieChart.dart';
import 'package:redux/redux.dart';

class DashboardPage extends StatelessWidget {
  final ViewModel model;

  DashboardPage(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                shadowColor: model.statsChartData['totalBalance'].round() >= 0
                    ? Colors.green
                    : Colors.red,
                elevation: 10,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5, right: 7),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.attach_money,
                            color:
                                model.statsChartData['totalBalance'].round() >=
                                        0
                                    ? Colors.green
                                    : Colors.red,
                          ),
                          Text(
                            'Total balance',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        Global.trans(
                            model.statsChartData['totalBalance'].round()),
                        style: TextStyle(
                          color:
                              model.statsChartData['totalBalance'].round() >= 0
                                  ? Colors.green
                                  : Colors.red,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 5),
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.attach_money,
                                  color: Theme.of(context).primaryColor,
                                  size: 16,
                                ),
                                Text(
                                  'Total input',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(2),
                            child: Text(
                              '+ ' +
                                  Global.trans(
                                    model.statsChartData['totalInput'].round(),
                                  ),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 5, left: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'with ',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (model.statsChartData['totalDebt'] !=
                                        0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StoreConnector<
                                              AppState, ViewModel>(
                                            converter:
                                                (Store<AppState> store) =>
                                                    ViewModel.create(store),
                                            builder: (BuildContext ctx,
                                                    ViewModel model) =>
                                                ListExpensiveScreen(
                                                    'Filter Expense List',
                                                    model,
                                                    null,
                                                    null,
                                                    ['Được cho mượn'],
                                                    null),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    ' ' +
                                        Global.trans(model
                                            .statsChartData['totalDebt']
                                            .round()) +
                                        ' ',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                Text(
                                  ' is in debt',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 5),
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.attach_money,
                                  color: Theme.of(context).primaryColorDark,
                                  size: 16,
                                ),
                                Text(
                                  'Total output',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(2),
                            child: Text(
                              '- ' +
                                  Global.trans(model
                                      .statsChartData['totalOutput']
                                      .round()),
                              style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 5, left: 5),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'with ',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (model.statsChartData['totalLoan'] !=
                                        0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StoreConnector<
                                              AppState, ViewModel>(
                                            converter:
                                                (Store<AppState> store) =>
                                                    ViewModel.create(store),
                                            builder: (BuildContext ctx,
                                                    ViewModel model) =>
                                                ListExpensiveScreen(
                                                    'Filter Expense List',
                                                    model,
                                                    null,
                                                    null,
                                                    ['Cho mượn'],
                                                    null),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    ' ' +
                                        Global.trans(model
                                            .statsChartData['totalLoan']
                                            .round()) +
                                        ' ',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                Text(
                                  ' is on loan',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Card(
                elevation: 3,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        'Three month later consumption',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: MyBarChart(
                        model,
                        // Disable animations for image tests.
                        animate: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Card(
                elevation: 3,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        'Expenses change in last 12 month',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: MyLineChart(
                        model.lineChartData,
                        // Disable animations for image tests.
                        animate: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Card(
                elevation: 3,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        'Expenses classify in all time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: MyPieChart(
                        model.pieChartData,
                        // Disable animations for image tests.
                        animate: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
