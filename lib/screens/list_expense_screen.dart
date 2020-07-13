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
      appBar: new AppBar(
        title: Text(title),
      ),
      body: Center(
        child: ExpenseList(
          model.filterExpense(expDate, expType, expName, expTitle),
          model.openModalExpense,
          model.removeExpense,
        ),
      ),
    );
  }
}
