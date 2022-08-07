import 'package:flutter/material.dart';

import 'logger.dart';
import 'error_handler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'model/task.dart';
import 'network/api.dart';
import 'network/dio_factory.dart';
import 's.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:to_do_app/services/sidebar.dart';
import 'package:to_do_app/pages/task_screen.dart';
import 'package:to_do_app/pages/home_screen.dart';
import 'package:to_do_app/pages/test_screen.dart';

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
  //final _dio = DioFactory.create();
  //late final _api = Api(_dio);
  late Future<List<dynamic>> _PersonsFuture;
  StreamController<int>? _currentBytesReceivedStreamController;

  var _isDark = false;
  var _locale = S.en;

  @override
  /*void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() {
    logger.info("HelloWorld");
    _currentBytesReceivedStreamController?.close();
    final streamController = StreamController<int>();
    _PersonsFuture = _api.getTasks(
      progressCallback: (current, total) {
        streamController.add(current);
      },
    );
    print(_currentBytesReceivedStreamController);
    _currentBytesReceivedStreamController = streamController;
  }

  Future<void> _refresh() {
    _loadItems();
    setState(() {});
    return _PersonsFuture;
  }

  @override
  void dispose() {
    _dio.close();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) => MaterialApp(
        localizationsDelegates: const [
          //AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.supportedLocales,
        locale: _locale,
        initialRoute: './home',
        routes: {
          './home': ((context) => HomeScreen()),
          './test': ((context) => TestScreen()),
          './task': ((context) => TaskScreen())
        },
      );
}
