import 'package:ecomind_parents/core/widgets/labeled_text_field.dart';
import 'package:ecomind_parents/core/widgets/pill_button.dart';
import 'package:ecomind_parents/core/widgets/screen_header.dart';
import 'package:ecomind_parents/features/main/main_top_bar.dart';
import 'package:ecomind_parents/features/users/domain/personal_commitment.dart';
import 'package:ecomind_parents/features/users/presentation/commitment/commitment_state.dart';
import 'package:ecomind_parents/features/users/presentation/commitment/commitment_view_model.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Frames 05 to 08 (HU-006). Add and Edit only differ in the title and in the starting text.
class CommitmentPage extends StatefulWidget {
  final CommitmentViewModel viewModel;
  // Null to add a commitment, the current one to edit it
  final String? commitment;
  const new({super.key, required this.viewModel, this.commitment});

  @override
  State<CommitmentPage> createState() => _CommitmentPageState();
}

class _CommitmentPageState extends State<CommitmentPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.start(widget.commitment);
    widget.viewModel.addListener(onStateChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(onStateChanged);
    super.dispose();
  }

  // Closes with the saved text, so Profile shows it
  void onStateChanged() {
    final saved = widget.viewModel.state.savedText;
    if (saved != null && mounted) {
      Navigator.pop(context, saved);
    }
  }

  String? textErrorText(AppLocalizations l10n, CommitmentError? error) {
    return switch (error) {
      CommitmentError.required => l10n.commitmentRequired,
      CommitmentError.length => l10n.commitmentLength(
        PersonalCommitment.maxLength,
      ),
      null => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = widget.viewModel;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const MainTopBar(),
            ScreenHeader(
              title: widget.commitment == null
                  ? l10n.commitmentAddTitle
                  : l10n.commitmentEditTitle,
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: viewModel,
                builder: (context, child) {
                  final state = viewModel.state;
                  final colorScheme = Theme.of(context).colorScheme;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.commitmentSubtitle,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 32),
                        LabeledTextField(
                          label: l10n.commitmentLabel,
                          initialValue: widget.commitment,
                          hintText: l10n.commitmentPlaceholder,
                          bordered: true,
                          maxLines: 6,
                          onChanged: viewModel.onTextChange,
                          errorText: textErrorText(l10n, state.textError),
                          textCapitalization: TextCapitalization.sentences,
                          // The field does not accept more characters than the limit
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                              PersonalCommitment.maxLength,
                            ),
                          ],
                          enabled: !state.isSaving,
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            // "42 of 150 characters" is read instead of "42/150"
                            child: Semantics(
                              label: l10n.commitmentCounterDescription(
                                state.text.length,
                                PersonalCommitment.maxLength,
                              ),
                              excludeSemantics: true,
                              child: Text(
                                l10n.commitmentCounter(
                                  state.text.length,
                                  PersonalCommitment.maxLength,
                                ),
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (state.saveFailed) const _SaveFailure(),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          // After a failure the same button retries with the text in the field
                          child: PillButton(
                            text: state.saveFailed
                                ? l10n.commitmentRetry
                                : l10n.commitmentSave,
                            onPressed: viewModel.save,
                            isLoading: state.isSaving,
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: state.isSaving
                                ? null
                                : () => Navigator.pop(context),
                            child: Text(
                              l10n.commitmentCancel,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Frame 08: the text the user wrote stays in the field
class _SaveFailure extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    // The screen reader announces the failure as soon as it appears
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              l10n.commitmentSaveFailed,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: colorScheme.onErrorContainer,
              ),
            ),
            Text(
              l10n.commitmentSaveFailedHint,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: colorScheme.onErrorContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
