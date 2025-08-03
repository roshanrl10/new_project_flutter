import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_flutter/app/service_locator/notification_service.dart';
import 'package:new_project_flutter/features/equipments/presentation/view_model/equipment_bloc.dart';
import 'package:new_project_flutter/features/equipments/presentation/view_model/equipment_event.dart';
import 'package:new_project_flutter/features/equipments/presentation/view_model/equipment_state.dart';

class EquipmentsPage extends StatefulWidget {
  const EquipmentsPage({super.key});

  @override
  State<EquipmentsPage> createState() => _EquipmentsPageState();
}

class _EquipmentsPageState extends State<EquipmentsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All Categories';
  String _selectedPriceRange = 'All Prices';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EquipmentBloc>().add(FetchEquipments());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EquipmentBloc, EquipmentState>(
      listener: (context, state) {
        if (state is EquipmentRentalSuccess) {
          // Show notification
          NotificationService().showRentalSuccess('Equipment');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is EquipmentRentalError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is EquipmentRentalLoaded) {
          // Show notification when rentals are loaded
          if (state.equipmentRentals.isNotEmpty) {
            NotificationService().showInfo(
              'Rentals Loaded',
              'Found ${state.equipmentRentals.length} equipment rentals.',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rent Equipment'),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            // Test button to manually trigger equipment fetch
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                print('🔄 Manual refresh triggered');
                context.read<EquipmentBloc>().add(FetchEquipments());
              },
            ),
          ],
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
                      hintText: 'Search equipment...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (query) {
                      context.read<EquipmentBloc>().add(
                        FilterEquipments(query),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Filter Row
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items:
                              [
                                'All Categories',
                                'Tents',
                                'Sleeping Bags',
                                'Backpacks',
                                'Climbing Gear',
                                'Cooking Equipment',
                                'Navigation',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCategory = newValue!;
                            });
                            context.read<EquipmentBloc>().add(
                              FilterEquipmentsByCategory(newValue!),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedPriceRange,
                          decoration: InputDecoration(
                            labelText: 'Price Range',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items:
                              [
                                'All Prices',
                                'Under \$20',
                                '\$20 - \$50',
                                '\$50 - \$100',
                                'Over \$100',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedPriceRange = newValue!;
                            });
                            context.read<EquipmentBloc>().add(
                              FilterEquipmentsByPrice(newValue!),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Equipment List
            Expanded(
              child: BlocBuilder<EquipmentBloc, EquipmentState>(
                builder: (context, state) {
                  if (state is EquipmentLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    );
                  }
                  if (state is EquipmentLoaded) {
                    if (state.equipments.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.build_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No equipment found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: state.equipments.length,
                      itemBuilder: (context, index) {
                        final equipment = state.equipments[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Equipment Image
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Image.network(
                                    equipment.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey.shade300,
                                        child: const Icon(
                                          Icons.build,
                                          size: 48,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // Equipment Info
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            equipment.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            '\$${equipment.price.toStringAsFixed(2)}/day',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.category,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            equipment.category,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      equipment.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.inventory,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Available: ${equipment.quantity}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // Rent Button
                                    SizedBox(
                                      width: double.infinity,
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed:
                                            equipment.available
                                                ? () => _showRentalForm(
                                                  context,
                                                  equipment,
                                                )
                                                : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Rent Now',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is EquipmentError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<EquipmentBloc>().add(
                                FetchEquipments(),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEquipmentDetails(BuildContext context, dynamic equipment) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(equipment.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${equipment.description}'),
                const SizedBox(height: 8),
                Text('Category: ${equipment.category}'),
                const SizedBox(height: 8),
                Text('Price: \$${equipment.price.toStringAsFixed(2)}/day'),
                const SizedBox(height: 8),
                Text('Available: ${equipment.quantity}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showRentalForm(context, equipment);
                },
                child: const Text('Rent'),
              ),
            ],
          ),
    );
  }

  void _showRentalForm(BuildContext context, dynamic equipment) {
    print('🔧 Opening rental form for equipment: ${equipment.name}');
    print('🔧 Equipment details:');
    print('  - ID: ${equipment.id}');
    print('  - Name: ${equipment.name}');
    print('  - Price: ${equipment.price}');
    print('  - Quantity: ${equipment.quantity}');
    print('  - Available: ${equipment.available}');

    showDialog(
      context: context,
      builder: (context) => _RentalFormDialog(equipment: equipment),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _RentalFormDialog extends StatefulWidget {
  final dynamic equipment;

  const _RentalFormDialog({required this.equipment});

  @override
  State<_RentalFormDialog> createState() => _RentalFormDialogState();
}

class _RentalFormDialogState extends State<_RentalFormDialog> {
  DateTime? startDate;
  DateTime? endDate;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    print('🔧 Building rental dialog with quantity: $quantity');
    return AlertDialog(
      title: Text('Rent ${widget.equipment.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Start Date
          ListTile(
            title: const Text('Start Date'),
            subtitle: Text(
              startDate?.toString().split(' ')[0] ?? 'Select date',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                setState(() {
                  startDate = date;
                });
              }
            },
          ),

          // End Date
          ListTile(
            title: const Text('End Date'),
            subtitle: Text(endDate?.toString().split(' ')[0] ?? 'Select date'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate:
                    startDate ?? DateTime.now().add(const Duration(days: 1)),
                firstDate:
                    startDate ?? DateTime.now().add(const Duration(days: 1)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                setState(() {
                  endDate = date;
                });
              }
            },
          ),

          // Quantity
          ListTile(
            title: const Text('Quantity'),
            subtitle: Text('$quantity'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    print('🔧 Decreasing quantity from $quantity');
                    print(
                      '🔧 Equipment quantity: ${widget.equipment.quantity}',
                    );
                    print(
                      '🔧 Equipment quantity type: ${widget.equipment.quantity.runtimeType}',
                    );
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                      print('🔧 Quantity decreased to $quantity');
                    } else {
                      print('🔧 Cannot decrease quantity below 1');
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '$quantity',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    print('🔧 Increasing quantity from $quantity');
                    final maxQuantity = widget.equipment.quantity ?? 10;
                    print('🔧 Max quantity: $maxQuantity');
                    print('🔧 Current quantity: $quantity');
                    if (quantity < maxQuantity) {
                      setState(() {
                        quantity++;
                      });
                      print('🔧 Quantity increased to $quantity');
                    } else {
                      print('🔧 Cannot increase quantity above $maxQuantity');
                    }
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // Total Price
          if (startDate != null && endDate != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Price:'),
                  Text(
                    '\$${_calculateTotalPrice(widget.equipment.price, startDate!, endDate!, quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        BlocBuilder<EquipmentBloc, EquipmentState>(
          builder: (context, state) {
            print('🔧 Equipment rental state: ${state.runtimeType}');
            print('🔧 Start date: $startDate');
            print('🔧 End date: $endDate');
            print('🔧 Is loading: ${state is EquipmentRentalActionLoading}');
            print('🔧 State details: $state');

            final isDisabled = startDate == null || endDate == null;

            print('🔧 Button disabled: $isDisabled');
            print('🔧 Start date: $startDate');
            print('🔧 End date: $endDate');
            print('🔧 Quantity: $quantity');
            print('🔧 Equipment: ${widget.equipment.name}');

            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDisabled ? Colors.grey : Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onPressed:
                  isDisabled
                      ? null
                      : () {
                        print('🔧 Confirm rental button pressed!');
                        const hardcodedUserId = '688339f4171a690ae2d5d852';

                        final rentalData = {
                          'user': hardcodedUserId,
                          'equipment': widget.equipment.id,
                          'equipmentName': widget.equipment.name,
                          'startDate': startDate!.toIso8601String(),
                          'endDate': endDate!.toIso8601String(),
                          'quantity': quantity,
                          'totalPrice': _calculateTotalPrice(
                            widget.equipment.price,
                            startDate!,
                            endDate!,
                            quantity,
                          ),
                          'status': 'confirmed',
                          'specialRequests': 'Rental from Flutter app',
                        };

                        print('🔧 Rental data: $rentalData');
                        print('🔧 Triggering RentEquipment event...');
                        context.read<EquipmentBloc>().add(
                          RentEquipment(rentalData),
                        );
                        print(
                          '🔧 RentEquipment event triggered, closing dialog...',
                        );
                        Navigator.of(context).pop();

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Equipment rented successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        // Navigate to saved bookings page to show the rental
                        Navigator.pushNamed(context, '/saved-bookings');
                      },
              child:
                  state is EquipmentRentalActionLoading
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Text('Confirm Rental'),
            );
          },
        ),
      ],
    );
  }

  double _calculateTotalPrice(
    double price,
    DateTime start,
    DateTime end,
    int quantity,
  ) {
    final days = end.difference(start).inDays;
    return price * days * quantity;
  }
}

class EquipmentsView extends StatelessWidget {
  const EquipmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(); // This is now handled in the main EquipmentsPage
  }
}
