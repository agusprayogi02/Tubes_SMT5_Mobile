import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:penilaian/app/core/theme/theme.dart';

class PenilaianFormCard extends StatelessWidget {
  PenilaianFormCard({
    super.key,
    required this.label,
    required this.onChanged,
    this.value,
  });

  final String? value;
  final String label;
  final ValueChanged<String> onChanged;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = (value ?? "").replaceAll(RegExp(r'[^0-9.]'), '');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: label,
              ),
              TextSpan(
                text: "*",
                style:
                    AppStyles.text16PxSemiBold.copyWith(color: ColorTheme.red),
              ),
            ],
          ),
          style: AppStyles.text16PxSemiBold.copyWith(color: ColorTheme.primary),
        ),
        8.verticalSpacingRadius,
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: AppStyles.text18Px.copyWith(color: ColorTheme.neutral[800]),
          decoration: GenerateTheme.inputDecoration("Masukkan $label"),
          onSubmitted: (_) {
            if (controller.text.isNotEmpty) {
              final clear = controller.text.replaceAll(RegExp(r'[^0-9.]'), '');
              controller.text = clear;
              onChanged.call(controller.text);
            }
          },
        ),
        16.verticalSpacingRadius,
      ],
    );
  }
}
