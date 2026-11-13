import 'dart:async';

import 'package:ecomind_parents/features/main/secondary_scaffold.dart';
import 'package:ecomind_parents/features/quests/domain/quest.dart';
import 'package:ecomind_parents/features/quests/infrastructure/quest_repository.dart';
import 'package:ecomind_parents/features/quests/presentation/quest_details_page.dart';
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
  late Future<List<Quest>> _results = widget.repository.search('');
  Timer? _debounce;

  void _search() {
    _debounce?.cancel();
    setState(() {
      _results = widget.repository.search(_query.text.trim());
    });
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
    return SecondaryScaffold(
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
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 350), _search);
              },
              onSubmitted: (_) => _search(),
            ),
            Expanded(
              child: FutureBuilder<List<Quest>>(
                future: _results,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
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
                        leading: QuestTile(theme: quest.theme, size: 42),
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
    );
  }
}
