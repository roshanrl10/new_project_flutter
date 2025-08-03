import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_project_flutter/features/trekkingSpots/presentation/view_model/map_bloc.dart';
import 'package:new_project_flutter/features/trekkingSpots/presentation/view_model/map_event.dart';
import 'package:new_project_flutter/features/trekkingSpots/presentation/view_model/map_state.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedDifficulty = 'All Difficulties';
  String _selectedRegion = 'All Regions';
  List<TrekkingRoute> _routes = [];
  List<TrekkingRoute> _filteredRoutes = [];
  TrekkingRoute? _selectedRoute;

  @override
  void initState() {
    super.initState();
    _initializeMockData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapBloc>().add(LoadMapPlaces());
    });
  }

  void _initializeMockData() {
    _routes = [
      TrekkingRoute(
        id: "TR001",
        name: "Everest Base Camp Trek",
        difficulty: "Hard",
        duration: "14 days",
        distance: "130 km",
        elevation: "5,364m",
        description:
            "The classic trek to Everest Base Camp, offering stunning views of the world's highest peak and surrounding mountains.",
        coordinates: [86.8523, 27.9881],
        waypoints: [
          Waypoint("Lukla", [86.7311, 27.6869]),
          Waypoint("Namche Bazaar", [86.7131, 27.8067]),
          Waypoint("Tengboche", [86.7644, 27.8368]),
          Waypoint("Dingboche", [86.8306, 27.8925]),
          Waypoint("Lobuche", [86.8089, 27.9519]),
          Waypoint("Everest Base Camp", [86.8523, 27.9881]),
        ],
        isBookmarked: false,
        status: "active",
      ),
      TrekkingRoute(
        id: "TR002",
        name: "Annapurna Circuit",
        difficulty: "Moderate",
        duration: "21 days",
        distance: "230 km",
        elevation: "5,416m",
        description:
            "A complete circuit around the Annapurna massif, showcasing diverse landscapes and cultures.",
        coordinates: [83.9294, 28.5967],
        waypoints: [
          Waypoint("Besisahar", [84.4239, 28.2306]),
          Waypoint("Manang", [84.0169, 28.6667]),
          Waypoint("Thorong La Pass", [83.9294, 28.5967]),
          Waypoint("Muktinath", [83.8697, 28.8117]),
          Waypoint("Jomsom", [83.7231, 28.7806]),
          Waypoint("Pokhara", [83.9856, 28.2096]),
        ],
        isBookmarked: true,
        status: "active",
      ),
      TrekkingRoute(
        id: "TR003",
        name: "Langtang Valley Trek",
        difficulty: "Easy",
        duration: "7 days",
        distance: "65 km",
        elevation: "3,870m",
        description:
            "A beautiful valley trek close to Kathmandu, known for its scenic beauty and cultural richness.",
        coordinates: [85.5500, 28.2167],
        waypoints: [
          Waypoint("Syabrubesi", [85.3722, 28.1606]),
          Waypoint("Langtang Village", [85.5333, 28.2167]),
          Waypoint("Kyanjin Gompa", [85.5500, 28.2167]),
        ],
        isBookmarked: false,
        status: "active",
      ),
      TrekkingRoute(
        id: "TR004",
        name: "Manaslu Circuit Trek",
        difficulty: "Hard",
        duration: "18 days",
        distance: "177 km",
        elevation: "5,106m",
        description:
            "A remote and challenging trek around the eighth highest mountain in the world.",
        coordinates: [84.5597, 28.5500],
        waypoints: [
          Waypoint("Soti Khola", [84.9667, 28.2333]),
          Waypoint("Samagaon", [84.6167, 28.6500]),
          Waypoint("Larkya La Pass", [84.5597, 28.5500]),
          Waypoint("Bimthang", [84.5167, 28.5167]),
        ],
        isBookmarked: false,
        status: "active",
      ),
    ];
    _filteredRoutes = _routes;
  }

  void _searchRoutes() {
    if (_searchController.text.trim().isEmpty) {
      setState(() {
        _filteredRoutes = _routes;
      });
    } else {
      setState(() {
        _filteredRoutes =
            _routes
                .where(
                  (route) =>
                      route.name.toLowerCase().contains(
                        _searchController.text.toLowerCase(),
                      ) ||
                      route.difficulty.toLowerCase().contains(
                        _searchController.text.toLowerCase(),
                      ),
                )
                .toList();
      });
    }
  }

  void _filterByDifficulty(String difficulty) {
    setState(() {
      _selectedDifficulty = difficulty;
      _applyFilters();
    });
  }

  void _filterByRegion(String region) {
    setState(() {
      _selectedRegion = region;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<TrekkingRoute> filtered = _routes;

    // Apply difficulty filter
    if (_selectedDifficulty != 'All Difficulties') {
      filtered =
          filtered
              .where((route) => route.difficulty == _selectedDifficulty)
              .toList();
    }

    // Apply region filter
    if (_selectedRegion != 'All Regions') {
      filtered =
          filtered
              .where((route) => _getRouteRegion(route) == _selectedRegion)
              .toList();
    }

    // Apply search filter
    if (_searchController.text.trim().isNotEmpty) {
      filtered =
          filtered
              .where(
                (route) =>
                    route.name.toLowerCase().contains(
                      _searchController.text.toLowerCase(),
                    ) ||
                    route.difficulty.toLowerCase().contains(
                      _searchController.text.toLowerCase(),
                    ),
              )
              .toList();
    }

    setState(() {
      _filteredRoutes = filtered;
    });
  }

  String _getRouteRegion(TrekkingRoute route) {
    if (route.name.contains("Everest")) return "Everest Region";
    if (route.name.contains("Annapurna")) return "Annapurna Region";
    if (route.name.contains("Langtang")) return "Langtang Region";
    if (route.name.contains("Manaslu")) return "Manaslu Region";
    return "Other Regions";
  }

  void _handleRouteSelect(TrekkingRoute route) {
    setState(() {
      _selectedRoute = route;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing ${route.name} on the map'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleBookmark(TrekkingRoute route) {
    setState(() {
      final index = _routes.indexWhere((r) => r.id == route.id);
      if (index != -1) {
        _routes[index] = _routes[index].copyWith(
          isBookmarked: !_routes[index].isBookmarked,
        );
        _applyFilters();
      }
    });

    final updatedRoute = _routes.firstWhere((r) => r.id == route.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updatedRoute.isBookmarked
              ? '${route.name} added to bookmarks'
              : '${route.name} removed from bookmarks',
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case "Easy":
        return Colors.green;
      case "Moderate":
        return Colors.orange;
      case "Hard":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  double _getDifficultyHue(String difficulty) {
    switch (difficulty) {
      case "Easy":
        return BitmapDescriptor.hueGreen;
      case "Moderate":
        return BitmapDescriptor.hueOrange;
      case "Hard":
        return BitmapDescriptor.hueRed;
      default:
        return BitmapDescriptor.hueAzure;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trekking Maps & Routes"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search and Filter Section
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
                    labelText: 'Search by route name or difficulty',
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
                        _searchRoutes();
                      },
                    ),
                  ),
                  onChanged: (value) => _searchRoutes(),
                ),
                const SizedBox(height: 12),

                // Filter Row
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedDifficulty,
                        decoration: InputDecoration(
                          labelText: 'Difficulty',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items:
                            [
                              'All Difficulties',
                              'Easy',
                              'Moderate',
                              'Hard',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            _filterByDifficulty(newValue);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedRegion,
                        decoration: InputDecoration(
                          labelText: 'Region',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items:
                            [
                              'All Regions',
                              'Everest Region',
                              'Annapurna Region',
                              'Langtang Region',
                              'Manaslu Region',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            _filterByRegion(newValue);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Row(
              children: [
                // Routes List
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Routes (${_filteredRoutes.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child:
                              _filteredRoutes.isEmpty
                                  ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.map_outlined,
                                          size: 64,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'No routes found matching your criteria.',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {
                                              _selectedDifficulty =
                                                  'All Difficulties';
                                              _selectedRegion = 'All Regions';
                                              _filteredRoutes = _routes;
                                            });
                                          },
                                          child: const Text('Show All Routes'),
                                        ),
                                      ],
                                    ),
                                  )
                                  : ListView.builder(
                                    itemCount: _filteredRoutes.length,
                                    itemBuilder: (context, index) {
                                      final route = _filteredRoutes[index];
                                      return Card(
                                        margin: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          side:
                                              _selectedRoute?.id == route.id
                                                  ? BorderSide(
                                                    color: Colors.orange,
                                                    width: 2,
                                                  )
                                                  : BorderSide.none,
                                        ),
                                        child: InkWell(
                                          onTap:
                                              () => _handleRouteSelect(route),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        route.name,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.star,
                                                        color:
                                                            route.isBookmarked
                                                                ? Colors.yellow
                                                                : Colors.grey,
                                                        size: 20,
                                                      ),
                                                      onPressed:
                                                          () => _handleBookmark(
                                                            route,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: _getDifficultyColor(
                                                      route.difficulty,
                                                    ).withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    route.difficulty,
                                                    style: TextStyle(
                                                      color:
                                                          _getDifficultyColor(
                                                            route.difficulty,
                                                          ),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.schedule,
                                                      size: 14,
                                                      color: Colors.grey[600],
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      route.duration,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Icon(
                                                      Icons.place,
                                                      size: 14,
                                                      color: Colors.grey[600],
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      route.distance,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Icon(
                                                      Icons.trending_up,
                                                      size: 14,
                                                      color: Colors.grey[600],
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      'Max: ${route.elevation}',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Map and Route Details
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Map
                        Expanded(
                          flex: 1,
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(27.7172, 85.3240), // Kathmandu
                                  zoom: 8,
                                ),
                                markers:
                                    _filteredRoutes
                                        .map(
                                          (route) => Marker(
                                            markerId: MarkerId(route.id),
                                            position: LatLng(
                                              route.coordinates[1],
                                              route.coordinates[0],
                                            ),
                                            infoWindow: InfoWindow(
                                              title: route.name,
                                              snippet:
                                                  '${route.difficulty} • ${route.elevation}',
                                            ),
                                            icon:
                                                BitmapDescriptor.defaultMarkerWithHue(
                                                  _getDifficultyHue(
                                                    route.difficulty,
                                                  ),
                                                ),
                                          ),
                                        )
                                        .toSet(),
                                onTap: (LatLng position) {
                                  // Handle map tap
                                },
                              ),
                            ),
                          ),
                        ),

                        // Route Details
                        if (_selectedRoute != null) ...[
                          const SizedBox(height: 16),
                          Expanded(
                            flex: 1,
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedRoute!.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Detailed route information',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildRouteStat(
                                            'Duration',
                                            _selectedRoute!.duration,
                                          ),
                                        ),
                                        Expanded(
                                          child: _buildRouteStat(
                                            'Distance',
                                            _selectedRoute!.distance,
                                          ),
                                        ),
                                        Expanded(
                                          child: _buildRouteStat(
                                            'Max Elevation',
                                            _selectedRoute!.elevation,
                                          ),
                                        ),
                                        Expanded(
                                          child: _buildRouteStat(
                                            'Difficulty',
                                            _selectedRoute!.difficulty,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _selectedRoute!.description,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Key Waypoints',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount:
                                            _selectedRoute!.waypoints.length,
                                        itemBuilder: (context, index) {
                                          final waypoint =
                                              _selectedRoute!.waypoints[index];
                                          return Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 4,
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '${index + 1}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    waypoint.name,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '${waypoint.coordinates[1].toStringAsFixed(4)}, ${waypoint.coordinates[0].toStringAsFixed(4)}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // TODO: Implement planning functionality
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text(
                                              'Start Planning Trek',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // TODO: Implement GPS download
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.orange,
                                              side: const BorderSide(
                                                color: Colors.orange,
                                              ),
                                            ),
                                            child: const Text(
                                              'Download GPS Data',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class TrekkingRoute {
  final String id;
  final String name;
  final String difficulty;
  final String duration;
  final String distance;
  final String elevation;
  final String description;
  final List<double> coordinates;
  final List<Waypoint> waypoints;
  final bool isBookmarked;
  final String status;

  TrekkingRoute({
    required this.id,
    required this.name,
    required this.difficulty,
    required this.duration,
    required this.distance,
    required this.elevation,
    required this.description,
    required this.coordinates,
    required this.waypoints,
    required this.isBookmarked,
    required this.status,
  });

  TrekkingRoute copyWith({
    String? id,
    String? name,
    String? difficulty,
    String? duration,
    String? distance,
    String? elevation,
    String? description,
    List<double>? coordinates,
    List<Waypoint>? waypoints,
    bool? isBookmarked,
    String? status,
  }) {
    return TrekkingRoute(
      id: id ?? this.id,
      name: name ?? this.name,
      difficulty: difficulty ?? this.difficulty,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      elevation: elevation ?? this.elevation,
      description: description ?? this.description,
      coordinates: coordinates ?? this.coordinates,
      waypoints: waypoints ?? this.waypoints,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      status: status ?? this.status,
    );
  }
}

class Waypoint {
  final String name;
  final List<double> coordinates;

  Waypoint(this.name, this.coordinates);
}
