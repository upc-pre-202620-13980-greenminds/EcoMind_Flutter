import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Full width green button; while loading it shows a spinner and cannot be pressed
class PrimaryButton extends StatelessWidget {
  const new({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          // 48 is the minimum touch target
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  semanticsLabel: AppLocalizations.of(context).loading,
                ),
              )
            : Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}
