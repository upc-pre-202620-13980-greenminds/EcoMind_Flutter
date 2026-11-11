import 'package:ecomind_parents/core/widgets/coming_soon_view.dart';
import 'package:flutter/material.dart';

// Full screen version, opened from a shortcut such as the settings icon
class ComingSoonPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SafeArea(child: ComingSoonView()),
    );
  }
}
