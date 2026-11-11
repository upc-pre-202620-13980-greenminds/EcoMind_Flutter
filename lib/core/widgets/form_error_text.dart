import 'package:flutter/material.dart';

// Error of the whole form, announced by the screen reader as soon as it appears
class FormErrorText extends StatelessWidget {
  const new({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, top: 8),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ),
    );
  }
}
