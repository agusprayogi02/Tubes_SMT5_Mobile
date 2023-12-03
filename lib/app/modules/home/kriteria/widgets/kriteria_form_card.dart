import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:penilaian/app/core/theme/theme.dart';

class KriteriaFormCard extends StatefulWidget {
  const KriteriaFormCard({
    super.key,
    required this.number,
    required this.onChanged,
    this.onDelete,
    this.name,
    this.w,
  });

  final int number;
  final Function(String name, String w) onChanged;
  final VoidCallback? onDelete;
  final String? name;
  final String? w;

  @override
  State<KriteriaFormCard> createState() => _KriteriaFormCardState();
}

class _KriteriaFormCardState extends State<KriteriaFormCard> {
  final nameCont = TextEditingController();
  final wCont = TextEditingController();
  bool delete = false;

  @override
  void initState() {
    super.initState();
    nameCont.text = widget.name ?? "";
    wCont.text = widget.w ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onDoubleTap: () {
            setState(() {
              delete = !delete;
            });
          },
          onTap: delete
              ? () {
                  widget.onDelete?.call();
                  setState(() {
                    delete = !delete;
                  });
                }
              : null,
          child: Container(
            height: 48.r,
            width: 44.r,
            decoration: BoxDecoration(
              color: delete ? ColorTheme.red : ColorTheme.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                bottomLeft: Radius.circular(10.r),
              ),
            ),
            alignment: Alignment.center,
            child: delete
                ? const Icon(
                    Icons.delete_rounded,
                    color: ColorTheme.white,
                    size: 30,
                  )
                : Text(
                    "${widget.number}",
                    style: AppStyles.text14Px.copyWith(color: ColorTheme.white),
                  ),
          ),
        ),
        10.horizontalSpaceRadius,
        Expanded(
          child: TextField(
            decoration: GenerateTheme.inputDecoration("Nama Kriteria"),
            style: AppStyles.text16Px.copyWith(color: ColorTheme.black),
            controller: nameCont,
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
                final clear = wCont.text.replaceAll(RegExp(r'[^0-9]'), '');
                wCont.text = clear;
              }
            },
            onSubmitted: (value) {
              if (wCont.text.isNotEmpty && nameCont.text.isNotEmpty) {
                final clear = wCont.text.replaceAll(RegExp(r'[^0-9]'), '');
                wCont.text = clear;
                widget.onChanged(nameCont.text, clear);
              }
            },
          ),
        ),
      ],
    );
  }
}