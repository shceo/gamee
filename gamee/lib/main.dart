import 'dart:async';
import 'package:flutter/material.dart';
import 'src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };
  runZonedGuarded<Future<void>>(
    () async {
      runApp(const GameeApp());
    },
    (error, stack) {
      debugPrint('Uncaught error: $error');
      debugPrintStack(stackTrace: stack);
    },
  );
}
