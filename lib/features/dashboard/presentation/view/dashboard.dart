import 'package:flutter/material.dart';
import 'package:new_project_flutter/app/service_locator/notification_service.dart';
import 'package:new_project_flutter/app/widgets/notification_widget.dart';
import 'package:new_project_flutter/features/agency/presentation/view/agency_page.dart';
import 'package:new_project_flutter/features/dashboard/presentation/view/dashboard_grid_item.dart';
import 'package:new_project_flutter/features/dashboard/presentation/view/saved_bookings_page.dart';
import 'package:new_project_flutter/features/equipments/presentation/view/equipments_page.dart';
import 'package:new_project_flutter/features/hotelBooking/presentation/view/hotel_booking_page.dart';
import 'package:new_project_flutter/features/itenerary/presentation/view/itinerary_page.dart';
import 'package:new_project_flutter/features/trekkingSpots/presentation/view/trekking_spots_page.dart';

import 'package:new_project_flutter/features/weather/presentation/view/weather_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  final List<Widget> _bottomPages = [
    const Center(child: Text('Explore')), // Placeholder
    const SavedBookingsPage(), // Updated to use SavedBookingsPage
    const NotificationWidget(), // Notifications page
  ];

  void _handleProfileMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'profile':
        _showEditProfileDialog(context);
        break;
      case 'logout':
        _showLogoutDialog(context);
        break;
    }
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: const Text(
            'Edit profile functionality will be implemented here.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement edit profile functionality
                NotificationService().showInfo(
                  'Edit Profile',
                  'Edit profile feature coming soon!',
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _performLogout(BuildContext context) {
    // TODO: Implement actual logout logic with AuthBloc
    // For now, just show notification and navigate to login
    NotificationService().showInfo(
      'Logout Successful',
      'You have been logged out successfully.',
    );

    // Navigate to login page
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF2E9F7),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
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
                      color: const Color(0xFFD6C8D6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'T-REK',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.account_circle, size: 30),
                            onSelected: (value) {
                              _handleProfileMenuSelection(context, value);
                            },
                            itemBuilder:
                                (BuildContext context) => [
                                  const PopupMenuItem<String>(
                                    value: 'profile',
                                    child: Row(
                                      children: [
                                        Icon(Icons.person, color: Colors.grey),
                                        SizedBox(width: 8),
                                        Text('Edit Profile'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'logout',
                                    child: Row(
                                      children: [
                                        Icon(Icons.logout, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text(
                                          'Logout',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                          ),
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
                          const DashboardGridItem(
                            iconData: Icons.hotel,
                            label: 'hotel booking',
                            page: HotelBookingPage(),
                          ),
                          const DashboardGridItem(
                            iconData: Icons.apartment,
                            label: 'agency',
                            page: AgencyPage(),
                          ),
                          const DashboardGridItem(
                            iconData: Icons.build,
                            label: 'equipments',
                            page: EquipmentsPage(),
                          ),
                          const DashboardGridItem(
                            iconData: Icons.wb_sunny,
                            label: 'weather',
                            page: WeatherPage(),
                          ),
                          const DashboardGridItem(
                            iconData: Icons.hiking,
                            label: 'trekking spots',
                            page: MapPage(),
                          ),
                          const DashboardGridItem(
                            iconData: Icons.list_alt,
                            label: 'itinerary',
                            page: ItineraryPage(),
                          ),
                          // Test notification button
                          GestureDetector(
                            onTap: () {
                              NotificationService().showInfo(
                                'Test Notification',
                                'This is a test notification to demonstrate the notification system!',
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue.shade300),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.notifications,
                                    size: 40,
                                    color: Colors.blue.shade700,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Test\nNotification',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              : _bottomPages[_currentIndex],
    );
  }
}
