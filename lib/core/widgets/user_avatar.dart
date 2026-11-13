import 'package:ecomind_parents/core/widgets/initials_avatar.dart';
import 'package:flutter/material.dart';

// Avatar equipped in Store, with the same images of the student app.
// Without an avatar, or with one this version does not know, it shows the initials.
class UserAvatar extends StatelessWidget {
  const new({
    super.key,
    required this.name,
    required this.imageReference,
    this.size = 44,
  });
  final String name;
  final String? imageReference;
  final double size;

  // imageReference of the backend -> image of assets/images
  static const Map<String, String> _images = {
    'avatar_alex': 'assets/images/avatar_alex.png',
    'avatar_leaf': 'assets/images/avatar_leafwings.png',
    'avatar_leafwings': 'assets/images/avatar_leafwings.png',
    'avatar_lunalunette': 'assets/images/avatar_lunalunette.png',
    'avatar_mickey': 'assets/images/avatar_mickey.png',
    'avatar_ranma': 'assets/images/avatar_ranma.png',
    'avatar_rosalina': 'assets/images/avatar_rosalina.png',
    'avatar_salsolcito': 'assets/images/avatar_salsolcito.png',
    'avatar_sonic': 'assets/images/avatar_sonic.png',
  };

  @override
  Widget build(BuildContext context) {
    final image = _images[imageReference];
    if (image == null) {
      return InitialsAvatar(name: name, size: size);
    }
    // Decorative: the name is always written next to the avatar
    return ExcludeSemantics(
      child: Image.asset(image, width: size, height: size, fit: BoxFit.contain),
    );
  }
}
