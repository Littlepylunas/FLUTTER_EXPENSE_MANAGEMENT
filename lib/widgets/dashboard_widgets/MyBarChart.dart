import 'package:charts_flutter/flutter.dart';
import '../../redux/view.dart';
import '../../screens/list_expense_screen.dart';
import 'package:redux/redux.dart';

/// Bar chart example
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MyBarChart extends StatelessWidget {
  final ViewModel model;
  final bool animate;

  MyBarChart(this.model, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new BarChart(
      model.barChartData,
      animate: animate,
      animationDuration: Duration(milliseconds: 1000),
      barGroupingType: BarGroupingType.grouped,
      selectionModels: [
        SelectionModelConfig(updatedListener: (SelectionModel slModel) {
          if (slModel.hasDatumSelection) {
            int type = slModel.selectedSeries[0].id == 'Input' ? 1 : -1;
            String month = slModel.selectedSeries[0]
                .domainFn(slModel.selectedDatum[0].index);
            double value = slModel.selectedSeries[0]
                .measureFn(slModel.selectedDatum[0].index);
            if (value != 0)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoreConnector<AppState, ViewModel>(
                    converter: (Store<AppState> store) =>
                        ViewModel.create(store),
                    builder: (BuildContext ctx, ViewModel model) =>
                        ListExpensiveScreen('Filter Expense List', model, month,
                            type, null, null),
                  ),
                ),
              );
          }
        })
      ],
      vertical: false,
      barRendererDecorator: new BarLabelDecorator<String>(
        labelAnchor: BarLabelAnchor.end,
        labelPosition: BarLabelPosition.auto,
      ),
      primaryMeasureAxis: new NumericAxisSpec(
        showAxisLine: true,
        tickProviderSpec: new BasicNumericTickProviderSpec(desiredTickCount: 4),
      ),
      domainAxis: new OrdinalAxisSpec(
        // Make sure that we draw the domain axis line.
        showAxisLine: true,
        // But don't draw anything else.
        // renderSpec: new NoneRenderSpec(),
      ),
    );
  }
}
