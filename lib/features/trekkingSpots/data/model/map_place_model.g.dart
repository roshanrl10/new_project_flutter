// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_place_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MapPlaceModelAdapter extends TypeAdapter<MapPlaceModel> {
  @override
  final int typeId = 4;

  @override
  MapPlaceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MapPlaceModel(
      id: fields[0] as String,
      name: fields[1] as String,
      latitude: fields[2] as double,
      longitude: fields[3] as double,
      difficulty: fields[4] as String,
      elevation: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MapPlaceModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.difficulty)
      ..writeByte(5)
      ..write(obj.elevation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapPlaceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
