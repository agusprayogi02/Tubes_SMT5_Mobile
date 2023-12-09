import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:penilaian/app/core/widgets/base/base_app_bar.dart';
import 'package:penilaian/app/core/widgets/base/base_loading_indicator.dart';
import 'package:penilaian/app/core/widgets/base/base_scaffold.dart';
import 'package:penilaian/app/core/widgets/text/no_found_widget.dart';
import 'package:penilaian/app/data/models/kriteria_model.dart';
import 'package:penilaian/app/data/models/penilaian_model.dart';
import 'package:penilaian/app/data/services/local_services/selected_local_services.dart';

import 'widgets/penilaian_form_card.dart';

class PenilaianPage extends StatefulWidget {
  const PenilaianPage({
    super.key,
    required this.altKey,
  });

  final String altKey;

  @override
  State<PenilaianPage> createState() => _PenilaianPageState();
}

class _PenilaianPageState extends State<PenilaianPage> {
  late final String _refKey;
  late final CollectionReference _penilaianRef;
  late final CollectionReference _kriteriaRef;
  bool filledAll = true;

  @override
  void initState() {
    super.initState();
    _refKey = Modular.get<SelectedLocalServices>().selected;
    _penilaianRef = FirebaseFirestore.instance.collection('$_refKey/penilaian/${widget.altKey}');
    _kriteriaRef = FirebaseFirestore.instance.collection('$_refKey/kriteria');
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const BaseAppBar(
        title: 'Penilaian',
      ),
      body: FutureBuilder(
          future: _penilaianRef.get(),
          builder: (context, snapshot) {
            final Map<String, num> inputs = {};
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isNotEmpty) {
                final stream = snapshot.data!.docs;
                stream.map((e) {
                  final val = e.data() as Map<dynamic, dynamic>;
                  inputs[e.id] = val['nilai'] ?? 0;
                });
              }
              return FirestorePagination(
                query: _kriteriaRef.orderBy('created_at'),
                onEmpty: const NoFoundWidget(),
                itemBuilder: (context, snap, i) {
                  final data = KriteriaModel.fromMap(snap.data() as Map<Object?, Object?>);
                  return PenilaianFormCard(
                    label: data.name,
                    value: inputs[snap.id].toString(),
                    onChanged: (value) {
                      PenilaianModel model =
                          PenilaianModel.initial(snap.id, double.tryParse(value) ?? 0);
                      _penilaianRef.doc(snap.id).set(model.toJson());
                    },
                  );
                },
              );
            } else {
              return const BaseLoadingIndicator();
            }
          }),
    );
  }
}
