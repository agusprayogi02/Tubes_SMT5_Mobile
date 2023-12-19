import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:penilaian/app/blocs/session/session_cubit.dart';
import 'package:penilaian/app/core/theme/theme.dart';
import 'package:penilaian/app/data/extensions/extensions.dart';
import 'package:penilaian/app/routes/app_routes.dart';

import '../../data/services/local_services/flavor_local_services.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final local = FlavorLocalServicesImpl();

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));
    // ignore: use_build_context_synchronously
    context.read<SessionCubit>().checkSession();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('/base_url').doc('URLKU').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          local.setBaseUrl(snapshot.data!.data()?['url']);
          _init();
          return BlocListener<SessionCubit, SessionState>(
            listener: (context, state) {
              if (state is SessionReadyState) {
                context.to.pushReplacementNamed(AppRoutes.home);
              } else {
                context.to.pushReplacementNamed(AppRoutes.login);
              }
            },
            child: Scaffold(
              backgroundColor: ColorTheme.primary,
              body: SafeArea(
                child: Center(
                  child: Image.asset(
                    local.image,
                    width: 250.r,
                  ),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: ColorTheme.primary,
          body: SafeArea(
            child: Center(
              child: Image.asset(
                local.image,
                width: 250.r,
              ),
            ),
          ),
        );
      },
    );
  }
}
