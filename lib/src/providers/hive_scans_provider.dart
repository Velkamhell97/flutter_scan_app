import 'package:flutter/material.dart';

class HiveScansProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  //-Mas dificil usarlo porque en hive todos los datos se precargan, el error se debeira capturar 
  //-en otro lugar
  String? error;

  //-Aunque no es el lugar ideal es neceasrio manejarlo desde aqui para utilizarlo en otros widgets
  final scrollController = ScrollController();

  //-La desventaja de trabajar con mapas (scans) y indices (tabs)
  final _types = ['geo','http'];

  int getIndex(String type) => _types.indexOf(type);

  //-Se actualiza el tipo y asi se filtran por otro nombre los scans del listenable
  String _selectedType = 'geo';
  String get selectedType => _selectedType;
  set selectedType(String selectedType) {
    _selectedType = selectedType;
    notifyListeners();
  }
}
