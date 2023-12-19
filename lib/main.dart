import 'package:device_preview_minus/device_preview_minus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_storage/get_storage.dart';
import 'package:penilaian/app/data/services/local_services/flavor_local_services.dart';

import 'app/app_module.dart';
import 'app/app_widget.dart';
import 'app/core/config/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final local = FlavorLocalServicesImpl();
  await local.setImage("assets/img/logo.png");
  await local.setName("Tentu Bisa");

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => ModularApp(
        module: AppModule(),
        child: const AppWidget(),
      ),
    ),
  );
}
