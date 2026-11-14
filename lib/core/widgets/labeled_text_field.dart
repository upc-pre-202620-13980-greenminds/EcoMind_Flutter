import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Label above a field. The gray version is the one of Sign in and Sign up;
// the bordered version, with a green label, is the one of the profile and family screens
class LabeledTextField extends StatelessWidget {
  const new({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialValue,
    this.hintText,
    this.errorText,
    this.bordered = false,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.inputFormatters,
    this.suffixIcon,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
  });
  final String label;
  final ValueChanged<String> onChanged;
  final String? initialValue;
  final String? hintText;
  final String? errorText;
  final bool bordered;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  // Shows a value that cannot be changed, keeping the normal colors
  final bool readOnly;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(bordered ? 12 : 11),
      borderSide: bordered
          ? BorderSide(color: colorScheme.outlineVariant)
          : BorderSide.none,
    );
    final labelStyle = bordered
        ? textTheme.labelLarge?.copyWith(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          )
        : textTheme.labelMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: bordered ? 8 : 4,
      children: [
        // The field already tells its label to the screen reader
        ExcludeSemantics(
          child: Padding(
            padding: EdgeInsets.only(left: bordered ? 0 : 4),
            child: Text(label, style: labelStyle),
          ),
        ),
        Semantics(
          label: label,
          child: TextFormField(
            initialValue: initialValue,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            enabled: enabled,
            readOnly: readOnly,
            maxLines: maxLines,
            minLines: maxLines > 1 ? maxLines : null,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            autofillHints: autofillHints,
            inputFormatters: inputFormatters,
            style: textTheme.bodyLarge,
            decoration: InputDecoration(
              filled: true,
              fillColor: bordered
                  ? colorScheme.surface
                  : colorScheme.surfaceContainerHighest,
              hintText: hintText,
              hintStyle: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
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
              contentPadding: EdgeInsets.symmetric(
                horizontal: bordered ? 14 : 12,
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
