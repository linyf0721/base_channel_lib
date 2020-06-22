import 'package:basechannellib_example/channel/flutter_to_native_channel.dart';
import 'package:basechannellib_example/channel/native_to_flutter_channel.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:basechannellib/basechannellib.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    ExampleNTFEventChannel.instance().registerEvent("test", ntfEventCallback);

    ExampleFTNMethodChannel.instance()
        .registerNativeToDart("testNative", methodCallback);
  }

  /// native向flutter发送事件
  ntfEventCallback(args) {
    print(args);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await ExampleFTNMethodChannel.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  onClickVersion() async {
    var version = await ExampleFTNMethodChannel.platformVersion;
    setState(() {
      _platformVersion = version;
    });
  }

  onClickNTFChannel() async {
    ExampleFTNMethodChannel.sendEventTest();
  }

  Future<String> methodCallback(args) async {
    print(args);
    return "test";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              FlatButton(
                onPressed: onClickVersion,
                child: Text('获取版本信息'),
              ),
              Text("版本$_platformVersion"),
              FlatButton(
                onPressed: onClickNTFChannel,
                child: Text('原生向flutter通信'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
