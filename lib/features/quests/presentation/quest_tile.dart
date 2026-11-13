import 'package:flutter/material.dart';

class QuestTile extends StatelessWidget {
  const new({super.key, required this.theme, required this.size});

  final String theme;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Icons and color layers from EcoMind_Android's QuestTile.
    final (icon, top, face, base) = switch (theme) {
      'COLLABORATIVE' => ('collaborative', 0xffffe079, 0xffffc943, 0xffff9e42),
      'MINIGAME' => ('minigame', 0xff83caff, 0xff3dadff, 0xff496be7),
      'WRITE' => ('write', 0xffff9077, 0xffff552f, 0xffd60000),
      _ => ('checkbox', 0xff9be5a5, 0xff66d575, 0xff159e67),
    };
    final radius = BorderRadius.circular(size * .28);

    return SizedBox.square(
      dimension: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(color: Color(base), borderRadius: radius),
          ),
          Positioned.fill(
            bottom: size * .1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(top),
                borderRadius: radius,
              ),
            ),
          ),
          Positioned.fill(
            top: size * .1,
            bottom: size * .1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(face),
                borderRadius: radius,
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/ic_quest_$icon.png',
                  width: size * (icon == 'write' ? .65 : .55),
                  height: size * (icon == 'write' ? .65 : .55),
                  excludeFromSemantics: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
