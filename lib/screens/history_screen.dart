import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/cake_order.dart';
import '../providers/app_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final s = appState.strings;
    final orders = appState.orders;
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: s.searchPlaceholder,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          appState.setSearchQuery('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
              onChanged: (val) {
                appState.setSearchQuery(val);
                setState(() {});
              },
            ),
          ),

          // Orders List
          Expanded(
            child: appState.isLoadingOrders
                ? const Center(child: CircularProgressIndicator())
                : orders.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 64,
                                color: theme.colorScheme.primary.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                s.noOrdersFound,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return Card(
                            elevation: 1,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => _showOrderDetailsBottomSheet(context, order),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                order.customerName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                order.cakeName,
                                                style: TextStyle(
                                                  color: theme.colorScheme.primary,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, size: 22),
                                          color: theme.colorScheme.error,
                                          tooltip: s.delete,
                                          onPressed: () => _confirmDeleteOrder(context, order),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      dateFormat.format(order.orderDate),
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurfaceVariant,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Divider(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              s.totalCost,
                                              style: TextStyle(
                                                color: theme.colorScheme.onSurfaceVariant,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              s.formatCurrency(order.totalCost),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '+${order.profitMarginPercent.toStringAsFixed(0)}% Margin',
                                            style: TextStyle(
                                              color: Colors.green.shade800,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              s.sellingPrice,
                                              style: TextStyle(
                                                color: theme.colorScheme.onSurfaceVariant,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              s.formatCurrency(order.sellingPrice),
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
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetailsBottomSheet(BuildContext context, CakeOrder order) {
    final appState = context.read<AppState>();
    final s = appState.strings;
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomCtx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.cakeName,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${s.customerName}: ${order.customerName}',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              dateFormat.format(order.orderDate),
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(bottomCtx),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Recipe Breakdown
                  Text(
                    s.recipeIngredients,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  if (order.items.isEmpty)
                    Text(
                      s.noIngredientsInCake,
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    )
                  else
                    ...order.items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.ingredientName,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              '${item.usedQuantity.toStringAsFixed(item.usedQuantity.truncateToDouble() == item.usedQuantity ? 0 : 2)} ${item.usedUnit}',
                              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              s.formatCurrency(item.cost),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      );
                    }),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.rawMaterialCost,
                        style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                      ),
                      Text(
                        s.formatCurrency(order.rawMaterialCost),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),

                  const Divider(height: 24),

                  // Baking Utility Breakdown
                  Text(
                    s.bakingBreakdown,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    s.ovenWattage,
                    '${order.ovenWattage.toStringAsFixed(0)} W',
                  ),
                  _buildDetailRow(
                    s.bakingTemp,
                    '${order.bakingTemp.toStringAsFixed(0)} °C',
                  ),
                  _buildDetailRow(
                    s.bakingTime,
                    '${order.bakingTimeMinutes.toStringAsFixed(0)} min',
                  ),
                  _buildDetailRow(
                    s.electricityRate,
                    '${s.currency}${order.electricityRate.toStringAsFixed(2)} / kWh',
                  ),
                  _buildDetailRow(
                    s.electricityCost,
                    s.formatCurrency(order.electricityCost),
                    isHighlight: true,
                  ),

                  const Divider(height: 24),

                  // Packaging & Overhead
                  Text(
                    s.packagingAndOverhead,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(s.packagingCost, s.formatCurrency(order.packagingCost)),
                  _buildDetailRow(s.overheadCost, s.formatCurrency(order.overheadCost)),

                  const Divider(height: 24),

                  // Total & Profit Breakdown
                  Text(
                    s.breakdown,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(s.totalCost, s.formatCurrency(order.totalCost), isBold: true),
                  _buildDetailRow(
                    s.profitMargin,
                    '${order.profitMarginPercent.toStringAsFixed(1)}%',
                  ),
                  _buildDetailRow(
                    s.profitAmount,
                    '+ ${s.formatCurrency(order.profitAmount)}',
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
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          s.sellingPrice,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          s.formatCurrency(order.sellingPrice),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (order.notes != null && order.notes!.trim().isNotEmpty) ...[
                    const Divider(height: 24),
                    Text(
                      s.notes,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.notes!,
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool isBold = false, bool isHighlight = false, Color? color}) {
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
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold || isHighlight ? FontWeight.bold : FontWeight.w500,
              fontSize: isBold ? 15 : 13,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteOrder(BuildContext context, CakeOrder order) {
    final appState = Provider.of<AppState>(context, listen: false);
    final s = appState.strings;

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(s.deleteOrder),
        content: Text(
          '${s.deleteOrderConfirm}\n\n"${order.cakeName}" (${order.customerName})',
        ),
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
              if (order.id != null) {
                await appState.deleteOrder(order.id!);
              }
              if (dialogCtx.mounted) {
                Navigator.pop(dialogCtx);
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(s.orderDeletedSuccess)),
                );
              }
            },
            child: Text(s.delete),
          ),
        ],
      ),
    );
  }
}
