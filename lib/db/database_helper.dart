import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/ingredient.dart';
import '../models/cake_order.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  // In-memory storage for web where sqflite is not supported
  final List<Ingredient> _inMemoryIngredients = [];
  final List<CakeOrder> _inMemoryOrders = [];
  bool _inMemoryInitialized = false;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError('sqflite is not supported in the web browser.');
    }
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  void _initInMemoryData() {
    if (_inMemoryInitialized) return;
    _inMemoryInitialized = true;

    _inMemoryIngredients.addAll(const [
      Ingredient(id: 1, name: 'All Purpose Flour (ময়দা)', purchasePrice: 70.0, purchaseQuantity: 1.0, unit: 'kg'),
      Ingredient(id: 2, name: 'White Sugar (চিনি)', purchasePrice: 135.0, purchaseQuantity: 1.0, unit: 'kg'),
      Ingredient(id: 3, name: 'Butter (মাখন)', purchasePrice: 450.0, purchaseQuantity: 500.0, unit: 'g'),
      Ingredient(id: 4, name: 'Eggs (ডিম)', purchasePrice: 150.0, purchaseQuantity: 12.0, unit: 'pcs'),
      Ingredient(id: 5, name: 'Cocoa Powder (কোকো পাউডার)', purchasePrice: 280.0, purchaseQuantity: 200.0, unit: 'g'),
      Ingredient(id: 6, name: 'Milk (দুধ)', purchasePrice: 90.0, purchaseQuantity: 1.0, unit: 'L'),
      Ingredient(id: 7, name: 'Baking Powder (বেকিং পাউডার)', purchasePrice: 120.0, purchaseQuantity: 100.0, unit: 'g'),
      Ingredient(id: 8, name: 'Vanilla Extract (ভ্যানিলা এসেন্স)', purchasePrice: 160.0, purchaseQuantity: 50.0, unit: 'ml'),
      Ingredient(id: 9, name: 'Whipping Cream (হুইপিং ক্রিম)', purchasePrice: 420.0, purchaseQuantity: 1.0, unit: 'L'),
      Ingredient(id: 10, name: 'Dark Chocolate Compound (চকলেট)', purchasePrice: 380.0, purchaseQuantity: 500.0, unit: 'g'),
    ]);

    _inMemoryOrders.addAll([
      CakeOrder(
        id: 1,
        customerName: 'Ayesha Rahman',
        cakeName: 'Chocolate Fudge Birthday Cake (2 lbs)',
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        ovenWattage: 1800.0,
        bakingTemp: 180.0,
        bakingTimeMinutes: 45.0,
        electricityRate: 8.5,
        electricityCost: 11.48,
        rawMaterialCost: 435.0,
        packagingCost: 60.0,
        overheadCost: 50.0,
        totalCost: 556.48,
        profitMarginPercent: 35.0,
        sellingPrice: 751.25,
        items: const [
          OrderIngredientItem(ingredientId: 1, ingredientName: 'All Purpose Flour (ময়দা)', usedQuantity: 250.0, usedUnit: 'g', cost: 17.5),
          OrderIngredientItem(ingredientId: 2, ingredientName: 'White Sugar (চিনি)', usedQuantity: 200.0, usedUnit: 'g', cost: 27.0),
          OrderIngredientItem(ingredientId: 3, ingredientName: 'Butter (মাখন)', usedQuantity: 150.0, usedUnit: 'g', cost: 135.0),
          OrderIngredientItem(ingredientId: 4, ingredientName: 'Eggs (ডিম)', usedQuantity: 3.0, usedUnit: 'pcs', cost: 37.5),
          OrderIngredientItem(ingredientId: 5, ingredientName: 'Cocoa Powder (কোকো পাউডার)', usedQuantity: 60.0, usedUnit: 'g', cost: 84.0),
          OrderIngredientItem(ingredientId: 10, ingredientName: 'Dark Chocolate Compound (চকলেট)', usedQuantity: 150.0, usedUnit: 'g', cost: 114.0),
        ],
        notes: 'Birthday cake with gold drip and custom text topper.',
      ),
      CakeOrder(
        id: 2,
        customerName: 'Tanvir Hossain',
        cakeName: 'Vanilla Sponge Anniversary Cake (1.5 lbs)',
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        ovenWattage: 1600.0,
        bakingTemp: 175.0,
        bakingTimeMinutes: 35.0,
        electricityRate: 8.5,
        electricityCost: 7.93,
        rawMaterialCost: 285.0,
        packagingCost: 50.0,
        overheadCost: 40.0,
        totalCost: 382.93,
        profitMarginPercent: 30.0,
        sellingPrice: 497.81,
        items: const [
          OrderIngredientItem(ingredientId: 1, ingredientName: 'All Purpose Flour (ময়দা)', usedQuantity: 200.0, usedUnit: 'g', cost: 14.0),
          OrderIngredientItem(ingredientId: 2, ingredientName: 'White Sugar (চিনি)', usedQuantity: 150.0, usedUnit: 'g', cost: 20.25),
          OrderIngredientItem(ingredientId: 3, ingredientName: 'Butter (মাখন)', usedQuantity: 100.0, usedUnit: 'g', cost: 90.0),
          OrderIngredientItem(ingredientId: 4, ingredientName: 'Eggs (ডিম)', usedQuantity: 2.0, usedUnit: 'pcs', cost: 25.0),
          OrderIngredientItem(ingredientId: 6, ingredientName: 'Milk (দুধ)', usedQuantity: 100.0, usedUnit: 'ml', cost: 9.0),
          OrderIngredientItem(ingredientId: 8, ingredientName: 'Vanilla Extract (ভ্যানিলা এসেন্স)', usedQuantity: 10.0, usedUnit: 'ml', cost: 32.0),
          OrderIngredientItem(ingredientId: 7, ingredientName: 'Baking Powder (বেকিং পাউডার)', usedQuantity: 10.0, usedUnit: 'g', cost: 12.0),
        ],
        notes: 'Anniversary celebration, mild sweetness requested.',
      ),
    ]);
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      throw UnsupportedError('sqflite cannot be initialized in the browser.');
    }

    // Enable FFI on Desktop platforms
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cake_cost_calculator.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Ingredients Table
    await db.execute('''
      CREATE TABLE ingredients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        purchase_price REAL NOT NULL,
        purchase_quantity REAL NOT NULL,
        unit TEXT NOT NULL
      )
    ''');

    // 2. Orders Table
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_name TEXT NOT NULL,
        cake_name TEXT NOT NULL,
        order_date TEXT NOT NULL,
        oven_wattage REAL NOT NULL,
        baking_temp REAL NOT NULL,
        baking_time_minutes REAL NOT NULL,
        electricity_rate REAL NOT NULL,
        electricity_cost REAL NOT NULL,
        raw_material_cost REAL NOT NULL,
        packaging_cost REAL NOT NULL,
        overhead_cost REAL NOT NULL,
        total_cost REAL NOT NULL,
        profit_margin_percent REAL NOT NULL,
        selling_price REAL NOT NULL,
        items_json TEXT NOT NULL,
        notes TEXT
      )
    ''');

    // Seed default common pantry ingredients
    await _seedDefaultIngredients(db);
  }

  Future<void> _seedDefaultIngredients(Database db) async {
    final defaultIngredients = [
      {'name': 'All Purpose Flour (ময়দা)', 'purchase_price': 70.0, 'purchase_quantity': 1.0, 'unit': 'kg'},
      {'name': 'White Sugar (চিনি)', 'purchase_price': 135.0, 'purchase_quantity': 1.0, 'unit': 'kg'},
      {'name': 'Butter (মাখন)', 'purchase_price': 450.0, 'purchase_quantity': 500.0, 'unit': 'g'},
      {'name': 'Eggs (ডিম)', 'purchase_price': 150.0, 'purchase_quantity': 12.0, 'unit': 'pcs'},
      {'name': 'Cocoa Powder (কোকো পাউডার)', 'purchase_price': 280.0, 'purchase_quantity': 200.0, 'unit': 'g'},
      {'name': 'Milk (দুধ)', 'purchase_price': 90.0, 'purchase_quantity': 1.0, 'unit': 'L'},
      {'name': 'Baking Powder (বেকিং পাউডার)', 'purchase_price': 120.0, 'purchase_quantity': 100.0, 'unit': 'g'},
      {'name': 'Vanilla Extract (ভ্যানিলা এসেন্স)', 'purchase_price': 160.0, 'purchase_quantity': 50.0, 'unit': 'ml'},
      {'name': 'Whipping Cream (হুইপিং ক্রিম)', 'purchase_price': 420.0, 'purchase_quantity': 1.0, 'unit': 'L'},
      {'name': 'Dark Chocolate Compound (চকলেট)', 'purchase_price': 380.0, 'purchase_quantity': 500.0, 'unit': 'g'},
    ];

    final batch = db.batch();
    for (final ing in defaultIngredients) {
      batch.insert('ingredients', ing);
    }
    await batch.commit(noResult: true);
  }

  // --- Ingredient CRUD ---

  Future<int> insertIngredient(Ingredient ingredient) async {
    if (kIsWeb) {
      _initInMemoryData();
      final newId = (_inMemoryIngredients.isEmpty
              ? 0
              : _inMemoryIngredients.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b)) +
          1;
      final newIng = ingredient.copyWith(id: newId);
      _inMemoryIngredients.add(newIng);
      return newId;
    }
    final db = await database;
    return await db.insert('ingredients', ingredient.toMap());
  }

  Future<List<Ingredient>> getIngredients() async {
    if (kIsWeb) {
      _initInMemoryData();
      final list = List<Ingredient>.from(_inMemoryIngredients);
      list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      return list;
    }
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'ingredients',
      orderBy: 'name ASC',
    );
    return maps.map((m) => Ingredient.fromMap(m)).toList();
  }

  Future<int> updateIngredient(Ingredient ingredient) async {
    if (kIsWeb) {
      _initInMemoryData();
      final idx = _inMemoryIngredients.indexWhere((e) => e.id == ingredient.id);
      if (idx >= 0) {
        _inMemoryIngredients[idx] = ingredient;
        return 1;
      }
      return 0;
    }
    final db = await database;
    return await db.update(
      'ingredients',
      ingredient.toMap(),
      where: 'id = ?',
      whereArgs: [ingredient.id],
    );
  }

  Future<int> deleteIngredient(int id) async {
    if (kIsWeb) {
      _initInMemoryData();
      _inMemoryIngredients.removeWhere((e) => e.id == id);
      return 1;
    }
    final db = await database;
    return await db.delete(
      'ingredients',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- Order CRUD ---

  Future<int> insertOrder(CakeOrder order) async {
    if (kIsWeb) {
      _initInMemoryData();
      final newId = (_inMemoryOrders.isEmpty
              ? 0
              : _inMemoryOrders.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b)) +
          1;
      final newOrder = CakeOrder(
        id: newId,
        customerName: order.customerName,
        cakeName: order.cakeName,
        orderDate: order.orderDate,
        ovenWattage: order.ovenWattage,
        bakingTemp: order.bakingTemp,
        bakingTimeMinutes: order.bakingTimeMinutes,
        electricityRate: order.electricityRate,
        electricityCost: order.electricityCost,
        rawMaterialCost: order.rawMaterialCost,
        packagingCost: order.packagingCost,
        overheadCost: order.overheadCost,
        totalCost: order.totalCost,
        profitMarginPercent: order.profitMarginPercent,
        sellingPrice: order.sellingPrice,
        items: order.items,
        notes: order.notes,
      );
      _inMemoryOrders.insert(0, newOrder);
      return newId;
    }
    final db = await database;
    return await db.insert('orders', order.toMap());
  }

  Future<List<CakeOrder>> getOrders({String? searchQuery}) async {
    if (kIsWeb) {
      _initInMemoryData();
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final query = searchQuery.trim().toLowerCase();
        return _inMemoryOrders.where((order) {
          return order.customerName.toLowerCase().contains(query) ||
              order.cakeName.toLowerCase().contains(query);
        }).toList();
      }
      return List<CakeOrder>.from(_inMemoryOrders);
    }
    final db = await database;
    List<Map<String, dynamic>> maps;

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final query = '%${searchQuery.trim()}%';
      maps = await db.query(
        'orders',
        where: 'customer_name LIKE ? OR cake_name LIKE ?',
        whereArgs: [query, query],
        orderBy: 'order_date DESC, id DESC',
      );
    } else {
      maps = await db.query(
        'orders',
        orderBy: 'order_date DESC, id DESC',
      );
    }

    return maps.map((m) => CakeOrder.fromMap(m)).toList();
  }

  Future<CakeOrder?> getOrderById(int id) async {
    if (kIsWeb) {
      _initInMemoryData();
      try {
        return _inMemoryOrders.firstWhere((o) => o.id == id);
      } catch (_) {
        return null;
      }
    }
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return CakeOrder.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteOrder(int id) async {
    if (kIsWeb) {
      _initInMemoryData();
      _inMemoryOrders.removeWhere((o) => o.id == id);
      return 1;
    }
    final db = await database;
    return await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

