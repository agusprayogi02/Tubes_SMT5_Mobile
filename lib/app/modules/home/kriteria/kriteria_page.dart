import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:penilaian/app/core/theme/theme.dart';
import 'package:penilaian/app/core/widgets/base/base_app_bar.dart';
import 'package:penilaian/app/core/widgets/base/base_scaffold.dart';
import 'package:penilaian/app/core/widgets/text/no_found_widget.dart';
import 'package:penilaian/app/data/extensions/extensions.dart';
import 'package:penilaian/app/data/models/kriteria_model.dart';
import 'package:penilaian/app/data/services/local_services/selected_local_services.dart';
import 'package:penilaian/app/routes/app_routes.dart';

import '../../../core/widgets/text/warning_text.dart';
import 'widgets/kriteria_form_card.dart';

class KriteriaPage extends StatefulWidget {
  const KriteriaPage({
    super.key,
  });

  @override
  State<KriteriaPage> createState() => _KriteriaPageState();
}

class _KriteriaPageState extends State<KriteriaPage> {
  final List<String> listKriteria = [16.generateRandomString];

  late CollectionReference _kriteriaRef;
  late String _refKey;

  @override
  void initState() {
    super.initState();
    _refKey = Modular.get<SelectedLocalServices>().selected;
    _kriteriaRef = FirebaseFirestore.instance.collection('$_refKey/kriteria');
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const BaseAppBar(
        title: "Kriteria",
      ),
      body: Column(
        children: [
          const WarningText(
            text:
                "Untuk menentukan jenis kriteria, dapat diklik bagian kotak nomor. Jika berwarna biru maka kriteria benefit dan berwarna merah untuk cost.",
          ),
          12.verticalSpacingRadius,
          FirestorePagination(
            query: _kriteriaRef.orderBy('created_at'),
            isLive: true,
            onEmpty: const NoFoundWidget(),
            itemBuilder: (context, snapshot, i) {
              final data = KriteriaModel.fromMap(snapshot.data() as Map<Object?, Object?>);
              return KriteriaFormCard(
                number: i + 1,
                name: data.name,
                w: "${data.w}",
                isBenefit: data.isBenefit,
                onChanged: (name, w) {
                  _kriteriaRef.doc(snapshot.id).update(data
                      .copyWith(
                        name: name,
                        w: double.tryParse(w),
                      )
                      .toMap());
                },
                onDelete: () async {
                  await _kriteriaRef.doc(snapshot.id).delete();
                },
                onTap: () {
                  _kriteriaRef
                      .doc(snapshot.id)
                      .update(data.copyWith(isBenefit: !data.isBenefit).toMap());
                },
              ).py(8);
            },
          ).expand(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: 16.all.copyWith(top: 0),
        child: Row(
          children: [
            12.horizontalSpaceRadius,
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorTheme.green,
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
                  final v = KriteriaModel.init();
                  _kriteriaRef.doc(16.generateRandomString).set(v.toMap());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_box_outlined),
                    6.horizontalSpaceRadius,
                    const Text('Tambah'),
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
                  context.to.pushNamed(AppRoutes.alternatifHome);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Alternatif'),
                    6.horizontalSpaceRadius,
                    const Icon(Icons.format_align_center_rounded),
                  ],
                ),
              ),
            ),
            12.horizontalSpaceRadius,
          ],
        ),
      ),
    );
  }
}
