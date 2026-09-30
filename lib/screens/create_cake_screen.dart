import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/ingredient.dart';
import '../providers/app_state.dart';
import 'package:provider/provider.dart';

class CreateCakeScreen extends StatefulWidget {
  final VoidCallback? onOrderSaved;

  const CreateCakeScreen({super.key, this.onOrderSaved});

  @override
  State<CreateCakeScreen> createState() => _CreateCakeScreenState();
}

class _CreateCakeScreenState extends State<CreateCakeScreen> {
  final _customerNameController = TextEditingController();
  final _cakeNameController = TextEditingController();
  final _notesController = TextEditingController();

  final _wattageController = TextEditingController();
  final _tempController = TextEditingController();
  final _timeController = TextEditingController();
  final _rateController = TextEditingController();

  final _packagingController = TextEditingController();
  final _overheadController = TextEditingController();
  final _profitMarginController = TextEditingController();

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final state = context.read<AppState>();
      _customerNameController.text = state.customerName;
      _cakeNameController.text = state.cakeName;
      _notesController.text = state.notes;

      _wattageController.text = state.ovenWattage.toStringAsFixed(0);
      _tempController.text = state.bakingTemp.toStringAsFixed(0);
      _timeController.text = state.bakingTimeMinutes.toStringAsFixed(0);
      _rateController.text = state.electricityRate.toStringAsFixed(2);

      _packagingController.text = state.packagingCost.toStringAsFixed(0);
      _overheadController.text = state.overheadCost.toStringAsFixed(0);
      _profitMarginController.text = state.profitMarginPercent.toStringAsFixed(0);

      _initialized = true;
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _cakeNameController.dispose();
    _notesController.dispose();
    _wattageController.dispose();
    _tempController.dispose();
    _timeController.dispose();
    _rateController.dispose();
    _packagingController.dispose();
    _overheadController.dispose();
    _profitMarginController.dispose();
    super.dispose();
  }

  void _syncStateWithControllers() {
    final state = context.read<AppState>();
    _customerNameController.text = state.customerName;
    _cakeNameController.text = state.cakeName;
    _notesController.text = state.notes;

    _wattageController.text = state.ovenWattage.toStringAsFixed(0);
    _tempController.text = state.bakingTemp.toStringAsFixed(0);
    _timeController.text = state.bakingTimeMinutes.toStringAsFixed(0);
    _rateController.text = state.electricityRate.toStringAsFixed(2);

    _packagingController.text = state.packagingCost.toStringAsFixed(0);
    _overheadController.text = state.overheadCost.toStringAsFixed(0);
    _profitMarginController.text = state.profitMarginPercent.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final s = appState.strings;
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Order & Customer Info Card
            _buildSectionCard(
              theme: theme,
              title: s.orderDetails,
              icon: Icons.person_outline,
              child: Column(
                children: [
                  TextField(
                    controller: _customerNameController,
                    decoration: InputDecoration(
                      labelText: s.customerName,
                      hintText: s.enterCustomerName,
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (val) => appState.updateOrderInfo(customerName: val),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _cakeNameController,
                    decoration: InputDecoration(
                      labelText: s.cakeName,
                      hintText: s.enterCakeName,
                      prefixIcon: const Icon(Icons.cake_outlined),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (val) => appState.updateOrderInfo(cakeName: val),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: appState.orderDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2040),
                            );
                            if (picked != null) {
                              appState.updateOrderInfo(orderDate: picked);
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: s.orderDate,
                              prefixIcon: const Icon(Icons.calendar_today_outlined),
                              border: const OutlineInputBorder(),
                            ),
                            child: Text(
                              dateFormat.format(appState.orderDate),
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: s.notes,
                      hintText: s.enterNotes,
                      prefixIcon: const Icon(Icons.note_alt_outlined),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (val) => appState.updateOrderInfo(notes: val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. Ingredients Section
            _buildSectionCard(
              theme: theme,
              title: s.recipeIngredients,
              icon: Icons.kitchen_outlined,
              trailing: FilledButton.tonalIcon(
                onPressed: () => _showAddIngredientModal(context),
                icon: const Icon(Icons.add, size: 18),
                label: Text(s.add),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (appState.recipeItems.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cookie_outlined,
                            size: 40,
                            color: theme.colorScheme.primary.withOpacity(0.6),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            s.noIngredientsInCake,
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: () => _showAddIngredientModal(context),
                            icon: const Icon(Icons.add),
                            label: Text(s.addIngredientToCake),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: [
                        ...appState.recipeItems.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final item = entry.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.ingredient.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${item.usedQuantity.toStringAsFixed(item.usedQuantity.truncateToDouble() == item.usedQuantity ? 0 : 2)} ${item.usedUnit} • ${s.formatCurrency(item.cost)}',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 20),
                                  tooltip: s.edit,
                                  onPressed: () => _showEditItemModal(context, item),
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline,
                                      size: 20, color: theme.colorScheme.error),
                                  tooltip: s.delete,
                                  onPressed: () => appState.removeRecipeItem(idx),
                                ),
                              ],
                            ),
                          );
                        }),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                s.rawMaterialCost,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              s.formatCurrency(appState.rawMaterialCost),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. Baking & Electricity Utility Section
            _buildSectionCard(
              theme: theme,
              title: s.utilitySection,
              icon: Icons.electric_bolt_outlined,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _wattageController,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: InputDecoration(
                            labelText: s.ovenWattage,
                            hintText: '1800',
                            border: const OutlineInputBorder(),
                            suffixText: 'W',
                          ),
                          onChanged: (val) {
                            final parsed = double.tryParse(val) ?? 0.0;
                            appState.updateUtility(ovenWattage: parsed);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _tempController,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: InputDecoration(
                            labelText: s.bakingTemp,
                            hintText: '180',
                            border: const OutlineInputBorder(),
                            suffixText: '°C',
                          ),
                          onChanged: (val) {
                            final parsed = double.tryParse(val) ?? 0.0;
                            appState.updateUtility(bakingTemp: parsed);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _timeController,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: InputDecoration(
                            labelText: s.bakingTime,
                            hintText: '40',
                            border: const OutlineInputBorder(),
                            suffixText: 'min',
                          ),
                          onChanged: (val) {
                            final parsed = double.tryParse(val) ?? 0.0;
                            appState.updateUtility(bakingTimeMinutes: parsed);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _rateController,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: InputDecoration(
                            labelText: s.electricityRate,
                            hintText: '8.50',
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            final parsed = double.tryParse(val) ?? 0.0;
                            appState.updateUtility(electricityRate: parsed);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.electricityCost,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${((appState.ovenWattage * (appState.bakingTimeMinutes / 60)) / 1000).toStringAsFixed(2)} kWh consumed',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          s.formatCurrency(appState.electricityCost),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. Packaging & Overheads Section
            _buildSectionCard(
              theme: theme,
              title: s.packagingAndOverhead,
              icon: Icons.inventory_2_outlined,
              child: Column(
                children: [
                  TextFormField(
                    controller: _packagingController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    decoration: InputDecoration(
                      labelText: s.packagingCost,
                      border: const OutlineInputBorder(),
                      prefixText: '${s.currency} ',
                    ),
                    onChanged: (val) {
                      final parsed = double.tryParse(val) ?? 0.0;
                      appState.updateCosts(packagingCost: parsed);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _overheadController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    decoration: InputDecoration(
                      labelText: s.overheadCost,
                      border: const OutlineInputBorder(),
                      prefixText: '${s.currency} ',
                    ),
                    onChanged: (val) {
                      final parsed = double.tryParse(val) ?? 0.0;
                      appState.updateCosts(overheadCost: parsed);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 5. Cost & Selling Price Summary
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.3)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.monetization_on_outlined,
                            color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          s.costSummary,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    _buildSummaryRow(
                      theme: theme,
                      label: s.rawMaterialCost,
                      value: s.formatCurrency(appState.rawMaterialCost),
                    ),
                    _buildSummaryRow(
                      theme: theme,
                      label: s.electricityCost,
                      value: s.formatCurrency(appState.electricityCost),
                    ),
                    _buildSummaryRow(
                      theme: theme,
                      label: s.packagingCost,
                      value: s.formatCurrency(appState.packagingCost),
                    ),
                    _buildSummaryRow(
                      theme: theme,
                      label: s.overheadCost,
                      value: s.formatCurrency(appState.overheadCost),
                    ),
                    const Divider(height: 16),
                    _buildSummaryRow(
                      theme: theme,
                      label: s.totalCost,
                      value: s.formatCurrency(appState.totalCost),
                      isBold: true,
                      color: theme.colorScheme.onSurface,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            s.profitMargin,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            controller: _profitMarginController,
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                            ],
                            decoration: const InputDecoration(
                              suffixText: '%',
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            onChanged: (val) {
                              final parsed = double.tryParse(val) ?? 0.0;
                              appState.updateCosts(profitMarginPercent: parsed);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      theme: theme,
                      label: s.profitAmount,
                      value: '+ ${s.formatCurrency(appState.profitAmount)}',
                      color: Colors.green.shade700,
                      isBold: true,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              s.sellingPrice,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            s.formatCurrency(appState.sellingPrice),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Save and Reset buttons
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      appState.resetCalculator();
                      _syncStateWithControllers();
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(s.reset),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (appState.customerName.trim().isEmpty ||
                          appState.cakeName.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(s.pleaseFillRequired),
                            backgroundColor: theme.colorScheme.error,
                          ),
                        );
                        return;
                      }

                      final order = appState.buildOrderFromDraft();
                      final success = await appState.saveOrder(order);

                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(s.orderSavedSuccess),
                            backgroundColor: Colors.green.shade700,
                            action: SnackBarAction(
                              label: s.tabHistory,
                              textColor: Colors.white,
                              onPressed: () {
                                widget.onOrderSaved?.call();
                              },
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: Text(
                      s.saveOrder,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required Widget child,
    Widget? trailing,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
            const Divider(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required ThemeData theme,
    required String label,
    required String value,
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color ?? theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color ?? theme.colorScheme.onSurface,
              fontSize: isBold ? 15 : 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddIngredientModal(BuildContext context) {
    final appState = context.read<AppState>();
    final s = appState.strings;
    final pantry = appState.ingredients;

    if (pantry.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.addFirstIngredientMsg),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      return;
    }

    Ingredient selectedIngredient = pantry.first;
    List<String> compatibleUnits = selectedIngredient.compatibleUnits;
    String selectedUnit = compatibleUnits.first;
    final qtyController = TextEditingController(text: '100');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final usedQty = double.tryParse(qtyController.text) ?? 0.0;
            final liveCost = selectedIngredient.calculateCost(
              usedQuantity: usedQty,
              usedUnit: selectedUnit,
            );

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.add_shopping_cart,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(s.addIngredientToCake),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<Ingredient>(
                        value: selectedIngredient,
                        decoration: InputDecoration(
                          labelText: s.selectIngredient,
                          border: const OutlineInputBorder(),
                        ),
                        isExpanded: true,
                        items: pantry.map((ing) {
                          return DropdownMenuItem<Ingredient>(
                            value: ing,
                            child: Text(
                              ing.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              selectedIngredient = val;
                              compatibleUnits = val.compatibleUnits;
                              selectedUnit = compatibleUnits.first;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pantry: ${s.formatCurrency(selectedIngredient.purchasePrice)} / ${selectedIngredient.purchaseQuantity} ${selectedIngredient.unit}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: qtyController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                              ],
                              decoration: InputDecoration(
                                labelText: s.usedAmount,
                                border: const OutlineInputBorder(),
                              ),
                              onChanged: (_) => setDialogState(() {}),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Required';
                                }
                                final p = double.tryParse(val);
                                if (p == null || p <= 0) return 'Must be > 0';
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
                              items: compatibleUnits.map((u) {
                                return DropdownMenuItem(value: u, child: Text(u));
                              }).toList(),
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
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              s.cost,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              s.formatCurrency(liveCost),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
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
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final usedQty = double.parse(qtyController.text.trim());
                      appState.addOrUpdateRecipeItem(
                        ingredient: selectedIngredient,
                        usedQuantity: usedQty,
                        usedUnit: selectedUnit,
                      );
                      Navigator.pop(dialogCtx);
                    }
                  },
                  child: Text(s.add),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditItemModal(BuildContext context, RecipeDraftItem item) {
    final appState = context.read<AppState>();
    final s = appState.strings;
    final compatibleUnits = item.ingredient.compatibleUnits;
    String selectedUnit = item.usedUnit;
    final qtyController = TextEditingController(
      text: item.usedQuantity.toStringAsFixed(
        item.usedQuantity.truncateToDouble() == item.usedQuantity ? 0 : 2,
      ),
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final usedQty = double.tryParse(qtyController.text) ?? 0.0;
            final liveCost = item.ingredient.calculateCost(
              usedQuantity: usedQty,
              usedUnit: selectedUnit,
            );

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(item.ingredient.name),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: qtyController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                              ],
                              decoration: InputDecoration(
                                labelText: s.usedAmount,
                                border: const OutlineInputBorder(),
                              ),
                              onChanged: (_) => setDialogState(() {}),
                              validator: (val) {
                                if (val == null || val.isEmpty) return 'Required';
                                final p = double.tryParse(val);
                                if (p == null || p <= 0) return 'Must be > 0';
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
                              items: compatibleUnits.map((u) {
                                return DropdownMenuItem(value: u, child: Text(u));
                              }).toList(),
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
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              s.cost,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              s.formatCurrency(liveCost),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
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
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final usedQty = double.parse(qtyController.text.trim());
                      appState.addOrUpdateRecipeItem(
                        ingredient: item.ingredient,
                        usedQuantity: usedQty,
                        usedUnit: selectedUnit,
                      );
                      Navigator.pop(dialogCtx);
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
}
