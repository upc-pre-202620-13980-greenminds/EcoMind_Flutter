import 'package:ecomind_parents/core/widgets/text_link.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// "My commitment" card of the Profile tab (HU-006), for students and parents
class CommitmentCard extends StatelessWidget {
  const new({
    super.key,
    required this.commitment,
    required this.onAdd,
    required this.onEdit,
  });
  // Null when the user has not written one yet
  final String? commitment;
  final VoidCallback onAdd;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final text = commitment;
    final bodyStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 13,
      color: colorScheme.onSurface,
    );

    return Card.outlined(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 4, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      l10n.commitmentTitle,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                // Empty state: there is nothing to edit yet
                text == null
                    ? TextLink(text: l10n.commitmentAdd, onPressed: onAdd)
                    : TextLink(
                        text: l10n.profileEdit,
                        color: colorScheme.onSurfaceVariant,
                        semanticLabel: l10n.commitmentEditTitle,
                        onPressed: onEdit,
                      ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(text ?? l10n.commitmentEmpty, style: bodyStyle),
            ),
          ],
        ),
      ),
    );
  }
}
