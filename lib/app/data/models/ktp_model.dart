import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class KtpModel extends Equatable {
  ///Nik number
  final String? nik;

  /// name of the person
  final String? name;

  ///Gender type
  final String? gender;

  ///birthday date
  final String? bornDate;

  ///Province of country
  final String? province;

  ///City where live
  final String? city;

  ///Subdistrict where live
  final String? subdistrict;

  ///Unique code from the last digit number in nik
  final String? uniqueCode;

  ///Postal code of the subdistrict
  final String? postalCode;

  ///Age with output year, month and date
  final String? age;

  ///Age in year
  final int? ageYear;

  ///Age in month
  final int? ageMonth;

  ///Age in day
  final int? ageDay;

  ///Next birthday counters count from now
  final String? nextBirthday;

  ///Zodiac by born date
  final String? zodiac;

  /// Photo of the person
  final String? photo;

  /// penilaian sudah terisi
  final bool filled;

  /// nilai hasil penilaian
  final num nilai;

  const KtpModel({
    this.nik,
    this.name,
    this.gender,
    this.bornDate,
    this.province,
    this.city,
    this.subdistrict,
    this.uniqueCode,
    this.postalCode,
    this.age,
    this.ageYear,
    this.ageMonth,
    this.ageDay,
    this.nextBirthday,
    this.zodiac,
    this.photo,
    this.filled = false,
    this.nilai = 0,
  });

  KtpModel copyWith({
    ValueGetter<String?>? nik,
    ValueGetter<String?>? name,
    ValueGetter<String?>? gender,
    ValueGetter<String?>? bornDate,
    ValueGetter<String?>? province,
    ValueGetter<String?>? city,
    ValueGetter<String?>? subdistrict,
    ValueGetter<String?>? uniqueCode,
    ValueGetter<String?>? postalCode,
    ValueGetter<String?>? age,
    ValueGetter<int?>? ageYear,
    ValueGetter<int?>? ageMonth,
    ValueGetter<int?>? ageDay,
    ValueGetter<String?>? nextBirthday,
    ValueGetter<String?>? zodiac,
    ValueGetter<bool?>? valid,
    ValueGetter<String?>? photo,
    ValueGetter<bool?>? filled,
    num? nilai,
  }) {
    return KtpModel(
      nik: nik?.call() ?? this.nik,
      name: name?.call() ?? this.name,
      gender: gender?.call() ?? this.gender,
      bornDate: bornDate?.call() ?? this.bornDate,
      province: province?.call() ?? this.province,
      city: city?.call() ?? this.city,
      subdistrict: subdistrict?.call() ?? this.subdistrict,
      uniqueCode: uniqueCode?.call() ?? this.uniqueCode,
      postalCode: postalCode?.call() ?? this.postalCode,
      age: age?.call() ?? this.age,
      ageYear: ageYear?.call() ?? this.ageYear,
      ageMonth: ageMonth?.call() ?? this.ageMonth,
      ageDay: ageDay?.call() ?? this.ageDay,
      nextBirthday: nextBirthday?.call() ?? this.nextBirthday,
      zodiac: zodiac?.call() ?? this.zodiac,
      photo: photo?.call() ?? this.photo,
      filled: filled?.call() ?? this.filled,
      nilai: nilai ?? this.nilai,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nik': nik,
      'name': name,
      'gender': gender,
      'born_date': bornDate,
      'province': province,
      'city': city,
      'subdistrict': subdistrict,
      'unique_code': uniqueCode,
      'postal_code': postalCode,
      'age': age,
      'age_year': ageYear,
      'age_month': ageMonth,
      'age_day': ageDay,
      'next_birthday': nextBirthday,
      'zodiac': zodiac,
      'photo': photo,
      'filled': filled,
      'nilai': nilai,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  // factory KtpModel.fromScan(NIKModel item) {
  //   return KtpModel(
  //     nik: item.nik,
  //     age: item.age,
  //     ageDay: item.ageDay,
  //     ageMonth: item.ageMonth,
  //     ageYear: item.ageYear,
  //     bornDate: item.bornDate,
  //     city: item.city,
  //     gender: item.gender,
  //     nextBirthday: item.nextBirthday,
  //     postalCode: item.postalCode,
  //     province: item.province,
  //     subdistrict: item.subdistrict,
  //     uniqueCode: item.uniqueCode,
  //     zodiac: item.zodiac,
  //     filled: false,
  //     nilai: 0,
  //   );
  // }

  factory KtpModel.fromMap(Map<dynamic, dynamic> map) {
    return KtpModel(
      nik: map['nik'],
      name: map['name'],
      gender: map['gender'],
      bornDate: map['born_date'],
      province: map['province'],
      city: map['city'],
      subdistrict: map['subdistrict'],
      uniqueCode: map['unique_code'],
      postalCode: map['postal_code'],
      age: map['age'],
      ageYear: map['age_year']?.toInt(),
      ageMonth: map['age_month']?.toInt(),
      ageDay: map['age_day']?.toInt(),
      nextBirthday: map['next_birthday'],
      zodiac: map['zodiac'],
      photo: map['photo'],
      filled: map['filled'] ?? false,
      nilai: map['nilai'] ?? 0,
    );
  }

  @override
  List<Object?> get props {
    return [
      nik,
      name,
      gender,
      bornDate,
      province,
      city,
      subdistrict,
      uniqueCode,
      postalCode,
      age,
      ageYear,
      ageMonth,
      ageDay,
      nextBirthday,
      zodiac,
      photo,
      filled,
      nilai,
    ];
  }
}
