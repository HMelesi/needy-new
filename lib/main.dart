import 'package:flutter/material.dart';
import 'package:needy_new/MyApp.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:needy_new/RootPage.dart';
import 'package:needy_new/authentication.dart';

/// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.');
  BackgroundFetch.finish(taskId);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
        initialRoute: '/',
        home: Scaffold(
          body: RootPage(auth: Auth()),
        )),
  );
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}
