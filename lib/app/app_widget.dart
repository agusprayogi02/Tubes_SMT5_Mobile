import 'package:device_preview_minus/device_preview_minus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:penilaian/app/blocs/session/session_cubit.dart';
import 'package:penilaian/app/core/storage/storage_path.dart';
import 'package:penilaian/app/data/extensions/extensions.dart';
import 'package:penilaian/app/data/services/local_services/flavor_local_services.dart';
import 'package:penilaian/app/pages/connectivity/cubit/connectivity_cubit.dart';
import 'package:penilaian/app/pages/connectivity/cubit/connectivity_state.dart';

import 'core/theme/theme.dart';
import 'routes/app_routes.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final messengerKey = GlobalKey<ScaffoldMessengerState>();
  final sessionBloc = SessionCubit();
  final connectivityBloc = Modular.get<ConnectivityCubit>();
  final local = FlavorLocalServicesImpl();

  @override
  void initState() {
    super.initState();
    Modular.setInitialRoute('/');
    Modular.get<StoragePathInterface>().initialize();
    connectivityBloc.recheckInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityCubit>(create: (context) => connectivityBloc),
        BlocProvider(create: (context) => sessionBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ConnectivityCubit, ConnectivityState>(
            listener: (context, state) {
              if (state is ConnectivityNoInternetState) {
                context.to.pushNamed(AppRoutes.noInternet);
              }
            },
          ),
          BlocListener<SessionCubit, SessionState>(
            listener: (context, state) {
              if (state is SessionReadyState) {
                // var app = locator.get<App>();

                // Todo: rollbar
              }

              if (state is SessionNotReadyState) {
                context.to.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
              }

              if (state is SessionUnAuthorizedTokenState) {
                sessionBloc.deleteSession();
              }
            },
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          builder: (_, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              scaffoldMessengerKey: messengerKey,
              title: local.name,
              theme: colorTheme,
              locale: DevicePreview.locale(context),
              builder: DevicePreview.appBuilder,
              routeInformationParser: Modular.routeInformationParser,
              routerDelegate: Modular.routerDelegate,
            );
          },
        ),
      ),
    );
  }
}
