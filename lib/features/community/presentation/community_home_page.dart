import 'package:flutter/material.dart';

import '../domain/community.dart';
import '../infrastructure/community_repository.dart';
import 'community_widgets.dart';
import 'local_community_page.dart';

class CommunityHomePage extends StatefulWidget {
  const CommunityHomePage({super.key, required this.repository});

  final CommunityRepository repository;

  @override
  State<CommunityHomePage> createState() => _CommunityHomePageState();
}

class _CommunityHomePageState extends State<CommunityHomePage> {
  final _search = TextEditingController();
  String _locality = 'Lima';
  String _query = '';
  bool _joining = false;
  Community? _selected;

  late Future<CommunityDirectory> _directory = widget.repository.getDirectory(
    _locality,
  );

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final request = widget.repository.getDirectory(_locality);
    setState(() => _directory = request);

    try {
      await request;
    } catch (_) {
      // FutureBuilder muestra el error y permite reintentar.
    }
  }

  Future<void> _changeLocality() async {
    var value = _locality;

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cambiar localidad'),
        content: TextFormField(
          initialValue: value,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Localidad',
            hintText: 'Ejemplo: Lima',
          ),
          onChanged: (text) => value = text,
          onFieldSubmitted: (text) {
            if (text.trim().isNotEmpty) {
              Navigator.pop(dialogContext, text.trim());
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (value.trim().isNotEmpty) {
                Navigator.pop(dialogContext, value.trim());
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (!mounted || result == null || result == _locality) return;

    _locality = result;
    _query = '';
    _search.clear();
    await _reload();
  }

  Future<void> _open(Community community, bool isMember) async {
    if (_joining) return;

    if (isMember) {
      setState(() => _selected = community);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(community.name),
        content: SingleChildScrollView(
          child: Text(
            '${community.description}\n\n'
            'Localidad: ${community.locality}\n\n'
            'Solo puedes pertenecer a una comunidad local.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Unirme'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    setState(() => _joining = true);

    try {
      await widget.repository.join(community.id);
      if (!mounted) return;

      // Actualiza las membresías antes de abrir el detalle.
      await _reload();
      if (!mounted) return;

      setState(() => _selected = community);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(communityError(error))));
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  void _backToDirectory() {
    setState(() => _selected = null);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;

    return PopScope(
      canPop: selected == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _selected != null) _backToDirectory();
      },
      child: selected != null
          ? LocalCommunityPage(
              key: ValueKey(selected.id),
              community: selected,
              repository: widget.repository,
              onBack: _backToDirectory,
            )
          : _buildDirectory(),
    );
  }

  Widget _buildDirectory() {
    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => communityComingSoon(context),
              child: const Text('Mis eventos'),
            ),
          ),
          CommunitySelector(onLocal: () {}),
          const SizedBox(height: 16),
          CommunitySearch(
            controller: _search,
            hint: 'Buscar comunidad',
            onSearch: () {
              setState(() => _query = _search.text.trim().toLowerCase());
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Localidad: $_locality'),
                TextButton(
                  onPressed: _joining ? null : _changeLocality,
                  child: const Text('Cambiar'),
                ),
              ],
            ),
          ),
          if (_joining) const LinearProgressIndicator(),
          const SizedBox(height: 12),
          FutureBuilder<CommunityDirectory>(
            future: _directory,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return CommunityFailure(
                  error: snapshot.error,
                  onRetry: _reload,
                );
              }

              final directory = snapshot.data!;
              final communities = directory.communities
                  .where((item) => item.name.toLowerCase().contains(_query))
                  .toList();

              if (communities.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No se encontraron comunidades. '
                    'Prueba otra búsqueda o cambia la localidad.',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return Column(
                children: [
                  for (final community in communities)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CommunityCard(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CommunityImage(url: community.iconUrl),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  community.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                              ),
                              const SizedBox(width: 8),
                              FilledButton(
                                onPressed: _joining
                                    ? null
                                    : () => _open(
                                        community,
                                        directory.membershipIds.contains(
                                          community.id,
                                        ),
                                      ),
                                child: Text(
                                  directory.membershipIds.contains(community.id)
                                      ? 'Entrar'
                                      : 'Unirme',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
