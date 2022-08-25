import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../ui/strings.dart';
import 'model.dart';


class MainDataBooking with DiagnosticableTreeMixin {
  final MainModel parent;

  MainDataBooking({required this.parent});

  double _countM1 = 0;
  double _countM2 = 0;
  double _countM3 = 0;
  double _countM4 = 0;
  double _countM5 = 0;
  double _countM6 = 0;

  List<TotalData> chartCount = [];

  double _totalM1 = 0;
  double _totalM2 = 0;
  double _totalM3 = 0;
  double _totalM4 = 0;
  double _totalM5 = 0;
  double _totalM6 = 0;

  List<EarningDataForGraphics> data2 = [];

  getStat(){
    _countM1 = 0;
    _countM2 = 0;
    _countM3 = 0;
    _countM4 = 0;
    _countM5 = 0;
    _countM6 = 0;
    _totalM1 = 0;
    _totalM2 = 0;
    _totalM3 = 0;
    _totalM4 = 0;
    _totalM5 = 0;
    _totalM6 = 0;
    // print("main model booking - getStat <---------------------");
    for (var item in bookings){
      // print("item.finished=${item.finished} item.time=${item.time}");
      // if (!item.finished)
      //   continue;
      var _day = DateTime.now();
      if (_day.month == item.time.month && _day.year == item.time.year) {
        _countM1++;
        _totalM1+=item.total;
        // print("_day=$_day && item.time=${item.time} _countM1=$_countM1 id=${item.id}");
      }
      _day = _day.subtract(Duration(days: _day.day+1));
      if (_day.month == item.time.month && _day.year == item.time.year) {
        _countM2++;
        _totalM2+=item.total;
        // print("_day=$_day && item.time=${item.time} _countM2=$_countM2");
      }
      _day = _day.subtract(Duration(days: _day.day+1));
      if (_day.month == item.time.month && _day.year == item.time.year) {
        _countM3++;
        _totalM3+=item.total;
        // print("_day=$_day && item.time=${item.time} _countM3=$_countM3");
      }
      _day = _day.subtract(Duration(days: _day.day+1));
      if (_day.month == item.time.month && _day.year == item.time.year) {
        _countM4++;
        _totalM4+=item.total;
        // print("_day=$_day && item.time=${item.time} _countM4=$_countM4");
      }
      _day = _day.subtract(Duration(days: _day.day+1));
      if (_day.month == item.time.month && _day.year == item.time.year) {
        _countM5++;
        _totalM5+=item.total;
        // print("_day=$_day && item.time=${item.time} _countM5=$_countM5");
      }
      _day = _day.subtract(Duration(days: _day.day+1));
      if (_day.month == item.time.month && _day.year == item.time.year) {
        _countM6++;
        _totalM6+=item.total;
        // print("_day=$_day && item.time=${item.time} _countM6=$_countM6");
      }
    }
    // print("<---------------------");
    var _day = DateTime.now();
    initializeDateFormatting();
    chartCount = [
      TotalData(DateFormat.MMM(strings.locale).format(DateTime(_day.year, _day.month - 5, 1)), _countM6, Colors.red),
      TotalData(DateFormat.MMM(strings.locale).format(DateTime(_day.year, _day.month - 4, 1)), _countM5, Colors.red),
      TotalData(DateFormat.MMM(strings.locale).format(DateTime(_day.year, _day.month - 3, 1)), _countM4, Colors.red),
      TotalData(DateFormat.MMM(strings.locale).format(DateTime(_day.year, _day.month - 2, 1)), _countM3, Colors.red),
      TotalData(DateFormat.MMM(strings.locale).format(DateTime(_day.year, _day.month - 1, 1)), _countM2, Colors.red),
      TotalData(DateFormat.MMM(strings.locale).format(_day), _countM1, Colors.red),
    ];

    data2 = [
      EarningDataForGraphics(DateFormat.MMM(strings.locale).format(DateTime(_day.year, _day.month - 5, 1)), _totalM6),
      EarningDataForGraphics(DateFormat.MMM(strings.locale).format(DateTime(_day.year, _day.month - 4, 1)), _totalM5),
      EarningDataForGraphics(DateFormat.MMM(strings.locale).format(DateTime(_day.year, _day.month - 3, 1)), _totalM4),
      EarningDataForGraphics(DateFormat.MMM(strings.locale).format(DateTime(_day.year, _day.month - 2, 1)), _totalM3),
      EarningDataForGraphics(DateFormat.MMM(strings.locale).format(DateTime(_day.year, _day.month - 1, 1)), _totalM2),
      EarningDataForGraphics(DateFormat.MMM(strings.locale).format(DateTime(_day.year, _day.month, 1)), _totalM1),
    ];
  }

  setStatus(OrderData item){
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return;
    item.ver2 = true;
    item.history.add(StatusHistory(
        statusId: item.status,
        time: DateTime.now().toUtc(),
        byAdmin: true,
        activateUserId : user.uid
    ));

    String statusName = "";
    for (var st in appSettings.statuses)
      if (st.id == item.status)
        statusName = getTextByLocale(st.name, strings.locale);

    if (item.status == parent.completeStatus)
      item.finished = true;
    else
      item.finished = false;

    sendMessage(strings.get(416),  /// "Booking status was changed",
        "${strings.get(415)} $statusName\n" /// "Now status:",
            "${strings.get(114)}: ${item.id}",  /// "Id",
        item.customerId, true, appSettings.cloudKey);
  }

}

class TotalData {
  TotalData(this.year, this.sales, this.color);
  final String year;
  final double sales;
  final Color color;
}


class EarningDataForGraphics {
  EarningDataForGraphics(this.year, this.sales);

  final String year;
  final double sales;
}



