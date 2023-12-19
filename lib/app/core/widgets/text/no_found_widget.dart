import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:penilaian/app/core/theme/theme.dart';

class NoFoundWidget extends StatelessWidget {
  const NoFoundWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline_rounded,
              size: 64.r, color: ColorTheme.greyScale50),
          12.verticalSpacingRadius,
          Text(
            "Data kosong",
            style: AppStyles.text16PxMedium
                .copyWith(color: ColorTheme.greyScale50),
          ),
        ],
      ),
    );
  }
}
