// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_scan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveScanModelAdapter extends TypeAdapter<HiveScanModel> {
  @override
  final int typeId = 0;

  @override
  HiveScanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveScanModel(
      tipo: fields[0] as String,
      valor: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveScanModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.tipo)
      ..writeByte(1)
      ..write(obj.valor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveScanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
