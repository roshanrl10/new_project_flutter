# Flutter Backend API Integration Guide

This guide explains how the Flutter app connects to the 34b-web-api backend.

## Overview

The Flutter app now connects to the same backend API that powers the web frontend. All features are available with the same functionality but adapted for mobile use.

## Backend API Endpoints

### Base URL

- **Android Emulator**: `http://10.0.2.2:3000/api`
- **iOS Simulator**: `http://localhost:3000/api`
- **Physical Device**: Use your computer's IP address

### Available Endpoints

#### Authentication

- `POST /auth/login` - User login
- `POST /auth/register` - User registration

#### Hotels

- `GET /hotels` - Get all hotels
- `POST /hotels` - Create new hotel (admin only)

#### Bookings

- `GET /bookings` - Get user's bookings
- `POST /bookings` - Create new booking
- `DELETE /bookings/:id` - Delete booking

#### Equipment

- `GET /equipment` - Get all equipment
- `GET /equipment/:id` - Get equipment by ID
- `POST /equipment` - Create equipment (admin only)
- `PUT /equipment/:id` - Update equipment (admin only)
- `DELETE /equipment/:id` - Delete equipment (admin only)

#### Equipment Rentals

- `GET /equipment/rentals/all` - Get all rentals (admin)
- `GET /equipment/rentals` - Get user's rentals
- `POST /equipment/rentals` - Create rental
- `PUT /equipment/rentals/:id` - Update rental
- `DELETE /equipment/rentals/:id` - Delete rental

#### Agencies

- `GET /agencies` - Get all agencies
- `GET /agencies/:id` - Get agency by ID
- `POST /agencies` - Create agency (admin only)
- `PUT /agencies/:id` - Update agency (admin only)
- `DELETE /agencies/:id` - Delete agency (admin only)

#### Agency Bookings

- `GET /agencies/bookings/all` - Get all agency bookings (admin)
- `GET /agencies/bookings` - Get user's agency bookings
- `POST /agencies/bookings` - Create agency booking
- `PUT /agencies/bookings/:id` - Update agency booking
- `DELETE /agencies/bookings/:id` - Delete agency booking

#### Weather

- `GET /weather/current` - Get current weather
- `GET /weather/forecast` - Get weather forecast
- `GET /weather/mock` - Get mock weather data

## Flutter Implementation

### Network Infrastructure

#### API Client (`lib/core/network/api_client.dart`)

- Singleton pattern for HTTP client
- Automatic token management
- Request/response logging
- Error handling

#### API Service (`lib/core/network/api_service.dart`)

- Base HTTP methods (GET, POST, PUT, DELETE)
- File upload support
- Error handling

### Feature-Specific Implementations

#### Authentication

- **Remote Data Source**: `lib/features/auth/data/data_source/remote_datasource/auth_remote_datasource.dart`
- **Model**: `lib/features/auth/data/model/api_user_model.dart`
- **Repository**: Updated to use remote data source

#### Hotels

- **Remote Data Source**: `lib/features/hotelBooking/data/data_source/remote_datasource/hotel_remote_datasource.dart`
- **Model**: `lib/features/hotelBooking/data/model/hotel_model.dart`
- **Repository**: Updated to use remote data source

#### Equipment

- **Remote Data Source**: `lib/features/equipments/data/data_source/remote_datasource/equipment_remote_datasource.dart`
- **Models**:
  - `lib/features/equipments/data/model/equipment_model.dart`
  - `lib/features/equipments/data/model/equipment_rental_model.dart`
- **Entity**: `lib/features/equipments/domain/entity/equipment_rental_entity.dart`

#### Bookings

- **Remote Data Source**: `lib/features/hotelBooking/data/data_source/remote_datasource/booking_remote_datasource.dart`
- **Model**: `lib/features/hotelBooking/data/model/booking_model.dart`
- **Entity**: `lib/features/hotelBooking/domain/entity/booking_entity.dart`

#### Weather

- **Remote Data Source**: `lib/features/weather/data/data_source/remote_datasource/weather_remote_datasource.dart`
- **Model**: `lib/features/weather/data/model/weather_model.dart`

## Configuration

### API Endpoints (`lib/app/constant/api_endpoints.dart`)

All API endpoints are centralized in this file for easy management.

### Environment Setup

1. Ensure your backend server is running on port 3000
2. For Android emulator, use `10.0.2.2:3000`
3. For iOS simulator, use `localhost:3000`
4. For physical devices, use your computer's IP address

## Authentication Flow

1. User enters credentials
2. App sends POST request to `/auth/login`
3. Backend returns user data and JWT token
4. Token is stored in SharedPreferences
5. Token is automatically included in subsequent requests
6. On 401 errors, user is logged out

## Error Handling

- Network timeouts: 30 seconds
- Automatic token refresh
- User-friendly error messages
- Graceful degradation when offline

## Testing

### Backend Connection Test

1. Start your backend server
2. Run the Flutter app
3. Try logging in with valid credentials
4. Check network logs for successful API calls

### Feature Testing

1. Test each feature (hotels, equipment, bookings, etc.)
2. Verify data is fetched from backend
3. Test create/update/delete operations
4. Verify error handling

## Troubleshooting

### Common Issues

1. **Connection Refused**

   - Check if backend server is running
   - Verify correct IP address and port
   - Check firewall settings

2. **401 Unauthorized**

   - Check if user is logged in
   - Verify token is valid
   - Try logging in again

3. **404 Not Found**

   - Check API endpoint URLs
   - Verify backend routes are correct

4. **500 Server Error**
   - Check backend logs
   - Verify request data format
   - Check database connection

### Debug Tips

1. Enable network logging in `api_client.dart`
2. Check browser developer tools for backend errors
3. Use Postman to test API endpoints directly
4. Check Flutter console for detailed error messages

## Next Steps

1. **Complete Agency Integration**: Add agency booking features
2. **Add Offline Support**: Implement local caching
3. **Push Notifications**: Add booking confirmations
4. **Image Upload**: Implement profile picture upload
5. **Real-time Updates**: Add WebSocket support for live updates

## File Structure

```
lib/
├── core/
│   └── network/
│       ├── api_client.dart
│       └── api_service.dart
├── app/
│   └── constant/
│       └── api_endpoints.dart
└── features/
    ├── auth/
    │   └── data/
    │       ├── data_source/
    │       │   └── remote_datasource/
    │       │       └── auth_remote_datasource.dart
    │       └── model/
    │           └── api_user_model.dart
    ├── hotelBooking/
    │   └── data/
    │       ├── data_source/
    │       │   └── remote_datasource/
    │       │       ├── hotel_remote_datasource.dart
    │       │       └── booking_remote_datasource.dart
    │       └── model/
    │           ├── hotel_model.dart
    │           └── booking_model.dart
    ├── equipments/
    │   └── data/
    │       ├── data_source/
    │       │   └── remote_datasource/
    │       │       └── equipment_remote_datasource.dart
    │       └── model/
    │           ├── equipment_model.dart
    │           └── equipment_rental_model.dart
    └── weather/
        └── data/
            ├── data_source/
            │   └── remote_datasource/
            │       └── weather_remote_datasource.dart
            └── model/
                └── weather_model.dart
```

This integration provides a complete mobile experience that mirrors your web frontend functionality while maintaining the same backend API.
