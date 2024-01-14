import 'package:flutter/material.dart';
import 'package:gsy_app/test/demo_page.dart';

class DemoApp extends StatelessWidget {
  DemoApp({Key? super.key});

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: DemoPage());
  }
}
