import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:penilaian/app/core/theme/theme.dart';

class KriteriaFormCard extends StatefulWidget {
  const KriteriaFormCard({
    super.key,
    required this.number,
    required this.onChanged,
    this.onDelete,
    this.onTap,
    this.name,
    this.w,
    this.isBenefit = true,
  });

  final int number;
  final Function(String name, String w) onChanged;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final String? name;
  final String? w;
  final bool isBenefit;

  @override
  State<KriteriaFormCard> createState() => _KriteriaFormCardState();
}

class _KriteriaFormCardState extends State<KriteriaFormCard> {
  final nameCont = TextEditingController();
  final wCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameCont.text = widget.name ?? "";
    wCont.text = widget.w ?? "";
  }

  onUpdate() {
    nameCont.text = widget.name ?? "";
    wCont.text = widget.w ?? "";
  }

  @override
  Widget build(BuildContext context) {
    onUpdate();
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (_) {
        widget.onDelete?.call();
      },
      confirmDismiss: (direction) async {
        bool delete = false;
        final snackbarController = ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Yakin Ingin Hapus Kriteria ${widget.number}?'),
            action:
                SnackBarAction(label: 'Hapus', onPressed: () => delete = true),
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
      child: InkWell(
        onTap: widget.onTap,
        child: Row(
          children: [
            Container(
              height: 48.r,
              width: 44.r,
              decoration: BoxDecoration(
                color: widget.isBenefit ? ColorTheme.primary : ColorTheme.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  bottomLeft: Radius.circular(10.r),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "${widget.number}",
                style: AppStyles.text16PxBold.copyWith(color: ColorTheme.white),
              ),
            ),
            10.horizontalSpaceRadius,
            Expanded(
              child: TextField(
                decoration: GenerateTheme.inputDecoration("Nama Kriteria"),
                style: AppStyles.text16Px.copyWith(color: ColorTheme.black),
                controller: nameCont,
                onSubmitted: (value) {
                  if (nameCont.text.isNotEmpty) {
                    final clear = wCont.text.replaceAll(RegExp(r'[^0-9.]'), '');
                    wCont.text = clear;
                    widget.onChanged(nameCont.text, clear);
                  }
                },
              ),
            ),
            10.horizontalSpaceRadius,
            SizedBox(
              width: 65,
              child: TextField(
                controller: wCont,
                decoration: GenerateTheme.inputDecoration("W"),
                keyboardType: TextInputType.number,
                style: AppStyles.text16Px.copyWith(color: ColorTheme.black),
                onChanged: (_) {
                  if (wCont.text.isNotEmpty) {
                    final clear = wCont.text.replaceAll(RegExp(r'[^0-9.]'), '');
                    wCont.text = clear;
                  }
                },
                onSubmitted: (value) {
                  if (wCont.text.isNotEmpty && nameCont.text.isNotEmpty) {
                    final clear = wCont.text.replaceAll(RegExp(r'[^0-9.]'), '');
                    wCont.text = clear;
                    widget.onChanged(nameCont.text, clear);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
