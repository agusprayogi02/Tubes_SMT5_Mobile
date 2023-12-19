import 'dart:convert' show utf8;
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:equatable/equatable.dart';
import 'package:penilaian/app/data/extensions/extensions.dart';
import 'package:penilaian/app/data/models/kriteria_model.dart';

part 'csv_load_state.dart';

class CsvLoadCubit extends Cubit<CsvLoadState> {
  CsvLoadCubit() : super(CsvLoadInitial());

  generateCsv() async {
    List<List<String>> data = [
      ["No.", "Name", "Roll No."],
      ["1", 3.generateRandomString, 3.generateRandomString],
      ["2", 3.generateRandomString, 3.generateRandomString],
      ["3", 3.generateRandomString, 3.generateRandomString]
    ];
    return const ListToCsvConverter().convert(data);
  }

  Future<void> loadKriteria(String filePath, String dbPath) async {
    emit(CsvLoadLoading());
    try {
      final input = File(filePath).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter(fieldDelimiter: ';'))
          .toList();
      // final csvData = await generateCsv();
      // final File file = File(filePath);
      // await file.writeAsString(csvData);
      // await OpenFilex.open(file.path);
      final kriteriaRef = FirebaseFirestore.instance.collection(dbPath);
      for (var i = 0; i < fields.length; i++) {
        final data = fields[i];
        if (i == 0) continue;
        var model = KriteriaModel.init();
        model = model.copyWith(
          name: data[0],
          w: num.parse(data[1].toString()),
          isBenefit:
              (data[2].toString().toLowerCase() == 'cost') ? false : true,
        );
        await kriteriaRef.doc().set(model.toMap());
      }
      emit(CsvLoadSuccess(fields));
    } catch (e) {
      print(e);
      emit(CsvLoadError(e.toString()));
    }
  }
}
