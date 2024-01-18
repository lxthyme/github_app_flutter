import 'package:flutter/material.dart';

class GSYIconText extends StatelessWidget {
  final String? iconText;
  final IconData iconData;
  final TextStyle textStyle;
  final Color iconColor;
  final double padding;
  final double iconSize;
  final VoidCallback? onPressed;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double textWidth;
  const GSYIconText(
    this.iconData,
    this.iconText,
    this.textStyle,
    this.iconColor,
    this.iconSize, {
    super.key,
    this.padding = 0,
    this.onPressed,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.textWidth = -1,
  });

  @override
  Widget build(BuildContext context) {
    Widget showText = textWidth == -1
        ? SizedBox(
            child: Text(
              iconText ?? '',
              style: textStyle.merge(const TextStyle(textBaseline: TextBaseline.alphabetic)),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        : SizedBox(
            width: textWidth,
            child: Text(
              iconText ?? '',
              style: textStyle.merge(const TextStyle(textBaseline: TextBaseline.alphabetic)),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
    return Row(
      textBaseline: TextBaseline.alphabetic,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        Icon(
          iconData,
          size: iconSize,
          color: iconColor,
        ),
        Padding(padding: EdgeInsets.all(padding)),
        showText,
      ],
    );
  }
}
