import 'package:flutter/material.dart';

// Group of options where only one can be chosen, like the role of Sign up.
// Same look as the selector of the student app: the chosen option has a border and a check.
class OptionSelector extends StatelessWidget {
  const new({
    super.key,
    required this.label,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    this.errorText,
    this.enabled = true,
  });
  final String label;
  final List<String> options;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final shape = BorderRadius.circular(11);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        ExcludeSemantics(
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(label, style: textTheme.labelMedium),
          ),
        ),
        Row(
          spacing: 8,
          children: [
            for (var index = 0; index < options.length; index++)
              Expanded(
                child: Semantics(
                  label: '$label, ${options[index]}',
                  selected: index == selectedIndex,
                  inMutuallyExclusiveGroup: true,
                  button: true,
                  excludeSemantics: true,
                  child: Material(
                    color: index == selectedIndex
                        ? colorScheme.primary.withValues(alpha: 0.15)
                        : colorScheme.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                      borderRadius: shape,
                      side: index == selectedIndex
                          ? BorderSide(color: colorScheme.primary, width: 1.5)
                          : BorderSide.none,
                    ),
                    child: InkWell(
                      borderRadius: shape,
                      onTap: enabled ? () => onSelected(index) : null,
                      child: ConstrainedBox(
                        // Minimum touch target of 48
                        constraints: const BoxConstraints(minHeight: 48),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // The check shows the choice without depending only on color
                              if (index == selectedIndex) ...[
                                Icon(
                                  Icons.check,
                                  size: 18,
                                  color: colorScheme.onSurface,
                                ),
                                const SizedBox(width: 6),
                              ],
                              Flexible(
                                child: Text(
                                  options[index],
                                  style: textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
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
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              errorText!,
              style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
            ),
          ),
      ],
    );
  }
}
