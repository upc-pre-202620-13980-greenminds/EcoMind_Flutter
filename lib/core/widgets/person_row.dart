import 'package:ecomind_parents/core/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

// Row of a friend or a family member: avatar, name, subtitle and an optional action
class PersonRow extends StatelessWidget {
  const new({
    super.key,
    required this.name,
    required this.subtitle,
    this.avatarImageReference,
    this.trailing,
  });
  final String name;
  final String subtitle;
  final String? avatarImageReference;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final trailingWidget = trailing;

    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Row(
            spacing: 12,
            children: [
              UserAvatar(name: name, imageReference: avatarImageReference),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // "?" adds the widget only when it is not null
              ?trailingWidget,
            ],
          ),
        ),
        Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant),
      ],
    );
  }
}
