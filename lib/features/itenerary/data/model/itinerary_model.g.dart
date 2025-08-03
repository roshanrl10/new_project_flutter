// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItineraryModelAdapter extends TypeAdapter<ItineraryModel> {
  @override
  final int typeId = 3;

  @override
  ItineraryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItineraryModel(
      id: fields[0] as String,
      name: fields[1] as String,
      imageUrls: (fields[2] as List).cast<String>(),
      itinerarySteps: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ItineraryModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrls)
      ..writeByte(3)
      ..write(obj.itinerarySteps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItineraryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
