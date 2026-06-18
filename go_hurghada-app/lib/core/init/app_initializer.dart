import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_hurghada/firebase_options.dart';
import 'package:go_hurghada/core/utils/room_migration_helper.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 2. Ensure all rooms have totalCount (idempotent — skips rooms that already have it)
    // Run in background so it doesn't block startup
    RoomMigrationHelper.addTotalCountToAllRooms(defaultCount: 5).catchError(
      (e) => debugPrint('[Migration] error: $e'),
    );

    // 3. Load Environment Variables
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      debugPrint('Error loading .env file: $e');
    }

    // 2. Initialize Hive
    await Hive.initFlutter();

    // 3. Open Hive Boxes
    await Hive.openBox('settings_box');
    await Hive.openBox('profile_box');
    await Hive.openBox('bookings');
    await Hive.openBox('currency_rates');
    await Hive.openBox('favorites_box'); // Ensure favorites box is opened early

    // 4. Initialize Core Services (Optional pre-fetching)
    // Detailed service init is handled in DependencyInjection to keep this method fast
  }
}
