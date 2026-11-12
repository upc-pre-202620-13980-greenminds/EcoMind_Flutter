import 'package:flutter/material.dart';

// "‹" and green title of the secondary screens, such as Edit profile
class ScreenHeader extends StatelessWidget {
  const new({super.key, required this.title, this.action});
  final String title;
  // Optional button on the right, such as the preferences of the inbox
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: IconButton(
              onPressed: () => Navigator.maybePop(context),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              icon: Icon(Icons.chevron_left, color: primary, size: 32),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Semantics(
              header: true,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: primary,
                ),
              ),
            ),
          ),
          if (action != null)
            Align(alignment: AlignmentDirectional.centerEnd, child: action),
        ],
      ),
    );
  }
}
