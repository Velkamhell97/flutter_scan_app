import 'package:flutter/material.dart';
import 'dart:async';

import '../models/models.dart';
import '../services/services.dart';

  class ScansProvider extends ChangeNotifier {
    /// En este servicio unicamente se hacen las operaciones con la DB
    final SqfliteApi db = SqfliteApi();

    bool _loading = false;
    bool get loading => _loading;
    set loading(bool loading) {
      _loading = loading;
      notifyListeners();
    }

    /// Error principalmente al cargar los datos, para errores en el crud de las DB se utiliza un snackbar
    /// Para el caso de Hive esto tiene menos uso ya que este precarga los datos por lo que no se puede
    /// como tal capturar un error de carga, se deberia hacer otra logica pero es muy raro que pase con hive
    String? error;

    ScansProvider(){
      loadScans();
    }

    /// Con el selected type decidimos que elemento del mapa mostrar 
    String _selectedType = 'geo';
    String get selectedType => _selectedType;
    set selectedType(String selectedType) {
      _selectedType = selectedType;
      notifyListeners();
    }

    /// Desventaja de trabajar con mapas (scans) y indices (tabs)
    int getIndex(String type) => scansMap.keys.toList().indexOf(_selectedType);

    /// Las peticiones a las db locales no necesitan manejar tantos estados como fetching, data y error
    /// ya que las operaciones, insert, update, delete son demasiado rapidas porque siempre se hacen
    /// sobre un elemento al tiempo (en esta app), la unica operacion que valdria la pena un loading
    /// seria la carga de los archivos iniciales (get) que tambien tendrian que ser demasidos, por esta
    /// razon no necesitamos crear varias listas con cada una con su estado, sino solo la lista de
    /// valores para cada categoria, como la db no separa entre estas listas sino que todas estan juntas
    /// lo que hacemos en verdad es filtrarlas.
    /// 
    /// Ahora bien se podria crear una sola lista como hive y filtrarlas cuando se cambia de tipo pero
    /// si se separan en el primer loading sera mas optimo, como es la misma lista que se muestra con
    /// diferentes valores no podemos crear una lista de listas de scans, ya que no tenemos el indice
    /// para cambiar entre una y otra, en vez de eso utilizamos un mapa que para este caso es un poco
    /// mas intuitivo, el unico problema esque como el bottomNavigation esta conectado con la lissta seleccionada
    /// lo ideal seria utilizar ese mismo indice para cambiar la lista pero como tenemos unmapa
    /// tenemos que crear un string que cambie al cambiar el bottomBar y devuelva la lista correcta
    /// de igual manera como el cambio del tipo tambien debe cambiar el bottomBar debemos crear la funcion
    /// que devuelve el indice correspondiente a ese tipo, aunque paresca enredado es un aproach claro
    /// e intuitivo
    Map<String, List<Scan>> scansMap = {
      'geo'  : [],
      'http' : [],
    };

    //---------------------------------------
    // New Scans
    //---------------------------------------
    Future<Scan?> newScan(String value) async {
      final tipo = value.contains('http') ? 'http' : 'geo';
      
      try {
        final dbScan = Scan(valor: value, tipo: tipo);
        final id = await db.insertScan(dbScan);

        final scan = dbScan.copyWith(id: id);

        /// Se pueden usar operaciones de mutabilidad porque el cambio del map debemos activarlo manualmente
        /// con el notifyListener pero lo normal seria crear un nuevo estado [...old, new]
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
    /// Sirve para la primera carga y recargas cuadno ocurre un error ya que vuelve a aparecer la pantalla
    /// de loading, sin embargo con el caso de hive es mas complicado porque su listener es un valueNotifier
    /// al cual no se le pueden añadir errorss sino que siempre tiene un valor y como no podemos recargar ese
    /// Notifier sino hasta que haya un cambio en esos valores el get de esos valores no redibujara el widget
    /// por lo que para hive se manejara de otra forma, recordar que los errores son muy raros que aparezcan en 
    /// bases de datos locales ya que no hay peticiones ni nada
    Future<void> loadScans()  async{
      loading = true;

      try {
        for(String type in scansMap.keys){
          /// Se deben reemplazar no el addAll ya que agregaria nuevas al repetirse
          scansMap[type] = await db.getScanByType(type); 
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
        /// Lo ideal seria craer un nuevo estado, pero como se manejan mapas se muta
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
