import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './providers/auth_house.dart';
import './providers/tasks.dart';
import './providers/auth.dart';
import '../screens/task_detail_screen.dart';
import '../screens/tasks_completed_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/tasks_overview_screen.dart';
import '../screens/auth_house_screen.dart';
import './screens/add_task_screen.dart';
import './screens/scoreboard_screen.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: AuthHouse()),
        ChangeNotifierProxyProvider2<Auth, AuthHouse, Tasks>(
          update: (ctx, auth, authHouse, previousTasks) =>
              // Tasks(
              //     auth.token,
              //     previousTasks == null ? [] : previousTasks.getDoList,
              //     previousTasks == null ? [] : previousTasks.getDoneList,
              //     auth.userId),
              Tasks(auth.token, [], [], null),
          create: (ctx) => Tasks(null, [], [], null),
        ),
      ],
      child: Consumer2<Auth, AuthHouse>(
        builder: (ctx, auth, authHouse, _) => MaterialApp(
          home: auth.isAuth
              ? authHouse.isAuth
                  ? const TasksOverviewScreen()
                  : const AuthHouseScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen()),
          //  auth.isAuth
          //     ? authHouse.isAuth
          //         ? const TasksOverviewScreen()
          //         : const AuthHouseScreen()
          //     : FutureBuilder(
          //         future: auth.tryAutoLogin(),
          //         builder: (ctx, authResultSnapshot) =>
          //             authResultSnapshot.connectionState ==
          //                     ConnectionState.waiting
          //                 ? const SplashScreen()
          //                 : const AuthScreen()),
          routes: {
            AuthHouseScreen.routeName: (ctx) => const AuthHouseScreen(),
            TaskDetailScreen.routeName: (ctx) => TaskDetailScreen(),
            AddTaskScreen.routeName: (ctx) => const AddTaskScreen(),
            TasksCompletedScreen.routeName: (ctx) =>
                const TasksCompletedScreen(),
            ScoreBoard.routeName: (ctx) => ScoreBoard(),
          },
        ),
      ),
    );
  }
}
