import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/ingredient.dart';
import '../providers/app_state.dart';
import 'package:provider/provider.dart';

class IngredientsScreen extends StatelessWidget {
  const IngredientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final s = appState.strings;
    final ingredients = appState.ingredients;
    final theme = Theme.of(context);

    return Scaffold(
      body: appState.isLoadingIngredients
          ? const Center(child: CircularProgressIndicator())
          : ingredients.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.kitchen_outlined,
                          size: 72,
                          color: theme.colorScheme.primary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          s.noIngredientsYet,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          s.addFirstIngredientMsg,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: () => _showIngredientDialog(context),
                          icon: const Icon(Icons.add),
                          label: Text(s.addIngredient),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    final item = ingredients[index];
                    final rate = item.purchaseQuantity > 0
                        ? (item.purchasePrice / item.purchaseQuantity)
                        : 0.0;

                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Icon(
                            _getIconForUnit(item.unit),
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${s.purchasePrice}: ${s.formatCurrency(item.purchasePrice)} / ${item.purchaseQuantity.toStringAsFixed(item.purchaseQuantity.truncateToDouble() == item.purchaseQuantity ? 0 : 2)} ${item.unit}',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${s.ratePerUnit}: ${s.formatCurrency(rate)} / ${item.unit}',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              color: theme.colorScheme.primary,
                              tooltip: s.edit,
                              onPressed: () => _showIngredientDialog(
                                context,
                                ingredient: item,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: theme.colorScheme.error,
                              tooltip: s.delete,
                              onPressed: () => _confirmDelete(context, item),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showIngredientDialog(context),
        icon: const Icon(Icons.add),
        label: Text(s.addIngredient),
      ),
    );
  }

  IconData _getIconForUnit(String unit) {
    switch (unit.toLowerCase()) {
      case 'kg':
      case 'g':
        return Icons.scale_outlined;
      case 'l':
      case 'ml':
        return Icons.local_drink_outlined;
      case 'pcs':
        return Icons.egg_outlined;
      default:
        return Icons.shopping_basket_outlined;
    }
  }

  void _showIngredientDialog(BuildContext context, {Ingredient? ingredient}) {
    final appState = context.read<AppState>();
    final s = appState.strings;
    final isEditing = ingredient != null;

    final nameController = TextEditingController(text: ingredient?.name ?? '');
    final priceController = TextEditingController(
      text: ingredient != null ? ingredient.purchasePrice.toString() : '',
    );
    final quantityController = TextEditingController(
      text: ingredient != null ? ingredient.purchaseQuantity.toString() : '1',
    );
    String selectedUnit = ingredient?.unit ?? 'g';

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(
                    isEditing ? Icons.edit_note : Icons.add_circle_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(isEditing ? s.editIngredientTitle : s.addIngredientTitle),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: s.ingredientName,
                          hintText: s.enterIngredientName,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.label_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return isEditing
                                ? 'Name is required'
                                : 'Please enter ingredient name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                        ],
                        decoration: InputDecoration(
                          labelText: s.purchasePrice,
                          hintText: '0.00',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.currency_rupee),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Price is required';
                          }
                          final parsed = double.tryParse(value);
                          if (parsed == null || parsed < 0) {
                            return 'Invalid price';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: quantityController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                              ],
                              decoration: InputDecoration(
                                labelText: s.purchaseQuantity,
                                hintText: '1.0',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.straighten),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Quantity required';
                                }
                                final parsed = double.tryParse(value);
                                if (parsed == null || parsed <= 0) {
                                  return 'Must be > 0';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              value: selectedUnit,
                              decoration: InputDecoration(
                                labelText: s.unit,
                                border: const OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'g', child: Text('g')),
                                DropdownMenuItem(value: 'kg', child: Text('kg')),
                                DropdownMenuItem(value: 'ml', child: Text('ml')),
                                DropdownMenuItem(value: 'L', child: Text('L')),
                                DropdownMenuItem(value: 'pcs', child: Text('pcs')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setDialogState(() {
                                    selectedUnit = val;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: Text(s.cancel),
                ),
                FilledButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final name = nameController.text.trim();
                      final price = double.parse(priceController.text.trim());
                      final qty = double.parse(quantityController.text.trim());

                      if (isEditing) {
                        final updated = ingredient.copyWith(
                          name: name,
                          purchasePrice: price,
                          purchaseQuantity: qty,
                          unit: selectedUnit,
                        );
                        await appState.updateIngredient(updated);
                      } else {
                        final newIng = Ingredient(
                          name: name,
                          purchasePrice: price,
                          purchaseQuantity: qty,
                          unit: selectedUnit,
                        );
                        await appState.addIngredient(newIng);
                      }

                      if (dialogCtx.mounted) {
                        Navigator.pop(dialogCtx);
                      }
                    }
                  },
                  child: Text(s.save),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Ingredient item) {
    final appState = context.read<AppState>();
    final s = appState.strings;

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(s.delete),
        content: Text('${s.deleteIngredientConfirm}\n\n"${item.name}"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(s.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              if (item.id != null) {
                await appState.deleteIngredient(item.id!);
              }
              if (dialogCtx.mounted) {
                Navigator.pop(dialogCtx);
              }
            },
            child: Text(s.delete),
          ),
        ],
      ),
    );
  }
}
