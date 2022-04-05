import 'package:hive/hive.dart';

import '../models/models.dart';

//-Se podria hacer un provider que maneje todo con hive como db pero se quiere explotar la capacidad
//-de los listenables de este paquete con el ValueNotifierBuilder
class HiveApi {
  final scansBox = Hive.box<HiveScanModel>('scans');
  
  //-Forma de representar un error
  Future<HiveScanModel?> insertScan(String value) async {
    final type = value.contains('http') ? 'http' : 'geo';
    final dbScan = HiveScanModel(tipo: type, valor: value);

    try {
      await scansBox.add(dbScan);
      return dbScan;
    } catch (e) {
      return null;
    }
  }

  //-Cuando se carga el box, carga todos los elementos (mas dificil capturar un error)
  Future<List<HiveScanModel>> getScans() async {
    final scans = scansBox.values;
    return scans.toList();
  }

  Future<HiveScanModel?> getScanByKey(int scanKey) async {
    final scan = scansBox.get(scanKey);
    return scan;
  }

  Future<List<HiveScanModel>> getScanByType(String type) async {
    final scans = scansBox.values.where((scan) => scan.tipo == type);
    return scans.toList();
  }
  
  Future<void> updateScanByKey(int scanKey, HiveScanModel newScan) async {
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
      for(HiveScanModel scan in scans){
        await scan.delete();
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