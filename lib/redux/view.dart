import 'dart:collection';
import 'package:charts_flutter/flutter.dart' as charts;
import '../utils/SqfliteControl.dart';
import 'package:intl/intl.dart';
import '../utils/global.dart';
import '../redux/actions.dart';
import '../widgets/history_widgets/modal_expense.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import '../models/Models.dart';

class AppState {
  final List<Expense> items;
  AppState({@required this.items});

  AppState.initialState() : items = List.unmodifiable([]);
}

//          <Expense>[
//           Expense(
//             id: DateTime.now().toString(),
//             content: Content(name: "Chi phí phát sinh", type: -1),
//             title: '+ ví',
//             amount: 2500000,
//             date: new DateTime(2020, 7, 7),
//             picture: '',
//           ),
//           Expense(
//             id: DateTime.now().toString(),
//             content: Content(name: "Được cho mượn", type: 1),
//             title: '++++++++++++',
//             amount: 1500000,
//             date: new DateTime(2020, 7, 3),
//             picture: '',
//           ),
//           Expense(
//             id: DateTime.now().toString(),
//             content: Content(name: "Được cho mượn", type: 1),
//             title: '++++++++++++',
//             amount: 2000000,
//             date: new DateTime(2020, 6, 17),
//             picture: '',
//           ),
//           Expense(
//             id: DateTime.now().toString(),
//             content: Content(name: "Chi phí phát sinh", type: -1),
//             title: '+ ví',
//             amount: 500000,
//             date: new DateTime(2020, 6, 7),
//             picture: '',
//           ),
//           Expense(
//             id: DateTime.now().toString(),
//             content: Content(name: "Cho mượn", type: -1),
//             title: '++++++++++++',
//             amount: 2500000,
//             date: new DateTime(2020, 6, 3),
//             picture: '',
//           ),
//           Expense(
//             id: DateTime.now().toString(),
//             content: Content(name: "Chi phí phát sinh", type: -1),
//             title: '+ ví',
//             amount: 2500000,
//             date: new DateTime(2020, 1, 11),
//             picture: '',
//           ),
//           Expense(
//             id: DateTime.now().toString(),
//             content: Content(name: "Tiêu dùng định kỳ", type: -1),
//             title: 'tiền nhà',
//             amount: 1500000,
//             date: new DateTime(2020, 1, 15),
//             picture: '',
//           ),
//           Expense(
//             id: DateTime.now().toString(),
//             content: Content(name: "Thu nhập", type: 1),
//             title: '+ others',
//             amount: 8000000,
//             date: new DateTime(2020, 1, 07),
//             picture: '',
//           ),
//         ]
class ViewModel {
  final List<Expense> items;
  final Function getAllExpense;
  final Function(Expense) addNewExpense;
  final Function(Expense) editExpense;
  final Function(Expense) removeExpense;
  final Function(String, int, List<String>, String) filterExpense;
  final Function(BuildContext, bool, Expense) openModalExpense;
  final Map<String, double> statsChartData;
  final List<charts.Series<BarChartModel, String>> barChartData;
  final List<charts.Series<LineChartModel, DateTime>> lineChartData;
  final List<charts.Series<PieChartModel, String>> pieChartData;

  ViewModel({
    this.items,
    this.getAllExpense,
    this.addNewExpense,
    this.editExpense,
    this.removeExpense,
    this.filterExpense,
    this.openModalExpense,
    this.statsChartData,
    this.barChartData,
    this.lineChartData,
    this.pieChartData,
  });

  factory ViewModel.create(Store<AppState> store) {
    //
    Function _onGetAllExpense = () async {
      var items = await SqfliteControl.instance
          .queryAllRows(SqfliteControl.tableExpense);
      print("_onGetAllExpense .....");
      store.dispatch(
          GetAllExpenseAction(items.map((e) => Expense.fromMap(e)).toList()));
    };

    Function _onAddNewExpense = (Expense _expense) async {
      Map<String, dynamic> row = _expense.toMap();
      print("_onAddNewExpense: ............................................");
      print(row.keys);
      print(row.values);

      var status = await SqfliteControl.instance
          .insert(row, SqfliteControl.tableExpense);
      print("_onAddNewExpense: " + (status != -1 ? 'Successed' : 'Failed'));

      if (_expense.picture != null) {
        var row2 = _expense.picture.toMap();
        var status2 = await SqfliteControl.instance
            .insert(row2, SqfliteControl.tablePicture);
        print("_onAddNewPicture: " + (status2 != -1 ? 'Successed' : 'Failed'));
      }

      store.dispatch(AddExpenseAction(_expense));
    };

    Function _onEditExpense = (Expense _expense) async {
      Map<String, dynamic> row = _expense.toMap();
      print("_onEditExpense: ............................................");
      print(row.keys);
      print(row.values);

      var status = await SqfliteControl.instance.update(
          row, SqfliteControl.tableExpense, SqfliteControl.columnExpenseId);
      print("_onEditExpense: " + (status != -1 ? 'Successed' : 'Failed'));

      if (_expense.picture != null) {
        var row2 = _expense.picture.toMap();
        var status2 = await SqfliteControl.instance.update(
            row2, SqfliteControl.tablePicture, SqfliteControl.columnPictureId);
        print("_onEditpicture: " + (status2 != -1 ? 'Successed' : 'Failed'));
      }

      store.dispatch(UpdateExpenseAction(_expense));
    };

    Function _onRemoveExpense = (Expense _expense) async {
      Map<String, dynamic> row = _expense.toMap();
      print("_onRemoveExpense: ............................................");
      print(row.keys);
      print(row.values);

      var status = await SqfliteControl.instance.delete(
          row, SqfliteControl.tableExpense, SqfliteControl.columnExpenseId);
      print("_onRemoveExpense: " + (status != -1 ? 'Successed' : 'Failed'));

      if (_expense.picture != null) {
        var row2 = _expense.picture.toMap();
        var status2 = await SqfliteControl.instance.delete(
            row2, SqfliteControl.tablePicture, SqfliteControl.columnPictureId);
        print("_onRemovePicture: " + (status2 != -1 ? 'Successed' : 'Failed'));
      }

      store.dispatch(DeleteExpenseAction(_expense));
    };

    Function _onOpenModalExpense =
        (BuildContext buildContext, bool type, Expense expense) async {
      await showModalBottomSheet(
        isScrollControlled: true,
        context: buildContext,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ModalExpense(
                type,
                expense,
                type ? _onAddNewExpense : _onEditExpense,
              ),
            ),
          );
        },
      );
    };

    _onfilterExpense(
        String date, int contentType, List<String> contentName, String title) {
      print("_onAddNewExpense: ............................................");
      List<Expense> items = []..addAll(store.state.items);
      List<Expense> rtnItems = [];
      items.forEach((element) {
        if ((date == null || element.date.contains(date)) &&
            (contentType == null || element.contentType == contentType) &&
            (contentName == null ||
                contentName.contains(element.contentName)) &&
            (title == null ||
                element.title.toLowerCase().contains(title.toLowerCase())))
          rtnItems.add(element);
      });

      rtnItems.sort((a, b) => b.date.compareTo(a.date));
      return rtnItems;
    }

    /// Get Charts Data
    Map<String, double> _onGetStatsChartData() {
      print(
          "_onGetStatsChartData: ............................................");
      double totalBalance = 0,
          totalInput = 0,
          totalDebt = 0,
          totalOutput = 0,
          totalLoan = 0;
      store.state.items.forEach((element) {
        // print(element.toMap().values);
        if (element.contentType == -1) {
          totalOutput += element.amount;
          if (element.contentName == 'Cho mượn') totalLoan += element.amount;
        } else if (element.contentType == 1) {
          totalInput += element.amount;
          if (element.contentName == 'Được cho mượn')
            totalDebt += element.amount;
        } else {}
      });
      totalBalance = totalInput - totalOutput;

      Map<String, double> _rtn = new HashMap();
      _rtn['totalBalance'] = totalBalance;
      _rtn['totalInput'] = totalInput;
      _rtn['totalDebt'] = totalDebt;
      _rtn['totalOutput'] = totalOutput;
      _rtn['totalLoan'] = totalLoan;
      return _rtn;
    }

    List<charts.Series<BarChartModel, String>> _onGetBarChartData() {
      print("_onGetBarChartData: ............................................");
      var curDate = DateTime.now();
      Map<String, ValueInMonth> values = new HashMap();
      for (int i = 0; i < 3; i++) {
        values[DateFormat('MM/yyyy').format(curDate)] = new ValueInMonth(0, 0);
        curDate = Global.getPrvMonth(curDate);
      }
      store.state.items.forEach((element) {
        DateTime dt = DateFormat('dd/MM/yyyy HH:mm:ss').parse(element.date);
        var elMonth = DateFormat('MM/yyyy').format(dt);
        if (values.containsKey(elMonth)) {
          if (element.contentType == 1) {
            values[elMonth].input += element.amount;
          } else if (element.contentType == -1) {
            values[elMonth].output += element.amount;
          } else {}
        }
      });

      List<BarChartModel> tableOutput = [];
      List<BarChartModel> tableInput = [];

      var sortedKeys = values.keys.toList()..sort((a, b) => b.compareTo(a));

      sortedKeys.forEach((key) {
        tableInput.add(new BarChartModel(key, values[key].input));
        tableOutput.add(new BarChartModel(key, values[key].output));
      });

      return [
        new charts.Series<BarChartModel, String>(
          id: 'Input',
          domainFn: (BarChartModel sales, _) => sales.month,
          measureFn: (BarChartModel sales, _) => sales.value,
          colorFn: (BarChartModel sales, _) =>
              charts.ColorUtil.fromDartColor(Colors.lightBlue),
          data: tableInput,
          labelAccessorFn: (BarChartModel sales, _) =>
              Global.trans(sales.value.truncate().toInt()),
        ),
        new charts.Series<BarChartModel, String>(
          id: 'Output',
          domainFn: (BarChartModel sales, _) => sales.month,
          domainLowerBoundFn: (BarChartModel sales, _) => sales.month,
          measureFn: (BarChartModel sales, _) => sales.value,
          colorFn: (BarChartModel sales, _) =>
              charts.ColorUtil.fromDartColor(Color(0xAAFF6666)),
          data: tableOutput,
          labelAccessorFn: (BarChartModel sales, _) =>
              Global.trans(sales.value.truncate().toInt()),
        ),
      ];
    }

    List<charts.Series<LineChartModel, DateTime>> _onGetLineChartData() {
      print(
          "_onGetLineChartData: ............................................");
      var curDate = new DateTime.now();
      var date = new DateTime(curDate.year, curDate.month);
      Map<DateTime, ValueInMonth> values = new HashMap();
      for (int i = 0; i < 12; i++) {
        values[date] = new ValueInMonth(0, 0);
        date = Global.getPrvMonth(date);
      }
      store.state.items.forEach((element) {
        DateTime dt = DateFormat('dd/MM/yyyy HH:mm:ss').parse(element.date);
        var elDate = new DateTime(dt.year, dt.month);
        if (values.containsKey(elDate)) {
          if (element.contentType == 1) {
            values[elDate].input += element.amount;
          } else if (element.contentType == -1) {
            values[elDate].output += element.amount;
          } else {}
        }
      });

      List<LineChartModel> tableOutput = [];
      List<LineChartModel> tableInput = [];

      var sortedKeys = values.keys.toList()..sort((a, b) => a.compareTo(b));

      sortedKeys.forEach((key) {
        // print(key);
        tableInput.add(new LineChartModel(
            new DateTime(key.year, key.month), values[key].input));
        tableOutput.add(new LineChartModel(
            new DateTime(key.year, key.month), values[key].output));
      });

      return [
        new charts.Series<LineChartModel, DateTime>(
          id: 'Input',
          domainFn: (LineChartModel sales, _) => sales.date,
          measureFn: (LineChartModel sales, _) => sales.value,
          data: tableInput,
        ),
        new charts.Series<LineChartModel, DateTime>(
          id: 'Output',
          domainFn: (LineChartModel sales, _) => sales.date,
          measureFn: (LineChartModel sales, _) => sales.value,
          data: tableOutput,
        )
      ];
    }

    List<charts.Series<PieChartModel, String>> _onGetPieChartData() {
      print("_onGetPieChartData: ............................................");
      Map<String, double> types = new HashMap();
      double sum = 0;
      store.state.items.forEach((element) {
        if (element.contentType == -1) {
          sum += element.amount;
          if (!types.containsKey(element.contentName)) {
            types[element.contentName] = 0;
          }
          types[element.contentName] += element.amount;
        }
      });
      List<PieChartModel> data = [];

      types.forEach((key, value) {
        data.add(new PieChartModel(
            key, value, double.parse((value * 100 / sum).round().toString())));
      });

      return [
        new charts.Series<PieChartModel, String>(
          id: 'Expense Types',
          domainFn: (PieChartModel types, _) => types.name,
          measureFn: (PieChartModel types, _) => types.value,
          labelAccessorFn: (PieChartModel types, _) =>
              types.percent.round().toString() + ' %',
          data: data,
        )
      ];
    }

    return ViewModel(
      items: store.state.items,
      getAllExpense: _onGetAllExpense,
      addNewExpense: _onAddNewExpense,
      editExpense: _onEditExpense,
      removeExpense: _onRemoveExpense,
      openModalExpense: _onOpenModalExpense,
      filterExpense: _onfilterExpense,
      statsChartData: _onGetStatsChartData(),
      barChartData: _onGetBarChartData(),
      lineChartData: _onGetLineChartData(),
      pieChartData: _onGetPieChartData(),
    );
  }
}
