import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/core/widgets/form_error_text.dart';
import 'package:ecomind_parents/core/widgets/labeled_text_field.dart';
import 'package:ecomind_parents/core/widgets/primary_button.dart';
import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/presentation/auth_messages.dart';
import 'package:ecomind_parents/features/iam/presentation/recovery_request/password_recovery_page.dart';
import 'package:ecomind_parents/features/iam/presentation/recovery_request/password_recovery_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_up/sign_up_page.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_up/sign_up_view_model.dart';
import 'package:ecomind_parents/features/main/main_page.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  final SignInViewModel viewModel;
  const new({super.key, required this.viewModel});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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

  void onStateChanged() {
    if (widget.viewModel.state.isAuthenticated && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }
  }

  void openSignUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpPage(viewModel: getIt<SignUpViewModel>()),
      ),
    );
  }

  // Push and not replace: going back from the request returns to Sign in
  void openPasswordRecovery() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordRecoveryPage(
          viewModel: getIt<PasswordRecoveryViewModel>(),
          initialEmail: widget.viewModel.state.email.trim(),
        ),
      ),
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
                      obscureText: state.isPasswordHidden,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      enabled: !state.isLoading,
                      // "Done" on the keyboard sends the form
                      onSubmitted: (_) => viewModel.submit(),
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
                    if (state.errorMessage != null)
                      FormErrorText(message: state.errorMessage!.text(l10n)),
                    // The backend gives the same answer to an email that is not verified yet
                    if (state.errorMessage == AuthError.invalidCredentials)
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 4),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            l10n.signInVerifyEmailHint,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: state.isLoading ? null : openPasswordRecovery,
                        child: Text(
                          l10n.signInForgotPassword,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      text: l10n.signInButton,
                      onPressed: viewModel.submit,
                      isLoading: state.isLoading,
                    ),
                    const SizedBox(height: 56),
                    Text(
                      l10n.signInNoAccount,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: state.isLoading ? null : openSignUp,
                      child: Text(
                        l10n.signInSignUpLink,
                        style: Theme.of(context).textTheme.titleMedium,
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
