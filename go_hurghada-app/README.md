# Go Hurghadda - Egypt Domestic Flight Booking App

A production-quality Flutter application for searching and booking domestic flights within Egypt. This app features a clean, modern UI inspired by Booking.com, with full state management using Riverpod and clean architecture.

## 🎯 Features

- **Flight Search**: Search for one-way and round-trip flights
- **Multiple Airlines**: Support for EgyptAir, Air Cairo, and Nile Air
- **Smart Sorting**: Sort results by cheapest, fastest, or best value
- **Date Selection**: Beautiful custom calendar for selecting travel dates
- **Airport Selection**: Easy-to-use airport selector with search
- **Direct Booking**: Redirect to airline websites for booking
- **Clean Architecture**: Separation of concerns with domain, data, and presentation layers
- **State Management**: Riverpod for reactive state management
- **Mock Data**: Currently uses mock data with structure ready for API integration

## 🏗️ Architecture

This project follows **Clean Architecture** principles:

```
lib/
├── core/                    # Core utilities and constants
│   ├── constants/          # App constants and Egypt airports data
│   ├── theme/              # App theme and colors
│   └── utils/              # Utility functions (date formatting, URL launcher)
├── domain/                  # Business logic layer
│   ├── entities/           # Domain models (Flight, SearchParams)
│   └── repositories/       # Repository interfaces
├── data/                    # Data layer
│   ├── datasources/        # Data sources (mock data, API service)
│   └── repositories/       # Repository implementations
└── presentation/            # UI layer
    ├── navigation/         # GoRouter configuration
    ├── providers/          # Riverpod providers
    ├── screens/            # App screens
    └── widgets/            # Reusable widgets
```

## 📦 Dependencies

### Core Dependencies
- **flutter_riverpod** (^2.6.1): State management
- **go_router** (^14.6.2): Navigation
- **dio** (^5.7.0): HTTP client for API calls
- **freezed** (^2.5.7): Code generation for immutable classes
- **flutter_dotenv** (^5.2.1): Environment variable management
- **url_launcher** (^6.3.1): Launch external URLs
- **intl** (^0.19.0): Internationalization and date formatting

### Dev Dependencies
- **build_runner** (^2.4.13): Code generation
- **freezed** (^2.5.7): Immutable class generation
- **json_serializable** (^6.8.0): JSON serialization

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart SDK 3.9.2 or higher

### Installation

1. **Clone the repository**
   ```bash
   cd go_hurghada
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (Freezed models)**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Environment Variables

The app uses a `.env` file for configuration. The file is already created with placeholders:

```env
# Amadeus API Configuration (Future Use)
AMADEUS_API_KEY=your_api_key_here
AMADEUS_API_SECRET=your_api_secret_here
AMADEUS_BASE_URL=https://test.api.amadeus.com

# Backend Proxy URL (Future Use)
BACKEND_PROXY_URL=https://your-backend-proxy.com/api
```

## 📱 Screens

### 1. Home Screen
- Trip type selection (One-way / Round-trip)
- Airport selection (From/To)
- Date selection
- Passenger and class selection
- Search button

### 2. Date Selection Screen
- Custom calendar UI
- Month navigation
- Date selection with visual feedback
- Matches the design perfectly

### 3. Search Results Screen
- Flight cards with airline info
- Departure and arrival times
- Duration and stops information
- Price display
- Sorting options (Best, Cheapest, Fastest)
- Book button for each flight

## 🎨 Design

The UI is pixel-perfect and matches the provided Go Hurghadda design with:
- Blue primary color (#0066FF)
- Clean, modern interface
- Smooth animations
- Responsive layout
- Material Design 3 components

## 🔌 API Integration (Future)

The app is structured to easily integrate with the Amadeus Flight API:

### API Service Template
Located at `lib/data/datasources/api_service.dart`, ready for:
- Flight search endpoint
- City codes endpoint
- Proper error handling
- Request/response logging

### Backend Proxy
The architecture supports a backend proxy to securely handle API keys:
```
Flutter App → Backend Proxy → Amadeus API
```

### Migration Path
1. Update `.env` with actual API credentials
2. Implement API response models
3. Update `FlightRepositoryImpl` to use `ApiService` instead of mock data
4. Test with real API endpoints

## 🗂️ Mock Data

Currently, the app uses mock data for:
- **8 Egyptian airports**: Cairo, Hurghada, Sharm El Sheikh, Luxor, Aswan, Alexandria, Marsa Alam, Giza
- **Multiple flights** per route with realistic:
  - Departure/arrival times
  - Prices (in EGP)
  - Durations
  - Airline information
  - Booking URLs

## 🧪 Testing

To run tests:
```bash
flutter test
```

## 📝 Code Generation

When you modify Freezed models, regenerate code:
```bash
# Watch mode (auto-regenerate on changes)
flutter pub run build_runner watch

# One-time build
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🎯 Future Enhancements

- [ ] Integrate with real Amadeus Flight API
- [ ] Add user authentication
- [ ] Save favorite routes
- [ ] Flight price alerts
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Offline mode with cached results
- [ ] Payment integration
- [ ] Booking history

## 📄 License

This project is private and not licensed for public use.

## 👥 Contributors

- Development Team

## 📞 Support

For support, please contact the development team.

---

**Built with ❤️ using Flutter**
