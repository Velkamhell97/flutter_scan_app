import 'package:flutter/material.dart';

//-Solo se encarga del indice, como se desea cambiar desde otro widget es necesario el provider
class UIProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int currentIndex) {
    _currentIndex = currentIndex;
    notifyListeners();
  }

  final scrollController = ScrollController();
}