import 'package:flutter/material.dart';
import 'dart:async';

import '../models/models.dart';
import '../services/services.dart';


class ScansProvider extends ChangeNotifier {
  final SqfliteApi db = SqfliteApi();

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  //-Error principalmente al cargar los datos para los demas se utiliza un snackbar
  String? error;

  final scrollController = ScrollController();

  ScansProvider(){
    loadScans();
  }

  String _selectedType = 'geo';
  String get selectedType => _selectedType;
  set selectedType(String selectedType) {
    _selectedType = selectedType;
    notifyListeners();
  }

  //-Desventaja de trabajar con mapas (scans) y indices (tabs)
  List<ScanModel> get activeScans => scansMap[_selectedType]!;
  int getIndex(String type) => scansMap.keys.toList().indexOf(_selectedType);

  //-Se podria utilizar una clase con las propiedades completas y la lista de sus scans
  //-pero se tendria que hacer mucha mutabilidad con las listas que no es malo, pero
  //-desentraliza un poco la logica ya que asi se maneja unicamente los arreglos
  
  //-Tambien se podria crear una lista para cada categoria pero eso implicaria tener un widget
  //-o lista para cada una de ellas lo cual puede que no sea malo pero crece la complejidad
  Map<String, List<ScanModel>> scansMap = {
    'geo'  : [],
    'http' : [],
  };

  //---------------------------------------
  // New Scans
  //---------------------------------------
  Future<ScanModel?> newScan(String value) async {
    final tipo = value.contains('http') ? 'http' : 'geo';
    
    try {
      final dbScan = ScanModel(valor: value, tipo: tipo);
      final id = await db.insertScan(dbScan);

      //-Se utiliza el copyWith para dejar la clase constante
      final scan = dbScan.copyWith(id: id);

      //Se pueden usar operaciones de mutabilidad porque el cambio del map debemos activarlo manualmente
      //con el notifyListener pero lo normal seria crear un nuevo estado [...old, new]
      scansMap[tipo]!.add(scan);

      if (selectedType == tipo) {
        notifyListeners();
      }

      return scan;
    } catch (e) {
      print('error ${e.toString()}');
      return null;
    }    
  }

  //---------------------------------------
  // Get Scans By Type
  //---------------------------------------
  Future<void> loadScans()  async{
    loading = true;

    try {
      for(String type in scansMap.keys){
        final scans = await db.getScanByType(type);
        //-Se deben reemplazar no el addAll ya que agregaria nuevas al repetirse
        scansMap[type] = scans; 
      }
    } catch (e) {
      print('error ${e.toString()}');
      error = 'error ${e.toString()}';
    } finally {
      loading = false;
    }
  }

  //---------------------------------------
  // Delete Scan By ID
  //---------------------------------------
  Future<String?> deleteScanById(int scanId) async {
    try {
      await db.deleteScanById(scanId);
      //-Lo ideal seria craer un nuevo estado, pero como se manejan mapas se muta
      scansMap[selectedType]!.removeWhere((scan) => scan.id == scanId);
      
      if(scansMap[selectedType]!.isEmpty){
        notifyListeners();
      }

      return null;
    } catch (e) {
      print('error ${e.toString()}');
      return 'error ${e.toString()}';
    }
  }

  //---------------------------------------
  // Delete Scans By Type
  //---------------------------------------
  Future<String?> deleteScansByType(String type) async {
    try {
      await db.deleteScanByType(type);
      scansMap[type] = [];

      notifyListeners();
      return null;
    } catch (e) {
      print('error ${e.toString()}');
      return 'error ${e.toString()}';
    }
  }

  //---------------------------------------
  // Delete Active Scans
  //---------------------------------------
  Future<String?> deleteActiveScans() async {
    try {
      await db.deleteScanByType(_selectedType);
      scansMap[selectedType] = [];

      notifyListeners();
      return null;
    } catch (e) {
      print('error ${e.toString()}');
      return 'error ${e.toString()}';
    }
  }

  //---------------------------------------
  // Delete All Scans
  //---------------------------------------
  Future<String?> deleteAllScans() async {
    try {
      await db.deleteAllScans();

      for(String key in scansMap.keys){
        scansMap[key] = [];
      }

      notifyListeners();
      return null;
    } catch (e) {
      print('error ${e.toString()}');
      return 'error ${e.toString()}';
    }
  }
}
