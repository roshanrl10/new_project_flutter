// import 'package:flutter/material.dart';
// import 'package:new_project_flutter/features/hotelBooking/domain/entity/hotel_entity.dart';

// class HotelListWidget extends StatelessWidget {
//   final List<Hotel> hotels;

//   const HotelListWidget({super.key, required this.hotels});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: hotels.length,
//       itemBuilder: (context, index) {
//         final hotel = hotels[index];
//         return Card(
//           margin: const EdgeInsets.all(8.0),
//           child: ListTile(
//             title: Text(hotel.name),
//             subtitle: Text(hotel.description),
//             trailing: ElevatedButton(
//               onPressed: () {
//                 // Handle booking here
//               },
//               child: const Text('Book'),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
