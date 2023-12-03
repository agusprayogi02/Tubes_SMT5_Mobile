import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:penilaian/app/core/theme/theme.dart';
import 'package:penilaian/app/core/widgets/base/base_app_bar.dart';
import 'package:penilaian/app/core/widgets/base/base_scaffold.dart';
import 'package:penilaian/app/data/extensions/extensions.dart';

import 'widgets/kriteria_form_card.dart';

class KriteriaPage extends StatefulWidget {
  const KriteriaPage({super.key});

  @override
  State<KriteriaPage> createState() => _KriteriaPageState();
}

class _KriteriaPageState extends State<KriteriaPage> {
  final List<String> listKriteria = [8.generateRandomString];

  late DatabaseReference _kriteriaRef;

  @override
  void initState() {
    super.initState();
    _kriteriaRef = FirebaseDatabase.instance.ref('kriteria');
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const BaseAppBar(
        title: "Kreteria",
      ),
      body: FirebaseAnimatedList(
        query: _kriteriaRef,
        itemBuilder: (context, snapshot, anim, i) {
          final data = snapshot.value as Map<Object?, Object?>;
          return KriteriaFormCard(
            number: i + 1,
            name: "${data['name']}",
            w: "${data['w']}",
            onChanged: (name, w) {
              _kriteriaRef.child(snapshot.key!).update({
                'name': name,
                'w': w,
              });
            },
            onDelete: () {
              _kriteriaRef.child(snapshot.key!).remove();
            },
          ).py(8);
        },
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
                  _kriteriaRef.child(8.generateRandomString).set({
                    'name': '',
                    'w': 0,
                  });
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
                onPressed: () {},
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
            12.horizontalSpaceRadius,
          ],
        ),
      ),
    );
  }
}
