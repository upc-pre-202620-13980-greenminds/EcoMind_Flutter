import 'package:flutter/material.dart';

// Green bold text that works as a link, such as "Manage" or "Add member"
class TextLink extends StatelessWidget {
  const new({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.fontSize = 13,
    this.semanticLabel,
  });
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final double fontSize;
  // Longer text for the screen reader, such as "Add Luna to the family"
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final link = TextButton(
      onPressed: onPressed,
      // TextButton keeps a touch target of 48
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
          color: onPressed == null
              ? Theme.of(context).disabledColor
              : color ?? Theme.of(context).colorScheme.primary,
        ),
      ),
    );

    if (semanticLabel == null) {
      return link;
    }
    return Semantics(
      label: semanticLabel,
      button: true,
      excludeSemantics: true,
      child: link,
    );
  }
}
