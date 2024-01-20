import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gsy_app/common/style/gsy_style.dart';
import 'package:gsy_app/redux/gsy_state.dart';

class TODOPage extends StatelessWidget {
  final String title;
  const TODOPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<GSYState>(builder: (context, vm) {
      return Material(
        color: GSYColors.white,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('TODO'),
          ),
          body: SafeArea(
            child: Center(
              child: Text(title),
            ),
          ),
        ),
      );
    });
  }
}
