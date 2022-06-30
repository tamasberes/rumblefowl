// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rumblefowl/ui/screens/home_screen.dart';
import 'package:logging/logging.dart';

import 'services/mail/mail_test.dart';

Future<void> main() async {
  setupLogging();
  runApp(const MyApp());
  await MailHelper().init();
}

void setupLogging() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('${record.time}: ${record.level.name}-${record.loggerName}: ${record.message}');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demooh',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const HomeScreen(),
    );
  }
}
