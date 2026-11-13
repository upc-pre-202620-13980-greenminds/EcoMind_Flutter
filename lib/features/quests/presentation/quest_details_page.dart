import 'package:ecomind_parents/core/widgets/primary_button.dart';
import 'package:ecomind_parents/features/main/secondary_scaffold.dart';
import 'package:ecomind_parents/features/quests/domain/quest.dart';
import 'package:ecomind_parents/features/quests/infrastructure/quest_repository.dart';
import 'package:ecomind_parents/features/quests/presentation/quest_tile.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class QuestDetailsPage extends StatefulWidget {
  const new({
    super.key,
    required this.quest,
    required this.repository,
    this.assignmentId,
  });

  final Quest quest;
  final QuestRepository repository;
  final int? assignmentId;

  @override
  State<QuestDetailsPage> createState() => _QuestDetailsPageState();
}

class _QuestDetailsPageState extends State<QuestDetailsPage> {
  late int? _assignmentId = widget.assignmentId;
  late Future<QuestDetails> _details = _load();
  bool _saving = false;

  Future<QuestDetails> _load() =>
      widget.repository.getDetails(widget.quest, assignmentId: _assignmentId);

  void _reload() {
    setState(() {
      _details = _load();
    });
  }

  Future<void> _save(Future<void> Function() action) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await action();
      final details = await _load();
      if (mounted) {
        setState(() {
          _details = Future.value(details);
        });
      }
    } catch (_) {
      if (mounted) {
        _reload();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).errorUnknown)),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _write(QuestActivity activity) async {
    final l10n = AppLocalizations.of(context);
    var response = activity.response ?? '';
    final result = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(activity.description),
          content: TextFormField(
            initialValue: response,
            autofocus: true,
            minLines: 2,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: l10n.questsResponse,
              helperText: l10n.questsMinCharacters(activity.minCharacters),
            ),
            onChanged: (value) => setDialogState(() => response = value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: response.trim().runes.length < activity.minCharacters
                  ? null
                  : () => Navigator.pop(context, response.trim()),
              child: Text(l10n.editProfileSave),
            ),
          ],
        ),
      ),
    );
    if (mounted && result != null) {
      await _save(
        () =>
            widget.repository.submit(activity.assignmentId!, {'text': result}),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final quest = widget.quest;
    return SecondaryScaffold(
      title: quest.title,
      body: PopScope(
        canPop: !_saving,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            Center(child: QuestTile(theme: quest.theme, size: 72)),
            const SizedBox(height: 16),
            Text(quest.description),
            const SizedBox(height: 16),
            if (quest.canStart || widget.assignmentId != null)
              FutureBuilder<QuestDetails>(
                future: _details,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(
                      child: CircularProgressIndicator(
                        semanticsLabel: l10n.loading,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return TextButton(
                      onPressed: _reload,
                      child: Text(l10n.questsRetry),
                    );
                  }
                  final details = snapshot.requireData;
                  final assignment = details.assignment;
                  final active = assignment?.isPending ?? false;
                  final supported =
                      details.activities.isNotEmpty &&
                      details.activities.every(
                        (activity) =>
                            activity.type == 'CHECKBOX' ||
                            activity.type == 'WRITE',
                      );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final activity in details.activities)
                        if (activity.type == 'CHECKBOX')
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(activity.description),
                            value: activity.isComplete,
                            onChanged:
                                !active ||
                                    _saving ||
                                    activity.assignmentId == null
                                ? null
                                : (value) => _save(
                                    () => widget.repository.submit(
                                      activity.assignmentId!,
                                      {'checked': value == true},
                                    ),
                                  ),
                          )
                        else
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(activity.description),
                            subtitle: activity.response == null
                                ? null
                                : Text(activity.response!),
                            trailing: activity.type != 'WRITE'
                                ? null
                                : IconButton(
                                    tooltip: l10n.questsResponse,
                                    onPressed:
                                        !active ||
                                            _saving ||
                                            activity.assignmentId == null ||
                                            activity.isComplete
                                        ? null
                                        : () => _write(activity),
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                          ),
                      if (assignment?.status == 'COMPLETED')
                        Text(l10n.questsCompleted)
                      else if (!active && quest.canStart && supported)
                        PrimaryButton(
                          text: l10n.questsStart,
                          isLoading: _saving,
                          onPressed: () => _save(() async {
                            _assignmentId = await widget.repository.start(
                              quest.id,
                            );
                          }),
                        )
                      else if (quest.type != 'FAMILY' &&
                          assignment?.status == 'READY_TO_COMPLETE' &&
                          details.activities.isNotEmpty &&
                          details.activities.every(
                            (activity) => activity.isComplete,
                          ))
                        PrimaryButton(
                          text: l10n.questsFinish,
                          isLoading: _saving,
                          onPressed: () => _save(
                            () => widget.repository.finish(assignment!.id),
                          ),
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
