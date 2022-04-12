import 'package:hive/hive.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'scan.g.dart';

/// Forma de definir un TypeAdapter
@HiveType(typeId: 0)
class Scan extends HiveObject {
  /// Este id es para trabajar con sqflite
  @HiveField(0)
  int? id;

  @HiveField(1, defaultValue: 'geo')
  final String tipo;

  @HiveField(2)
  final String valor;

  /// Las clases creadas con hive no pueden ser constantes por lo que el copyWith para que la clase
  /// sea inmutable no tendria sentido porque no todas las variables son finales, sin embargo se deja
  Scan({this.id, required this.tipo, required this.valor});

  LatLng getLatLng () {
    final latlng = valor.substring(4).split(',');

    final lat = double.parse(latlng[0]);
    final lon = double.parse(latlng[1]);

    return LatLng(lat, lon);
  }
  
  Scan copyWith({int? id, String? tipo, String? valor}) => Scan(
    id: id ?? this.id,
    tipo: tipo ?? this.tipo, 
    valor: valor ?? this.valor
  );

  /// El fromMap y el toMap es para el casteo de los elementos guardados con sfqlite
  factory Scan.fromMap(Map<String, dynamic> json) => Scan(
    id: json["id"],
    tipo: json["tipo"],
    valor: json["valor"],
  );

  Map<String, dynamic> toMap() => {
    // "id": id,
    "tipo": tipo,
    "valor": valor,
  };

  @override
  String toString() {
    return 'Scan: {id:$id, tipo:$tipo, valor:$valor}';
  }
}
