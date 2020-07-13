import 'global.dart';

abstract class Currency {
  double value;
  int base;

  Currency(this.value, @override this.base);

  String valueStandardized() {
    return '\$ + ${value.toString()}';
  }
}

class VND extends Currency {
  int base = 1;
  VND(double value) : super(value, 1);

  @override
  String valueStandardized() {
    if (value >= 10 ^ 12) return '>>';
    return Global.toText(value.truncate().toInt());
  }
}

class USD extends Currency {
  int base = 22500;

  USD(double value) : super(value, 22500);

  @override
  String valueStandardized() {
    return '\$ + ${value.toString()}';
  }
}
