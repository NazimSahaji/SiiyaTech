import 'dart:convert';

class OrderIngredientItem {
  final int? ingredientId;
  final String ingredientName;
  final double usedQuantity;
  final String usedUnit;
  final double cost;

  const OrderIngredientItem({
    this.ingredientId,
    required this.ingredientName,
    required this.usedQuantity,
    required this.usedUnit,
    required this.cost,
  });

  Map<String, dynamic> toMap() {
    return {
      'ingredient_id': ingredientId,
      'ingredient_name': ingredientName,
      'used_quantity': usedQuantity,
      'used_unit': usedUnit,
      'cost': cost,
    };
  }

  factory OrderIngredientItem.fromMap(Map<String, dynamic> map) {
    return OrderIngredientItem(
      ingredientId: map['ingredient_id'] as int?,
      ingredientName: map['ingredient_name'] as String? ?? '',
      usedQuantity: (map['used_quantity'] as num?)?.toDouble() ?? 0.0,
      usedUnit: map['used_unit'] as String? ?? 'g',
      cost: (map['cost'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CakeOrder {
  final int? id;
  final String customerName;
  final String cakeName;
  final DateTime orderDate;
  
  // Oven & utilities
  final double ovenWattage; // in Watts, e.g. 1500
  final double bakingTemp; // in °C, e.g. 180
  final double bakingTimeMinutes; // in Minutes, e.g. 45
  final double electricityRate; // Rate per kWh
  final double electricityCost; // Calculated: ((wattage * (bakingTimeMinutes / 60)) / 1000) * electricityRate

  // Material & overhead
  final double rawMaterialCost;
  final double packagingCost;
  final double overheadCost;
  final double totalCost;

  // Pricing
  final double profitMarginPercent; // e.g. 30%
  final double sellingPrice; // totalCost * (1 + profitMarginPercent / 100)

  // Snapshot of ingredients
  final List<OrderIngredientItem> items;
  final String? notes;

  const CakeOrder({
    this.id,
    required this.customerName,
    required this.cakeName,
    required this.orderDate,
    required this.ovenWattage,
    required this.bakingTemp,
    required this.bakingTimeMinutes,
    required this.electricityRate,
    required this.electricityCost,
    required this.rawMaterialCost,
    required this.packagingCost,
    required this.overheadCost,
    required this.totalCost,
    required this.profitMarginPercent,
    required this.sellingPrice,
    required this.items,
    this.notes,
  });

  /// Helper to calculate electricity cost
  static double calculateElectricityCost({
    required double wattage,
    required double bakingTimeMinutes,
    required double electricityRate,
  }) {
    if (wattage <= 0 || bakingTimeMinutes <= 0 || electricityRate <= 0) {
      return 0.0;
    }
    final kwh = (wattage * (bakingTimeMinutes / 60.0)) / 1000.0;
    return kwh * electricityRate;
  }

  /// Helper to calculate selling price
  static double calculateSellingPrice({
    required double totalCost,
    required double profitMarginPercent,
  }) {
    if (totalCost <= 0) return 0.0;
    return totalCost * (1.0 + (profitMarginPercent / 100.0));
  }

  double get profitAmount => sellingPrice - totalCost;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'customer_name': customerName,
      'cake_name': cakeName,
      'order_date': orderDate.toIso8601String(),
      'oven_wattage': ovenWattage,
      'baking_temp': bakingTemp,
      'baking_time_minutes': bakingTimeMinutes,
      'electricity_rate': electricityRate,
      'electricity_cost': electricityCost,
      'raw_material_cost': rawMaterialCost,
      'packaging_cost': packagingCost,
      'overhead_cost': overheadCost,
      'total_cost': totalCost,
      'profit_margin_percent': profitMarginPercent,
      'selling_price': sellingPrice,
      'items_json': jsonEncode(items.map((i) => i.toMap()).toList()),
      'notes': notes ?? '',
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory CakeOrder.fromMap(Map<String, dynamic> map) {
    List<OrderIngredientItem> parsedItems = [];
    if (map['items_json'] != null && map['items_json'].toString().isNotEmpty) {
      try {
        final decoded = jsonDecode(map['items_json'] as String) as List<dynamic>;
        parsedItems = decoded
            .map((item) => OrderIngredientItem.fromMap(item as Map<String, dynamic>))
            .toList();
      } catch (_) {
        parsedItems = [];
      }
    }

    return CakeOrder(
      id: map['id'] as int?,
      customerName: map['customer_name'] as String? ?? '',
      cakeName: map['cake_name'] as String? ?? '',
      orderDate: DateTime.tryParse(map['order_date'] as String? ?? '') ?? DateTime.now(),
      ovenWattage: (map['oven_wattage'] as num?)?.toDouble() ?? 0.0,
      bakingTemp: (map['baking_temp'] as num?)?.toDouble() ?? 0.0,
      bakingTimeMinutes: (map['baking_time_minutes'] as num?)?.toDouble() ?? 0.0,
      electricityRate: (map['electricity_rate'] as num?)?.toDouble() ?? 0.0,
      electricityCost: (map['electricity_cost'] as num?)?.toDouble() ?? 0.0,
      rawMaterialCost: (map['raw_material_cost'] as num?)?.toDouble() ?? 0.0,
      packagingCost: (map['packaging_cost'] as num?)?.toDouble() ?? 0.0,
      overheadCost: (map['overhead_cost'] as num?)?.toDouble() ?? 0.0,
      totalCost: (map['total_cost'] as num?)?.toDouble() ?? 0.0,
      profitMarginPercent: (map['profit_margin_percent'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (map['selling_price'] as num?)?.toDouble() ?? 0.0,
      items: parsedItems,
      notes: map['notes'] as String?,
    );
  }
}
