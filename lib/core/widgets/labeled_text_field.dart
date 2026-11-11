import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Label above a gray field, as in the Sign in and Sign up frames
class LabeledTextField extends StatelessWidget {
  const new({
    super.key,
    required this.label,
    required this.onChanged,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.inputFormatters,
    this.suffixIcon,
    this.onSubmitted,
    this.enabled = true,
  });
  final String label;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: BorderSide.none,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        // The field already tells its label to the screen reader
        ExcludeSemantics(
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(label, style: Theme.of(context).textTheme.labelMedium),
          ),
        ),
        Semantics(
          label: label,
          child: TextField(
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            enabled: enabled,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            autofillHints: autofillHints,
            inputFormatters: inputFormatters,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest,
              border: border,
              enabledBorder: border,
              disabledBorder: border,
              focusedBorder: border.copyWith(
                borderSide: BorderSide(color: colorScheme.primary),
              ),
              errorBorder: border.copyWith(
                borderSide: BorderSide(color: colorScheme.error),
              ),
              focusedErrorBorder: border.copyWith(
                borderSide: BorderSide(color: colorScheme.error),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              errorText: errorText,
              errorMaxLines: 3,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
