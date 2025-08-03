import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_flutter/features/itenerary/domain/entity/itinerary_entity.dart';
import 'package:new_project_flutter/features/itenerary/presentation/view_model/itinerary_bloc.dart';
import 'package:new_project_flutter/features/itenerary/presentation/view_model/itinerary_state.dart';

import '../view_model/itinerary_event.dart';

class ItineraryPage extends StatelessWidget {
  const ItineraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trek Itineraries")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search by name...",
                border: OutlineInputBorder(),
              ),
              onChanged:
                  (query) => context.read<ItineraryBloc>().add(
                    SearchItineraryEvent(query),
                  ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ItineraryBloc, ItineraryState>(
              builder: (context, state) {
                if (state is ItineraryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ItineraryLoaded) {
                  return ListView.builder(
                    itemCount: state.itineraries.length,
                    itemBuilder: (context, index) {
                      final itinerary = state.itineraries[index];
                      return ListTile(
                        title: Text(itinerary.name),
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ItineraryDetailPage(itinerary),
                              ),
                            ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("No itineraries found."));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ItineraryDetailPage extends StatelessWidget {
  final ItineraryEntity itinerary;
  const ItineraryDetailPage(this.itinerary, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itinerary.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // TODO: Save functionality
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Itinerary saved!")));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: itinerary.imageUrls.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Image.network(itinerary.imageUrls[index]),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    itinerary.itinerarySteps[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
