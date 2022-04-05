import 'package:hive/hive.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'hive_scan_model.g.dart';

@HiveType(typeId: 0)
class HiveScanModel extends HiveObject {

  @HiveField(0)
  String tipo;

  @HiveField(1)
  String valor;

  HiveScanModel({required this.tipo, required this.valor});

  LatLng getLatLng () {
    final latlng = this.valor.substring(4).split(',');

    final lat = double.parse(latlng[0]);
    final lon = double.parse(latlng[1]);

    return LatLng(lat, lon);
  }
}
