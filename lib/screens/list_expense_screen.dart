import '../redux/view.dart';

import '../widgets/history_widgets/expense_list.dart';
import 'package:flutter/material.dart';

class ListExpensiveScreen extends StatelessWidget {
  final String title;
  final ViewModel model;

  final String expDate;
  final int expType;
  final List<String> expName;
  final String expTitle;

  ListExpensiveScreen(this.title, this.model, this.expDate, this.expType,
      this.expName, this.expTitle);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: new AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: Text(title),
      // ),
      body: Container(
        padding: EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/4.jpg"),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: Center(
          child: ExpenseList(
            model.filterExpense(expDate, expType, expName, expTitle),
            model.openModalExpense,
            model.removeExpense,
          ),
        ),
      ),
    );
  }
}
