import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/core/widgets/form_error_text.dart';
import 'package:ecomind_parents/core/widgets/labeled_text_field.dart';
import 'package:ecomind_parents/core/widgets/primary_button.dart';
import 'package:ecomind_parents/features/iam/presentation/auth_messages.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_page.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_up/sign_up_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/terms/terms_page.dart';
import 'package:ecomind_parents/features/iam/presentation/verify_email/verify_email_page.dart';
import 'package:ecomind_parents/features/iam/presentation/verify_email/verify_email_view_model.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final SignUpViewModel viewModel;
  const new({super.key, required this.viewModel});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(onStateChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(onStateChanged);
    super.dispose();
  }

  // Push and not replace: "Go back" in Verify email returns to this form
  void onStateChanged() {
    final viewModel = widget.viewModel;
    if (viewModel.state.isCodeSent && mounted) {
      viewModel.onCodeScreenOpened();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyEmailPage(
            viewModel: getIt<VerifyEmailViewModel>(),
            registration: viewModel.registration,
          ),
        ),
      );
    }
  }

  void openSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInPage(viewModel: getIt<SignInViewModel>()),
      ),
    );
  }

  void openTerms() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TermsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = widget.viewModel;

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            final state = viewModel.state;
            final textTheme = Theme.of(context).textTheme;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AutofillGroup(
                child: Column(
                  children: [
                    const SizedBox(height: 64),
                    Image.asset(
                      'assets/images/img_logo_ecomind.png',
                      width: 203,
                      height: 74,
                      semanticLabel: l10n.logoDescription,
                    ),
                    const SizedBox(height: 56),
                    LabeledTextField(
                      label: l10n.signUpNameLabel,
                      onChanged: viewModel.onNameChange,
                      errorText: state.nameError?.text(l10n),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      enabled: !state.isLoading,
                    ),
                    const SizedBox(height: 8),
                    LabeledTextField(
                      label: l10n.signInEmailLabel,
                      onChanged: viewModel.onEmailChange,
                      errorText: state.emailError?.text(l10n),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      enabled: !state.isLoading,
                    ),
                    const SizedBox(height: 8),
                    LabeledTextField(
                      label: l10n.signInPasswordLabel,
                      onChanged: viewModel.onPasswordChange,
                      errorText: state.passwordError?.text(l10n),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                      enabled: !state.isLoading,
                    ),
                    const SizedBox(height: 8),
                    LabeledTextField(
                      label: l10n.signUpConfirmPasswordLabel,
                      onChanged: viewModel.onConfirmPasswordChange,
                      errorText: state.confirmPasswordError?.text(l10n),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      enabled: !state.isLoading,
                      onSubmitted: (_) => viewModel.submit(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: state.termsAccepted,
                          onChanged: state.isLoading
                              ? null
                              : (value) =>
                                    viewModel.onTermsAcceptedChange(value!),
                          semanticLabel: l10n.signUpTermsCheckbox,
                        ),
                        Flexible(
                          child: ExcludeSemantics(
                            child: Text(
                              l10n.signUpTermsPrefix,
                              style: textTheme.labelSmall,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: openTerms,
                          child: Text(
                            l10n.signUpTermsLink,
                            style: textTheme.labelSmall?.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (state.termsError != null)
                      FormErrorText(message: state.termsError!.text(l10n)),
                    if (state.errorMessage != null)
                      FormErrorText(message: state.errorMessage!.text(l10n)),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      text: l10n.signUpButton,
                      onPressed: viewModel.submit,
                      isLoading: state.isLoading,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      l10n.signUpHaveAccount,
                      style: textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: state.isLoading ? null : openSignIn,
                      child: Text(
                        l10n.signInButton,
                        style: textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
