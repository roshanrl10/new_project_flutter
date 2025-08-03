import '../../domain/entity/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  WeatherModel({
    required super.temperature,
    required super.condition,
    required super.iconCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['temperature'] as num).toDouble(),
      condition: json['condition'] ?? '',
      iconCode: json['iconCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'condition': condition,
      'iconCode': iconCode,
    };
  }

  WeatherEntity toEntity() {
    return WeatherEntity(
      temperature: temperature,
      condition: condition,
      iconCode: iconCode,
    );
  }

  factory WeatherModel.fromEntity(WeatherEntity entity) {
    return WeatherModel(
      temperature: entity.temperature,
      condition: entity.condition,
      iconCode: entity.iconCode,
    );
  }
}
