import 'package:flutter/material.dart';

import '../domain/community.dart';
import '../infrastructure/community_repository.dart';
import 'community_widgets.dart';

class LocalCommunityPage extends StatefulWidget {
  const LocalCommunityPage({
    super.key,
    required this.community,
    required this.repository,
    required this.onBack,
  });

  final Community community;
  final CommunityRepository repository;
  final VoidCallback onBack;

  @override
  State<LocalCommunityPage> createState() => _LocalCommunityPageState();
}

class _LocalCommunityPageState extends State<LocalCommunityPage> {
  final _search = TextEditingController();
  String _query = '';

  late Future<List<CommunityEvent>> _events = widget.repository.getEvents(
    widget.community.id,
  );

  late Future<CommunityGoal?> _goal = widget.repository.getGoal(
    widget.community.id,
  );

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _reloadEvents() {
    setState(() {
      _events = widget.repository.getEvents(widget.community.id);
    });
  }

  void _reloadGoal() {
    setState(() {
      _goal = widget.repository.getGoal(widget.community.id);
    });
  }

  Future<void> _refresh() async {
    _reloadEvents();
    _reloadGoal();

    try {
      await Future.wait<Object?>([_events, _goal]);
    } catch (_) {
      // Cada FutureBuilder muestra el error de su sección.
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = communityGreen(context);

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          CommunitySelector(onLocal: widget.onBack),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.community.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: green,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      widget.community.locality,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Opciones de comunidad',
                onSelected: (_) => widget.onBack(),
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'directory',
                    child: Text('Ver comunidades locales'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildGoal(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => communityComingSoon(context),
                  child: const Text('Premios'),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: green, width: 2)),
                  ),
                  child: Text(
                    'Eventos',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => communityComingSoon(context),
                  child: const Text('Noticias'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CommunitySearch(
                  controller: _search,
                  hint: 'Buscar evento',
                  onSearch: () {
                    setState(() {
                      _query = _search.text.trim().toLowerCase();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  FilledButton(
                    onPressed: () => communityComingSoon(context),
                    child: const Text('+ Crear'),
                  ),
                  TextButton(
                    onPressed: () => communityComingSoon(context),
                    child: const Text('Mis eventos'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildEvents(),
        ],
      ),
    );
  }

  Widget _buildGoal() {
    return FutureBuilder<CommunityGoal?>(
      future: _goal,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LinearProgressIndicator();
        }

        if (snapshot.hasError) {
          return CommunityFailure(error: snapshot.error, onRetry: _reloadGoal);
        }

        final goal = snapshot.data;

        return CommunityCard(
          child: ExpansionTile(
            shape: const Border(),
            collapsedShape: const Border(),
            title: Text(
              goal?.title ?? 'No hay una meta comunitaria activa.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: communityGreen(context),
                fontWeight: FontWeight.w600,
              ),
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              if (goal == null)
                const Text('Cuando exista una meta, aparecerá aquí.')
              else ...[
                LinearProgressIndicator(value: goal.fraction),
                const SizedBox(height: 8),
                Text('Progreso: ${goal.progress} / ${goal.target}'),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildEvents() {
    return FutureBuilder<List<CommunityEvent>>(
      future: _events,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return CommunityFailure(
            error: snapshot.error,
            onRetry: _reloadEvents,
          );
        }

        final events = snapshot.data!
            .where((event) => event.name.toLowerCase().contains(_query))
            .toList();

        if (events.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'No hay eventos para mostrar.',
              textAlign: TextAlign.center,
            ),
          );
        }

        return Column(
          children: [
            for (final event in events)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _EventCard(event: event),
              ),
          ],
        );
      },
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final CommunityEvent event;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return CommunityCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: text.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (event.location.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(event.location, style: text.bodySmall),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        'Cupos disponibles: ${event.availablePlaces}',
                        style: text.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                CommunityImage(url: event.imageUrl, size: 76),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: null,
              child: const Text('Inscripción próximamente'),
            ),
          ],
        ),
      ),
    );
  }
}
