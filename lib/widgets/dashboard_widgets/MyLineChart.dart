import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/global.dart';

class MyLineChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  MyLineChart(this.seriesList, {this.animate});

  @override
  State<StatefulWidget> createState() => new _MyLineChart();
}

class _MyLineChart extends State<MyLineChart> {
  DateTime _time;
  Map<String, num> _measures;

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, num>{};
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.date;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.value;
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
    });
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      new SizedBox(
        height: 150.0,
        child: new charts.TimeSeriesChart(
          widget.seriesList,
          animate: widget.animate,
          primaryMeasureAxis: new charts.NumericAxisSpec(
            showAxisLine: true,
            tickProviderSpec:
                new charts.BasicNumericTickProviderSpec(desiredTickCount: 5),
          ),
          selectionModels: [
            new charts.SelectionModelConfig(
              type: charts.SelectionModelType.info,
              changedListener: _onSelectionChanged,
            )
          ],
        ),
      ),
    ];

    if (_time != null) {
      children.add(
        new Padding(
          padding: new EdgeInsets.only(top: 0.0),
          child: new Text(
            DateFormat('MM-yyyy').format(_time),
            style: TextStyle(
              color: Theme.of(context).primaryColorLight,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    _measures?.forEach((String series, num value) {
      children.add(
        new Text(
          '$series: ' + Global.trans(value.truncate().toInt()),
          style: TextStyle(
              color: series == 'Output'
                  ? Theme.of(context).primaryColorDark
                  : Theme.of(context).primaryColor),
        ),
      );
    });

    return new Column(children: children);
  }
}
