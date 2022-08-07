import 'package:flutter/material.dart';

import 'logger.dart';
import 'error_handler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 's.dart';
import 'dart:async';
import 'package:to_do_app/pages/task_screen.dart';
import 'package:to_do_app/pages/home_screen.dart';

void main() {
  runZonedGuarded(() {
    initLogger();
    logger.info('Start main');
    ErrorHandler.init();
    runApp(const App());
    logger.info('End main');
  }, ErrorHandler.recordError);
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late Future<List<dynamic>> _PersonsFuture;
  StreamController<int>? _currentBytesReceivedStreamController;

  var _isDark = false;
  var _locale = S.en;

  @override
  @override
  Widget build(BuildContext context) => MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.supportedLocales,
        locale: _locale,
        initialRoute: './home',
        routes: {
          './home': ((context) => HomeScreen()),
          './task': ((context) => TaskScreen())
        },
      );
}
