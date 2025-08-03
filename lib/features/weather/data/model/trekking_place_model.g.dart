// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trekking_place_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrekkingPlaceModelAdapter extends TypeAdapter<TrekkingPlaceModel> {
  @override
  final int typeId = 3;

  @override
  TrekkingPlaceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrekkingPlaceModel(
      placeName: fields[0] as String,
      lat: fields[1] as double,
      lon: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TrekkingPlaceModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.placeName)
      ..writeByte(1)
      ..write(obj.lat)
      ..writeByte(2)
      ..write(obj.lon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrekkingPlaceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
