import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

import '../models/models.dart';

//Por ser un constructor asyncrono que debe inicializarse al inicio de la app es mejor manejar 
//un modelo singlenton que uno tipo provider que se le pase como parametro a otro notifier
class SqfliteApi {
  SqfliteApi._internal();

  static final SqfliteApi _instance = SqfliteApi._internal();

  factory SqfliteApi() => _instance;

  late final Database _database;

  FutureOr<void> _onCreated(Database db, int version) async {
    return await db.execute('''
      CREATE TABLE Scans(
        id INTEGER PRIMARY KEY,
        tipo TEXT,
        valor TEXT
      )
    ''');
  }

  Future<void> initDB() async{
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');

    _database = await openDatabase(path, version: 1, onCreate: _onCreated);
  }

  //------------------------- ORM OPERATIONS --------------------------//
  Future<int> insertScan(ScanModel newScan) async {
    final id = await _database.insert('Scans', newScan.toMap());
    return id;
  }

  Future<List<ScanModel>> getScans() async {
    final results = await _database.query('Scans');

    final scans = List<ScanModel>.from(results.map((s) => ScanModel.fromMap(s)));

    return scans;
  }

  Future<ScanModel?> getScanById(int scanId) async {
    final results = await _database.query('Scans', where: 'id = ?', whereArgs: [scanId]);

    if(results.isEmpty) return null;

    final scan = ScanModel.fromMap(results.first);

    return scan;
  }

   Future<List<ScanModel>> getScanByType(String type) async {
    final results = await _database.query('Scans',where: 'tipo = ?', whereArgs: [type]);

    final scans = List<ScanModel>.from(results.map((s) => ScanModel.fromMap(s)));

    return scans;
  }
  
  Future<int> updateScanById(int scanId, ScanModel newScan ) async {
    final result = await _database.update('Scans', newScan.toMap(), where: 'id = ?', whereArgs: [scanId]);
    return result;
  }

  Future<int> deleteScanById(int scanId) async{
    final result = await _database.delete('Scans', where: 'id = ?', whereArgs: [scanId]);
    return result;
  }

  Future<int> deleteScanByType(String type) async{
    final result = await _database.delete('Scans', where: 'tipo = ?', whereArgs: [type]);
    return result;
  }

  Future<int> deleteAllScans() async {
    final result = await _database.delete('Scans');
    return result;
  }


  //------------------------- RAW OPERATIONS --------------------------//
  Future<int> insertScanRaw(ScanModel newScan) async {
    final tipo  = newScan.tipo;
    final valor = newScan.valor ;

    final result = await _database.rawInsert('''
      INSERT INTO Scans(tipo, valor)
        VALUES('$tipo', '$valor')
    ''');

    return result;
  }

   Future<List<ScanModel>> getScansRaw() async {
    final results = await _database.rawQuery('''
      SELECT * FROM Scans
    ''');

    final scans = List<ScanModel>.from(results.map((s) => ScanModel.fromMap(s)));

    return scans;
  }

  Future<ScanModel?> getScanByIdRaw(int scanId) async {
    final result = await _database.rawQuery('''
      SELECT * FROM Scans WHERE id = '$scanId'
    ''');

    if(result.isEmpty) return null;

    final scan = ScanModel.fromMap(result.first);

    return scan;
  }

  Future<List<ScanModel>> getScanByTypeRaw(String type) async {
    final results = await _database.rawQuery('''
      SELECT * FROM Scans WHERE tipo = '$type'
    ''');

    final scans = List<ScanModel>.from(results.map((s) => ScanModel.fromMap(s)));

    return scans;
  }

  Future<int> updateScanByIdRaw(int scanId, ScanModel newScan ) async {
    final tipo  = newScan.tipo;
    final valor = newScan.valor;

    final result = await _database.rawUpdate('''
      UPDATE Scans SET tipo = ?, valor = ? WHERE id = ?
    ''',
      [tipo, valor, scanId]
    );

    return result;
  }

  Future<int> deleteScanByIdRaw(int scanId) async{
    final result = await _database.rawDelete('''
      DELETE FROM Scans WHERE id = ?
    ''',
      [scanId]
    );

    return result;
  }

  Future<int> deleteScanByTypeRaw(String type) async{
    final result = await _database.rawDelete('''
      DELETE FROM Scans WHERE type = ?
    ''',
      [type]
    );

    return result;
  }

  Future<int> deleteAllScansRaw() async {
    final result = await _database.rawDelete('''
      DELETE FROM Scans
    ''');

    return result;
  }
}