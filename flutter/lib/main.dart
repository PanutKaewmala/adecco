import 'dart:async';

import 'package:ahead_adecco/src/app.dart';
import 'package:ahead_adecco/src/config/export_config.dart';
import 'package:ahead_adecco/src/widgets/export_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// * old main
// Future<void> main() async {
//   // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//   WidgetsFlutterBinding.ensureInitialized();
//   Environments.setEnvironment(Environment.dev);
//   await Init.instance.initialize();
//   // FlutterNativeSplash.remove();

//   runZonedGuarded(() async {
//     await SentryFlutter.init((options) {
//       options.dsn = sentryUrl;
//       options.tracesSampleRate = 1.0;
//     });
//     // Future.delayed(
//     //     const Duration(seconds: 2), () => FlutterNativeSplash.remove());

//     runApp(const App());
//   }, (exception, stackTrace) async {
//     if (kReleaseMode) {
//       if (exception is OSError || exception is PlatformException) {
//         await Sentry.captureException(exception, stackTrace: stackTrace);
//         debugPrint("App exception: $exception $stackTrace");
//       }
//     }
//     debugPrint("App exception other: $exception $stackTrace");
//   });
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Environments.setEnvironment(Environment.dev);
  await Init.instance.initialize();
  if (kReleaseMode) {
    await Sentry.init(
      (options) {
        options.dsn = sentryUrl;
      },
      appRunner: () => runApp(const App()), // Init your App.
    );
  } else {
    runApp(const App());
  }
}
