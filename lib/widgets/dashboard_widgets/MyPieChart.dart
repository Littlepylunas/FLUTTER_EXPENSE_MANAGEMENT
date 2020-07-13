import 'package:charts_flutter/flutter.dart';
import '../../redux/view.dart';
import '../../screens/list_expense_screen.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_redux/flutter_redux.dart';

/// Example that shows how to build a datum legend that shows measure values.
///
/// Also shows the option to provide a custom measure formatter.
class MyPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  MyPieChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 60,
        arcRendererDecorators: [
          new charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.auto,
          ),
        ],
      ),
      selectionModels: [
        SelectionModelConfig(updatedListener: (SelectionModel slModel) {
          if (slModel.hasDatumSelection) {
            int type = slModel.selectedSeries[0].id == 'Input' ? 1 : -1;
            String contentName = slModel.selectedSeries[0]
                .domainFn(slModel.selectedDatum[0].index);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoreConnector<AppState, ViewModel>(
                  converter: (Store<AppState> store) => ViewModel.create(store),
                  builder: (BuildContext ctx, ViewModel model) =>
                      ListExpensiveScreen('Filter Expense List', model, null,
                          type, [contentName], null),
                ),
              ),
            );
          }
        })
      ],
      behaviors: [
        new charts.DatumLegend(
          entryTextStyle: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.ColorUtil.fromDartColor(Colors.blueGrey),
          ),
          position: charts.BehaviorPosition.end,
          horizontalFirst: false,
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          showMeasures: false,
          measureFormatter: (num value) {
            return value == null ? '-' : '${value}k';
          },
        ),
      ],
    );
  }
}
