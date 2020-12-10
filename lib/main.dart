import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails details) async {
      print('FlutterError.onError');
      FlutterError.dumpErrorToConsole(details);
      if (kDebugMode) {
        await sendError(details.exceptionAsString());
      }
      exit(1);
    };
    runApp(MyApp());
  }, (dynamic error, StackTrace stackTrace) async {
    print('runZonedGuarded');
    if (kDebugMode) {
      await sendError(error.toString());
    }
    exit(1);
  });
}

Future<void> sendError(String text) async {
  final response = await http.post(
      'https://slack.com/api/chat.postMessage?channel=xxxx&text=$text',
      headers: {"Authorization": "Bearer xxxx"});
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void onTap() {
    final a = null;
    assert(a != null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              child: Text(
                'Crash!!',
                style: TextStyle(fontSize: 50),
              ),
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
