class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);

  // For Android Emulator
  // static const String serverAddress = "http://10.0.2.2:3000";
  // For iOS Simulator
  // static const String serverAddress = "http://localhost:3000";
  // For Web Browser - use 127.0.0.1 instead of localhost
  static const String serverAddress = "http://127.0.0.1:3000";

  // Base URL
  static const String baseUrl = "$serverAddress/api/";
  static const String imageUrl = "$serverAddress/uploads/";

  // Auth endpoints
  static const String login = "auth/login";
  static const String register = "auth/register";

  // Hotel endpoints
  static const String hotels = "hotels";
  static const String getAllHotels = "hotels";

  // Booking endpoints
  static const String bookings = "bookings";
  static const String getUserBookings = "bookings";
  static const String createBooking = "bookings";
  static const String deleteBooking = "bookings";
  static const String getAllBookings = "bookings/admin/all";

  // Equipment endpoints
  static const String equipment = "equipment";
  static const String getAllEquipment = "equipment";
  static const String getEquipmentById = "equipment";
  static const String createEquipment = "equipment";
  static const String updateEquipment = "equipment";
  static const String deleteEquipment = "equipment";

  // Equipment Rental endpoints
  static const String equipmentRentals = "equipment/rentals";
  static const String getUserEquipmentRentals = "equipment/rentals";
  static const String createEquipmentRental = "equipment/rentals";
  static const String updateEquipmentRental = "equipment/rentals";
  static const String deleteEquipmentRental = "equipment/rentals";

  // Agency endpoints
  static const String agencies = "agencies";
  static const String getAllAgencies = "agencies";
  static const String createAgency = "agencies";
  static const String updateAgency = "agencies";
  static const String deleteAgency = "agencies";

  // Agency Booking endpoints
  static const String agencyBookings = "agencies/bookings";
  static const String getUserAgencyBookings = "agencies/bookings";
  static const String createAgencyBooking = "agencies/bookings";
  static const String updateAgencyBooking = "agencies/bookings";
  static const String deleteAgencyBooking = "agencies/bookings";

  // Guide Booking endpoints
  static const String guideBookings = "guides/bookings";
  static const String createGuideBooking = "guides/bookings";

  // Weather endpoints
  static const String currentWeather = "weather/current";
  static const String weatherForecast = "weather/forecast";
  static const String mockWeather = "weather/mock";

  // Trekking Spots endpoints
  static const String trekkingSpots = "trekking-spots";
  static const String getAllTrekkingSpots = "trekking-spots";
  static const String getTrekkingSpotById = "trekking-spots";
  static const String createTrekkingSpot = "trekking-spots";
  static const String updateTrekkingSpot = "trekking-spots";
  static const String deleteTrekkingSpot = "trekking-spots";
}
