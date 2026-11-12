import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/core/widgets/form_error_text.dart';
import 'package:ecomind_parents/core/widgets/labeled_text_field.dart';
import 'package:ecomind_parents/core/widgets/primary_button.dart';
import 'package:ecomind_parents/features/iam/presentation/auth_messages.dart';
import 'package:ecomind_parents/features/iam/presentation/recovery_heading.dart';
import 'package:ecomind_parents/features/iam/presentation/recovery_request/password_recovery_page.dart';
import 'package:ecomind_parents/features/iam/presentation/recovery_request/password_recovery_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/reset_password/reset_password_state.dart';
import 'package:ecomind_parents/features/iam/presentation/reset_password/reset_password_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_page.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_view_model.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Opened from the emailed link; it is always the only screen in the stack
class ResetPasswordPage extends StatefulWidget {
  final ResetPasswordViewModel viewModel;
  // Null when the link is malformed; it is never shown or saved
  final String? token;
  const new({super.key, required this.viewModel, required this.token});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  // The ViewModel received first is the one this page uses and disposes
  late final ResetPasswordViewModel viewModel = widget.viewModel;

  @override
  void initState() {
    super.initState();
    viewModel.openLink(widget.token);
  }

  @override
  void dispose() {
    // Forgets the token and the typed passwords
    viewModel.dispose();
    super.dispose();
  }

  // Sign in starts empty; nothing typed here goes with it
  void goToSignIn() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => SignInPage(viewModel: getIt<SignInViewModel>()),
      ),
      (route) => false,
    );
  }

  // Sign in stays below, so going back from the request returns to it
  void requestNewLink() {
    final navigator = Navigator.of(context);
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => SignInPage(viewModel: getIt<SignInViewModel>()),
      ),
      (route) => false,
    );
    navigator.push(
      MaterialPageRoute(
        builder: (context) =>
            PasswordRecoveryPage(viewModel: getIt<PasswordRecoveryViewModel>()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // There is no screen below: going back leads to Sign in
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          goToSignIn();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              final state = viewModel.state;
              final textTheme = Theme.of(context).textTheme;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: BackButton(onPressed: goToSignIn),
                    ),
                    const SizedBox(height: 16),
                    ...switch (state) {
                      ResetPasswordState(isCompleted: true) => _completed(l10n),
                      ResetPasswordState(isLinkInvalid: true) => _invalidLink(
                        l10n,
                        state.linkStatus,
                      ),
                      _ => _form(l10n, state),
                    },
                    const SizedBox(height: 32),
                    if (!state.isCompleted)
                      TextButton(
                        onPressed: state.isLoading ? null : goToSignIn,
                        child: Text(
                          l10n.recoveryBackToSignIn,
                          style: textTheme.titleMedium,
                        ),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _form(AppLocalizations l10n, ResetPasswordState state) {
    return [
      RecoveryHeading(title: l10n.resetTitle, message: l10n.resetMessage),
      const SizedBox(height: 40),
      // Discards the autofill context so the password is not offered for saving
      AutofillGroup(
        onDisposeAction: AutofillContextAction.cancel,
        child: Column(
          children: [
            LabeledTextField(
              label: l10n.resetPasswordLabel,
              onChanged: viewModel.onPasswordChange,
              errorText: state.passwordError?.text(l10n),
              obscureText: state.isPasswordHidden,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              enabled: !state.isLoading,
              suffixIcon: IconButton(
                onPressed: viewModel.togglePasswordVisibility,
                tooltip: state.isPasswordHidden
                    ? l10n.showPassword
                    : l10n.hidePassword,
                icon: Icon(
                  state.isPasswordHidden
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
            ),
            const SizedBox(height: 8),
            LabeledTextField(
              label: l10n.resetConfirmPasswordLabel,
              onChanged: viewModel.onConfirmPasswordChange,
              errorText: state.confirmPasswordError?.text(l10n),
              obscureText: state.isPasswordHidden,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              enabled: !state.isLoading,
              // "Done" on the keyboard sends the form
              onSubmitted: (_) => viewModel.submit(),
            ),
          ],
        ),
      ),
      if (state.errorMessage != null)
        FormErrorText(message: state.errorMessage!.text(l10n)),
      const SizedBox(height: 32),
      PrimaryButton(
        text: l10n.resetButton,
        onPressed: viewModel.submit,
        isLoading: state.isLoading,
      ),
    ];
  }

  List<Widget> _invalidLink(AppLocalizations l10n, ResetLinkStatus status) {
    return [
      RecoveryHeading(
        title: l10n.resetInvalidTitle,
        message: status == ResetLinkStatus.rejected
            ? l10n.errorResetTokenInvalid
            : l10n.resetInvalidMessage,
      ),
      const SizedBox(height: 40),
      PrimaryButton(text: l10n.resetRequestNewLink, onPressed: requestNewLink),
    ];
  }

  List<Widget> _completed(AppLocalizations l10n) {
    return [
      RecoveryHeading(
        title: l10n.resetSuccessTitle,
        message: l10n.resetSuccessMessage,
      ),
      const SizedBox(height: 40),
      PrimaryButton(text: l10n.signInButton, onPressed: goToSignIn),
    ];
  }
}
