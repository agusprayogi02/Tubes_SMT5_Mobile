import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart'
    show IModularNavigator, Modular;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:penilaian/app/core/theme/theme.dart';
import 'package:penilaian/app/core/widgets/snackbar/top_snackbar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../core/widgets/base/base_loading_indicator.dart';
import 'num_extension.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  IModularNavigator get to => Modular.to;

  B get<B extends Object>({String? key}) => Modular.get();

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  Size get size => MediaQuery.of(this).size;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  void hideLoading() {
    if (Navigator.of(this).canPop()) {
      Navigator.of(this).pop();
    }
  }

  void showLoadingIndicator({
    bool barrierDismissible = false,
    Color barrierColor = Colors.black54,
    String message = "Please wait",
  }) {
    showDialog(
      context: this,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            width: 150.w,
            height: 150.h,
            color: Colors.white,
            child: BaseLoadingIndicator(
              color: ColorTheme.primary,
              semanticsLabel: message,
            ),
          ),
        ),
      ),
    );
  }

  void showSnackbar({
    required String message,
    bool error = false,
    bool isPop = false,
  }) {
    if (isPop) {
      hideLoading();
    }
    showTopSnackBar(
      Overlay.of(this),
      TopSnackBar(
        message: message,
        isSuccess: !error,
      ),
    );
  }

  void showSnackbarValidationError({
    required String title,
    required Map<String, dynamic> messages,
    bool error = false,
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Column(
            children: [
              Text(title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.spMin,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 10),
              ...messages.entries.map(
                (e) => Text(
                  e.value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.spMin,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: 10.rounded,
          ),
          backgroundColor: error
              ? ColorTheme.statusLightRed
              : ColorTheme.brandBackgroundLight,
          padding: EdgeInsets.zero,
          elevation: 0,
          duration: const Duration(seconds: 5),
          margin: EdgeInsets.all(20.r),
        ),
      );
  }
}
