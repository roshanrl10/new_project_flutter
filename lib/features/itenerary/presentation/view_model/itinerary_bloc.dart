import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_flutter/features/itenerary/domain/entity/itinerary_entity.dart';

import 'package:new_project_flutter/features/itenerary/domain/use_case/gt_itineraries_usecase.dart';

import 'package:new_project_flutter/features/itenerary/presentation/view_model/itinerary_event.dart';
import 'package:new_project_flutter/features/itenerary/presentation/view_model/itinerary_state.dart';

class ItineraryBloc extends Bloc<ItineraryEvent, ItineraryState> {
  final GetItineraries getItineraries;

  List<ItineraryEntity> _allItineraries = [];

  ItineraryBloc(this.getItineraries) : super(ItineraryInitial()) {
    on<LoadItinerariesEvent>((event, emit) async {
      emit(ItineraryLoading());
      try {
        final itineraries = await getItineraries();
        _allItineraries = itineraries;
        emit(ItineraryLoaded(itineraries));
      } catch (_) {
        emit(ItineraryError("Failed to load itineraries"));
      }
    });

    on<SearchItineraryEvent>((event, emit) {
      final filtered =
          _allItineraries
              .where(
                (itinerary) => itinerary.name.toLowerCase().contains(
                  event.query.toLowerCase(),
                ),
              )
              .toList();
      emit(ItineraryLoaded(filtered));
    });
  }
}
