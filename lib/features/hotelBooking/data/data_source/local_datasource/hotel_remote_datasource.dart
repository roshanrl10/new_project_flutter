import 'package:new_project_flutter/features/hotelBooking/data/model/hotel_model.dart';

abstract class HotelRemoteDataSource {
  Future<List<HotelModel>> fetchHotels();
}

class HotelRemoteDataSourceImpl implements HotelRemoteDataSource {
  @override
  Future<List<HotelModel>> fetchHotels() async {
    // Replace with API call later if needed
    return [
      HotelModel(
        id: '1',
        name: 'Mountain View Resort',
        location: 'Pokhara',
        description: 'A peaceful retreat in the hills of Pokhara.',
        services: ['WiFi', 'Pool', 'Breakfast'],
        price: 120.0,
        imageUrl:
            'https://tse2.mm.bing.net/th/id/OIP.GRZoblOGeDFYEYj0CtUibgHaE5?rs=1&pid=ImgDetMain&o=7&rm=3',
        rating: 4.5,
        available: true,
      ),
      HotelModel(
        id: '2',
        name: 'Lakeside Paradise',
        location: 'Pokhara',
        description: 'Overlooking the beautiful lake.',
        services: ['WiFi', 'Gym'],
        price: 100.0,
        imageUrl:
            'https://tse2.mm.bing.net/th/id/OIP.GRZoblOGeDFYEYj0CtUibgHaE5?rs=1&pid=ImgDetMain&o=7&rm=3',
        rating: 4.2,
        available: true,
      ),
    ];
  }
}
