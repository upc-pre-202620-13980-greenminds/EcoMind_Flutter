import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/core/widgets/form_error_text.dart';
import 'package:ecomind_parents/core/widgets/labeled_text_field.dart';
import 'package:ecomind_parents/core/widgets/primary_button.dart';
import 'package:ecomind_parents/features/iam/domain/account_rules.dart';
import 'package:ecomind_parents/features/iam/domain/registration.dart';
import 'package:ecomind_parents/features/iam/presentation/auth_messages.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_page.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/verify_email/verify_email_view_model.dart';
import 'package:ecomind_parents/features/main/main_page.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerifyEmailPage extends StatefulWidget {
  final VerifyEmailViewModel viewModel;
  final Registration registration;
  const new({super.key, required this.viewModel, required this.registration});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool wasCodeResent = false;

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
    if (!mounted) {
      return;
    }
    final state = widget.viewModel.state;

    // Only when it changes, so the message is not shown again on every update
    if (state.codeResent && !wasCodeResent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).verifyEmailCodeResent),
        ),
      );
    }
    wasCodeResent = state.codeResent;

    // Sign up and this screen are removed: there is no way back to them
    if (state.isAuthenticated) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false,
      );
    } else if (state.needsSignIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SignInPage(viewModel: getIt<SignInViewModel>()),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = widget.viewModel;
    final registration = widget.registration;

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
                  const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: BackButton(),
                  ),
                  const SizedBox(height: 16),
                  Image.asset(
                    'assets/images/img_logo_ecomind.png',
                    width: 203,
                    height: 74,
                    semanticLabel: l10n.logoDescription,
                  ),
                  Text(
                    l10n.verifyEmailSubtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  Text(
                    l10n.verifyEmailMessage(
                      EmailAddress.normalize(registration.email),
                    ),
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  LabeledTextField(
                    label: l10n.verifyEmailCodeLabel,
                    onChanged: viewModel.onCodeChange,
                    errorText: state.codeError?.text(l10n),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    // Only digits, up to the length of the code
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(VerificationCode.length),
                    ],
                    enabled: !state.isLoading,
                    onSubmitted: (_) => viewModel.confirm(registration),
                  ),
                  if (state.errorMessage != null)
                    FormErrorText(message: state.errorMessage!.text(l10n)),
                  const SizedBox(height: 40),
                  PrimaryButton(
                    text: l10n.verifyEmailButton,
                    onPressed: () => viewModel.confirm(registration),
                    isLoading: state.isLoading,
                  ),
                  TextButton(
                    onPressed: state.isLoading
                        ? null
                        : () => viewModel.resendCode(registration),
                    child: Text(
                      l10n.verifyEmailResend,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 48),
                  TextButton(
                    onPressed: state.isLoading
                        ? null
                        : () => Navigator.pop(context),
                    child: Text(
                      l10n.verifyEmailGoBack,
                      style: textTheme.bodyMedium,
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
