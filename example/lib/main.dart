import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_imagekit/flutter_imagekit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double linearProgress = 0.0;
  File? file; /// please use File Picker or Image Picker
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ImageKit.io"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(value: linearProgress),
            const Text(
              'ImageKit.io Upload Progress',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ImageKit.io(
            file,
            privateKey: "PrivateKey", // (Keep Confidential)
            onUploadProgress: (progressValue) {
              if (kDebugMode) {
                print(progressValue);
              }
              setState(() {
                linearProgress = progressValue;
              });
            },
          ).then((String url) {
            /// Get your uploaded Image file link from [ImageKit.io]
            /// then save it anywhere you want. For Example- [Firebase, MongoDB] etc.
            if (kDebugMode) {
              print(url);
            }
          });
        },
        tooltip: 'Submit',
        child: const Icon(Icons.add),
      ),
    );
  }
}
