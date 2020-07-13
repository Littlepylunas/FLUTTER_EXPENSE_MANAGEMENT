import '../utils/SqfliteControl.dart';

class Content {
  String name;
  int type;

  Content({this.name, this.type});
}

class Picture {
  String id;
  String base64;

  Picture({this.id, this.base64});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      SqfliteControl.columnPictureId: id,
      SqfliteControl.columnBase64: base64,
    };

    return map;
  }

  Picture.fromMap(Map<String, dynamic> map) {
    id = map[SqfliteControl.columnPictureId].toString();
    base64 = map[SqfliteControl.columnBase64];
  }
}

class Expense {
  String id;
  String contentName;
  int contentType;
  String title;
  double amount;
  String date;
  String pictureId;
  Picture picture;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      SqfliteControl.columnExpenseId: id,
      SqfliteControl.columnContentName: contentName,
      SqfliteControl.columnContentType: contentType,
      SqfliteControl.columnTitle: title,
      SqfliteControl.columnAmount: num.parse(amount.toString()),
      SqfliteControl.columnDate: date,
      SqfliteControl.columnPictureCode: pictureId,
    };

    return map;
  }

  Expense.fromMap(Map<String, dynamic> map) {
    id = map[SqfliteControl.columnExpenseId].toString();
    contentName = map[SqfliteControl.columnContentName];
    contentType = map[SqfliteControl.columnContentType];
    title = map[SqfliteControl.columnTitle];
    amount = double.parse(map[SqfliteControl.columnAmount].toString());
    date = map[SqfliteControl.columnDate];
    pictureId = map[SqfliteControl.columnPictureCode];
  }

  Expense({
    this.id,
    this.contentName,
    this.contentType,
    this.title,
    this.amount,
    this.date,
    this.pictureId,
    this.picture,
  });
}

/// Sample ordinal data type.
class BarChartModel {
  final String month;
  final double value;

  BarChartModel(this.month, this.value);
}

/// Sample ordinal data type.
class PieChartModel {
  final String name;
  final double value;
  final double percent;

  PieChartModel(this.name, this.value, this.percent);
}

/// Sample ordinal data type.
class LineChartModel {
  final DateTime date;
  final double value;

  LineChartModel(this.date, this.value);
}

class ValueInMonth {
  double input;
  double output;

  ValueInMonth(this.input, this.output);
}
