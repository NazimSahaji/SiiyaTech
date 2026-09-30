import 'package:flutter_test/flutter_test.dart';
import 'package:cake_cost_calculator/models/ingredient.dart';
import 'package:cake_cost_calculator/models/cake_order.dart';
import 'package:cake_cost_calculator/providers/app_state.dart';

void main() {
  group('Ingredient Cost Calculation Unit Tests', () {
    test('Calculates cost correctly for same unit', () {
      const eggs = Ingredient(
        name: 'Eggs',
        purchasePrice: 120.0,
        purchaseQuantity: 12.0,
        unit: 'pcs',
      );
      // 4 eggs should cost (120/12)*4 = 40.0
      final cost = eggs.calculateCost(usedQuantity: 4, usedUnit: 'pcs');
      expect(cost, closeTo(40.0, 0.001));
    });

    test('Calculates cost correctly for kg to g conversion', () {
      const flour = Ingredient(
        name: 'Flour',
        purchasePrice: 80.0,
        purchaseQuantity: 1.0,
        unit: 'kg',
      );
      // 250g should cost (80 / 1000) * 250 = 20.0
      final cost = flour.calculateCost(usedQuantity: 250, usedUnit: 'g');
      expect(cost, closeTo(20.0, 0.001));
    });

    test('Calculates cost correctly for g to kg conversion', () {
      const butter = Ingredient(
        name: 'Butter',
        purchasePrice: 400.0,
        purchaseQuantity: 500.0,
        unit: 'g',
      );
      // 1 kg should cost (400 / 500) * 1000 = 800.0
      final cost = butter.calculateCost(usedQuantity: 1, usedUnit: 'kg');
      expect(cost, closeTo(800.0, 0.001));
    });

    test('Calculates cost correctly for L to ml conversion', () {
      const milk = Ingredient(
        name: 'Milk',
        purchasePrice: 90.0,
        purchaseQuantity: 1.0,
        unit: 'L',
      );
      // 200ml should cost (90 / 1000) * 200 = 18.0
      final cost = milk.calculateCost(usedQuantity: 200, usedUnit: 'ml');
      expect(cost, closeTo(18.0, 0.001));
    });
  });

  group('Electricity Utility Calculation Tests', () {
    test('Calculates electricity cost using wattage, time, and rate', () {
      // 1800W for 40 minutes at rate 8.5/kWh:
      // kWh = (1800 * (40/60)) / 1000 = 1.2 kWh
      // Cost = 1.2 * 8.5 = 10.2
      final cost = CakeOrder.calculateElectricityCost(
        wattage: 1800,
        bakingTimeMinutes: 40,
        electricityRate: 8.5,
      );
      expect(cost, closeTo(10.2, 0.001));
    });

    test('Returns 0 for invalid or non-positive values', () {
      expect(
        CakeOrder.calculateElectricityCost(
          wattage: 0,
          bakingTimeMinutes: 40,
          electricityRate: 8.5,
        ),
        0.0,
      );
      expect(
        CakeOrder.calculateElectricityCost(
          wattage: 1500,
          bakingTimeMinutes: 0,
          electricityRate: 8.5,
        ),
        0.0,
      );
    });
  });

  group('Selling Price & Profit Margin Calculation Tests', () {
    test('Calculates final selling price based on total cost and profit margin', () {
      final sellingPrice = CakeOrder.calculateSellingPrice(
        totalCost: 500.0,
        profitMarginPercent: 30.0,
      );
      // 500 * (1 + 0.30) = 650.0
      expect(sellingPrice, closeTo(650.0, 0.001));
    });
  });

  group('Localization Tests', () {
    test('Language toggle changes state and strings', () {
      final appState = AppState();
      expect(appState.isBengali, false);
      expect(appState.strings.langCode, 'EN');
      expect(appState.strings.customerName, 'Customer Name');
      expect(appState.currency, '₹');
      expect(appState.formatCurrency(250), '₹250.00');

      appState.toggleLanguage();
      expect(appState.isBengali, true);
      expect(appState.strings.langCode, 'বাং');
      expect(appState.strings.customerName, 'গ্রাহকের নাম');
      expect(appState.currency, '₹');
      expect(appState.formatCurrency(250), '₹250.00');
    });
  });
}
