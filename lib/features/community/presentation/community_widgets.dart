import 'package:ecomind_parents/core/api_exception.dart';
import 'package:flutter/material.dart';

Color communityGreen(BuildContext context) {
  final theme = Theme.of(context);
  return theme.brightness == Brightness.light
      ? theme.colorScheme.onPrimaryContainer
      : theme.colorScheme.primary;
}

void communityComingSoon(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Esta función estará disponible próximamente.'),
    ),
  );
}

String communityError(Object? error) {
  if (error is ApiException) {
    if (error.statusCode == 401) {
      return 'Tu sesión venció. Vuelve a iniciar sesión.';
    }
    if (error.statusCode == 403) {
      return 'No tienes permiso para realizar esta acción.';
    }
    if (error.statusCode == 409) {
      return 'No se pudo completar la operación. '
          'Actualiza el listado para revisar tu membresía.';
    }
  }
  return 'No se pudo completar la solicitud. Inténtalo nuevamente.';
}

class CommunityCard extends StatelessWidget {
  const CommunityCard({super.key, required this.child});

  final Widget child;

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
      child: child,
    );
  }
}

class CommunitySelector extends StatelessWidget {
  const CommunitySelector({super.key, required this.onLocal});

  final VoidCallback onLocal;

  @override
  Widget build(BuildContext context) {
    return CommunityCard(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: onLocal,
                child: const Text(
                  'Comunidad local',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () => communityComingSoon(context),
                child: const Text(
                  'Más comunidades',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommunitySearch extends StatelessWidget {
  const CommunitySearch({
    super.key,
    required this.controller,
    required this.onSearch,
    this.hint = 'Buscar',
  });

  final TextEditingController controller;
  final VoidCallback onSearch;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => onSearch(),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          tooltip: 'Buscar',
          onPressed: onSearch,
          icon: const Icon(Icons.arrow_forward),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}

class CommunityFailure extends StatelessWidget {
  const CommunityFailure({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(communityError(error), textAlign: TextAlign.center),
          TextButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}

class CommunityImage extends StatelessWidget {
  const CommunityImage({super.key, required this.url, this.size = 48});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final placeholder = ColoredBox(
      color: colors.primaryContainer,
      child: Center(
        child: Icon(Icons.eco_outlined, color: colors.onPrimaryContainer),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox.square(
        dimension: size,
        child: url == null || url!.trim().isEmpty
            ? placeholder
            : Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, error, stackTrace) => placeholder,
              ),
      ),
    );
  }
}
