import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gsy_app/common/style/gsy_style.dart';

class GSYCardItem extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;
  final Color? color;
  final RoundedRectangleBorder? shape;
  final double elevation;
  const GSYCardItem({
    required this.child,
    this.margin,
    this.color,
    this.shape,
    this.elevation = 5,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsets margin = this.margin ?? const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10);
    RoundedRectangleBorder shape =
        this.shape ?? const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)));
    Color color = this.color ?? GSYColors.cardWhite;
    return Card(
      elevation: elevation,
      shape: shape,
      color: color,
      margin: margin,
      child: child,
    );
  }
}
