import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/core/widgets/form_error_text.dart';
import 'package:ecomind_parents/core/widgets/labeled_text_field.dart';
import 'package:ecomind_parents/core/widgets/primary_button.dart';
import 'package:ecomind_parents/features/iam/presentation/auth_messages.dart';
import 'package:ecomind_parents/features/iam/presentation/recovery_heading.dart';
import 'package:ecomind_parents/features/iam/presentation/recovery_request/password_recovery_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_page.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_view_model.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PasswordRecoveryPage extends StatefulWidget {
  final PasswordRecoveryViewModel viewModel;
  // Email already typed in Sign in, so the parent does not write it twice
  final String initialEmail;
  const new({super.key, required this.viewModel, this.initialEmail = ''});

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  // The ViewModel received first is the one this page uses and disposes
  late final PasswordRecoveryViewModel viewModel = widget.viewModel;
  bool wasLinkResent = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialEmail.isNotEmpty) {
      viewModel.onEmailChange(widget.initialEmail);
    }
    viewModel.addListener(onStateChanged);
  }

  @override
  void dispose() {
    viewModel.removeListener(onStateChanged);
    // The ViewModel belongs to this page only
    viewModel.dispose();
    super.dispose();
  }

  void onStateChanged() {
    if (!mounted) {
      return;
    }
    final linkResent = viewModel.state.linkResent;

    // Only when it changes, so the message is not shown again on every update
    if (linkResent && !wasLinkResent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).recoveryLinkResent),
        ),
      );
    }
    wasLinkResent = linkResent;
  }

  void submit() {
    viewModel.submit(
      languageTag: Localizations.localeOf(context).toLanguageTag(),
    );
  }

  // Sign in is below this screen, except when it was opened from a reset link
  void backToSignIn() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => SignInPage(viewModel: getIt<SignInViewModel>()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
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
                    child: BackButton(onPressed: backToSignIn),
                  ),
                  const SizedBox(height: 16),
                  if (!state.isSent) ...[
                    RecoveryHeading(
                      title: l10n.recoveryTitle,
                      message: l10n.recoveryMessage,
                    ),
                    const SizedBox(height: 40),
                    AutofillGroup(
                      child: LabeledTextField(
                        label: l10n.signInEmailLabel,
                        // Keeps what was typed when returning from the confirmation
                        initialValue: state.email,
                        onChanged: viewModel.onEmailChange,
                        errorText: state.emailError?.text(l10n),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.email],
                        enabled: !state.isLoading,
                        onSubmitted: (_) => submit(),
                      ),
                    ),
                    if (state.errorMessage != null)
                      FormErrorText(message: state.errorMessage!.text(l10n)),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: l10n.recoveryButton,
                      onPressed: submit,
                      isLoading: state.isLoading,
                    ),
                  ] else ...[
                    RecoveryHeading(
                      title: l10n.recoverySentTitle,
                      message: l10n.recoverySentMessage(state.email.trim()),
                    ),
                    if (state.errorMessage != null)
                      FormErrorText(message: state.errorMessage!.text(l10n)),
                    const SizedBox(height: 40),
                    PrimaryButton(
                      text: l10n.recoveryBackToSignIn,
                      // Leaving while the link is sent again is safe
                      onPressed: backToSignIn,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: state.isLoading ? null : submit,
                      child: state.isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                semanticsLabel: l10n.loading,
                              ),
                            )
                          : Text(
                              l10n.recoveryResend,
                              style: textTheme.bodyMedium,
                            ),
                    ),
                    TextButton(
                      onPressed: state.isLoading ? null : viewModel.editEmail,
                      child: Text(
                        l10n.recoveryChangeEmail,
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  if (!state.isSent)
                    TextButton(
                      onPressed: state.isLoading ? null : backToSignIn,
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
    );
  }
}
