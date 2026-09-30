class Ingredient {
  final int? id;
  final String name;
  final double purchasePrice;
  final double purchaseQuantity;
  final String unit; // 'g', 'kg', 'ml', 'L', 'pcs'

  const Ingredient({
    this.id,
    required this.name,
    required this.purchasePrice,
    required this.purchaseQuantity,
    required this.unit,
  });

  Ingredient copyWith({
    int? id,
    String? name,
    double? purchasePrice,
    double? purchaseQuantity,
    String? unit,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      purchaseQuantity: purchaseQuantity ?? this.purchaseQuantity,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'purchase_price': purchasePrice,
      'purchase_quantity': purchaseQuantity,
      'unit': unit,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      purchasePrice: (map['purchase_price'] as num?)?.toDouble() ?? 0.0,
      purchaseQuantity: (map['purchase_quantity'] as num?)?.toDouble() ?? 1.0,
      unit: map['unit'] as String? ?? 'g',
    );
  }

  /// Calculates dynamic cost based on used amount and unit.
  /// Handles conversions: kg <-> g, L <-> ml, pcs <-> pcs.
  double calculateCost({
    required double usedQuantity,
    required String usedUnit,
  }) {
    if (purchaseQuantity <= 0) return 0.0;

    final normPurchaseUnit = unit.trim().toLowerCase();
    final normUsedUnit = usedUnit.trim().toLowerCase();

    // Direct match
    if (normPurchaseUnit == normUsedUnit) {
      return (purchasePrice / purchaseQuantity) * usedQuantity;
    }

    // Weight conversions: kg <-> g
    if (normPurchaseUnit == 'kg' && normUsedUnit == 'g') {
      // purchasePrice is for purchaseQuantity in kg (e.g. 1 kg = 1000g)
      final pricePerGram = purchasePrice / (purchaseQuantity * 1000.0);
      return pricePerGram * usedQuantity;
    }
    if (normPurchaseUnit == 'g' && normUsedUnit == 'kg') {
      final pricePerKg = (purchasePrice / purchaseQuantity) * 1000.0;
      return pricePerKg * usedQuantity;
    }

    // Volume conversions: L <-> ml
    if (normPurchaseUnit == 'l' && normUsedUnit == 'ml') {
      final pricePerMl = purchasePrice / (purchaseQuantity * 1000.0);
      return pricePerMl * usedQuantity;
    }
    if (normPurchaseUnit == 'ml' && normUsedUnit == 'l') {
      final pricePerLiter = (purchasePrice / purchaseQuantity) * 1000.0;
      return pricePerLiter * usedQuantity;
    }

    // Fallback if units differ but user still provided quantity
    return (purchasePrice / purchaseQuantity) * usedQuantity;
  }

  /// Returns list of compatible units for this ingredient based on its base unit.
  List<String> get compatibleUnits {
    final norm = unit.trim().toLowerCase();
    if (norm == 'kg' || norm == 'g') {
      return ['g', 'kg'];
    }
    if (norm == 'l' || norm == 'ml') {
      return ['ml', 'L'];
    }
    return ['pcs'];
  }
}
