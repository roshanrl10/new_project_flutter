import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/network/api_client.dart';

// Trekking Spots
import 'package:new_project_flutter/features/trekkingSpots/presentation/view/trekking_spots_page.dart';

// Hive Models
import 'features/auth/data/model/auth_user_model.dart';
import 'features/itenerary/data/model/itinerary_model.dart';
import 'features/trekkingSpots/data/model/map_place_model.dart';

// Auth - New Clean Architecture
import 'features/auth/data/repository/auth_repository_impl.dart';
import 'features/auth/data/data_source/remote_datasource/auth_remote_datasource.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/use_case/login_use_case.dart';
import 'features/auth/domain/use_case/register_use_case.dart';
import 'features/auth/domain/use_case/logout_use_case.dart';
import 'features/auth/domain/use_case/is_logged_in_use_case.dart';
import 'features/auth/presentation/view_model/auth_bloc.dart';
import 'features/auth/presentation/view/login.dart';
import 'features/auth/presentation/view/signup.dart';

// Itinerary
import 'features/itenerary/data/data_source/local_datasource/itinerary_local_datasource.dart';
import 'features/itenerary/data/repository/local_repository/itinerary_repository_impl.dart';
import 'features/itenerary/domain/repository/itinerary_repository.dart';
import 'features/itenerary/domain/use_case/gt_itineraries_usecase.dart';
import 'features/itenerary/presentation/view_model/itinerary_bloc.dart';
import 'features/itenerary/presentation/view_model/itinerary_event.dart';

// Hotel Booking
import 'features/hotelBooking/data/data_source/remote_datasource/hotel_remote_datasource.dart';
import 'features/hotelBooking/data/data_source/remote_datasource/booking_remote_datasource.dart';
import 'features/hotelBooking/data/repository/hotel_repository_impl.dart';
import 'features/hotelBooking/domain/repository/hotel_repository.dart';
import 'features/hotelBooking/domain/use_case/get_hotels.dart';
import 'features/hotelBooking/presentation/view/hotel_booking_page.dart';
import 'features/hotelBooking/presentation/view_model/hotel_booking_bloc.dart';

// Agency
import 'features/agency/presentation/view/agency_page.dart';
import 'features/agency/data/data_source/remote_datasource/agency_remote_datasource.dart';
import 'features/agency/data/repository/agency_repository_impl.dart';
import 'features/agency/domain/repository/agency_repository.dart';
import 'features/agency/presentation/view_model/agency_bloc.dart';

// Equipment
import 'features/equipments/presentation/view/equipments_page.dart';
import 'features/equipments/data/data_source/remote_datasource/equipment_remote_datasource.dart';
import 'features/equipments/data/data_source/remote_datasource/equipment_rental_remote_datasource.dart';
import 'features/equipments/data/repository/equipment_repository_impl.dart';
import 'features/equipments/domain/repository/equipment_repository.dart';
import 'features/equipments/presentation/view_model/equipment_bloc.dart';

// Weather
import 'features/weather/presentation/view/weather_page.dart';

// Map
import 'features/trekkingSpots/data/data_source/local_datasource/map_local_data_source.dart';
import 'features/trekkingSpots/data/repository/local_repository/map_repository_impl.dart';
import 'features/trekkingSpots/domain/repository/map_repository.dart';
import 'features/trekkingSpots/presentation/view_model/map_bloc.dart';

// Misc Screens
import 'features/splash/presentation/view/splash_view.dart';
import 'features/dashboard/presentation/view/dashboard.dart';
import 'features/dashboard/presentation/view/saved_bookings_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API Client
  apiClient.initialize();
  print(
    '🔧 API Client initialized with base URL: ${apiClient.dio.options.baseUrl}',
  );

  // Force reinitialize to ensure latest endpoints
  apiClient.reinitialize();

  await Hive.initFlutter();

  // Register Hive Adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(AuthUserModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ItineraryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(MapPlaceModelAdapter());
  }

  // Open Hive Boxes
  final userBox = await Hive.openBox<AuthUserModel>('users');
  final itineraryBox = await Hive.openBox<ItineraryModel>('itineraries');
  final mapBox = await Hive.openBox<MapPlaceModel>('map_places');

  // Initialize Data Sources
  final authRemoteDataSource = AuthRemoteDataSourceImpl();
  final hotelRemoteDataSource = HotelRemoteDataSourceImpl();
  final bookingRemoteDataSource = BookingRemoteDataSourceImpl();
  final itineraryLocalDataSource = ItineraryLocalDataSourceImpl(itineraryBox);
  final mapLocalDataSource = MapLocalDataSource(mapBox);
  final agencyRemoteDataSource = AgencyRemoteDataSourceImpl();
  final equipmentRemoteDataSource = EquipmentRemoteDataSourceImpl();
  final equipmentRentalRemoteDataSource = EquipmentRentalRemoteDataSourceImpl();

  runApp(
    MultiRepositoryProvider(
      providers: [
        // Auth Repository
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepositoryImpl(authRemoteDataSource),
        ),

        // Auth Use Cases
        RepositoryProvider<LoginUseCase>(
          create: (context) => LoginUseCase(context.read<AuthRepository>()),
        ),
        RepositoryProvider<RegisterUseCase>(
          create: (context) => RegisterUseCase(context.read<AuthRepository>()),
        ),
        RepositoryProvider<LogoutUseCase>(
          create: (context) => LogoutUseCase(context.read<AuthRepository>()),
        ),
        RepositoryProvider<IsLoggedInUseCase>(
          create:
              (context) => IsLoggedInUseCase(context.read<AuthRepository>()),
        ),

        // Other Repositories
        RepositoryProvider<ItineraryRepository>(
          create: (_) => ItineraryRepositoryImpl(itineraryLocalDataSource),
        ),
        RepositoryProvider<GetItineraries>(
          create:
              (context) => GetItineraries(context.read<ItineraryRepository>()),
        ),
        RepositoryProvider<HotelRepository>(
          create:
              (_) => HotelRepositoryImpl(
                hotelRemoteDataSource: hotelRemoteDataSource,
                bookingRemoteDataSource: bookingRemoteDataSource,
              ),
        ),
        RepositoryProvider<GetHotels>(
          create: (context) => GetHotels(context.read<HotelRepository>()),
        ),
        RepositoryProvider<MapRepository>(
          create: (_) => MapRepositoryImpl(mapLocalDataSource),
        ),
        RepositoryProvider<AgencyRepository>(
          create: (_) => AgencyRepositoryImpl(agencyRemoteDataSource),
        ),
        RepositoryProvider<EquipmentRepository>(
          create:
              (_) => EquipmentRepositoryImpl(
                equipmentRemoteDataSource: equipmentRemoteDataSource,
                rentalRemoteDataSource: equipmentRentalRemoteDataSource,
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth BLoC
        BlocProvider<AuthBloc>(
          create:
              (context) => AuthBloc(
                loginUseCase: context.read<LoginUseCase>(),
                registerUseCase: context.read<RegisterUseCase>(),
                logoutUseCase: context.read<LogoutUseCase>(),
                isLoggedInUseCase: context.read<IsLoggedInUseCase>(),
                authRepository: context.read<AuthRepository>(),
              ),
        ),

        // Other BLoCs
        BlocProvider<HotelBookingBloc>(
          create:
              (_) => HotelBookingBloc(
                context.read<GetHotels>(),
                context.read<HotelRepository>(),
              ),
        ),
        BlocProvider<ItineraryBloc>(
          create:
              (_) =>
                  ItineraryBloc(context.read<GetItineraries>())
                    ..add(LoadItinerariesEvent()),
        ),
        BlocProvider<MapBloc>(
          create: (_) => MapBloc(context.read<MapRepository>()),
        ),
        BlocProvider<AgencyBloc>(
          create: (_) => AgencyBloc(context.read<AgencyRepository>()),
        ),
        BlocProvider<EquipmentBloc>(
          create: (_) => EquipmentBloc(context.read<EquipmentRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Trekking App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          fontFamily: 'Poppins',
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => const SignUpPage(),
          '/dashboard': (context) => Dashboard(),
          '/hotel-booking': (context) => const HotelBookingPage(),
          '/agency': (context) => const AgencyPage(),
          '/equipment': (context) => const EquipmentsPage(),
          '/weather': (context) => const WeatherPage(),
          '/map': (context) => const MapPage(),
          '/saved-bookings': (context) => const SavedBookingsPage(),
        },
      ),
    );
  }
}
