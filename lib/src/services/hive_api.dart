import 'package:hive/hive.dart';

import '../models/models.dart';

/// Se podria hacer un provider que maneje todo con Hive como DB pero se quiere explotar la capacidad
/// De los listenables de este paquete con el ValueNotifierBuilder
class HiveApi {
  final scansBox = Hive.box<Scan>('scans');
  
  /// Si devuelve nulo hay error
  Future<Scan?> insertScan(String value) async {
    final type = value.contains('http') ? 'http' : 'geo';
    final dbScan = Scan(tipo: type, valor: value);

    try {
      await scansBox.add(dbScan);
      return dbScan;
    } catch (e) {
      return null;
    }
  }

  /// Solo util si se utiliza Hive sin el ValueNotifierListener
  Future<List<Scan>> getScans() async {
    final scans = scansBox.values;
    return scans.toList();
  }

  Future<Scan?> getScanByKey(int scanKey) async {
    final scan = scansBox.get(scanKey);
    return scan;
  }

  Future<List<Scan>> getScanByType(String type) async {
    final scans = scansBox.values.where((scan) => scan.tipo == type);
    return scans.toList();
  }
  
  Future<void> updateScanByKey(int scanKey, Scan newScan) async {
    await scansBox.put(scanKey, newScan);
  }

  Future<String?> deleteScanByKey(int scanKey) async{
    try {
      await scansBox.delete(scanKey);
      return null;
    } catch (e) {
      print('error ${e.toString()}');
      return 'error ${e.toString()}';
    }
  }

  Future<String?> deleteScanByType(String type) async{
    final scans = scansBox.values.where((scan) => scan.tipo == type);

    try {
      for(Scan scan in scans){
        await scansBox.delete(scan.key);
      }

      return null;
    } catch (e) {
      print('error ${e.toString()}');
      return 'error ${e.toString()}';
    }
  }

  Future<void> deleteAllScans() async {
    await scansBox.clear();
  }
}