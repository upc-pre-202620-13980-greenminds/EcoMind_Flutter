import 'package:flutter/material.dart';

// Circle with the initials of a person, used while the avatars are not available
class InitialsAvatar extends StatelessWidget {
  const new({super.key, required this.name, this.size = 44});
  final String name;
  final double size;

  // First letter of the first two words: "Luna Rivera" gives "LR"
  String get initials {
    return name
        .trim()
        .split(' ')
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0].toUpperCase())
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    // Decorative: the name is always written next to the avatar
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Text(
          initials,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: size / 2.6,
            color: primary,
          ),
        ),
      ),
    );
  }
}
