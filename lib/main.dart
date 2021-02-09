import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:porcupine/porcupine_error.dart';
import 'package:porcupine/porcupine_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Porcupine',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Porcupine'),
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
  PorcupineManager _porcupineManager;
  String _status = '';

  @override
  void initState() {
    super.initState();
    _createPorcupineManager();
  }

  @override
  void dispose() {
    super.dispose();
    if (_porcupineManager != null) _porcupineManager.stop();
  }

  _createPorcupineManager() async {
    try {
      final _firstAsset = Platform.isAndroid
          ? 'assets/ppn/first_android.ppn'
          : 'assets/ppn/first_ios.ppn';
      final _secondAsset = Platform.isAndroid
          ? 'assets/ppn/second_android.ppn'
          : 'assets/ppn/second_ios.ppn';
      final _platform = Platform.isAndroid ? 'android' : 'ios';
      Directory directory = await getApplicationDocumentsDirectory();
      final _assetDir = 'packages/porcupine/assets';
      final path = _assetDir +
          '/resources/keyword_files/$_platform/first_$_platform.ppn';
      var filePath = join(directory.path, path);
      if (FileSystemEntity.typeSync(filePath) == FileSystemEntityType.notFound) {
        ByteData data = await rootBundle.load(_firstAsset);
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(filePath).writeAsBytes(bytes);
      }
      //Second File
      final path1 = _assetDir +
          '/resources/keyword_files/$_platform/second_$_platform.ppn';
      var filePath1 = join(directory.path, path1);
      if (FileSystemEntity.typeSync(filePath1) == FileSystemEntityType.notFound) {
        ByteData data = await rootBundle.load(_secondAsset);
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(filePath1).writeAsBytes(bytes);
      }
      _porcupineManager = await PorcupineManager.fromKeywordPaths(
        [filePath, filePath1],
        _wakeWordCallBack,
      );
      _porcupineManager.start();
    } on PvError catch (err) {
      print('------------------------');
      print(err.message);
      print('------------------------');
    }
  }

  _wakeWordCallBack(int keywordIndex) async {
    print('------------------------');
    print('------------------------');
    if (keywordIndex == 0) {
      print('Voice started');
      _status = 'Voice Started';
      setState(() {});
    } else if (keywordIndex == 1) {
      print('Voice Ended');
      _status = 'Voice Ended';
      setState(() {});
    }
    print('------------------------');
    print('------------------------');
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
            Text(_status),
          ],
        ),
      ),
    );
  }
}
