import 'package:ecomind_parents/features/monetization/application/buy_store_item_use_case.dart';
import 'package:ecomind_parents/features/monetization/domain/monetization_exception.dart';
import 'package:ecomind_parents/features/monetization/domain/store_catalog.dart';
import 'package:ecomind_parents/features/monetization/presentation/store/store_state.dart';
import 'package:ecomind_parents/features/monetization/presentation/store/store_view_model.dart';
import 'package:flutter/material.dart';

class StorePage extends StatefulWidget {
  final StoreViewModel viewModel;
  final Future<void> Function()? onBalanceChanged;

  const StorePage({super.key, required this.viewModel, this.onBalanceChanged});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_feedback);
    widget.viewModel.load();
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_feedback);
    super.dispose();
  }

  void _feedback() {
    final state = widget.viewModel.state;
    if (!mounted || (state.error == null && !state.operationSucceeded)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      if (state.operationSucceeded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La tienda se actualizó correctamente.'),
          ),
        );
        await widget.onBalanceChanged?.call();
      } else if (state.error != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_errorMessage(state.error!))));
      }
      widget.viewModel.consumeFeedback();
    });
  }

  String _errorMessage(MonetizationError error) => switch (error) {
    MonetizationError.insufficientGems => 'No tienes suficientes gemas.',
    MonetizationError.alreadyOwned => 'Este producto ya está en tu inventario.',
    MonetizationError.connection => 'No se pudo conectar con la tienda.',
    MonetizationError.sessionExpired =>
      'Tu sesión venció. Inicia sesión nuevamente.',
    MonetizationError.notFound => 'El producto ya no está disponible.',
    MonetizationError.unknown => 'No pudimos completar la operación.',
  };

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final state = widget.viewModel.state;
        if (state.isLoading && state.catalog.cosmetics.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error != null && state.catalog.cosmetics.isEmpty) {
          return _StoreError(onRetry: widget.viewModel.load);
        }
        return RefreshIndicator(
          onRefresh: widget.viewModel.load,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _StoreHeader(state: state, viewModel: widget.viewModel),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                sliver: _content(state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _content(StoreState state) {
    if (state.showInventory) {
      return _InventoryGrid(state: state, viewModel: widget.viewModel);
    }
    return switch (state.category) {
      StoreCategory.cosmetics => _CosmeticsGrid(
        state: state,
        viewModel: widget.viewModel,
      ),
      StoreCategory.multipliers => _BoostersList(
        state: state,
        viewModel: widget.viewModel,
      ),
      StoreCategory.gems => _GemPackagesGrid(
        packages: state.catalog.gemPackages,
      ),
    };
  }
}

class _StoreHeader extends StatelessWidget {
  final StoreState state;
  final StoreViewModel viewModel;
  const _StoreHeader({required this.state, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          Text(
            'Store',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: colors.primary,
            ),
          ),
          Text(
            'Personaliza tu experiencia ecológica.',
            style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          SegmentedButton<StoreCategory>(
            segments: const [
              ButtonSegment(
                value: StoreCategory.cosmetics,
                label: Text(
                  'Avatares y\ncosméticos',
                  textAlign: TextAlign.center,
                ),
              ),
              ButtonSegment(
                value: StoreCategory.multipliers,
                label: Text(
                  'Multiplicadores y\nprotectores',
                  textAlign: TextAlign.center,
                ),
              ),
              ButtonSegment(value: StoreCategory.gems, label: Text('Gemas')),
            ],
            selected: {state.category},
            onSelectionChanged: (value) {
              viewModel.setInventoryVisible(false);
              viewModel.selectCategory(value.first);
            },
            showSelectedIcon: false,
            style: ButtonStyle(
              textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 10)),
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 5),
              ),
              backgroundColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? colors.primary
                    : colors.surfaceContainerHigh,
              ),
              foregroundColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? colors.onPrimary
                    : colors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ModeButton(
                  text: 'Tienda',
                  selected: !state.showInventory,
                  onPressed: () => viewModel.setInventoryVisible(false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ModeButton(
                  text: 'Mi inventario',
                  selected: state.showInventory,
                  onPressed: () => viewModel.setInventoryVisible(true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Chip(
              avatar: Image.asset('assets/images/ic_gem.png', width: 18),
              label: Text('${state.gemBalance} gemas'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onPressed;
  const _ModeButton({
    required this.text,
    required this.selected,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      backgroundColor: selected ? Theme.of(context).colorScheme.primary : null,
      foregroundColor: selected
          ? Colors.white
          : Theme.of(context).colorScheme.onSurface,
    ),
    child: Text(text),
  );
}

class _CosmeticsGrid extends StatelessWidget {
  final StoreState state;
  final StoreViewModel viewModel;
  const _CosmeticsGrid({required this.state, required this.viewModel});
  @override
  Widget build(BuildContext context) => SliverGrid.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: .78,
    ),
    itemCount: state.catalog.cosmetics.length,
    itemBuilder: (context, index) {
      final item = state.catalog.cosmetics[index];
      final owned = state.inventory.cosmetics
          .where((e) => e.cosmeticId == item.id)
          .firstOrNull;
      return _ProductCard(
        title: item.name,
        subtitle: _cosmeticTypeName(item.type),
        price: item.priceInGems,
        icon: _cosmeticIcon(item.type),
        busy: state.busyItemId == item.id,
        ownedLabel: owned == null
            ? null
            : (owned.equipped ? 'Equipado' : 'En inventario'),
        actionLabel: owned == null ? 'Comprar' : null,
        onAction: owned == null
            ? () => viewModel.purchase(StoreItemKind.cosmetic, item.id)
            : null,
      );
    },
  );
}

class _BoostersList extends StatelessWidget {
  final StoreState state;
  final StoreViewModel viewModel;
  const _BoostersList({required this.state, required this.viewModel});
  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      ...state.catalog.multipliers.map(
        (item) => _WideProductCard(
          title: item.name,
          description: '${item.factor}x por ${item.durationMinutes} minutos',
          price: item.priceInGems,
          icon: Icons.auto_graph,
          busy: state.busyItemId == item.id,
          onBuy: () => viewModel.purchase(StoreItemKind.multiplier, item.id),
        ),
      ),
      ...state.catalog.streakProtectors.map(
        (item) => _WideProductCard(
          title: item.name,
          description: item.description,
          price: item.priceInGems,
          icon: Icons.shield_outlined,
          busy: state.busyItemId == item.id,
          onBuy: () => viewModel.purchase(StoreItemKind.protector, item.id),
        ),
      ),
    ];
    return SliverList.separated(
      itemCount: items.length,
      itemBuilder: (_, index) => items[index],
      separatorBuilder: (_, _) => const SizedBox(height: 12),
    );
  }
}

class _GemPackagesGrid extends StatelessWidget {
  final List<GemPackage> packages;
  const _GemPackagesGrid({required this.packages});
  @override
  Widget build(BuildContext context) => SliverGrid.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: .9,
    ),
    itemCount: packages.length,
    itemBuilder: (context, index) {
      final item = packages[index];
      return _ProductCard(
        title: item.name,
        subtitle: '${item.gemAmount} gemas',
        cashPrice: '${item.currency} ${item.price.toStringAsFixed(2)}',
        icon: Icons.diamond_outlined,
        ownedLabel: 'Próximamente',
      );
    },
  );
}

class _InventoryGrid extends StatelessWidget {
  final StoreState state;
  final StoreViewModel viewModel;
  const _InventoryGrid({required this.state, required this.viewModel});
  @override
  Widget build(BuildContext context) {
    final owned = state.inventory.cosmetics;
    if (owned.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: Text('Tu inventario está vacío.')),
      );
    }
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: .78,
      ),
      itemCount: owned.length,
      itemBuilder: (context, index) {
        final inventoryItem = owned[index];
        final item = state.catalog.cosmetics
            .where((e) => e.id == inventoryItem.cosmeticId)
            .firstOrNull;
        if (item == null) return const SizedBox.shrink();
        return _ProductCard(
          title: item.name,
          subtitle: _cosmeticTypeName(item.type),
          icon: _cosmeticIcon(item.type),
          busy: state.busyItemId == inventoryItem.id,
          ownedLabel: inventoryItem.equipped ? 'Equipado' : 'En inventario',
          actionLabel: inventoryItem.equipped ? 'Quitar' : 'Equipar',
          onAction: () => viewModel.changeEquipment(
            inventoryItem.id,
            !inventoryItem.equipped,
          ),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int? price;
  final String? cashPrice;
  final IconData icon;
  final String? ownedLabel;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool busy;
  const _ProductCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.price,
    this.cashPrice,
    this.ownedLabel,
    this.actionLabel,
    this.onAction,
    this.busy = false,
  });
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (ownedLabel != null)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  ownedLabel!,
                  style: TextStyle(fontSize: 9, color: colors.primary),
                ),
              ),
            Expanded(child: Icon(icon, size: 70, color: colors.primary)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 6),
            if (price != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/ic_gem.png', width: 18),
                  const SizedBox(width: 4),
                  Text('$price'),
                ],
              ),
            if (cashPrice != null)
              Text(
                cashPrice!,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            if (actionLabel != null)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: busy ? null : onAction,
                  child: busy
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(actionLabel!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WideProductCard extends StatelessWidget {
  final String title;
  final String description;
  final int price;
  final IconData icon;
  final bool busy;
  final VoidCallback onBuy;
  const _WideProductCard({
    required this.title,
    required this.description,
    required this.price,
    required this.icon,
    required this.busy,
    required this.onBuy,
  });
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(description, style: const TextStyle(fontSize: 11)),
                Row(
                  children: [
                    Image.asset('assets/images/ic_gem.png', width: 18),
                    Text(' $price'),
                  ],
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: busy ? null : onBuy,
            child: busy
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Comprar'),
          ),
        ],
      ),
    ),
  );
}

class _StoreError extends StatelessWidget {
  final VoidCallback onRetry;
  const _StoreError({required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('No pudimos cargar la tienda.'),
        const SizedBox(height: 12),
        FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
      ],
    ),
  );
}

String _cosmeticTypeName(CosmeticType type) => switch (type) {
  CosmeticType.avatar => 'Avatar',
  CosmeticType.head => 'Sombrero',
  CosmeticType.body => 'Vestimenta',
  CosmeticType.accessory => 'Accesorio',
  CosmeticType.unknown => 'Cosmético',
};

IconData _cosmeticIcon(CosmeticType type) => switch (type) {
  CosmeticType.avatar => Icons.person_outline,
  CosmeticType.head => Icons.face_retouching_natural,
  CosmeticType.body => Icons.checkroom,
  CosmeticType.accessory => Icons.auto_awesome,
  CosmeticType.unknown => Icons.redeem,
};
