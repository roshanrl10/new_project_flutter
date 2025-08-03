import 'package:new_project_flutter/features/equipments/data/model/equipment_model.dart';

abstract class EquipmentRemoteDataSource {
  Future<List<EquipmentModel>> fetchEquipments();
}

class EquipmentRemoteDataSourceImpl implements EquipmentRemoteDataSource {
  @override
  Future<List<EquipmentModel>> fetchEquipments() async {
    return [
      EquipmentModel(
        id: '1',
        name: 'Tent',
        category: 'Camping',
        description: 'Durable and waterproof tent.',
        price: 50.0,
        imageUrl:
            'https://tse2.mm.bing.net/th/id/OIP.c_huw2Dv94dF7JQxnNMoYQHaFs?rs=1&pid=ImgDetMain&o=7&rm=3',
        quantity: 5,
        brand: 'OutdoorPro',
        available: true,
        condition: 'good',
        location: 'Pokhara',
      ),
      EquipmentModel(
        id: '2',
        name: 'Backpack',
        category: 'Hiking',
        description: 'Comfortable hiking backpack.',
        price: 20.0,
        imageUrl:
            'https://th.bing.com/th/id/OIP.nHxxXVRGf28Z3r0joKamkgHaHa?w=218&h=218&c=7&r=0&o=7&dpr=1.6&pid=1.7&rm=3',
        quantity: 10,
        brand: 'TrekMaster',
        available: true,
        condition: 'excellent',
        location: 'Kathmandu',
      ),
    ];
  }
}
