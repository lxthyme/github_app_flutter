import 'package:flare_flutter/asset_provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gsy_app/common/style/gsy_style.dart';
import 'package:gsy_app/common/utils/navigator_utils.dart';
import 'package:gsy_app/redux/gsy_state.dart';
import 'package:gsy_app/widget/pull/gsy_flare_pull_controller.dart';

class AssetsTest extends StatelessWidget with GSYFlarePullController {
  AssetsTest({super.key});

  @override
  ValueNotifier<bool> isActive = ValueNotifier<bool>(true);

  @override
  bool get getPlayAuto => true;

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<GSYState>(builder: (context, vm) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Asset Test'),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              const Text('Assets Test'),
              const Image(
                image: AssetImage('static/images/logo.png', package: 'gsy_app'),
                width: 200,
                height: 200,
              ),
              const Text('1. Assets: static/file/loading_world_now.flr'),
              SizedBox(
                height: 200,
                child: FlareActor(
                  "static/file/loading_world_now.flr",
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                  sizeFromArtboard: true,
                  controller: this,
                  animation: "Earth Moving",
                  shouldClip: true,
                  //animation: "idle"
                ),
              ),
              const Text('2. Assets: gsy_app/static/file/loading_world_now.flr'),
              SizedBox(
                height: 200,
                child: FlareActor(
                  "gsy_app/static/file/loading_world_now.flr",
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                  controller: this,
                  animation: "Earth Moving",
                  boundsNode: 'gsy_app',
                  shouldClip: true,
                  //animation: "idle"
                ),
              ),
              const Text('3. Assets: package:gsy_app/static/file/loading_world_now.flr'),
              SizedBox(
                height: 200,
                child: FlareActor(
                  "package:gsy_app/static/file/loading_world_now.flr",
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                  controller: this,
                  animation: "Earth Moving",
                  shouldClip: true,
                  boundsNode: 'gsy_app',
                  // animation: "idle"
                ),
              ),
              const Text('4. Assets: packages:gsy_app/static/file/loading_world_now.flr'),
              SizedBox(
                height: 200,
                child: FlareActor(
                  "packages:gsy_app/static/file/loading_world_now.flr",
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                  controller: this,
                  animation: "Earth Moving",
                  shouldClip: true,
                  boundsNode: 'gsy_app',
                  //animation: "idle"
                ),
              ),
              const Text('5. Assets: package/gsy_app/static/file/loading_world_now.flr'),
              SizedBox(
                height: 200,
                child: FlareActor(
                  "package/gsy_app/static/file/loading_world_now.flr",
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                  controller: this,
                  animation: "Earth Moving",
                  boundsNode: 'gsy_app',
                  shouldClip: true,
                  //animation: "idle"
                ),
              ),
              const Text('6. Assets: packages/gsy_app/static/file/loading_world_now.flr'),
              SizedBox(
                height: 200,
                child: FlareActor(
                  "packages:gsy_app/static/file/loading_world_now.flr",
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                  controller: this,
                  animation: "Earth Moving",
                  boundsNode: 'gsy_app',
                  shouldClip: true,
                  //animation: "idle"
                ),
              ),
              const Text('6. Assets: packages/gsy_app/static/file/loading_world_now.flr'),
              SizedBox(
                height: 200,
                child: FlareActor.asset(
                  AssetFlare(bundle: rootBundle, name: 'packages/gsy_app/static/file/loading_world_now.flr'),
                  // "packages:gsy_app/static/file/loading_world_now.flr",
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                  controller: this,
                  animation: "Earth Moving",
                  boundsNode: 'gsy_app',
                  shouldClip: true,
                  //animation: "idle"
                ),
              ),
              const Text('7. Assets: packages:gsy_app/static/file/loading_world_now.flr'),
              SizedBox(
                height: 200,
                child: FlareActor.asset(
                  AssetFlare(bundle: rootBundle, name: 'packages:gsy_app/static/file/loading_world_now.flr'),
                  // "packages:gsy_app/static/file/loading_world_now.flr",
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                  controller: this,
                  animation: "Earth Moving",
                  boundsNode: 'gsy_app',
                  shouldClip: true,
                  //animation: "idle"
                ),
              ),
              const Text('----- END -----'),
            ],
          ),
        ),
      );
    });
  }
}
