import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFF2E9F7),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.update), label: 'Updates'),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Color(0xFFD6C8D6),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  _buildGridItem(Icons.hotel, 'hotel booking'),
                  _buildGridItem(Icons.apartment, 'agency'),
                  _buildGridItem(Icons.build, 'equipments'),
                  _buildGridItem(Icons.wb_sunny, 'weather'),
                  _buildGridItem(Icons.hiking, 'trekking spots'),
                  _buildGridItem(Icons.list_alt, 'itinerary'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(IconData iconData, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData, size: 60, color: Colors.black),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
