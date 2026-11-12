import 'package:ecomind_parents/core/widgets/form_error_text.dart';
import 'package:ecomind_parents/core/widgets/labeled_text_field.dart';
import 'package:ecomind_parents/core/widgets/pill_button.dart';
import 'package:ecomind_parents/features/main/secondary_scaffold.dart';
import 'package:ecomind_parents/features/users/presentation/family/create_family/create_family_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/family/family_messages.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Frames 18 and 45
class CreateFamilyPage extends StatefulWidget {
  final CreateFamilyViewModel viewModel;
  const new({super.key, required this.viewModel});

  @override
  State<CreateFamilyPage> createState() => _CreateFamilyPageState();
}

class _CreateFamilyPageState extends State<CreateFamilyPage> {
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

  // Closes with the new family, so the Family tab shows it
  void onStateChanged() {
    final created = widget.viewModel.state.createdFamily;
    if (created != null && mounted) {
      Navigator.pop(context, created);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = widget.viewModel;

    return SecondaryScaffold(
      title: l10n.createFamilyTitle,
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          final state = viewModel.state;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                LabeledTextField(
                  label: l10n.familyNameLabel,
                  hintText: l10n.familyNamePlaceholder,
                  bordered: true,
                  onChanged: viewModel.onNameChange,
                  errorText: state.nameMissing ? l10n.familyNameRequired : null,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  // Same limit as the backend
                  inputFormatters: [LengthLimitingTextInputFormatter(150)],
                  enabled: !state.isSaving,
                ),
                const SizedBox(height: 24),
                LabeledTextField(
                  label: l10n.familyCommitmentLabel,
                  hintText: l10n.familyCommitmentPlaceholder,
                  bordered: true,
                  maxLines: 3,
                  onChanged: viewModel.onCommitmentChange,
                  errorText: state.commitmentMissing
                      ? l10n.familyCommitmentRequired
                      : null,
                  textCapitalization: TextCapitalization.sentences,
                  inputFormatters: [LengthLimitingTextInputFormatter(255)],
                  enabled: !state.isSaving,
                ),
                if (state.hasMissingFields)
                  FormErrorText(message: l10n.familyRequiredInfo),
                if (state.errorMessage != null)
                  FormErrorText(message: state.errorMessage!.text(l10n)),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: PillButton(
                    text: l10n.createFamilySave,
                    onPressed: viewModel.save,
                    isLoading: state.isSaving,
                  ),
                ),
                TextButton(
                  onPressed: state.isSaving
                      ? null
                      : () => Navigator.pop(context),
                  child: Text(
                    l10n.cancel,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
