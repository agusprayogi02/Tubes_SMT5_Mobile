import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:penilaian/app/blocs/session/session_cubit.dart';
import 'package:penilaian/app/core/permission/permission.dart';
import 'package:penilaian/app/core/theme/theme.dart';
import 'package:penilaian/app/core/widgets/base/base_app_bar.dart';
import 'package:penilaian/app/core/widgets/base/base_scaffold.dart';
import 'package:penilaian/app/core/widgets/text/no_found_widget.dart';
import 'package:penilaian/app/data/extensions/extensions.dart';
import 'package:penilaian/app/data/models/data_model.dart';
import 'package:penilaian/app/data/services/local_services/selected_local_services.dart';
import 'package:penilaian/app/routes/app_routes.dart';

import 'cubit/home_cubit.dart';
import 'widgets/home_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeCubit>();
  String file = '';
  late final CollectionReference _penilaianRef;
  late final User user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    _penilaianRef = FirebaseFirestore.instance.collection(user.uid);
    permission();
  }

  permission() async {
    await Modular.get<PermissionInterface>().camera();
    await Modular.get<PermissionInterface>().storage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: "Beranda",
        isBack: false,
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<SessionCubit>().deleteSession();
            },
            icon: const Icon(Icons.logout_rounded, color: ColorTheme.white),
            tooltip: "Logout",
          ).pOnly(right: 12),
        ],
      ),
      body: FirestorePagination(
        query: _penilaianRef.orderBy('created_at'),
        onEmpty: const NoFoundWidget(),
        isLive: true,
        itemBuilder: (context, snapshot, i) {
          final data =
              DataModel.fromMap(snapshot.data() as Map<Object?, Object?>);
          return HomeCard(
            title: data.name,
            subTitle: data.deskripsi,
            color: data.color,
            onDelete: () async {
              await _penilaianRef.doc(snapshot.id).delete();
            },
            onChange: () {
              showDialog(
                context: context,
                builder: (context) {
                  final nameCont = TextEditingController(text: data.name);
                  final textCont = TextEditingController(text: data.deskripsi);

                  return AlertDialog(
                    title: const Text('Ubah data'),
                    content: IntrinsicHeight(
                      child: Column(
                        children: [
                          TextField(
                            decoration:
                                GenerateTheme.inputDecoration("Nama Jenis"),
                            style: AppStyles.text16Px
                                .copyWith(color: ColorTheme.black),
                            controller: nameCont,
                          ),
                          16.verticalSpacingRadius,
                          TextField(
                            maxLines: 4,
                            decoration:
                                GenerateTheme.inputDecoration("Deskripsi"),
                            style: AppStyles.text16Px
                                .copyWith(color: ColorTheme.black),
                            controller: textCont,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          final model = data.copyWith(
                            name: nameCont.text,
                            deskripsi: textCont.text,
                            color: data.color,
                          );
                          _penilaianRef
                              .doc(snapshot.id)
                              .set(model.toMap())
                              .then((value) => Modular.to.pop());
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save_rounded),
                            Text('Simpan'),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            onTap: () async {
              final key = snapshot.id;
              await Modular.get<SelectedLocalServices>()
                  .setSelected("/${user.uid}/$key");
              Modular.to.pushNamed(AppRoutes.kriteriaHome);
            },
          ).py(8);
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah data',
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final nameCont = TextEditingController();
              final textCont = TextEditingController();

              return AlertDialog(
                title: const Text('Tambah data'),
                content: IntrinsicHeight(
                  child: Column(
                    children: [
                      TextField(
                        decoration: GenerateTheme.inputDecoration("Nama Jenis"),
                        style: AppStyles.text16Px
                            .copyWith(color: ColorTheme.black),
                        controller: nameCont,
                      ),
                      16.verticalSpacingRadius,
                      TextField(
                        maxLines: 4,
                        decoration: GenerateTheme.inputDecoration("Deskripsi"),
                        style: AppStyles.text16Px
                            .copyWith(color: ColorTheme.black),
                        controller: textCont,
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      final data = DataModel.initial(
                          nameCont.text, textCont.text, 6.randColor);
                      _penilaianRef
                          .doc()
                          .set(data.toMap())
                          .then((value) => context.to.pop());
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save_rounded),
                        Text('Simpan'),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
        // child: const Icon(Icons.qr_code_scanner_rounded),
        child: const Icon(
          Icons.add_circle_outline_outlined,
          size: 30,
        ),
      ),
    );
  }
}
