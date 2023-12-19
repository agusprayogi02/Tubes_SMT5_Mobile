import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension NumExtensionX on num {
  Duration get microseconds => Duration(microseconds: toInt());

  Duration get milliseconds => Duration(milliseconds: toInt());

  Duration get seconds => Duration(seconds: toInt());

  Duration get minutes => Duration(minutes: toInt());

  Duration get hours => Duration(hours: toInt());

  Duration get days => Duration(days: toInt());

  Future get delayedMicroSeconds async => Future.delayed(toInt().microseconds);

  Future get delayedMilliSeconds async => Future.delayed(toInt().milliseconds);

  Future get delayedSeconds async => Future.delayed(toInt().seconds);

  Future get delayedMinutes async => Future.delayed(toInt().minutes);

  Future get delayedHours async => Future.delayed(toInt().hours);

  Radius get circular => Radius.circular(toDouble().r);

  BorderRadius get rounded => BorderRadius.circular(toDouble().r);

  EdgeInsets get all => EdgeInsets.all(toDouble().r);

  num get round3 => num.parse((toDouble()).toStringAsFixed(3));

  /// half vertical and full horizontal
  EdgeInsets get allHalfV => EdgeInsets.symmetric(
        horizontal: toDouble().r,
        vertical: toDouble().r / 2,
      );

  /// half horizontal and full vertical
  EdgeInsets get allHalfH => EdgeInsets.symmetric(
        horizontal: toDouble().r / 2,
        vertical: toDouble().r,
      );

  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble().w);

  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble().h);

  Iterable<int> get range => Iterable<int>.generate(toInt());

  String get generateRandomString {
    var r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(toInt(), (index) => chars[r.nextInt(chars.length)])
        .join();
  }

  String get randColor {
    var r = Random();
    const chars = '0123456789ABC';
    return '#${List.generate(toInt(), (index) => chars[r.nextInt(chars.length)]).join()}';
  }
}

extension DoubleExtensionX on double {
  double get round3 => double.parse((toDouble()).toStringAsFixed(3));
}
