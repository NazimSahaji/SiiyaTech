import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState();

  // ওয়েবে sqflite ডেটাবেস আটকাবে না
  if (!kIsWeb) {
    await appState.loadIngredients();
    await appState.loadOrders();
  }

  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const CakeCostCalculatorApp(),
    ),
  );
}

class CakeCostCalculatorApp extends StatelessWidget {
  const CakeCostCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Warm bakery / confectionery inspired theme
    const baseColor = Color(0xFFC04E67); // Deep rose / berry cake color

    final colorScheme = ColorScheme.fromSeed(
      seedColor: baseColor,
      brightness: Brightness.light,
      primary: baseColor,
      secondary: const Color(0xFF9E4770),
      tertiary: const Color(0xFFD48B4B), // Warm crust / honey amber
      surface: const Color(0xFFFFFBFB),
    );

    return MaterialApp(
      title: 'Cake Bake Cost Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFFBF8F8),
        appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.outlineVariant.withOpacity(0.6),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
