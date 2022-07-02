// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rumblefowl/services/mail/hive_manager.dart';
import 'package:rumblefowl/ui/components/mailbox_settings_dialog.dart';
import 'package:rumblefowl/ui/screens/home_screen.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'services/mail/mail_test.dart';

final log = Logger('main');

Future<void> main() async {
  setupLogging();
  await HiveManager().init();
  runApp(const MyApp());
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
