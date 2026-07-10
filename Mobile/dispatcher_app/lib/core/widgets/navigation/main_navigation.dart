import 'package:flutter/material.dart';

class MainNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MainNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        NavigationDestination(
          icon: Icon(Icons.local_shipping),
          label: "Trips",
        ),
        NavigationDestination(
          icon: Icon(Icons.location_on),
          label: "Tracking",
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: "Drivers",
        ),
        NavigationDestination(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
    );
  }
}