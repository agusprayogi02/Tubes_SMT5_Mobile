import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:penilaian/app/core/theme/theme.dart';
import 'package:penilaian/app/core/widgets/images/image_with_loader.dart';
import 'package:penilaian/app/data/extensions/extensions.dart';
import 'package:penilaian/app/data/models/ktm_model.dart';

import '../../../../core/widgets/button/icon_rounded_button.dart';

class AlternatifCard extends StatelessWidget {
  const AlternatifCard({
    super.key,
    required this.data,
    required this.number,
    this.onDelete,
    this.onEdit,
    this.onTap,
  });

  final KtmModel data;
  final int number;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (_) {
        onDelete?.call();
      },
      confirmDismiss: (direction) async {
        bool delete = false;
        final snackbarController = ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Yakin Ingin Hapus Kriteria ${data.nama}?'),
            action: SnackBarAction(label: 'Hapus', onPressed: () => delete = true),
          ),
        );
        await snackbarController.closed;
        return delete;
      },
      background: Container(
        color: ColorTheme.red,
        alignment: Alignment.centerRight,
        // padding: EdgeInsets.only(right: 16.w),
        child: const Icon(
          Icons.delete,
          color: ColorTheme.white,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 75.r,
          width: 1.sw,
          child: Row(
            children: [
              Container(
                height: 75.r,
                width: 44.r,
                decoration: BoxDecoration(
                  color: ColorTheme.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  number.toString(),
                  style: AppStyles.text18PxBold.copyWith(color: ColorTheme.white),
                ),
              ),
              8.horizontalSpaceRadius,
              Stack(
                fit: StackFit.loose,
                children: [
                  Container(
                    height: 75.r,
                    width: 24.r,
                    margin: EdgeInsets.only(left: 22.r),
                    decoration: const BoxDecoration(color: ColorTheme.primary),
                  ),
                  Positioned(
                    top: 12.r,
                    left: 0,
                    child: ImageWithLoader(
                      imageUrl: data.foto ?? "https://picsum.photos/200/300",
                      size: 45.r,
                      radius: 45.r,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  height: 75.r,
                  padding: 10.all,
                  decoration: const BoxDecoration(
                    color: ColorTheme.primary,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            data.nama ?? "-",
                            style: AppStyles.text16PxBold.copyWith(color: ColorTheme.white),
                          ).expand(),
                          Text.rich(
                            TextSpan(
                              text: "Status: ",
                              children: [
                                TextSpan(
                                  text: data.filled ? "Sudah Diisi!" : "Belum Diisi!",
                                  style: AppStyles.text14PxMedium.copyWith(
                                    color: ColorTheme.white,
                                    backgroundColor:
                                        data.filled ? ColorTheme.green : ColorTheme.red,
                                  ),
                                )
                              ],
                            ),
                            style: AppStyles.text14PxMedium.copyWith(color: ColorTheme.white),
                          )
                        ],
                      ).expand(),
                      IconRoundedButton(
                        icon: Icons.edit_square,
                        color: ColorTheme.orangeColor,
                        onTap: onEdit,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
