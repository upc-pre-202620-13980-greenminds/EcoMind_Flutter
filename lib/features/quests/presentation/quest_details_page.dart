import 'dart:async';

import 'package:ecomind_parents/core/widgets/pill_button.dart';
import 'package:ecomind_parents/features/quests/domain/quest.dart';
import 'package:ecomind_parents/features/quests/infrastructure/quest_repository.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum _QuestStage { detail, activities, finished }

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
  late _QuestStage _stage = _assignmentId == null
      ? _QuestStage.detail
      : _QuestStage.activities;
  QuestDetails? _details;
  bool _busy = false;
  bool _error = false;
  bool _finishAttempted = false;
  ({int activityId, bool checked})? _pendingCheck;
  final _drafts = <int, String>{};
  Timer? _autosave;

  @override
  void initState() {
    super.initState();
    if (widget.assignmentId != null) _run(_load);
  }

  @override
  void dispose() {
    _autosave?.cancel();
    super.dispose();
  }

  Future<void> _load({QuestAssignment? knownAssignment}) async {
    final details = await widget.repository.getDetails(
      widget.quest,
      assignmentId: _assignmentId,
      knownAssignment: knownAssignment,
    );
    if (mounted) setState(() => _details = details);
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = false;
    });
    try {
      await action();
    } catch (_) {
      if (mounted) setState(() => _error = true);
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        _scheduleAutosave();
      }
    }
  }

  Future<void> _start() => _run(() async {
    if (_details == null) await _load();
    if (!mounted) return;
    if (!_supportsActivities) return;
    final previous = _details?.assignment;
    if (previous?.isPending == true) {
      _assignmentId = previous!.id;
      setState(() => _stage = _QuestStage.activities);
      return;
    }
    // Re-read the assignment on retry if creating it timed out.
    setState(() => _details = null);
    final assignment = await widget.repository.start(widget.quest.id);
    if (!mounted) return;
    _assignmentId = assignment.id;
    await _load(knownAssignment: assignment);
    if (!mounted) return;
    _drafts.clear();
    _finishAttempted = false;
    setState(() => _stage = _QuestStage.activities);
  });

  bool get _canWrite =>
      _stage == _QuestStage.activities &&
      _details?.assignment?.isPending == true &&
      _details?.assignment?.collaborativeSessionId == null &&
      (widget.quest.type == 'ACTIVITIES' || widget.quest.type == 'DAILY_QUEST');

  String _answer(QuestActivity activity) =>
      _drafts[activity.assignmentId] ?? activity.response ?? '';

  bool _validAnswer(QuestActivity activity) =>
      _answer(activity).trim().runes.length >= activity.minCharacters;

  Iterable<QuestActivity> get _written => (_details?.activities ?? []).where(
    (activity) => activity.type == 'WRITE' && activity.assignmentId != null,
  );

  bool _needsSave(QuestActivity activity) =>
      _drafts.containsKey(activity.assignmentId) &&
      _validAnswer(activity) &&
      _answer(activity).trim() != activity.response;

  void _scheduleAutosave() {
    _autosave?.cancel();
    if (!_canWrite || _busy || _error || !_written.any(_needsSave)) return;
    _autosave = Timer(const Duration(milliseconds: 700), () {
      final activity = _written.firstWhere(_needsSave);
      _submit(activity.assignmentId!, {'text': _answer(activity).trim()});
    });
  }

  Future<void> _submit(int activityId, Map<String, Object> value) =>
      _run(() async {
        final details = _details!;
        final checked = value['checked'];
        if (checked is bool) {
          setState(
            () => _pendingCheck = (activityId: activityId, checked: checked),
          );
        }
        try {
          final saved = await widget.repository.submit(activityId, value);
          if (!mounted) return;
          setState(() {
            _details = (
              assignment: saved.assignment,
              activities: [
                for (final activity in details.activities)
                  if (activity.assignmentId == activityId)
                    QuestActivity(
                      description: activity.description,
                      type: activity.type,
                      assignmentId: activityId,
                      isComplete: saved.isComplete,
                      minCharacters: activity.minCharacters,
                      response: saved.response,
                    )
                  else
                    activity,
              ],
            );
          });
        } finally {
          if (mounted) setState(() => _pendingCheck = null);
        }
      });

  Future<void> _finish(QuestAssignment assignment) => _run(() async {
    await widget.repository.finish(assignment.id);
    if (mounted) setState(() => _stage = _QuestStage.finished);
  });

  Future<void> _retry() => _run(() async {
    await _load();
    if (mounted &&
        _stage == _QuestStage.activities &&
        _details?.assignment?.status == 'COMPLETED' &&
        _details?.assignment?.id == _assignmentId) {
      setState(() => _stage = _QuestStage.finished);
    }
  });

  void _back() {
    if (_stage == _QuestStage.activities && widget.assignmentId == null) {
      _autosave?.cancel();
      setState(() => _stage = _QuestStage.detail);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    if (_stage == _QuestStage.finished) {
      return _Celebration(quest: widget.quest);
    }
    final showActivities = _stage == _QuestStage.activities;
    final loadingActivities = showActivities && _details == null;
    final canGoBack = !_busy || !showActivities || loadingActivities;
    return PopScope(
      canPop: canGoBack && (!showActivities || widget.assignmentId != null),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop &&
            canGoBack &&
            showActivities &&
            widget.assignmentId == null) {
          _back();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: IconButton(
                    onPressed: canGoBack ? _back : null,
                    tooltip: MaterialLocalizations.of(context)
                        .backButtonTooltip,
                    icon: const Icon(Icons.chevron_left, size: 32),
                  ),
                ),
                if (_error)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.errorUnknown,
                          style: TextStyle(color: colors.error),
                        ),
                      ),
                      TextButton(
                        onPressed: !showActivities && _details == null
                            ? _start
                            : _retry,
                        child: Text(l10n.questsRetry),
                      ),
                    ],
                  ),
                Expanded(
                  child: RefreshIndicator(
                    notificationPredicate: (notification) =>
                        (showActivities || _details != null) &&
                        defaultScrollNotificationPredicate(notification),
                    onRefresh: () => _run(_load),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        _QuestHeading(quest: widget.quest),
                        if (showActivities) ...[
                          if (loadingActivities && _busy)
                            Center(
                              child: CircularProgressIndicator(
                                semanticsLabel: l10n.loading,
                              ),
                            ),
                          ..._activityContent(context),
                        ] else
                          ..._detailContent(context),
                      ],
                    ),
                  ),
                ),
                ..._actions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _detailContent(BuildContext context) {
    final quest = widget.quest;
    final l10n = AppLocalizations.of(context);
    final image = quest.imageUrl?.trim();
    return [
      Text(quest.description, style: Theme.of(context).textTheme.bodyLarge),
      if ((quest.type == 'MINIGAME') ||
          (_details != null &&
              (!_supportsActivities ||
                  (!quest.canStart &&
                      _details?.assignment?.isPending != true))))
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(l10n.questsActivitiesUnavailable),
        ),
      if (image != null && image.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Image.network(
            image,
            height: 200,
            fit: BoxFit.contain,
            semanticLabel: quest.title,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
        ),
    ];
  }

  bool get _supportsActivities {
    final activities = _details?.activities ?? [];
    return activities.isNotEmpty &&
        activities.every(
          (activity) =>
              activity.type == 'CHECKBOX' ||
              (activity.type == 'WRITE' &&
                  (widget.quest.type == 'ACTIVITIES' ||
                      widget.quest.type == 'DAILY_QUEST')),
        );
  }

  List<Widget> _activityContent(BuildContext context) {
    final details = _details;
    if (details == null) return [];
    final l10n = AppLocalizations.of(context);
    final active = details.assignment?.isPending ?? false;
    final pendingCheck = _pendingCheck;
    final progress = (details.assignment?.progress ?? 0).clamp(0.0, 100.0);
    return [
      for (final activity in details.activities)
        if (activity.type == 'CHECKBOX')
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(activity.description),
            value:
                pendingCheck != null &&
                    pendingCheck.activityId == activity.assignmentId
                ? pendingCheck.checked
                : activity.isComplete,
            onChanged:
                !active || _busy || _error || activity.assignmentId == null
                ? null
                : (value) => _submit(activity.assignmentId!, {
                    'checked': value == true,
                  }),
          )
        else if (activity.type == 'WRITE')
          _WrittenActivity(
            key: ValueKey(activity.assignmentId),
            activity: activity,
            answer: _answer(activity),
            editable: _canWrite && activity.assignmentId != null,
            showError: _finishAttempted && !_validAnswer(activity),
            onChanged: (value) {
              setState(() => _drafts[activity.assignmentId!] = value);
              _scheduleAutosave();
            },
          ),
      const SizedBox(height: 20),
      TweenAnimationBuilder<double>(
        tween: Tween(end: progress / 100),
        duration: const Duration(milliseconds: 200),
        builder: (context, value, _) => LinearProgressIndicator(
          value: value,
          minHeight: 16,
          borderRadius: BorderRadius.circular(8),
          backgroundColor: const Color(0xffe5e5e5),
        ),
      ),
      const SizedBox(height: 6),
      Text(
        l10n.questsPercentCompleted(progress.toInt()),
        textAlign: TextAlign.end,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      const SizedBox(height: 24),
    ];
  }

  List<Widget> _actions(BuildContext context) {
    final details = _details;
    final l10n = AppLocalizations.of(context);
    final assignment = details?.assignment;
    final completed = assignment?.status == 'COMPLETED';
    final active = assignment?.isPending == true;
    if (_stage == _QuestStage.detail) {
      if (!active && !widget.quest.canStart) return [];
      return [
        if (!_busy && completed && _written.isNotEmpty)
          TextButton(
            onPressed: () => setState(() => _stage = _QuestStage.activities),
            child: Text(l10n.questsViewSaved),
          ),
        _QuestButton(
          label: active
              ? l10n.questsContinue
              : completed
              ? l10n.questsRestart
              : l10n.questsStart,
          enabled: !_error && (details == null || _supportsActivities),
          isLoading: _busy,
          onPressed: _start,
        ),
      ];
    }
    if (details == null) return [];
    if (completed) {
      return [
        _QuestButton(
          label: l10n.questsRestart,
          enabled:
              !_busy && !_error && widget.quest.canStart && _supportsActivities,
          onPressed: _start,
        ),
      ];
    }
    final incomplete = _canWrite && _written.any((item) => !_validAnswer(item));
    final familyQuest = widget.quest.type == 'FAMILY';
    final canFinish =
        (familyQuest || assignment?.status == 'READY_TO_COMPLETE') &&
        (assignment?.progress ?? 0) >= 100 &&
        _supportsActivities &&
        details.activities.every((activity) => activity.isComplete) &&
        (!_canWrite || !_written.any(_needsSave));
    return [
      _QuestButton(
        label: l10n.questsFinish,
        enabled: !_busy && !_error && (incomplete || canFinish),
        green: true,
        onPressed: () {
          if (incomplete) {
            setState(() => _finishAttempted = true);
          } else if (familyQuest) {
            _back();
          } else {
            _finish(assignment!);
          }
        },
      ),
    ];
  }
}

class _QuestHeading extends StatelessWidget {
  const _QuestHeading({required this.quest});

  final Quest quest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final (category, categoryColor) = switch (quest.category) {
      'ENERGY' => (l10n.questsEnergy, const Color(0xffffc943)),
      'WATER' => (l10n.questsWater, const Color(0xff3dadff)),
      'RECYCLE' => (l10n.questsRecycle, const Color(0xff66d575)),
      _ => (null, Colors.transparent),
    };
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(l10n.questsDetailLabel, style: theme.textTheme.bodySmall),
        Semantics(
          header: true,
          child: Text(
            quest.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(height: 1.2),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 4,
          runSpacing: 4,
          children: [
            if (category != null) _QuestChip(category, categoryColor),
            if (quest.minutes case final minutes?)
              _QuestChip(l10n.questsMinutes(minutes), const Color(0xffb7b7b7)),
            _QuestChip(
              l10n.questsRewardPoints(quest.ecopoints),
              const Color(0xff7eb962),
            ),
            if (quest.gems > 0)
              _QuestChip(
                l10n.questsRewardGems(quest.gems),
                const Color(0xff3dadff),
              ),
            if (quest.type == 'COLLABORATIVE' || quest.theme == 'COLLABORATIVE')
              _QuestChip(l10n.questsCollaborative, const Color(0xffb580fa)),
          ],
        ),
        const SizedBox(height: 36),
      ],
    );
  }
}

class _QuestChip extends StatelessWidget {
  const _QuestChip(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(color: color, shape: const StadiumBorder()),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class _WrittenActivity extends StatelessWidget {
  const _WrittenActivity({
    super.key,
    required this.activity,
    required this.answer,
    required this.editable,
    required this.showError,
    required this.onChanged,
  });

  final QuestActivity activity;
  final String answer;
  final bool editable;
  final bool showError;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final length = answer.trim().runes.length;
    final helper = l10n.questsAnswerCount(length, activity.minCharacters);
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(12));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Text(activity.description),
          Semantics(
            label: activity.description,
            child: TextFormField(
              initialValue: answer,
              readOnly: !editable,
              onChanged: onChanged,
              minLines: 2,
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHigh,
                border: border,
                enabledBorder: length >= activity.minCharacters
                    ? border.copyWith(
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                        ),
                      )
                    : border,
                errorText: showError ? helper : null,
              ),
            ),
          ),
          if (activity.assignmentId != null && !showError)
            Row(
              children: [
                Expanded(child: Text(helper, style: theme.textTheme.bodySmall)),
                if (answer.trim() == activity.response)
                  Text(
                    l10n.questsAnswerSaved,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _QuestButton extends StatelessWidget {
  const _QuestButton({
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.green = false,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool enabled;
  final bool green;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => PillButton(
    text: label,
    onPressed: onPressed,
    enabled: enabled,
    isLoading: isLoading,
    buttonHeight: 58,
    faceColor: Color(green ? 0xff66d575 : 0xff3dadff),
    shadowColor: Color(green ? 0xff159e67 : 0xff496be7),
  );
}

class _Celebration extends StatelessWidget {
  const _Celebration({required this.quest});

  final Quest quest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(28, 0, 28, 28),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        l10n.questsCelebration,
                        style: theme.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: .82, end: 1),
                        duration: const Duration(milliseconds: 520),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) =>
                            Transform.scale(scale: value, child: child),
                        child: Image.asset(
                          'assets/quests/img_quest_completed.png',
                          width: 240,
                          height: 240,
                          excludeFromSemantics: true,
                        ),
                      ),
                      Text(
                        '+${l10n.questsRewardPoints(quest.ecopoints)}',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (quest.gems > 0)
                        Text('+${l10n.questsRewardGems(quest.gems)}'),
                    ],
                  ),
                ),
              ),
            ),
            _QuestButton(
              label: l10n.questsNice,
              green: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
