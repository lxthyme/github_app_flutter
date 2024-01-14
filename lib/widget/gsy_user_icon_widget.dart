import 'package:flutter/material.dart';
import 'package:gsy_app/common/style/gsy_style.dart';

class GSYUserIconWidget extends StatelessWidget {
  final String? image;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final EdgeInsetsGeometry? padding;

  const GSYUserIconWidget({
    this.image,
    this.onPressed,
    this.width = 30,
    this.height = 30,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: padding ?? const EdgeInsets.only(top: 4, right: 5, left: 5),
      constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      child: ClipOval(
        child: FadeInImage(
          placeholder: const AssetImage(GSYICons.DEFAULT_USER_ICON),
          image: NetworkImage(image ?? GSYICons.DEFAULT_REMOTE_PIC),
          fit: BoxFit.fitWidth,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
