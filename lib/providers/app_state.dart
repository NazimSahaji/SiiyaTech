import 'package:flutter/foundation.dart';
import '../db/database_helper.dart';
import '../models/ingredient.dart';
import '../models/cake_order.dart';
import '../l10n/app_strings.dart';

class RecipeDraftItem {
  final Ingredient ingredient;
  double usedQuantity;
  String usedUnit;

  RecipeDraftItem({
    required this.ingredient,
    required this.usedQuantity,
    required this.usedUnit,
  });

  double get cost => ingredient.calculateCost(
        usedQuantity: usedQuantity,
        usedUnit: usedUnit,
      );

  OrderIngredientItem toOrderItem() {
    return OrderIngredientItem(
      ingredientId: ingredient.id,
      ingredientName: ingredient.name,
      usedQuantity: usedQuantity,
      usedUnit: usedUnit,
      cost: cost,
    );
  }
}

class AppState extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // Language state
  bool _isBengali = false;
  bool get isBengali => _isBengali;
  AppStrings get strings => AppStrings(isBn: _isBengali);
  String get currency => strings.currency;
  String formatCurrency(num amount) => strings.formatCurrency(amount);

  void toggleLanguage() {
    _isBengali = !_isBengali;
    notifyListeners();
  }

  void setLanguage(bool isBn) {
    if (_isBengali != isBn) {
      _isBengali = isBn;
      notifyListeners();
    }
  }

  // --- Pantry / Ingredients State ---
  List<Ingredient> _ingredients = [];
  List<Ingredient> get ingredients => _ingredients;

  bool _isLoadingIngredients = false;
  bool get isLoadingIngredients => _isLoadingIngredients;

  Future<void> loadIngredients() async {
    _isLoadingIngredients = true;
    notifyListeners();
    try {
      if (kIsWeb) {
        // When running on web, sqflite cannot run in the browser.
        // Retrieve default sample in-memory ingredients from DatabaseHelper.
        _ingredients = await _db.getIngredients();
      } else {
        _ingredients = await _db.getIngredients();
      }
    } catch (e) {
      debugPrint('Error loading ingredients: $e');
    } finally {
      _isLoadingIngredients = false;
      notifyListeners();
    }
  }

  Future<void> addIngredient(Ingredient ingredient) async {
    await _db.insertIngredient(ingredient);
    await loadIngredients();
  }

  Future<void> updateIngredient(Ingredient ingredient) async {
    await _db.updateIngredient(ingredient);
    await loadIngredients();
  }

  Future<void> deleteIngredient(int id) async {
    await _db.deleteIngredient(id);
    // Also remove from draft recipe if present
    _recipeItems.removeWhere((item) => item.ingredient.id == id);
    await loadIngredients();
  }

  // --- Order History State ---
  List<CakeOrder> _orders = [];
  List<CakeOrder> get orders => _orders;

  bool _isLoadingOrders = false;
  bool get isLoadingOrders => _isLoadingOrders;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Future<void> loadOrders({String? search}) async {
    _isLoadingOrders = true;
    if (search != null) {
      _searchQuery = search;
    }
    notifyListeners();
    try {
      if (kIsWeb) {
        // When running on web, sqflite cannot run in the browser.
        // Retrieve default sample in-memory orders from DatabaseHelper.
        _orders = await _db.getOrders(searchQuery: _searchQuery);
      } else {
        _orders = await _db.getOrders(searchQuery: _searchQuery);
      }
    } catch (e) {
      debugPrint('Error loading orders: $e');
    } finally {
      _isLoadingOrders = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadOrders(search: query);
  }

  Future<bool> saveOrder(CakeOrder order) async {
    try {
      await _db.insertOrder(order);
      await loadOrders();
      return true;
    } catch (e) {
      debugPrint('Error saving order: $e');
      return false;
    }
  }

  Future<bool> deleteOrder(int id) async {
    try {
      await _db.deleteOrder(id);
      await loadOrders();
      return true;
    } catch (e) {
      debugPrint('Error deleting order: $e');
      return false;
    }
  }

  // --- Active Cake Cost Calculator Draft State ---
  String _customerName = '';
  String get customerName => _customerName;

  String _cakeName = '';
  String get cakeName => _cakeName;

  DateTime _orderDate = DateTime.now();
  DateTime get orderDate => _orderDate;

  String _notes = '';
  String get notes => _notes;

  final List<RecipeDraftItem> _recipeItems = [];
  List<RecipeDraftItem> get recipeItems => List.unmodifiable(_recipeItems);

  double _ovenWattage = 1800.0;
  double get ovenWattage => _ovenWattage;

  double _bakingTemp = 180.0;
  double get bakingTemp => _bakingTemp;

  double _bakingTimeMinutes = 40.0;
  double get bakingTimeMinutes => _bakingTimeMinutes;

  double _electricityRate = 8.5;
  double get electricityRate => _electricityRate;

  double _packagingCost = 60.0;
  double get packagingCost => _packagingCost;

  double _overheadCost = 50.0;
  double get overheadCost => _overheadCost;

  double _profitMarginPercent = 35.0;
  double get profitMarginPercent => _profitMarginPercent;

  // Calculators & Setters
  void updateOrderInfo({
    String? customerName,
    String? cakeName,
    DateTime? orderDate,
    String? notes,
  }) {
    if (customerName != null) _customerName = customerName;
    if (cakeName != null) _cakeName = cakeName;
    if (orderDate != null) _orderDate = orderDate;
    if (notes != null) _notes = notes;
    notifyListeners();
  }

  void updateUtility({
    double? ovenWattage,
    double? bakingTemp,
    double? bakingTimeMinutes,
    double? electricityRate,
  }) {
    if (ovenWattage != null) _ovenWattage = ovenWattage;
    if (bakingTemp != null) _bakingTemp = bakingTemp;
    if (bakingTimeMinutes != null) _bakingTimeMinutes = bakingTimeMinutes;
    if (electricityRate != null) _electricityRate = electricityRate;
    notifyListeners();
  }

  void updateCosts({
    double? packagingCost,
    double? overheadCost,
    double? profitMarginPercent,
  }) {
    if (packagingCost != null) _packagingCost = packagingCost;
    if (overheadCost != null) _overheadCost = overheadCost;
    if (profitMarginPercent != null) _profitMarginPercent = profitMarginPercent;
    notifyListeners();
  }

  void addOrUpdateRecipeItem({
    required Ingredient ingredient,
    required double usedQuantity,
    required String usedUnit,
  }) {
    final index = _recipeItems.indexWhere((item) => item.ingredient.id == ingredient.id);
    if (index >= 0) {
      _recipeItems[index].usedQuantity = usedQuantity;
      _recipeItems[index].usedUnit = usedUnit;
    } else {
      _recipeItems.add(
        RecipeDraftItem(
          ingredient: ingredient,
          usedQuantity: usedQuantity,
          usedUnit: usedUnit,
        ),
      );
    }
    notifyListeners();
  }

  void removeRecipeItem(int index) {
    if (index >= 0 && index < _recipeItems.length) {
      _recipeItems.removeAt(index);
      notifyListeners();
    }
  }

  void resetCalculator() {
    _customerName = '';
    _cakeName = '';
    _orderDate = DateTime.now();
    _notes = '';
    _recipeItems.clear();
    _ovenWattage = 1800.0;
    _bakingTemp = 180.0;
    _bakingTimeMinutes = 40.0;
    _electricityRate = 8.5;
    _packagingCost = 60.0;
    _overheadCost = 50.0;
    _profitMarginPercent = 35.0;
    notifyListeners();
  }

  // Real-time calculated values
  double get rawMaterialCost {
    return _recipeItems.fold(0.0, (sum, item) => sum + item.cost);
  }

  double get electricityCost {
    return CakeOrder.calculateElectricityCost(
      wattage: _ovenWattage,
      bakingTimeMinutes: _bakingTimeMinutes,
      electricityRate: _electricityRate,
    );
  }

  double get totalCost {
    return rawMaterialCost + electricityCost + _packagingCost + _overheadCost;
  }

  double get sellingPrice {
    return CakeOrder.calculateSellingPrice(
      totalCost: totalCost,
      profitMarginPercent: _profitMarginPercent,
    );
  }

  double get profitAmount => sellingPrice - totalCost;

  /// Builds a CakeOrder object from current draft
  CakeOrder buildOrderFromDraft() {
    return CakeOrder(
      customerName: _customerName.trim(),
      cakeName: _cakeName.trim(),
      orderDate: _orderDate,
      ovenWattage: _ovenWattage,
      bakingTemp: _bakingTemp,
      bakingTimeMinutes: _bakingTimeMinutes,
      electricityRate: _electricityRate,
      electricityCost: electricityCost,
      rawMaterialCost: rawMaterialCost,
      packagingCost: _packagingCost,
      overheadCost: _overheadCost,
      totalCost: totalCost,
      profitMarginPercent: _profitMarginPercent,
      sellingPrice: sellingPrice,
      items: _recipeItems.map((item) => item.toOrderItem()).toList(),
      notes: _notes.trim(),
    );
  }
}
