import 'package:ecomind_parents/core/widgets/coming_soon_page.dart';
import 'package:ecomind_parents/core/widgets/primary_button.dart';
import 'package:ecomind_parents/features/quests/domain/quest.dart';
import 'package:ecomind_parents/features/quests/infrastructure/quest_repository.dart';
import 'package:ecomind_parents/features/quests/presentation/quest_details_page.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class QuestProgressPage extends StatefulWidget {
  const new({super.key, required this.repository, this.isActive = true});

  final QuestRepository repository;
  final bool isActive;

  @override
  State<QuestProgressPage> createState() => _QuestProgressPageState();
}

class _QuestProgressPageState extends State<QuestProgressPage> {
  late Future<List<QuestProgressEntry>> _progress = widget.repository
      .getProgress();

  @override
  void didUpdateWidget(QuestProgressPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActive && widget.isActive) {
      _progress = widget.repository.getProgress();
    }
  }

  Future<void> _refresh() async {
    setState(() => _progress = widget.repository.getProgress());
    await _progress.then<void>((_) {}, onError: (Object _) {});
  }

  void _showComingSoon() {
    Navigator.of(context)
        .push<void>(MaterialPageRoute(builder: (_) => const ComingSoonPage()));
  }

  Future<void> _openQuest(QuestProgressEntry entry) async {
    final quest = entry.quest;
    if (quest == null) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => QuestDetailsPage(
          quest: quest,
          repository: widget.repository,
          assignmentId: entry.assignment.id,
        ),
      ),
    );
    if (mounted) await _refresh();
  }

  Future<void> _openList(String title, String empty, List<Widget> rows) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
              children: [_ProgressCard(title: title, empty: empty, rows: rows)],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder(
      future: _progress,
      builder: (context, snapshot) {
        if (!snapshot.hasData &&
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(semanticsLabel: l10n.loading),
          );
        }
        final entries = snapshot.data ?? const <QuestProgressEntry>[];
        final pending =
            entries.where((entry) => entry.assignment.isPending).toList()
              ..sort((a, b) => b.assignment.id.compareTo(a.assignment.id));
        final completed = <int, List<QuestProgressEntry>>{};
        for (final entry in entries) {
          if (entry.assignment.status == 'COMPLETED') {
            completed
                .putIfAbsent(entry.assignment.questId, () => [])
                .add(entry);
          }
        }
        final history = completed.values.toList();
        for (final attempts in history) {
          attempts.sort(_compareCompletions);
        }
        history.sort(
          (a, b) => _compareCompletions(a.first, b.first, latestFirst: true),
        );

        List<Widget> pendingRows(Iterable<QuestProgressEntry> items) => [
          for (final entry in items)
            _ProgressRow(
              entry: entry,
              onOpen: entry.quest == null ? null : () => _openQuest(entry),
            ),
        ];

        List<Widget> historyRows(Iterable<List<QuestProgressEntry>> items) => [
          for (final attempts in items)
            _ProgressRow(
              key: ValueKey(attempts.first.assignment.id),
              entry: attempts.first,
              otherCompletions: attempts.skip(1).toList()
                ..sort((a, b) => _compareCompletions(a, b, latestFirst: true)),
              onOpen: attempts.first.quest == null
                  ? null
                  : () => _openQuest(attempts.first),
            ),
        ];

        final active = pending.where((entry) => entry.quest?.type != 'FAMILY');
        final family = pending.where((entry) => entry.quest?.type == 'FAMILY');
        final loaded = snapshot.hasData;

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            children: [
              if (snapshot.hasError) ...[
                Text(
                  l10n.progressLoadError,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton(
                    onPressed: _refresh,
                    child: Text(l10n.questsRetry),
                  ),
                ),
              ],
              _ProgressCard(
                title: l10n.progressActive,
                empty: loaded ? l10n.progressEmptyActive : null,
                rows: pendingRows(active.take(2)),
                action: _ProgressLink(
                  label: l10n.progressSeeMore,
                  onPressed: loaded
                      ? () => _openList(
                          l10n.progressActive,
                          l10n.progressEmptyActive,
                          pendingRows(active),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              _ProgressCard(
                title: l10n.progressFamily,
                empty: loaded ? l10n.progressEmptyFamily : null,
                rows: pendingRows(family.take(2)),
                action: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: PrimaryButton(
                      text: l10n.progressCreateFamilyPlan,
                      onPressed: _showComingSoon,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _ProgressCard(
                title: l10n.progressFinished,
                empty: loaded ? l10n.progressEmptyFinished : null,
                rows: historyRows(history.take(2)),
                action: _ProgressLink(
                  label: l10n.progressViewHistory,
                  onPressed: loaded
                      ? () => _openList(
                          l10n.progressHistory,
                          l10n.progressEmptyFinished,
                          historyRows(history),
                        )
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

int _compareCompletions(
  QuestProgressEntry a,
  QuestProgressEntry b, {
  bool latestFirst = false,
}) {
  final aDate = a.assignment.endDate;
  final bDate = b.assignment.endDate;
  if (aDate == null && bDate != null) return 1;
  if (bDate == null && aDate != null) return -1;
  final byDate = aDate?.compareTo(bDate!) ?? 0;
  final order = byDate == 0
      ? a.assignment.id.compareTo(b.assignment.id)
      : byDate;
  return latestFirst ? -order : order;
}

class _ProgressCard extends StatelessWidget {
  const new({required this.title, required this.rows, this.empty, this.action});

  final String title;
  final List<Widget> rows;
  final String? empty;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.only(top: 8),
          elevation: 3,
          color: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 44, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                ...rows,
                if (rows.isEmpty && empty != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(empty!),
                  ),
                ?action,
              ],
            ),
          ),
        ),
        Semantics(
          header: true,
          child: Container(
            constraints: const BoxConstraints(minWidth: 155, minHeight: 39),
            padding: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2B824B),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF69A44E),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressLink extends StatelessWidget {
  const new({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: TextButton(
        onPressed: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              label,
              style: TextStyle(color: colors.onPrimaryContainer),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressRow extends StatefulWidget {
  const new({
    super.key,
    required this.entry,
    this.otherCompletions = const [],
    this.onOpen,
  });

  final QuestProgressEntry entry;
  final List<QuestProgressEntry> otherCompletions;
  final VoidCallback? onOpen;

  @override
  State<_ProgressRow> createState() => _ProgressRowState();
}

class _ProgressRowState extends State<_ProgressRow> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dates = MaterialLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final assignment = widget.entry.assignment;
    final date = assignment.endDate;
    final title = widget.entry.quest?.title.trim();
    final fraction = assignment.status == 'COMPLETED'
        ? 1.0
        : (assignment.progress / 100).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: widget.onOpen,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        title == null || title.isEmpty
                            ? l10n.progressUnavailableQuest
                            : title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (date != null && assignment.status == 'COMPLETED')
                        Text(
                          l10n.progressCompletedOn(
                            dates.formatMediumDate(date),
                          ),
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (widget.otherCompletions.isNotEmpty)
                IconButton(
                  tooltip: _expanded
                      ? l10n.progressHideCompletions
                      : l10n.progressShowCompletions,
                  onPressed: () => setState(() => _expanded = !_expanded),
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                ),
            ],
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: widget.onOpen,
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
              backgroundColor: colors.surfaceContainerHighest,
            ),
          ),
          if (_expanded)
            for (final attempt in widget.otherCompletions)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 12, top: 8),
                child: Text(
                  attempt.assignment.endDate == null
                      ? l10n.progressMissingDate
                      : dates.formatMediumDate(attempt.assignment.endDate!),
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ),
        ],
      ),
    );
  }
}
