import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class ScanModel {
  final int? id;
  final String tipo;
  final String valor;

  const ScanModel({this.id, required this.tipo, required this.valor});

  //-Se podria crear una extension que haga esto
  LatLng getLatLng () {
    final latlng = valor.substring(4).split(',');

    final lat = double.parse(latlng[0]);
    final lon = double.parse(latlng[1]);

    return LatLng(lat, lon);
  }

  ScanModel copyWith({int? id, String? tipo, String? valor}) => ScanModel(
    id: id ?? this.id,
    tipo: tipo ?? this.tipo, 
    valor: valor ?? this.valor
  );

  factory ScanModel.fromMap(Map<String, dynamic> json) => ScanModel(
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
