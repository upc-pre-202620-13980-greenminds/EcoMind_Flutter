import 'dart:async';

import 'package:ecomind_parents/features/main/secondary_scaffold.dart';
import 'package:ecomind_parents/features/quests/domain/quest.dart';
import 'package:ecomind_parents/features/quests/domain/quest_filters.dart';
import 'package:ecomind_parents/features/quests/infrastructure/quest_repository.dart';
import 'package:ecomind_parents/features/quests/presentation/quest_details_page.dart';
import 'package:ecomind_parents/features/quests/presentation/quest_filter_panel.dart';
import 'package:ecomind_parents/features/quests/presentation/quest_tile.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class QuestSearchPage extends StatefulWidget {
  const new({super.key, required this.repository});

  final QuestRepository repository;

  @override
  State<QuestSearchPage> createState() => _QuestSearchPageState();
}

class _QuestSearchPageState extends State<QuestSearchPage> {
  final _query = TextEditingController();
  QuestFilters _filters = const QuestFilters();
  bool _showFilters = false;
  late Future<List<Quest>> _results = widget.repository.search('');
  Timer? _debounce;

  void _search() {
    _debounce?.cancel();
    setState(() {
      _results = widget.repository.search(
        _query.text.trim(),
        filters: _filters,
      );
    });
  }

  void _toggleFilters() {
    FocusScope.of(context).unfocus();
    _debounce?.cancel();
    setState(() => _showFilters = !_showFilters);
    if (!_showFilters) _search();
  }

  void _applyFilters(QuestFilters filters) {
    FocusScope.of(context).unfocus();
    _filters = filters;
    _showFilters = false;
    _search();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopScope(
      canPop: !_showFilters,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _showFilters) _toggleFilters();
      },
      child: SecondaryScaffold(
        title: l10n.questsSearch,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 12,
            children: [
              TextField(
                controller: _query,
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  labelText: l10n.questsSearchHint,
                  prefixIcon: IconButton(
                    tooltip: l10n.questsFilters,
                    isSelected: _showFilters,
                    onPressed: _toggleFilters,
                    icon: Badge(
                      isLabelVisible: _filters.isActive,
                      child: const Icon(Icons.tune),
                    ),
                  ),
                  suffixIcon: IconButton(
                    tooltip: l10n.questsSearch,
                    onPressed: () => _applyFilters(_filters),
                    icon: const Icon(Icons.search),
                  ),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_) {
                  if (_showFilters) return;
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 350), _search);
                },
                onSubmitted: (_) => _applyFilters(_filters),
              ),
              Expanded(
                child: _showFilters
                    ? QuestFilterPanel(
                        initial: _filters,
                        onApply: _applyFilters,
                      )
                    : FutureBuilder<List<Quest>>(
                        future: _results,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Center(
                              child: CircularProgressIndicator(
                                semanticsLabel: l10n.loading,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: TextButton(
                                onPressed: _search,
                                child: Text(l10n.questsRetry),
                              ),
                            );
                          }
                          final results = snapshot.requireData;
                          if (results.isEmpty) {
                            return Center(child: Text(l10n.questsNoResults));
                          }
                          return ListView.builder(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              final quest = results[index];
                              return ListTile(
                                leading: QuestTile(
                                  theme: quest.theme,
                                  size: 42,
                                ),
                                title: Text(quest.title),
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  Navigator.of(context).push<void>(
                                    MaterialPageRoute(
                                      builder: (_) => QuestDetailsPage(
                                        quest: quest,
                                        repository: widget.repository,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
