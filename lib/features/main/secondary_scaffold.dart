import 'package:ecomind_parents/core/widgets/screen_header.dart';
import 'package:ecomind_parents/features/main/main_top_bar.dart';
import 'package:flutter/material.dart';

// Frame of the secondary screens: top bar and "‹" header, without the bottom bar
class SecondaryScaffold extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    required this.body,
    this.headerAction,
    this.isInsideInbox = false,
  });
  final String title;
  final Widget body;
  final Widget? headerAction;
  // True for the inbox and its preferences, so the bell has no action there
  final bool isInsideInbox;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MainTopBar(isInsideInbox: isInsideInbox),
            ScreenHeader(title: title, action: headerAction),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
