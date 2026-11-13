import 'package:ecomind_parents/core/widgets/primary_button.dart';
import 'package:ecomind_parents/core/widgets/text_link.dart';
import 'package:ecomind_parents/features/quests/domain/quest.dart';
import 'package:ecomind_parents/features/quests/infrastructure/quest_repository.dart';
import 'package:ecomind_parents/features/quests/presentation/quest_details_page.dart';
import 'package:ecomind_parents/features/quests/presentation/quest_search_page.dart';
import 'package:ecomind_parents/features/quests/presentation/quest_tile.dart';
import 'package:ecomind_parents/features/users/presentation/profile/profile_view_model.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class QuestsHomePage extends StatefulWidget {
  const new({super.key, required this.profile, required this.repository});

  final ProfileViewModel profile;
  final QuestRepository repository;

  @override
  State<QuestsHomePage> createState() => _QuestsHomePageState();
}

class _QuestsHomePageState extends State<QuestsHomePage> {
  late Future<PendingQuest?> _pending = widget.repository.getPending();
  late Future<List<Quest>> _catalog = widget.repository.getCatalog();

  void _reloadPending() {
    setState(() {
      _pending = widget.repository.getPending();
    });
  }

  void _reloadCatalog() {
    setState(() {
      _catalog = widget.repository.getCatalog();
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _pending = widget.repository.getPending();
      _catalog = widget.repository.getCatalog();
    });
    // The builders render each request's own error state.
    await Future.wait<Object?>([_pending, _catalog])
        .then<void>((_) {}, onError: (Object _) {});
  }

  Future<void> _openQuest(Quest quest, {int? assignmentId}) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => QuestDetailsPage(
          quest: quest,
          repository: widget.repository,
          assignmentId: assignmentId,
        ),
      ),
    );
    if (mounted) _reloadPending();
  }

  Future<void> _search() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => QuestSearchPage(repository: widget.repository),
      ),
    );
    if (mounted) _reloadPending();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final green = theme.brightness == Brightness.light
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.primary;

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 26),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListenableBuilder(
              listenable: widget.profile,
              builder: (context, _) {
                final state = widget.profile.state;
                final name = state.isLoading
                    ? null
                    : state.profile?.name.trim();
                return Semantics(
                  header: true,
                  child: Text(
                    name == null || name.isEmpty
                        ? l10n.questsWelcome
                        : l10n.questsWelcomeName(name),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: green,
                      fontSize: 28,
                      height: 1.18,
                    ),
                  ),
                );
              },
            ),
          ),
          FutureBuilder<PendingQuest?>(
            future: _pending,
            builder: (context, snapshot) {
              final pending = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (pending != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                      child: _PendingCard(
                        quest: pending.quest,
                        green: green,
                        onContinue: () => _openQuest(
                          pending.quest,
                          assignmentId: pending.assignment.id,
                        ),
                      ),
                    ),
                  if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: _LoadError(
                        message: l10n.questsPendingError,
                        onRetry: _reloadPending,
                      ),
                    ),
                  const SizedBox(height: 26),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 16,
                      end: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Semantics(
                            header: true,
                            child: Text(
                              l10n.questsRecommended,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: green,
                                fontWeight: FontWeight.w700,
                                fontSize: 19,
                              ),
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _search,
                          icon: const Icon(Icons.search, size: 21),
                          iconAlignment: IconAlignment.end,
                          label: Text(l10n.questsSearch),
                          style: TextButton.styleFrom(
                            foregroundColor: green,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<List<Quest>>(
                    future: _catalog,
                    builder: (context, catalog) {
                      if (catalog.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _LoadError(
                            message: l10n.questsCatalogError,
                            onRetry: _reloadCatalog,
                          ),
                        );
                      }
                      final quests = catalog.data;
                      if (quests == null) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: CircularProgressIndicator(
                              semanticsLabel: l10n.loading,
                            ),
                          ),
                        );
                      }
                      final recommended = quests
                          .where((quest) => quest.id != pending?.quest.id)
                          .toList();
                      if (recommended.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(l10n.questsEmpty),
                        );
                      }
                      return _Carousel(
                        quests: recommended,
                        green: green,
                        onOpen: _openQuest,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PendingCard extends StatelessWidget {
  const _PendingCard({
    required this.quest,
    required this.green,
    required this.onContinue,
  });

  final Quest quest;
  final Color green;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.questsPickUp,
            style: text.titleMedium?.copyWith(
              color: green,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        _QuestCard(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 14,
              children: [
                QuestTile(theme: quest.theme, size: 74),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8,
                    children: [
                      Text(
                        quest.title,
                        style: text.titleMedium?.copyWith(
                          color: green,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (quest.description.isNotEmpty)
                        Text(quest.description, style: text.bodyMedium),
                      const SizedBox(height: 2),
                      PrimaryButton(
                        text: l10n.questsContinue,
                        onPressed: onContinue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Carousel extends StatelessWidget {
  const _Carousel({
    required this.quests,
    required this.green,
    required this.onOpen,
  });

  final List<Quest> quests;
  final Color green;
  final ValueChanged<Quest> onOpen;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth * .39).clamp(128.0, 192.0);
        final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
        return SizedBox(
          height: 104 + 94 * scale,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: quests.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final quest = quests[index];
              final minutes = quest.minutes;
              final age = quest.age;
              final metadata = [
                if (minutes != null) l10n.questsMinutes(minutes),
                if (age != null) l10n.questsAge(age),
              ].join(' · ');
              return SizedBox(
                width: width,
                child: _QuestCard(
                  onTap: () => onOpen(quest),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        QuestTile(theme: quest.theme, size: 66),
                        Text(
                          quest.title,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleMedium?.copyWith(
                            fontSize: 15,
                            height: 1.2,
                            color: green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (metadata.isNotEmpty)
                          Text(
                            metadata,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodySmall?.copyWith(fontSize: 11),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _QuestCard extends StatelessWidget {
  const _QuestCard({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? child : InkWell(onTap: onTap, child: child),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message),
        TextLink(
          text: AppLocalizations.of(context).questsRetry,
          onPressed: onRetry,
        ),
      ],
    );
  }
}
