import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_flutter/app/service_locator/notification_service.dart';
import 'package:new_project_flutter/features/hotelBooking/presentation/view_model/hotel_booking_bloc.dart';
import 'package:new_project_flutter/features/hotelBooking/presentation/view_model/hotel_booking_state.dart';
import 'package:new_project_flutter/features/hotelBooking/presentation/view_model/hotel_booking_event.dart';
import 'package:new_project_flutter/features/equipments/presentation/view_model/equipment_bloc.dart';
import 'package:new_project_flutter/features/equipments/presentation/view_model/equipment_state.dart';
import 'package:new_project_flutter/features/equipments/presentation/view_model/equipment_event.dart';
import 'package:new_project_flutter/features/agency/presentation/view_model/agency_bloc.dart';
import 'package:new_project_flutter/features/agency/presentation/view_model/agency_state.dart';
import 'package:new_project_flutter/features/agency/presentation/view_model/agency_event.dart';
import 'package:new_project_flutter/features/hotelBooking/domain/entity/booking_entity.dart';
import 'package:new_project_flutter/features/equipments/domain/entity/equipment_rental_entity.dart';
// import 'package:new_project_flutter/features/agency/domain/entity/agency_entity.dart';
import 'package:new_project_flutter/features/agency/domain/entity/agency_booking_entity.dart';
// import 'package:new_project_flutter/features/auth/domain/repository/auth_repository.dart';

class SavedBookingsPage extends StatefulWidget {
  const SavedBookingsPage({super.key});

  @override
  State<SavedBookingsPage> createState() => _SavedBookingsPageState();
}

class _SavedBookingsPageState extends State<SavedBookingsPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  int _currentTabIndex = 0;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });

    // Get current user ID and load bookings
    _initializeBookings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh bookings when page is focused
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentUserId != null) {
        print('🔄 Refreshing bookings on page focus...');
        _loadLocalBookings();
        // Force a rebuild to ensure UI updates
        setState(() {});
      }
    });
  }

  // Add this method to handle navigation to this page
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print('🔄 App resumed - refreshing bookings...');
      if (_currentUserId != null) {
        _loadLocalBookings();
      }
    }
  }

  // Add this method to handle when page becomes visible
  void _onPageVisible() {
    print('🔄 Page became visible - refreshing bookings...');
    if (_currentUserId != null) {
      _loadLocalBookings();
    }
  }

  Future<void> _initializeBookings() async {
    try {
      // Use hardcoded user ID for testing
      const hardcodedUserId = '688339f4171a690ae2d5d852';

      setState(() {
        _currentUserId = hardcodedUserId;
      });

      // Load initial data from local state (no backend calls)
      print('🔄 Loading initial data from local state...');
      _loadLocalBookings();

      // TODO: Uncomment this when auth is working properly
      /*
      final authRepository = context.read<AuthRepository>();
      final currentUser = await authRepository.getCurrentUser();
      if (currentUser != null) {
        setState(() {
          _currentUserId = currentUser.id;
        });
        _loadLocalBookings();
      } else {
        // Show error or redirect to login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to view your bookings'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      }
      */
    } catch (e) {
      print('Error getting current user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading bookings: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _loadLocalBookings() {
    print('🔄 Loading data from local state (no backend calls)...');

    // Force a rebuild to show current local state
    setState(() {
      // This will trigger the BlocBuilder widgets to rebuild with current state
    });

    // Also trigger a manual refresh of the BLoCs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🔄 Triggering manual refresh of BLoCs...');
      print('🔄 Fetching hotel bookings for user: ${_currentUserId ?? ''}');
      context.read<HotelBookingBloc>().add(
        FetchUserBookings(_currentUserId ?? ''),
      );
      print('🔄 Fetching equipment rentals for user: ${_currentUserId ?? ''}');
      context.read<EquipmentBloc>().add(
        FetchUserEquipmentRentals(_currentUserId ?? ''),
      );
      print('🔄 Fetching agency bookings for user: ${_currentUserId ?? ''}');
      context.read<AgencyBloc>().add(
        FetchUserAgencyBookings(_currentUserId ?? ''),
      );
    });
  }

  void _loadBookings() {
    print('🔄 Refreshing local bookings data...');

    // Just trigger a rebuild to show current local state
    setState(() {
      // This will trigger the BlocBuilder widgets to rebuild with current state
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD6C8D6),
        elevation: 0,
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              print('🔄 Manual refresh triggered');
              _loadLocalBookings();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: const Color(0xFFF2E9F7),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              onTap: (index) {
                setState(() {
                  _currentTabIndex = index;
                });
                _loadBookings();
              },
              tabs: const [
                Tab(icon: Icon(Icons.hotel), text: 'Hotel Bookings'),
                Tab(icon: Icon(Icons.build), text: 'Equipment Rentals'),
                Tab(icon: Icon(Icons.apartment), text: 'Agency Bookings'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHotelBookingsTab(),
                _buildEquipmentRentalsTab(),
                _buildAgencyBookingsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelBookingsTab() {
    return BlocListener<HotelBookingBloc, HotelBookingState>(
      listener: (context, state) {
        if (state is HotelBookingSuccess) {
          // Show success notification
          NotificationService().showBookingCancelled('Hotel');
          // Refresh bookings after cancellation
          _loadBookings();
        } else if (state is HotelBookingLoaded) {
          // Handle when bookings are loaded (including after refresh)
          print('🔄 HotelBookingLoaded received - bookings refreshed');
          print('🔄 Found ${state.bookings.length} total bookings');
          final confirmedBookings =
              state.bookings.where((b) => b.status == 'confirmed').toList();
          print('🔄 Found ${confirmedBookings.length} confirmed bookings');

          // Don't call setState here - let BlocBuilder handle the rebuild naturally
          print('🔄 Letting BlocBuilder handle the UI update naturally');
        } else if (state is HotelBookingError) {
          // Show error notification
          NotificationService().showError('Cancellation Failed', state.message);
        }
      },
      child: BlocBuilder<HotelBookingBloc, HotelBookingState>(
        builder: (context, state) {
          print('🏨 Hotel bookings state: ${state.runtimeType}');
          print('🏨 State details: $state');
          print('🏨 Current user ID: $_currentUserId');

          if (state is HotelBookingLoading) {
            print('🏨 Loading hotel bookings...');
            return const Center(child: CircularProgressIndicator());
          } else if (state is HotelBookingLoaded) {
            print(
              '🏨 Hotel bookings loaded: ${state.bookings.length} bookings',
            );
            print(
              '🏨 All bookings: ${state.bookings.map((b) => '${b.hotelName} (${b.status})').toList()}',
            );
            final bookings =
                state.bookings.where((b) => b.status == 'confirmed').toList();
            print('🏨 Confirmed bookings: ${bookings.length}');

            // Show notification if bookings are loaded successfully
            if (bookings.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                NotificationService().showInfo(
                  'Bookings Loaded',
                  'Found ${bookings.length} confirmed hotel bookings.',
                );
              });
            }

            if (bookings.isEmpty) {
              print('🏨 No confirmed bookings found');
              return _buildEmptyState(
                icon: Icons.hotel,
                message: 'You haven\'t made any hotel bookings yet.',
                actionText: 'Book Hotels',
                onAction: () => Navigator.pushNamed(context, '/hotel-booking'),
              );
            }

            print('🏨 Building ${bookings.length} booking cards');
            return RefreshIndicator(
              onRefresh: () async {
                print('🔄 Pull to refresh triggered');
                _loadBookings();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  print('🏨 Building card for booking: ${booking.hotelName}');
                  return _buildHotelBookingCard(booking);
                },
              ),
            );
          } else if (state is HotelBookingError) {
            print('🏨 Hotel bookings error: ${state.message}');
            return Center(child: Text('Error: ${state.message}'));
          }

          print('🏨 Default state - no bookings found');
          return const Center(child: Text('No bookings found'));
        },
      ),
    );
  }

  Widget _buildEquipmentRentalsTab() {
    return BlocListener<EquipmentBloc, EquipmentState>(
      listener: (context, state) {
        if (state is EquipmentRentalSuccess) {
          // Show success notification
          NotificationService().showBookingCancelled('Equipment');
          // Refresh rentals after cancellation
          _loadBookings();
        } else if (state is EquipmentRentalLoaded) {
          // Handle when equipment rentals are loaded (including after refresh)
          print('🔄 EquipmentRentalLoaded received - rentals refreshed');
          print('🔄 Found ${state.equipmentRentals.length} total rentals');
          final confirmedRentals =
              state.equipmentRentals
                  .where((r) => r.status == 'confirmed')
                  .toList();
          print('🔄 Found ${confirmedRentals.length} confirmed rentals');

          // Don't call setState here - let BlocBuilder handle the rebuild naturally
          print('🔄 Letting BlocBuilder handle the UI update naturally');
        } else if (state is EquipmentRentalError) {
          // Show error notification
          NotificationService().showError('Cancellation Failed', state.message);
        }
      },
      child: BlocBuilder<EquipmentBloc, EquipmentState>(
        builder: (context, state) {
          print('🔧 Equipment rentals state: ${state.runtimeType}');
          print('🔧 State details: $state');
          print('🔧 Current user ID: $_currentUserId');

          if (state is EquipmentRentalLoading) {
            print('🔧 Loading equipment rentals...');
            return const Center(child: CircularProgressIndicator());
          } else if (state is EquipmentRentalLoaded) {
            print('🔧 EquipmentRentalLoaded state received');
            print(
              '🔧 Equipment rentals loaded: ${state.equipmentRentals.length} rentals',
            );
            print(
              '🔧 All rentals: ${state.equipmentRentals.map((r) => '${r.equipmentName} (${r.status})').toList()}',
            );

            // Debug each rental
            for (int i = 0; i < state.equipmentRentals.length; i++) {
              final rental = state.equipmentRentals[i];
              print('🔧 Rental $i:');
              print('  - ID: ${rental.id}');
              print('  - Equipment Name: ${rental.equipmentName}');
              print('  - Status: ${rental.status}');
              print('  - Total Price: ${rental.totalPrice}');
              print('  - Quantity: ${rental.quantity}');
              print('  - User ID: ${rental.userId}');
            }

            final rentals =
                state.equipmentRentals
                    .where((r) => r.status == 'confirmed')
                    .toList();
            print('🔧 Confirmed rentals: ${rentals.length}');

            if (rentals.isEmpty) {
              print('🔧 No confirmed rentals found');
              return _buildEmptyState(
                icon: Icons.build,
                message: 'You haven\'t rented any equipment yet.',
                actionText: 'Rent Equipment',
                onAction: () => Navigator.pushNamed(context, '/equipment'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                print('🔄 Pull to refresh triggered for equipment rentals');
                _loadBookings();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rentals.length,
                itemBuilder: (context, index) {
                  final rental = rentals[index];
                  return _buildEquipmentRentalCard(rental);
                },
              ),
            );
          } else if (state is EquipmentRentalError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const Center(child: Text('No rentals found'));
        },
      ),
    );
  }

  Widget _buildAgencyBookingsTab() {
    return BlocListener<AgencyBloc, AgencyState>(
      listener: (context, state) {
        if (state is AgencyBookingSuccess) {
          // Show success notification
          NotificationService().showBookingCancelled('Agency');
          // Refresh bookings after cancellation
          _loadBookings();
        } else if (state is AgencyBookingError) {
          // Show error notification
          NotificationService().showError('Cancellation Failed', state.message);
        }
      },
      child: BlocBuilder<AgencyBloc, AgencyState>(
        builder: (context, state) {
          print('🏢 Agency bookings state: ${state.runtimeType}');
          print('🏢 State details: $state');
          print('🏢 Current user ID: $_currentUserId');

          if (state is AgencyBookingLoading) {
            print('🏢 Loading agency bookings...');
            return const Center(child: CircularProgressIndicator());
          } else if (state is AgencyBookingLoaded) {
            print('🏢 AgencyBookingLoaded state received');
            print(
              '🏢 Agency bookings loaded: ${state.agencyBookings.length} bookings',
            );
            print(
              '🏢 All bookings: ${state.agencyBookings.map((b) => '${b.agencyName} (${b.status})').toList()}',
            );

            // Debug each booking
            for (int i = 0; i < state.agencyBookings.length; i++) {
              final booking = state.agencyBookings[i];
              print('🏢 Booking $i:');
              print('  - ID: ${booking.id}');
              print('  - Agency Name: ${booking.agencyName}');
              print('  - Status: ${booking.status}');
              print('  - Total Price: ${booking.totalPrice}');
              print('  - Number of People: ${booking.numberOfPeople}');
              print('  - User ID: ${booking.userId}');
            }
            final bookings =
                state
                    .agencyBookings; // Remove status filter since Agency doesn't have status

            if (bookings.isEmpty) {
              return _buildEmptyState(
                icon: Icons.apartment,
                message: 'You haven\'t booked any agencies yet.',
                actionText: 'Book Agencies',
                onAction: () => Navigator.pushNamed(context, '/agency'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                print('🔄 Pull to refresh triggered for agency bookings');
                _loadBookings();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return _buildAgencyBookingCard(booking);
                },
              ),
            );
          } else if (state is AgencyBookingError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const Center(child: Text('No agency bookings found'));
        },
      ),
    );
  }

  Widget _buildHotelBookingCard(Booking booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.hotel,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            booking.hotelName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(booking.status),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                Icons.calendar_today,
                'Check-in: ${_formatDate(booking.checkInDate)}',
              ),
              _buildInfoRow(
                Icons.calendar_today,
                'Check-out: ${_formatDate(booking.checkOutDate)}',
              ),
              _buildInfoRow(
                Icons.person,
                'Guests: 1', // Default to 1 guest since guests field is not available
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Price',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        '\$${booking.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  if (booking.status == 'confirmed')
                    ElevatedButton.icon(
                      onPressed:
                          () => _showCancelDialog(
                            'hotel',
                            booking.id,
                            booking.hotelName,
                          ),
                      icon: const Icon(Icons.cancel, size: 16),
                      label: const Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEquipmentRentalCard(EquipmentRental rental) {
    print('🔧 Building equipment rental card for:');
    print('  - Equipment Name: ${rental.equipmentName}');
    print('  - Status: ${rental.status}');
    print('  - Total Price: ${rental.totalPrice}');
    print('  - Quantity: ${rental.quantity}');

    // Add null safety checks
    final equipmentName =
        rental.equipmentName.isNotEmpty
            ? rental.equipmentName
            : 'Unknown Equipment';
    final status = rental.status.isNotEmpty ? rental.status : 'pending';
    final totalPrice = rental.totalPrice > 0 ? rental.totalPrice : 0.0;
    final quantity = rental.quantity > 0 ? rental.quantity : 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.build, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          equipmentName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusChip(status),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.calendar_today,
              'Start: ${_formatDate(rental.startDate)}',
            ),
            _buildInfoRow(
              Icons.calendar_today,
              'End: ${_formatDate(rental.endDate)}',
            ),
            _buildInfoRow(Icons.inventory, 'Quantity: $quantity'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                if (status == 'confirmed') ...[
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed:
                        () => _showCancelDialog(
                          'equipment',
                          rental.id,
                          rental.equipmentName,
                        ),
                    icon: const Icon(Icons.cancel, size: 16),
                    label: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgencyBookingCard(AgencyBooking booking) {
    print('🏢 Building agency booking card for:');
    print('  - Agency Name: ${booking.agencyName}');
    print('  - Status: ${booking.status}');
    print('  - Total Price: ${booking.totalPrice}');
    print('  - Number of People: ${booking.numberOfPeople}');

    // Add null safety checks
    final agencyName =
        booking.agencyName.isNotEmpty ? booking.agencyName : 'Unknown Agency';
    final status = booking.status.isNotEmpty ? booking.status : 'pending';
    final totalPrice = booking.totalPrice > 0 ? booking.totalPrice : 0.0;
    final numberOfPeople =
        booking.numberOfPeople > 0 ? booking.numberOfPeople : 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.apartment,
                        color: Colors.purple,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          agencyName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusChip(status),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.calendar_today,
              'Start: ${_formatDate(booking.startDate)}',
            ),
            _buildInfoRow(
              Icons.calendar_today,
              'End: ${_formatDate(booking.endDate)}',
            ),
            _buildInfoRow(Icons.people, 'People: $numberOfPeople'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '\$${booking.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed:
                      () => _showCancelDialog(
                        'agency',
                        booking.id,
                        booking.agencyName,
                      ),
                  icon: const Icon(Icons.cancel, size: 16),
                  label: const Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'confirmed':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Start exploring and make your first booking!',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: Icon(icon, size: 20),
              label: Text(actionText),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showCancelDialog(String type, String id, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Booking'),
          content: Text(
            'Are you sure you want to cancel your booking for "$name"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Keep Booking'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cancelBooking(type, id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cancel Booking'),
            ),
          ],
        );
      },
    );
  }

  void _cancelBooking(String type, String id) {
    print('🔍 Cancelling $type booking with ID: $id');

    switch (type) {
      case 'hotel':
        context.read<HotelBookingBloc>().add(CancelHotelBooking(id));
        break;
      case 'equipment':
        context.read<EquipmentBloc>().add(CancelEquipmentRental(id));
        break;
      case 'agency':
        context.read<AgencyBloc>().add(CancelAgencyBooking(id));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unknown booking type: $type'),
            backgroundColor: Colors.red,
          ),
        );
    }
  }
}
