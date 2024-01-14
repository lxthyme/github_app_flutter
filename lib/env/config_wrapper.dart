import 'package:flutter/material.dart';
import 'package:gsy_app/common/config/config.dart';
import 'package:gsy_app/env/env_config.dart';

class ConfigWrapper extends StatelessWidget {
  final EnvConfig? config;
  final Widget? child;

  const ConfigWrapper({
    super.key,
    this.config,
    this.child,
  });

  static EnvConfig? of(BuildContext context) {
    final _InheritedConfig inheritedConfig = context.dependOnInheritedWidgetOfExactType<_InheritedConfig>()!;
    return inheritedConfig.config;
  }

  @override
  Widget build(BuildContext context) {
    Config.DEBUG = config?.debug;
    debugPrint('ConfigWrapper build ${Config.DEBUG}');
    return _InheritedConfig(
      config: config,
      child: child!,
    );
  }
}

class _InheritedConfig extends InheritedWidget {
  final EnvConfig? config;
  const _InheritedConfig({
    required this.config,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedConfig oldWidget) => config != oldWidget.config;
}
