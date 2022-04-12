import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/providers.dart';

class CustomNavigatorBar extends StatelessWidget {
  const CustomNavigatorBar({Key? key}) : super(key: key);

  static const _scanTabs = ScanCategory.categories;

  @override
  Widget build(BuildContext context) {
    /// El consumer es tipo de selector pero que devuelve toda la referencia del provider, util para este caso
    /// que se necesita tanto una variable como el provider, sin embargo para providers con muchas propiedades
    /// es mas optimo el selector por que escucha una propiedad en especifico
    return Consumer<UIProvider>(
      builder: (context, bottomBar, __) {
        return BottomNavigationBar(
          onTap: (index) {
            bottomBar.currentIndex = index;
            context.read<ScansProvider>().selectedType = _scanTabs[index].type;
          },
          elevation: 8,
          currentIndex: bottomBar.currentIndex,
          items: _scanTabs.map((scan) {
            return BottomNavigationBarItem(
              icon: Icon(scan.icon),
              label: scan.label
            );
          }).toList(),
        );
      },
    );
  }
}