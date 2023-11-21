import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:penilaian/app/core/widgets/camera_overlay/camera_overlay_widget.dart';
import 'package:penilaian/app/data/extensions/extensions.dart';
import 'package:penilaian/app/modules/home/ktp_scan/cubit/ktp_scan_cubit.dart';
import 'package:penilaian/app/routes/app_routes.dart';

class KtpScanPage extends StatefulWidget {
  const KtpScanPage({super.key});

  @override
  State<KtpScanPage> createState() => _KtpScanPageState();
}

class _KtpScanPageState extends State<KtpScanPage> {
  final KtpScanCubit bloc = Modular.get<KtpScanCubit>();
  OverlayFormat format = OverlayFormat.cardID2;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocListener<KtpScanCubit, KtpScanState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is KtpScanLoading) {
            context.showLoadingIndicator();
          }
          if (state is KtpScanError) {
            context.showSnackbar(message: "NIK ditemukan", error: true, isPop: true);
          }
          if (state is KtpScanLoaded) {
            context.hideLoading();
            Modular.to.pushNamed(AppRoutes.KTP_RESULT, arguments: state.item);
            context.showSnackbar(message: "NIK ditemukan");
          }
        },
        child: Scaffold(
          body: FutureBuilder<List<CameraDescription>?>(
            future: availableCameras(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == null) {
                  return const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No camera found',
                        style: TextStyle(color: Colors.black),
                      ));
                }
                return CameraOverlayWidget(
                  snapshot.data!.first,
                  CardOverlay.byFormat(format),
                  (XFile file) async {
                    bloc.scanKtp(file.path);
                    // Modular.to.pop(file.path);
                  },
                  info:
                      'Position your ID card within the rectangle and ensure the image is perfectly readable.',
                  label: 'Scanning KTP',
                );
              } else {
                return const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Fetching cameras',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}