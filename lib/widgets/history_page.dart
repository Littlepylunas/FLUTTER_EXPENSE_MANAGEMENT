import 'package:expense_management/models/Models.dart';

import '../redux/view.dart';
import 'package:flutter/material.dart';
import '../widgets/history_widgets/expense_list.dart';

class HistoryPage extends StatelessWidget {
  final ViewModel model;
  HistoryPage(this.model);

  @override
  Widget build(BuildContext context) {
    List<Expense> list = []..addAll(model.items);
    list.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/2.jpg"),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: Center(
          child: ExpenseList(
            list,
            model.openModalExpense,
            model.removeExpense,
          ),
        ),
      ),
    );
  }
}
