import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/data_processing/api_key.dart';
import 'package:to_do_app/data_processing/shared_pref.dart';
import 'package:to_do_app/theme/theme.dart';
//import 'package:hive/hive.dart';

import 'bloc/task_bloc.dart';
import 'bloc/task_event.dart';
import 'logger.dart';
import 'error_handler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'navigation/app_navigation.dart';
import 'data_processing/hive_repository.dart';
import 'data_processing/tasks_repositoty.dart';
import 's.dart';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/model/task.dart';
import 'package:to_do_app/navigation/nav_cubit.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';

void main() {
  runZonedGuarded(() async {
    initLogger();
    logger.info('Start main');
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    await Hive.openBox<Task>('ToDos');
    await SharedPref.init();
    ErrorHandler.init();
    AppMetrica.activate(const AppMetricaConfig(appMetricaKey));
    AppMetrica.reportEvent('Start program');
    runApp(App());
    logger.info('End main');
  }, ErrorHandler.recordError);
}

class App extends StatelessWidget {
  //late Future<List<dynamic>> _PersonsFuture;
  //StreamController<int>? _currentBytesReceivedStreamController;
  var _isDark = false;
  var _locale = S.en;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => TasksRepository()),
        RepositoryProvider(create: (context) => HiveRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NavCubit()),
          BlocProvider(
            create: (context) => TaskBloc(
              tasksRepository: context.read<TasksRepository>(),
              hiveRepository: context.read<HiveRepository>(),
            )..add(TaskGetListEvent()),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: AppNavigator(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.supportedLocales,
          locale: _locale,
          // initialRoute: './home',
          // routes: {
          //   './home': ((context) => HomeScreen()),
          //   './task': ((context) => TaskScreen())
          // },
        ),
      ),
    );
  }
}

/*class App extends StatelessWidget {
  //late Future<List<dynamic>> _PersonsFuture;
  //StreamController<int>? _currentBytesReceivedStreamController;
  var _isDark = false;
  var _locale = S.en;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RepositoryProvider(
        create: (context) => TasksRepository(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => NavCubit()),
            BlocProvider(
              create: (context) =>
                  TaskBloc(tasksRepository: context.read<TasksRepository>())
                    ..add(TaskGetListEvent()),
            ),
          ],
          child: AppNavigator(),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.supportedLocales,
      locale: _locale,
      // initialRoute: './home',
      // routes: {
      //   './home': ((context) => HomeScreen()),
      //   './task': ((context) => TaskScreen())
      // },
    );
  }
}
*/