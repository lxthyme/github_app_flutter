import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GSYFlexButton extends StatelessWidget {
  final String? text;
  final Color? color;
  final Color? textColor;
  final VoidCallback? onPress;
  final double fontSize;
  final int maxLines;
  final MainAxisAlignment mainAxisAlignment;

  const GSYFlexButton({
    super.key,
    this.text,
    this.color,
    this.textColor = Colors.black,
    this.onPress,
    this.fontSize = 20,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: TextButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
        ),
        onPressed: () {
          onPress?.call();
        },
        child: Flex(
          mainAxisAlignment: mainAxisAlignment,
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Text(
                text!,
                style: TextStyle(color: textColor, fontSize: fontSize, height: 1),
                textAlign: TextAlign.center,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ));
  }
}
