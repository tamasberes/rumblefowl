// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:rumblefowl/services/db/hive_manager.dart';
import 'package:rumblefowl/services/prerferences/preferences_manager.dart';
import 'package:rumblefowl/ui/screens/home_screen.dart';

final log = Logger('main');

Future<void> main() async {
  setupLogging();
  await HiveManager().init();
  await PreferencesManager().init();
  runApp(const MyApp());
  doWhenWindowReady(() {
    const initialSize = Size(800, 600);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = "rumblefowl";
    appWindow.show();
  });
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}

final buttonColors = WindowButtonColors(iconNormal: const Color(0xFF805306), mouseOver: const Color(0xFFF6A00C), mouseDown: const Color(0xFF805306), iconMouseOver: const Color(0xFF805306), iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(mouseOver: const Color(0xFFD32F2F), mouseDown: const Color(0xFFB71C1C), iconNormal: const Color(0xFF805306), iconMouseOver: Colors.white);

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
    PreferencesManager changeNotifierProviderInstance = PreferencesManager();

    return ChangeNotifierProvider(
        create: (_) => changeNotifierProviderInstance,
        child: Consumer<PreferencesManager>(
            builder: (context, theme, _) => MaterialApp(
                title: 'Flutter Demooh',
                theme: getTheme(),
                home: Scaffold(
                  body: Column(
                    children: [
                      Container(color: Colors.amber.shade400,
                        child: WindowTitleBarBox(
                            child: Row(
                          children: [Expanded(child: MoveWindow()), const WindowButtons()],
                        )),
                      ),
                      const Expanded(child: HomeScreen())
                    ],
                  ),
                ))));
  }

  getTheme() {
    return PreferencesManager().getIsDarkMode() ? getDarkTheme() : getLightTheme();
  }

  ThemeData getLightTheme() {
    return ThemeData.from(useMaterial3: true, colorScheme: const ColorScheme.light());
  }

  ThemeData getDarkTheme() {
    return ThemeData.from(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
            background: Color(0xff1d1b1e),
            error: Color(0xffffb4a9),
            errorContainer: Color(0xff930006),
            inversePrimary: Color(0xff7b4998),
            inverseSurface: Color(0xffe8e1e5),
            onBackground: Color(0xffe8e1e5),
            onError: Color(0xff680003),
            onErrorContainer: Color(0xffffb4a9),
            onInverseSurface: Color(0xff322f32),
            onPrimary: Color(0xff491865),
            onPrimaryContainer: Color(0xfff7d9ff),
            onSecondary: Color(0xff382c3e),
            onSecondaryContainer: Color(0xfff0dcf5),
            onSurface: Color(0xffe8e1e5),
            onSurfaceVariant: Color(0xffcec3ce),
            onTertiary: Color(0xff4c2526),
            onTertiaryContainer: Color(0xffffd9d9),
            outline: Color(0xff978e97),
            primary: Color(0xffe8b4ff),
            primaryContainer: Color(0xff61317d),
            secondary: Color(0xffd3c0d8),
            secondaryContainer: Color(0xff504256),
            shadow: Color(0xff000000),
            surface: Color(0xff1d1b1e),
            surfaceTint: Color(0xffe8b4ff),
            surfaceVariant: Color(0xff4b444d),
            tertiary: Color(0xfff4b7b7),
            tertiaryContainer: Color(0xff663b3c)));
  }
}
