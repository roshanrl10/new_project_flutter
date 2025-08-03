import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_flutter/features/weather/domain/entity/weather_entity.dart';
import 'package:new_project_flutter/features/weather/presentation/view_model/weather_bloc.dart';
import 'package:new_project_flutter/features/weather/presentation/view_model/weather_event.dart';
// import 'package:new_project_flutter/features/weather/presentation/view_model/weather_state.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = 'All Locations';
  List<WeatherData> _weatherData = [];
  List<WeatherData> _filteredWeatherData = [];

  @override
  void initState() {
    super.initState();
    _initializeMockData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherBloc>().add(GetWeatherForLocation(_selectedLocation));
    });
  }

  void _initializeMockData() {
    _weatherData = [
      WeatherData(
        id: "W001",
        location: "Everest Base Camp",
        temperature: "-5°C",
        condition: "Cloudy",
        windSpeed: "15 km/h",
        visibility: "Good (8km)",
        humidity: "65%",
        uvIndex: "3",
        sunrise: "06:45",
        sunset: "18:30",
        recommendation: "Good for trekking with proper gear",
        forecast: [
          ForecastDay("Today", "-2°C", "-8°C", "Cloudy"),
          ForecastDay("Tomorrow", "1°C", "-5°C", "Partly Cloudy"),
          ForecastDay("Day 3", "-1°C", "-7°C", "Snow"),
          ForecastDay("Day 4", "3°C", "-3°C", "Sunny"),
          ForecastDay("Day 5", "2°C", "-4°C", "Cloudy"),
        ],
      ),
      WeatherData(
        id: "W002",
        location: "Annapurna Circuit",
        temperature: "8°C",
        condition: "Sunny",
        windSpeed: "8 km/h",
        visibility: "Excellent (15km)",
        humidity: "45%",
        uvIndex: "6",
        sunrise: "06:20",
        sunset: "18:45",
        recommendation: "Perfect conditions for trekking",
        forecast: [
          ForecastDay("Today", "12°C", "4°C", "Sunny"),
          ForecastDay("Tomorrow", "14°C", "6°C", "Sunny"),
          ForecastDay("Day 3", "10°C", "3°C", "Partly Cloudy"),
          ForecastDay("Day 4", "8°C", "1°C", "Cloudy"),
          ForecastDay("Day 5", "11°C", "5°C", "Sunny"),
        ],
      ),
      WeatherData(
        id: "W003",
        location: "Langtang Valley",
        temperature: "2°C",
        condition: "Light Rain",
        windSpeed: "12 km/h",
        visibility: "Moderate (5km)",
        humidity: "85%",
        uvIndex: "2",
        sunrise: "06:35",
        sunset: "18:25",
        recommendation: "Consider postponing trek",
        forecast: [
          ForecastDay("Today", "5°C", "-1°C", "Rain"),
          ForecastDay("Tomorrow", "3°C", "-2°C", "Rain"),
          ForecastDay("Day 3", "7°C", "1°C", "Cloudy"),
          ForecastDay("Day 4", "9°C", "3°C", "Partly Cloudy"),
          ForecastDay("Day 5", "11°C", "5°C", "Sunny"),
        ],
      ),
      WeatherData(
        id: "W004",
        location: "Manaslu Circuit",
        temperature: "6°C",
        condition: "Partly Cloudy",
        windSpeed: "10 km/h",
        visibility: "Good (10km)",
        humidity: "55%",
        uvIndex: "4",
        sunrise: "06:25",
        sunset: "18:35",
        recommendation: "Good conditions for experienced trekkers",
        forecast: [
          ForecastDay("Today", "9°C", "2°C", "Partly Cloudy"),
          ForecastDay("Tomorrow", "7°C", "1°C", "Cloudy"),
          ForecastDay("Day 3", "11°C", "4°C", "Sunny"),
          ForecastDay("Day 4", "8°C", "2°C", "Partly Cloudy"),
          ForecastDay("Day 5", "6°C", "0°C", "Cloudy"),
        ],
      ),
    ];
    _filteredWeatherData = _weatherData;
  }

  void _searchWeather() {
    if (_searchController.text.trim().isEmpty) {
      setState(() {
        _filteredWeatherData = _weatherData;
      });
    } else {
      setState(() {
        _filteredWeatherData =
            _weatherData
                .where(
                  (weather) => weather.location.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  ),
                )
                .toList();
      });
    }
  }

  Color _getRecommendationColor(String recommendation) {
    if (recommendation.contains("Perfect")) return Colors.green;
    if (recommendation.contains("Good")) return Colors.blue;
    return Colors.orange;
  }

  Color _getRecommendationBg(String recommendation) {
    if (recommendation.contains("Perfect")) return Colors.green.shade50;
    if (recommendation.contains("Good")) return Colors.blue.shade50;
    return Colors.orange.shade50;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Forecast"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by location (e.g., Everest, Annapurna)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _searchWeather();
                      },
                    ),
                  ),
                  onChanged: (value) => _searchWeather(),
                ),
                const SizedBox(height: 12),

                // Quick Location Buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        [
                              'All Locations',
                              'Everest Base Camp',
                              'Annapurna Circuit',
                              'Langtang Valley',
                              'Manaslu Circuit',
                            ]
                            .map(
                              (location) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedLocation = location;
                                    });
                                    if (location != 'All Locations') {
                                      _searchController.text = location;
                                      _searchWeather();
                                    } else {
                                      _searchController.clear();
                                      _searchWeather();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        _selectedLocation == location
                                            ? Colors.orange
                                            : Colors.white,
                                    foregroundColor:
                                        _selectedLocation == location
                                            ? Colors.white
                                            : Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(location),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),

          // Weather Content
          Expanded(
            child:
                _filteredWeatherData.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.cloud_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "No weather data found for this location.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _selectedLocation = 'All Locations';
                                _filteredWeatherData = _weatherData;
                              });
                            },
                            child: const Text('Show All Locations'),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _filteredWeatherData.length,
                      itemBuilder: (context, index) {
                        final weather = _filteredWeatherData[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            weather.location,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Current weather conditions',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getRecommendationBg(
                                          weather.recommendation,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        weather.recommendation,
                                        style: TextStyle(
                                          color: _getRecommendationColor(
                                            weather.recommendation,
                                          ),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Current Weather
                                Row(
                                  children: [
                                    // Weather Icon and Temperature
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Icon(
                                            _getWeatherIcon(weather.condition),
                                            size: 64,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            weather.temperature,
                                            style: const TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            weather.condition,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Weather Details
                                    Expanded(
                                      child: Column(
                                        children: [
                                          _buildWeatherDetail(
                                            Icons.air,
                                            'Wind',
                                            weather.windSpeed,
                                          ),
                                          const SizedBox(height: 8),
                                          _buildWeatherDetail(
                                            Icons.visibility,
                                            'Visibility',
                                            weather.visibility,
                                          ),
                                          const SizedBox(height: 8),
                                          _buildWeatherDetail(
                                            Icons.water_drop,
                                            'Humidity',
                                            weather.humidity,
                                          ),
                                          const SizedBox(height: 8),
                                          _buildWeatherDetail(
                                            Icons.wb_sunny,
                                            'UV Index',
                                            weather.uvIndex,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // 5-Day Forecast
                                const Text(
                                  '5-Day Forecast',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...weather.forecast.map(
                                  (day) => Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              _getWeatherIcon(day.condition),
                                              size: 24,
                                              color: Colors.blue,
                                            ),
                                            const SizedBox(width: 12),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  day.day,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  day.condition,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              day.high,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              day.low,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Sun Times
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.wb_sunny,
                                            color: Colors.orange,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Sunrise: ${weather.sunrise}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.wb_sunny,
                                            color: Colors.orange,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Sunset: ${weather.sunset}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'partly cloudy':
        return Icons.cloud;
      case 'rain':
      case 'light rain':
        return Icons.grain;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.cloud;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class WeatherData {
  final String id;
  final String location;
  final String temperature;
  final String condition;
  final String windSpeed;
  final String visibility;
  final String humidity;
  final String uvIndex;
  final String sunrise;
  final String sunset;
  final String recommendation;
  final List<ForecastDay> forecast;

  WeatherData({
    required this.id,
    required this.location,
    required this.temperature,
    required this.condition,
    required this.windSpeed,
    required this.visibility,
    required this.humidity,
    required this.uvIndex,
    required this.sunrise,
    required this.sunset,
    required this.recommendation,
    required this.forecast,
  });
}

class ForecastDay {
  final String day;
  final String high;
  final String low;
  final String condition;

  ForecastDay(this.day, this.high, this.low, this.condition);
}
