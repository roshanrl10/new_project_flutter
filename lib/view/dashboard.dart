// import 'package:flutter/material.dart';

// Dummy pages (replace with your actual pages)
import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Explore Page')));
}

class SavedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Saved Page')));
}

class UpdatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Updates Page')));
}

class HotelBookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Hotel Booking')));
}

class AgencyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Agency')));
}

class EquipmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Equipments')));
}

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Weather')));
}

class TrekkingSpotsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Trekking Spots')));
}

class ItineraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Itinerary')));
}

// Main Dashboard with navigation
class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [ExplorePage(), SavedPage(), UpdatesPage()];

  void _onGridItemTap(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFF2E9F7),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.update), label: 'Updates'),
        ],
      ),
      body:
          _currentIndex == 0
              ? SafeArea(
                child: Column(
                  children: [
                    Container(
                      color: Color(0xFFD6C8D6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'T-REK',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          Icon(Icons.account_circle, size: 30),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                        padding: const EdgeInsets.all(20),
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        children: [
                          _buildGridItem(
                            Icons.hotel,
                            'hotel booking',
                            HotelBookingPage(),
                          ),
                          _buildGridItem(
                            Icons.apartment,
                            'agency',
                            AgencyPage(),
                          ),
                          _buildGridItem(
                            Icons.build,
                            'equipments',
                            EquipmentsPage(),
                          ),
                          _buildGridItem(
                            Icons.wb_sunny,
                            'weather',
                            WeatherPage(),
                          ),
                          _buildGridItem(
                            Icons.hiking,
                            'trekking spots',
                            TrekkingSpotsPage(),
                          ),
                          _buildGridItem(
                            Icons.list_alt,
                            'itinerary',
                            ItineraryPage(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              : _pages[_currentIndex],
    );
  }

  Widget _buildGridItem(IconData iconData, String label, Widget page) {
    return InkWell(
      onTap: () => _onGridItemTap(page),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFEDE7F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 60, color: Colors.black),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
