import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hjalpguiden/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // ignore: avoid_print
    print('FlutterError: ${details.exceptionAsString()}');
    if (details.stack != null) {
      // ignore: avoid_print
      print(details.stack);
    }
  };

  runZonedGuarded(() => runApp(const ProviderScope(child: HjalpguidenApp())), (
    error,
    stackTrace,
  ) {
    // ignore: avoid_print
    print('Uncaught zone error: $error');
    // ignore: avoid_print
    print(stackTrace);
  });
}
