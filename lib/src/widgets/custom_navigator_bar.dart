import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/providers.dart';

class CustomNavigatorBar extends StatelessWidget {
  const CustomNavigatorBar({Key? key}) : super(key: key);

  static const _scanTabs = ScanCategory.categories;

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<NavigationProvider>();
    // print('build bottom');

    return BottomNavigationBar(
      onTap: (index) {
        navigationProvider.currentIndex = index;

        context.read<ScansProvider>().selectedType = _scanTabs[index].type;
        context.read<HiveScansProvider>().selectedType = _scanTabs[index].type;
      },
      elevation: 8,
      currentIndex: navigationProvider.currentIndex,
      items: _scanTabs.map((scan) {
        return BottomNavigationBarItem(
          icon: Icon(scan.icon),
          label: scan.label
        );
      }).toList(),
    );
  }
}