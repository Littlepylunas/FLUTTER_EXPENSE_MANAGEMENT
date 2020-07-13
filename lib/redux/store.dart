import '../models/Models.dart';
import '../redux/actions.dart';
import '../redux/view.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(items: itemReducer(state.items, action));
}

List<Expense> itemReducer(List<Expense> state, action) {
  if (action is AddExpenseAction) {
    List<Expense> items = []
      ..addAll(state)
      ..add(action.item);
    items.sort((a, b) => b.date.compareTo(a.date));

    return items;
  }

  if (action is UpdateExpenseAction) {
    List<Expense> items = []..addAll(state);
    var index = items.indexWhere((element) => element.id == action.item.id);
    items[index] = action.item;
    items.sort((a, b) => b.date.compareTo(a.date));

    return items;
  }

  if (action is DeleteExpenseAction) {
    List<Expense> items = []..addAll(state);
    items.remove(action.item);
    items.sort((a, b) => b.date.compareTo(a.date));

    return items;
  }

  if (action is GetAllExpenseAction) {
    List<Expense> items = []..addAll(action.items);
    items.sort((a, b) => b.date.compareTo(a.date));

    return items;
  }

  return state;
}
