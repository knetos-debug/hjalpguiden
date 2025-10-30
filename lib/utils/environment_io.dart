import 'dart:io';

bool isFlutterTestEnvironmentImpl() =>
    Platform.environment['FLUTTER_TEST'] == 'true';
