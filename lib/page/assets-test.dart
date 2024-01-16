import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gsy_app/common/style/gsy_style.dart';
import 'package:gsy_app/redux/gsy_state.dart';

class AssetsTest extends StatelessWidget {
  const AssetsTest({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<GSYState>(builder: (context, vm) {
      return const Material(
        color: GSYColors.white,
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Text('Assets Test'),
                Image(image: AssetImage('static/images/logo.png', package: 'gsy_app')),
                // Image(image: AssetImage('static/images/logo.png', package: 'gsy_app')),
              ],
            ),
          ),
        ),
      );
    });
  }
}
