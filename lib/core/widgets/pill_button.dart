import 'package:flutter/material.dart';

// Rounded green button with a darker base under the face, as in the profile frames
class PillButton extends StatelessWidget {
  const new({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.faceColor,
    this.shadowColor,
    this.buttonHeight = height,
  });
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final Color? faceColor;
  final Color? shadowColor;
  final double buttonHeight;

  // Same height in the design and in the minimum touch target
  static const double height = 48;
  static const double depth = height * 0.1;
  // Darker green of the base; the design uses the same one in both themes
  static const Color baseColor = Color(0xff2b824b);

  @override
  Widget build(BuildContext context) {
    final faceColor = enabled
        ? this.faceColor ?? Theme.of(context).colorScheme.primary
        : const Color(0xffa4a4a4);
    final base = enabled ? shadowColor ?? baseColor : Colors.grey;
    final depth = buttonHeight * 0.1;
    final shape = const StadiumBorder();

    return Semantics(
      button: true,
      enabled: enabled && !isLoading,
      child: SizedBox(
        height: buttonHeight,
        width: double.infinity,
        child: Stack(
          children: [
            // Base: what is seen under the face
            Positioned.fill(
              top: depth,
              child: DecoratedBox(
                decoration: ShapeDecoration(color: base, shape: shape),
              ),
            ),
            // Face, with a lighter band at the top
            Positioned.fill(
              bottom: depth,
              child: Material(
                shape: shape,
                clipBehavior: Clip.antiAlias,
                color: faceColor,
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0, 0.35, 0.35],
                      colors: [
                        Color.alphaBlend(
                          Colors.white.withValues(alpha: 0.35),
                          faceColor,
                        ),
                        Color.alphaBlend(
                          Colors.white.withValues(alpha: 0.35),
                          faceColor,
                        ),
                        faceColor,
                      ],
                    ),
                  ),
                  child: InkWell(
                    onTap: isLoading || !enabled ? null : onPressed,
                    customBorder: shape,
                    child: Center(
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: base,
                                    offset: const Offset(0, 1.5),
                                    blurRadius: 1.5,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
