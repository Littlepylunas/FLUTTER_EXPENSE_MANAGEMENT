class Global {
  // Hàm convert từ số thành chữ ()
  static String toText(int value) {
    if (value < 1000) return '0.' + read(value, 'k');
    int billion = (value / 1000000000).truncate().toInt();
    int thousand = ((value % 1000000) / 1000).truncate().toInt();
    int million = ((value % 1000000000) / 1000000).truncate().toInt();
    String result =
        read(billion, "tỷ") + read(million, 'tr') + read(thousand, 'k');
    return result;
  }

  static String read(int value, String endContent) {
    switch (value) {
      case 0:
        return "";
      default:
        return value.toString() + endContent;
    }
  }

  static String trans(int value) {
    bool positive = false;
    String rtn = '';
    if (value < 0) {
      positive = true;
      value = value * -1;
    }
    var str = value.toString();
    var size = str.length;
    if (value >= 1000000000)
      rtn = (value / 1000000000).truncate().toInt().toString() +
          '.' +
          str.substring(size - 9, size - 6) +
          '.' +
          str.substring(size - 6, size - 3) +
          '.' +
          str.substring(size - 3, size);
    else if (value >= 1000000)
      rtn = (value / 1000000).truncate().toInt().toString() +
          '.' +
          str.substring(size - 6, size - 3) +
          '.' +
          str.substring(size - 3, size);
    else if (value >= 1000)
      rtn = (value / 1000).truncate().toInt().toString() +
          '.' +
          str.substring(size - 3, size);
    else
      rtn = value.toString();

    if (positive)
      return '- ' + rtn;
    else
      return rtn;
  }

  static DateTime getPrvMonth(DateTime date) {
    if (date.month == 1)
      return DateTime(date.year - 1, 12);
    else
      return DateTime(date.year, date.month - 1);
  }

  static bool compareMonth(DateTime a, DateTime b) {
    if (a.month == b.month && a.year == b.year)
      return true;
    else
      return false;
  }
}
