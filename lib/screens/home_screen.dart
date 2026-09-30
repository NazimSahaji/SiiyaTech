import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'create_cake_screen.dart';
import 'ingredients_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final s = appState.strings;
    final theme = Theme.of(context);

    final screens = [
      CreateCakeScreen(
        onOrderSaved: () {
          setState(() {
            _currentIndex = 2; // Switch to Order History
          });
        },
      ),
      const IngredientsScreen(),
      const HistoryScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.cake, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                s.appTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          // Language Switcher Button (EN / বাং)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ActionChip(
              avatar: Icon(
                Icons.language,
                size: 18,
                color: theme.colorScheme.onPrimaryContainer,
              ),
              label: Text(
                s.langCode,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              backgroundColor: theme.colorScheme.primaryContainer,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              tooltip: s.switchLangTooltip,
              onPressed: () {
                appState.toggleLanguage();
              },
            ),
          ),
        ],
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.calculate_outlined),
            selectedIcon: const Icon(Icons.calculate),
            label: s.tabCalculator,
          ),
          NavigationDestination(
            icon: const Icon(Icons.kitchen_outlined),
            selectedIcon: const Icon(Icons.kitchen),
            label: s.tabPantry,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: s.tabHistory,
          ),
        ],
      ),
    );
  }
}
