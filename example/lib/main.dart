import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rdservice/rdservice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text("Init Device"),
                  onPressed: initDevice,
                ),
                ElevatedButton(
                  child: const Text("Capture"),
                  onPressed: captureFromDevice,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_platformVersion),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> initDevice() async {
    RDService? result;
    try {
      result = await Msf100.getDeviceInfo();
    } on PlatformException catch (e) {
      if (mounted) {
        setState(() {
          _platformVersion = e.message ?? 'Unknown exception';
        });
      }
      return;
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = result?.status ?? "Unknown";
    });
  }

  Future<void> captureFromDevice() async {
    PidData? result;
    try {
      result = await Msf100.capture();
    } on PlatformException catch (e) {
      if (mounted) {
        setState(() {
          _platformVersion = e.message ?? 'Unknown exception';
        });
      }
      return;
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = result?.resp.errInfo ?? 'Unknown Error';
    });
  }
}
