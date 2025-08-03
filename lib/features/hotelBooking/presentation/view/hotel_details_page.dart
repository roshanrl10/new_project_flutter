import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:new_project_flutter/app/service_locator/notification_service.dart';
import 'package:new_project_flutter/features/hotelBooking/domain/entity/hotel_entity.dart';
import 'package:new_project_flutter/features/hotelBooking/presentation/view_model/hotel_booking_bloc.dart';
import 'package:new_project_flutter/features/hotelBooking/presentation/view_model/hotel_booking_event.dart';
import 'package:new_project_flutter/features/hotelBooking/presentation/view_model/hotel_booking_state.dart';
// import 'package:new_project_flutter/features/auth/domain/repository/auth_repository.dart';

class HotelDetailsPage extends StatefulWidget {
  final Hotel hotel;

  const HotelDetailsPage({super.key, required this.hotel});

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _numberOfGuests = 1;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hotel.name),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<HotelBookingBloc, HotelBookingState>(
        listener: (context, state) {
          if (state is HotelBookingSuccess) {
            // Show notification
            NotificationService().showBookingSuccess(widget.hotel.name);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'View Bookings',
                  textColor: Colors.white,
                  onPressed: () {
                    // Navigate to saved bookings and trigger refresh
                    Navigator.pushNamed(context, '/saved-bookings').then((_) {
                      // This will trigger the refresh when returning from saved bookings
                      print('🔄 Returning from saved bookings page');
                    });
                  },
                ),
              ),
            );
            Navigator.of(context).pop();
          } else if (state is HotelBookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hotel Image
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  widget.hotel.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.hotel,
                        size: 64,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hotel Name and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.hotel.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '\$${widget.hotel.price.toStringAsFixed(2)}/night',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.hotel.location,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.hotel.rating}/5',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Description
                    Text(
                      'Description',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.hotel.description,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    const SizedBox(height: 16),

                    // Services
                    Text(
                      'Services',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children:
                          widget.hotel.services.map((service) {
                            return Chip(
                              label: Text(service),
                              backgroundColor: Colors.orange.shade100,
                            );
                          }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Booking Form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Book Your Stay',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Check-in Date
                          ListTile(
                            title: const Text('Check-in Date'),
                            subtitle: Text(
                              _checkInDate?.toString().split(' ')[0] ??
                                  'Select date',
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (date != null) {
                                setState(() {
                                  _checkInDate = date;
                                });
                              }
                            },
                          ),

                          // Check-out Date
                          ListTile(
                            title: const Text('Check-out Date'),
                            subtitle: Text(
                              _checkOutDate?.toString().split(' ')[0] ??
                                  'Select date',
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate:
                                    _checkInDate ??
                                    DateTime.now().add(const Duration(days: 1)),
                                firstDate:
                                    _checkInDate ??
                                    DateTime.now().add(const Duration(days: 1)),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (date != null) {
                                setState(() {
                                  _checkOutDate = date;
                                });
                              }
                            },
                          ),

                          // Number of Guests
                          ListTile(
                            title: const Text('Number of Guests'),
                            subtitle: Text('$_numberOfGuests'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (_numberOfGuests > 1) {
                                      setState(() {
                                        _numberOfGuests--;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                                Text('$_numberOfGuests'),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _numberOfGuests++;
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),

                          // Total Price
                          if (_checkInDate != null && _checkOutDate != null)
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
                                  const Text(
                                    'Total Price:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\$${_calculateTotalPrice().toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 16),

                          // Book Button
                          BlocBuilder<HotelBookingBloc, HotelBookingState>(
                            builder: (context, state) {
                              return SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed:
                                      (state is HotelBookingActionLoading ||
                                              _checkInDate == null ||
                                              _checkOutDate == null)
                                          ? null
                                          : _bookHotel,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child:
                                      state is HotelBookingActionLoading
                                          ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                          : const Text(
                                            'Book Now',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateTotalPrice() {
    if (_checkInDate == null || _checkOutDate == null) return 0;

    final days = _checkOutDate!.difference(_checkInDate!).inDays;
    return widget.hotel.price * days * _numberOfGuests;
  }

  void _bookHotel() async {
    if (_formKey.currentState!.validate() &&
        _checkInDate != null &&
        _checkOutDate != null) {
      try {
        // Test API connection first
        print('🔍 Testing API connection...');
        final dio = Dio();
        try {
          final testResponse = await dio.get(
            'http://127.0.0.1:3000/api/hotels',
          );
          print('✅ API connection test successful: ${testResponse.statusCode}');
          print('✅ API response data: ${testResponse.data}');
        } catch (e) {
          print('❌ API connection test failed: $e');
          // Show error to user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Connection failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // TEMPORARY: Use hardcoded user ID for testing
        String userId =
            '688e79727d3531f673be3d43'; // Working user ID from database
        print('🔍 Using hardcoded user ID: $userId');

        // TODO: Uncomment this when auth is working properly
        /*
        // Get current user from auth repository
        final authRepository = context.read<AuthRepository>();
        final currentUser = await authRepository.getCurrentUser();
        final isLoggedIn = await authRepository.isLoggedIn();

        if (currentUser == null || !isLoggedIn) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please login to book a hotel')),
          );
          return;
        }

        String userId = currentUser.id;
        
        // Fallback for testing if user ID is empty
        if (userId.isEmpty) {
          print('⚠️ User ID is empty, using fallback ID for testing');
          userId = '688e79727d3531f673be3d43'; // Working user ID from database
        }
        */

        print('🔍 Final user ID: $userId');
        print('🔍 User ID type: ${userId.runtimeType}');

        final bookingData = {
          'user': userId,
          'hotel': widget.hotel.id,
          'hotelName': widget.hotel.name,
          'checkIn': _checkInDate!.toIso8601String(),
          'checkOut': _checkOutDate!.toIso8601String(),
          'guests': _numberOfGuests,
          'totalPrice': _calculateTotalPrice(),
          'status': 'confirmed',
        };

        print('📤 Booking data: $bookingData'); // Debug log
        context.read<HotelBookingBloc>().add(BookHotel(bookingData));
      } catch (e) {
        print('💥 Error in _bookHotel: $e'); // Debug log
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
