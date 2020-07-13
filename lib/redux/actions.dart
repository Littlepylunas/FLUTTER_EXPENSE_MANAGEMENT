import '../redux/view.dart';
import '../utils/SqfliteControl.dart';
import 'package:redux/redux.dart';
import '../models/Models.dart';

class AddExpenseAction {
  final Expense item;
  AddExpenseAction(this.item);
}

class UpdateExpenseAction {
  final Expense item;

  UpdateExpenseAction(this.item);
}

class DeleteExpenseAction {
  final Expense item;

  DeleteExpenseAction(this.item);
}

class GetAllExpenseAction {
  final List<Expense> items;

  GetAllExpenseAction(this.items);
}

Function getAllItems = (Store<AppState> store) async {
  print("_onGetAllExpense .....");
  var items =
      await SqfliteControl.instance.queryAllRows(SqfliteControl.tableExpense);
  store.dispatch(
      GetAllExpenseAction(items.map((e) => Expense.fromMap(e)).toList()));
};
