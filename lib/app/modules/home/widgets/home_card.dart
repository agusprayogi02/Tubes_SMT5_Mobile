import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:penilaian/app/core/theme/theme.dart';
import 'package:penilaian/app/core/widgets/color/hex_color.dart';
import 'package:penilaian/app/data/extensions/extensions.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.title,
    required this.subTitle,
    this.srcImg,
    this.color,
    this.onTap,
    this.onDelete,
    this.onChange,
  });

  final String title;
  final String subTitle;
  final String? color;
  final String? srcImg;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (_) => onDelete!(),
      confirmDismiss: (direction) async {
        bool delete = false;
        final snackbarController = ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Yakin Ingin Hapus Kriteria $title?'),
            action: SnackBarAction(label: 'Hapus', onPressed: () => delete = true),
          ),
        );
        await snackbarController.closed;
        return delete;
      },
      background: Container(
        color: ColorTheme.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.w),
        child: const Icon(
          Icons.delete,
          color: ColorTheme.white,
        ),
      ),
      child: Container(
        height: 210,
        width: context.width,
        padding: 16.all,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 2,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
          color: color != null && srcImg == null ? HexColor(color!) : Colors.black,
          image: color == null && srcImg != null
              ? DecorationImage(
                  image: AssetImage(srcImg ?? 'assets/img/desa.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.5,
                )
              : null,
          borderRadius: 10.rounded,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: AppStyles.text20PxBold.copyWith(color: Colors.white),
                ).expand(),
                8.horizontalSpaceRadius,
                InkWell(
                  onTap: onChange,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: 8.rounded,
                    ),
                    padding: 6.all,
                    child: const Icon(
                      Icons.mode_edit_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  subTitle,
                  style: AppStyles.text12Px.copyWith(
                    color: Colors.white,
                  ),
                ).expand(),
                8.horizontalSpaceRadius,
                OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 3),
                    disabledForegroundColor: Colors.grey,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text('Lihat', style: TextStyle(color: Colors.white)),
                ).sized(w: .2.sw)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
