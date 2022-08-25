import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_bloc_and_cubit/nav_cubit.dart';
//import 'package:flutter_bloc_and_cubit/post_details_view.dart';
//import 'package:flutter_bloc_and_cubit/posts_view.dart';
import 'package:to_do_app/model/task.dart';
import 'package:to_do_app/navigation/nav_cubit.dart';
import 'package:to_do_app/pages/home_screen.dart';

import '../pages/task_screen.dart';

class AppNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavCubit, Task?>(builder: ((context, task) {
      return Navigator(
        pages: [
          MaterialPage(child: HomeScreen()),
          if (task != null && task.last_updated_by == 'home_screen')
            MaterialPage(child: TaskScreen()),
          if (task != null && task.last_updated_by != 'home_screen')
            MaterialPage(child: TaskScreen(task: task))
        ],
        onPopPage: (route, result) {
          BlocProvider.of<NavCubit>(context).popHome();
          return route.didPop(result);
        },
      );
    }));
  }
}
