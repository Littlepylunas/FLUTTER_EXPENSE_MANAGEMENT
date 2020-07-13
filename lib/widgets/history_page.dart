import '../redux/view.dart';
import 'package:flutter/material.dart';
import '../widgets/history_widgets/expense_list.dart';

class HistoryPage extends StatelessWidget {
  final ViewModel model;
  HistoryPage(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ExpenseList(
          model.items,
          model.openModalExpense,
          model.removeExpense,
        ),
      ),
    );
  }
}
