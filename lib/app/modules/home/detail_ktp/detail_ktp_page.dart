import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:penilaian/app/core/theme/theme.dart';
import 'package:penilaian/app/core/widgets/images/image_with_loader.dart';
import 'package:penilaian/app/core/widgets/text/warning_text.dart';
import 'package:penilaian/app/data/extensions/extensions.dart';
import 'package:penilaian/app/data/models/ktm_model.dart';
import 'package:penilaian/app/data/services/local_services/selected_local_services.dart';
import 'package:penilaian/app/routes/app_routes.dart';

import 'widgets/text_result_card.dart';

class DetailKtpPage extends StatefulWidget {
  const DetailKtpPage({
    super.key,
    required this.nikResult,
    required this.docKey,
  });

  final KtmModel nikResult;
  final String docKey;

  @override
  State<DetailKtpPage> createState() => _DetailKtpPageState();
}

class _DetailKtpPageState extends State<DetailKtpPage> {
  late final CollectionReference _alternatifRef;

  late final String _refKey;
  late KtmModel model;

  @override
  void initState() {
    super.initState();
    _refKey = context.get<SelectedLocalServices>().selected;
    model = widget.nikResult;
    _alternatifRef = FirebaseFirestore.instance.collection('$_refKey/alternatif');
  }

  Future<void> kirim() async {
    context.showLoadingIndicator();
    String key = widget.docKey.isEmpty ? 16.generateRandomString : widget.docKey;

    try {
      await _alternatifRef.doc(key).set(model.toJson());
      Modular.to.popUntil((p0) => p0.settings.name == AppRoutes.alternatifHome);
      context.showSnackbar(message: "Berhasil Membuat Alternatif!");
    } on firebase_core.FirebaseException catch (e) {
      context.showSnackbar(message: e.message ?? "Terjadi kesalahan", error: true, isPop: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail KTM'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            16.verticalSpacingRadius,
            const WarningText(
              text: "Klik pada bagian yang ingin diubah!",
            ).px(16),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              width: context.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ImageWithLoader(
                      imageUrl: widget.nikResult.foto,
                      width: 200,
                      size: 200,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  16.verticalSpacingRadius,
                  const Divider(color: Colors.black),
                  TextResultCard(
                    title: "NIK",
                    value: widget.nikResult.nim,
                    onChanged: (x) {
                      model = model.copyWith(nim: x);
                      setState(() {});
                    },
                  ),
                  const Divider(color: Colors.black),
                  TextResultCard(
                    title: "Nama",
                    value: widget.nikResult.nama,
                    onChanged: (x) {
                      model = model.copyWith(nama: x);
                      setState(() {});
                    },
                  ),
                  const Divider(color: Colors.black),
                  TextResultCard(
                    title: "TTL",
                    value: widget.nikResult.lahir,
                    onChanged: (x) {
                      model = model.copyWith(lahir: x);
                      setState(() {});
                    },
                  ),
                  const Divider(color: Colors.black),
                  TextResultCard(
                    title: "Prodi",
                    value: widget.nikResult.prodi,
                    onChanged: (x) {
                      model = model.copyWith(prodi: x);
                      setState(() {});
                    },
                  ),
                  const Divider(color: Colors.black),
                  TextResultCard(
                    title: "Jalan",
                    value: widget.nikResult.jalan,
                    onChanged: (x) {
                      model = model.copyWith(jalan: x);
                      setState(() {});
                    },
                  ),
                  const Divider(color: Colors.black),
                  TextResultCard(
                    title: "Dusun",
                    value: widget.nikResult.dusun,
                    onChanged: (x) {
                      model = model.copyWith(dusun: x);
                      setState(() {});
                    },
                  ),
                  const Divider(color: Colors.black),
                  TextResultCard(
                    title: "Kota/Kabupaten",
                    value: widget.nikResult.kota,
                    onChanged: (x) {
                      model = model.copyWith(kota: x);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            16.verticalSpacingRadius,
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorTheme.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          bottomLeft: Radius.circular(16.r),
                        ),
                      ),
                      textStyle: AppStyles.text16PxMedium,
                      minimumSize: Size(200.r, 48.r),
                    ),
                    onPressed: () {
                      Modular.to.pop();
                    },
                    child: widget.docKey.isEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.replay_rounded),
                              6.horizontalSpaceRadius,
                              const Text('Ulangi'),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.arrow_back_ios_new_rounded),
                              6.horizontalSpaceRadius,
                              const Text('Kembali'),
                            ],
                          ),
                  ),
                ),
                12.horizontalSpaceRadius,
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.r),
                          bottomRight: Radius.circular(16.r),
                        ),
                      ),
                      textStyle: AppStyles.text16PxMedium,
                      minimumSize: Size(200.r, 48.r),
                    ),
                    onPressed: () {
                      kirim();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Simpan'),
                        6.horizontalSpaceRadius,
                        const Icon(Icons.save_rounded),
                      ],
                    ),
                  ),
                ),
              ],
            ).px(16),
            16.verticalSpacingRadius,
          ],
        ),
      ),
    );
  }
}
