import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:penilaian/app/data/models/data_model.dart';
import 'package:penilaian/app/data/models/ktm_model.dart';

class PdfHelper {
  static Future<Uint8List> generateDocument(
      PdfPageFormat format, DataModel data, List<KtmModel> list) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: format,
          orientation: pw.PageOrientation.portrait,
          theme: pw.ThemeData.base(),
        ),
        build: (context) {
          return [
            pw.Column(
              children: [
                pw.Header(
                  level: 1,
                  text: data.name,
                ),
                pw.Paragraph(text: data.deskripsi),
                pw.TableHelper.fromTextArray(
                  data: [
                    ['Ranking', 'NIM', 'Nama', 'Nilai'],
                    ...list.map(
                      (e) => [
                        (list.indexOf(e) + 1).toString(),
                        e.nim,
                        e.nama,
                        e.nilai.toString(),
                      ],
                    )
                  ],
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                // pw.Table(
                //   border: pw.TableBorder.all(),
                //   defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                //   children: [
                //     pw.TableRow(
                //       children: [
                //         pw.Text('Ranking'),
                //         pw.Text('Nik'),
                //         pw.Text('Nama'),
                //         pw.Text('Nilai'),
                //       ],
                //     ),
                //     ...list.map((e) => pw.TableRow(
                //           children: [
                //             pw.Text(list.indexOf(e).toString()),
                //             pw.Text(e.nik ?? '-'),
                //             pw.Text(e.name ?? '-'),
                //             pw.Text(e.nilai.toString()),
                //           ],
                //         )),
                //   ],
                // ),
              ],
            ),
          ];
        },
      ),
    );
    return doc.save();
  }
}
