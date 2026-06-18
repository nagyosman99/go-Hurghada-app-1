import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// No description provided for @locationAccess.
  ///
  /// In en, this message translates to:
  /// **'Location Access'**
  String get locationAccess;

  /// No description provided for @locationAccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable location access to get local offers'**
  String get locationAccessSubtitle;

  /// No description provided for @shareThirdParties.
  ///
  /// In en, this message translates to:
  /// **'Share with Third Parties'**
  String get shareThirdParties;

  /// No description provided for @shareThirdPartiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow sharing data with app partners to improve offers and services'**
  String get shareThirdPartiesSubtitle;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themeTitle;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @offersPromotions.
  ///
  /// In en, this message translates to:
  /// **'Offers and Promotions'**
  String get offersPromotions;

  /// No description provided for @offersPromotionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified about exclusive offers, discounts, and travel deals'**
  String get offersPromotionsSubtitle;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @remindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive reminders for your upcoming trips'**
  String get remindersSubtitle;

  /// No description provided for @silentMode.
  ///
  /// In en, this message translates to:
  /// **'Silent Mode'**
  String get silentMode;

  /// No description provided for @silentModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mute all notifications except critical alerts'**
  String get silentModeSubtitle;

  /// No description provided for @generalTitle.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalTitle;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @categoryFlight.
  ///
  /// In en, this message translates to:
  /// **'Flight'**
  String get categoryFlight;

  /// No description provided for @categoryHotel.
  ///
  /// In en, this message translates to:
  /// **'Hotel'**
  String get categoryHotel;

  /// No description provided for @categoryActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get categoryActivities;

  /// No description provided for @locationElGouna.
  ///
  /// In en, this message translates to:
  /// **'El Gouna'**
  String get locationElGouna;

  /// No description provided for @locationMakadiBay.
  ///
  /// In en, this message translates to:
  /// **'Makadi Bay'**
  String get locationMakadiBay;

  /// No description provided for @locationSomaBay.
  ///
  /// In en, this message translates to:
  /// **'Soma Bay'**
  String get locationSomaBay;

  /// No description provided for @locationSahlHasheesh.
  ///
  /// In en, this message translates to:
  /// **'Sahl Hasheesh'**
  String get locationSahlHasheesh;

  /// No description provided for @activityScubaDiving.
  ///
  /// In en, this message translates to:
  /// **'Scuba Diving'**
  String get activityScubaDiving;

  /// No description provided for @activityDesertSafari.
  ///
  /// In en, this message translates to:
  /// **'Desert Safari'**
  String get activityDesertSafari;

  /// No description provided for @activityCityTours.
  ///
  /// In en, this message translates to:
  /// **'City Tours'**
  String get activityCityTours;

  /// No description provided for @activityWaterSports.
  ///
  /// In en, this message translates to:
  /// **'Water Sports'**
  String get activityWaterSports;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get navSaved;

  /// No description provided for @navSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get navSupport;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navMyBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get navMyBookings;

  /// No description provided for @onboard1Title.
  ///
  /// In en, this message translates to:
  /// **'Discover the beauty\nof your country step\nby step'**
  String get onboard1Title;

  /// No description provided for @onboard1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Through our app, you\'ll explore new places within your country — from beaches and natural wonders to historical sites.'**
  String get onboard1Subtitle;

  /// No description provided for @onboard2Title.
  ///
  /// In en, this message translates to:
  /// **'Travel made easy\nbook and go!'**
  String get onboard2Title;

  /// No description provided for @onboard2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Book flights, hotels, and local tours all in one app. Your next adventure starts here.'**
  String get onboard2Subtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select currency'**
  String get selectCurrency;

  /// No description provided for @selectCurrencyDescription.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred currency for pricing and transactions.'**
  String get selectCurrencyDescription;

  /// No description provided for @egyptianPound.
  ///
  /// In en, this message translates to:
  /// **'Egyptian Pound'**
  String get egyptianPound;

  /// No description provided for @uaeDirham.
  ///
  /// In en, this message translates to:
  /// **'United Arab Emirates Dirham'**
  String get uaeDirham;

  /// No description provided for @usDollar.
  ///
  /// In en, this message translates to:
  /// **'United States Dollar'**
  String get usDollar;

  /// No description provided for @euro.
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get euro;

  /// No description provided for @popularDestinations.
  ///
  /// In en, this message translates to:
  /// **'Popular Hurghada Destinations'**
  String get popularDestinations;

  /// No description provided for @popularActivities.
  ///
  /// In en, this message translates to:
  /// **'Popular Activities'**
  String get popularActivities;

  /// No description provided for @bestOffers.
  ///
  /// In en, this message translates to:
  /// **'Best offers'**
  String get bestOffers;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @seeAllLocations.
  ///
  /// In en, this message translates to:
  /// **'See all locations'**
  String get seeAllLocations;

  /// No description provided for @seeAllActivities.
  ///
  /// In en, this message translates to:
  /// **'See all activities'**
  String get seeAllActivities;

  /// No description provided for @seeAllOffers.
  ///
  /// In en, this message translates to:
  /// **'See all offers'**
  String get seeAllOffers;

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get welcomeTo;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signInSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Sign in successful!'**
  String get signInSuccessful;

  /// No description provided for @signUpSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Sign up successful! Please sign in.'**
  String get signUpSuccessful;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @enterEmailForOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter your Email to send OTP code'**
  String get enterEmailForOtp;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @findHotels.
  ///
  /// In en, this message translates to:
  /// **'Find Hotels in Hurghada'**
  String get findHotels;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get checkOut;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @searchHotels.
  ///
  /// In en, this message translates to:
  /// **'Search Hotels'**
  String get searchHotels;

  /// No description provided for @guestsRooms.
  ///
  /// In en, this message translates to:
  /// **'Guests & Rooms'**
  String get guestsRooms;

  /// No description provided for @rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// No description provided for @adults.
  ///
  /// In en, this message translates to:
  /// **'Adults'**
  String get adults;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @pleaseSelectCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Please select check-in date'**
  String get pleaseSelectCheckIn;

  /// No description provided for @pleaseSelectCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Please select check-out date'**
  String get pleaseSelectCheckOut;

  /// No description provided for @checkOutAfterCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check-out must be after check-in'**
  String get checkOutAfterCheckIn;

  /// No description provided for @roundTrip.
  ///
  /// In en, this message translates to:
  /// **'Round Trip'**
  String get roundTrip;

  /// No description provided for @oneWay.
  ///
  /// In en, this message translates to:
  /// **'One Way'**
  String get oneWay;

  /// No description provided for @searchFlights.
  ///
  /// In en, this message translates to:
  /// **'Search Flights'**
  String get searchFlights;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departure;

  /// No description provided for @returnFlight.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnFlight;

  /// No description provided for @passengers.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get passengers;

  /// No description provided for @cabinClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get cabinClass;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @selectAirport.
  ///
  /// In en, this message translates to:
  /// **'Select airport'**
  String get selectAirport;

  /// No description provided for @direct.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get direct;

  /// No description provided for @stops.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Direct} =1{1 stop} other{{count} stops}}'**
  String stops(num count);

  /// No description provided for @perPerson.
  ///
  /// In en, this message translates to:
  /// **'per person'**
  String get perPerson;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// No description provided for @cheapest.
  ///
  /// In en, this message translates to:
  /// **'Cheapest'**
  String get cheapest;

  /// No description provided for @fastest.
  ///
  /// In en, this message translates to:
  /// **'Fastest'**
  String get fastest;

  /// No description provided for @best.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get best;

  /// No description provided for @errorNoReturnFlights.
  ///
  /// In en, this message translates to:
  /// **'Could not find return flights'**
  String get errorNoReturnFlights;

  /// No description provided for @economy.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get economy;

  /// No description provided for @business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// No description provided for @firstClass.
  ///
  /// In en, this message translates to:
  /// **'First Class'**
  String get firstClass;

  /// No description provided for @cairo.
  ///
  /// In en, this message translates to:
  /// **'Cairo'**
  String get cairo;

  /// No description provided for @hurghada.
  ///
  /// In en, this message translates to:
  /// **'Hurghada'**
  String get hurghada;

  /// No description provided for @sharmElSheikh.
  ///
  /// In en, this message translates to:
  /// **'Sharm El Sheikh'**
  String get sharmElSheikh;

  /// No description provided for @luxor.
  ///
  /// In en, this message translates to:
  /// **'Luxor'**
  String get luxor;

  /// No description provided for @aswan.
  ///
  /// In en, this message translates to:
  /// **'Aswan'**
  String get aswan;

  /// No description provided for @alexandria.
  ///
  /// In en, this message translates to:
  /// **'Alexandria'**
  String get alexandria;

  /// No description provided for @marsaAlam.
  ///
  /// In en, this message translates to:
  /// **'Marsa Alam'**
  String get marsaAlam;

  /// No description provided for @giza.
  ///
  /// In en, this message translates to:
  /// **'Giza'**
  String get giza;

  /// No description provided for @cairoAirport.
  ///
  /// In en, this message translates to:
  /// **'Cairo International Airport'**
  String get cairoAirport;

  /// No description provided for @hurghadaAirport.
  ///
  /// In en, this message translates to:
  /// **'Hurghada International Airport'**
  String get hurghadaAirport;

  /// No description provided for @sharmElSheikhAirport.
  ///
  /// In en, this message translates to:
  /// **'Sharm El Sheikh International Airport'**
  String get sharmElSheikhAirport;

  /// No description provided for @luxorAirport.
  ///
  /// In en, this message translates to:
  /// **'Luxor International Airport'**
  String get luxorAirport;

  /// No description provided for @aswanAirport.
  ///
  /// In en, this message translates to:
  /// **'Aswan International Airport'**
  String get aswanAirport;

  /// No description provided for @elNouzhaAirport.
  ///
  /// In en, this message translates to:
  /// **'El Nouzha Airport'**
  String get elNouzhaAirport;

  /// No description provided for @marsaAlamAirport.
  ///
  /// In en, this message translates to:
  /// **'Marsa Alam International Airport'**
  String get marsaAlamAirport;

  /// No description provided for @sphinxAirport.
  ///
  /// In en, this message translates to:
  /// **'Sphinx International Airport'**
  String get sphinxAirport;

  /// No description provided for @activitiesInHurghada.
  ///
  /// In en, this message translates to:
  /// **'Activities in Hurghada'**
  String get activitiesInHurghada;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @noEmailSet.
  ///
  /// In en, this message translates to:
  /// **'No email set'**
  String get noEmailSet;

  /// No description provided for @currencySettings.
  ///
  /// In en, this message translates to:
  /// **'Currency Settings'**
  String get currencySettings;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @selectRoom.
  ///
  /// In en, this message translates to:
  /// **'Select Room'**
  String get selectRoom;

  /// No description provided for @seeAvailability.
  ///
  /// In en, this message translates to:
  /// **'See Availability'**
  String get seeAvailability;

  /// No description provided for @changeSearch.
  ///
  /// In en, this message translates to:
  /// **'Change search'**
  String get changeSearch;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @completeBooking.
  ///
  /// In en, this message translates to:
  /// **'Complete Booking'**
  String get completeBooking;

  /// No description provided for @reviewBooking.
  ///
  /// In en, this message translates to:
  /// **'Review Booking'**
  String get reviewBooking;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @cancelBookingQuestion.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking?'**
  String get cancelBookingQuestion;

  /// No description provided for @cancelBookingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking?'**
  String get cancelBookingConfirmation;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @downloadPdfInvoice.
  ///
  /// In en, this message translates to:
  /// **'Download PDF Invoice'**
  String get downloadPdfInvoice;

  /// No description provided for @bookActivity.
  ///
  /// In en, this message translates to:
  /// **'Book Activity'**
  String get bookActivity;

  /// No description provided for @continueToPayment.
  ///
  /// In en, this message translates to:
  /// **'Continue to Payment'**
  String get continueToPayment;

  /// No description provided for @downloadTicket.
  ///
  /// In en, this message translates to:
  /// **'Download Ticket'**
  String get downloadTicket;

  /// No description provided for @shareBooking.
  ///
  /// In en, this message translates to:
  /// **'Share Booking'**
  String get shareBooking;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @savePreference.
  ///
  /// In en, this message translates to:
  /// **'Save Preference'**
  String get savePreference;

  /// No description provided for @aiConnectionTest.
  ///
  /// In en, this message translates to:
  /// **'AI Connection Test'**
  String get aiConnectionTest;

  /// No description provided for @testGeminiApi.
  ///
  /// In en, this message translates to:
  /// **'Test Gemini API Connection'**
  String get testGeminiApi;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @myBookingsButton.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookingsButton;

  /// No description provided for @noBookingsFound.
  ///
  /// In en, this message translates to:
  /// **'No bookings found.'**
  String get noBookingsFound;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @yesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// No description provided for @bookingConfirmationSent.
  ///
  /// In en, this message translates to:
  /// **'Confirmation sent to email and phone'**
  String get bookingConfirmationSent;

  /// No description provided for @errorHotelNotFound.
  ///
  /// In en, this message translates to:
  /// **'Hotel not found'**
  String get errorHotelNotFound;

  /// No description provided for @bookingFailed.
  ///
  /// In en, this message translates to:
  /// **'Booking failed'**
  String get bookingFailed;

  /// No description provided for @pleaseSelectDates.
  ///
  /// In en, this message translates to:
  /// **'Please select check-in and check-out dates'**
  String get pleaseSelectDates;

  /// No description provided for @hotelsIn.
  ///
  /// In en, this message translates to:
  /// **'Hotels in {searchQuery}'**
  String hotelsIn(Object searchQuery);

  /// No description provided for @errorLoadingRooms.
  ///
  /// In en, this message translates to:
  /// **'Error loading rooms'**
  String get errorLoadingRooms;

  /// No description provided for @availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// No description provided for @chooseFlight.
  ///
  /// In en, this message translates to:
  /// **'Choose Flight'**
  String get chooseFlight;

  /// No description provided for @tour.
  ///
  /// In en, this message translates to:
  /// **'Tour'**
  String get tour;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @whatsIncluded.
  ///
  /// In en, this message translates to:
  /// **'What\'s Included'**
  String get whatsIncluded;

  /// No description provided for @whatsNotIncluded.
  ///
  /// In en, this message translates to:
  /// **'What\'s Not Included'**
  String get whatsNotIncluded;

  /// No description provided for @pickupInformation.
  ///
  /// In en, this message translates to:
  /// **'Pickup Information'**
  String get pickupInformation;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @pleaseEnterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get pleaseEnterFirstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @pleaseEnterLastName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get pleaseEnterLastName;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @noRoomsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No rooms available'**
  String get noRoomsAvailable;

  /// No description provided for @idLabel.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get idLabel;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @selectRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Room'**
  String get selectRoomTitle;

  /// No description provided for @perPersonFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get perPersonFrom;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Start your journey'**
  String get searchHint;

  /// No description provided for @noRoomsFound.
  ///
  /// In en, this message translates to:
  /// **'No rooms available'**
  String get noRoomsFound;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorGeneric;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @mobilePhone.
  ///
  /// In en, this message translates to:
  /// **'Mobile Phone'**
  String get mobilePhone;

  /// No description provided for @specialRequests.
  ///
  /// In en, this message translates to:
  /// **'Special Requests (Optional)'**
  String get specialRequests;

  /// No description provided for @specialRequestsHint.
  ///
  /// In en, this message translates to:
  /// **'Any special requirements?'**
  String get specialRequestsHint;

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF Invoice'**
  String get downloadPdf;

  /// No description provided for @searchHotelsHint.
  ///
  /// In en, this message translates to:
  /// **'Search hotels...'**
  String get searchHotelsHint;

  /// No description provided for @searchPrompt.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchPrompt;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by city or airport code'**
  String get searchPlaceholder;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhone;

  /// No description provided for @selectHotel.
  ///
  /// In en, this message translates to:
  /// **'Select your hotel'**
  String get selectHotel;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password Updated Successfully!'**
  String get passwordUpdated;

  /// No description provided for @noRoomsAvailableDates.
  ///
  /// In en, this message translates to:
  /// **'No rooms available for these dates.'**
  String get noRoomsAvailableDates;

  /// No description provided for @invalidOfferData.
  ///
  /// In en, this message translates to:
  /// **'Error: Invalid offer data'**
  String get invalidOfferData;

  /// No description provided for @confirmPay.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Pay'**
  String get confirmPay;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @freeCancellation.
  ///
  /// In en, this message translates to:
  /// **'Free cancellation available'**
  String get freeCancellation;

  /// No description provided for @reserveNowPayLater.
  ///
  /// In en, this message translates to:
  /// **'Reserve now & pay later'**
  String get reserveNowPayLater;

  /// No description provided for @updateSearch.
  ///
  /// In en, this message translates to:
  /// **'Update Search'**
  String get updateSearch;

  /// No description provided for @maxGuests.
  ///
  /// In en, this message translates to:
  /// **'Max {count} guests'**
  String maxGuests(Object count);

  /// No description provided for @perNight.
  ///
  /// In en, this message translates to:
  /// **'per night'**
  String get perNight;

  /// No description provided for @totalPriceWithNights.
  ///
  /// In en, this message translates to:
  /// **'total for {nights} night{nights, plural, =1{} other{s}}'**
  String totalPriceWithNights(num nights);

  /// No description provided for @stayDurationFormat.
  ///
  /// In en, this message translates to:
  /// **'for {nights} night{nights, plural, =1{} other{s}}, {adults} adults'**
  String stayDurationFormat(Object adults, num nights);

  /// No description provided for @reserve.
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get reserve;

  /// No description provided for @tooSmall.
  ///
  /// In en, this message translates to:
  /// **'Too Small'**
  String get tooSmall;

  /// No description provided for @needsCapacity.
  ///
  /// In en, this message translates to:
  /// **'Needs {count} capacity per room'**
  String needsCapacity(Object count);

  /// No description provided for @privateBathroom.
  ///
  /// In en, this message translates to:
  /// **'Private bathroom'**
  String get privateBathroom;

  /// No description provided for @airConditioning.
  ///
  /// In en, this message translates to:
  /// **'Air conditioning'**
  String get airConditioning;

  /// No description provided for @startingFrom.
  ///
  /// In en, this message translates to:
  /// **'Starting from'**
  String get startingFrom;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @facilities.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilities;

  /// No description provided for @noHotelsFound.
  ///
  /// In en, this message translates to:
  /// **'No hotels found'**
  String get noHotelsFound;

  /// No description provided for @adjustSearchCriteria.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search criteria'**
  String get adjustSearchCriteria;

  /// No description provided for @errorLoadingHotels.
  ///
  /// In en, this message translates to:
  /// **'Error loading hotels'**
  String get errorLoadingHotels;

  /// No description provided for @guestInfoBannerFormat.
  ///
  /// In en, this message translates to:
  /// **'You need rooms for {total} guest{total, plural, =1{} other{s}} ({rooms} room{rooms, plural, =1{} other{s}} × {perRoom} guest{perRoom, plural, =1{} other{s}}/room)'**
  String guestInfoBannerFormat(num perRoom, num rooms, num total);

  /// No description provided for @selectDates.
  ///
  /// In en, this message translates to:
  /// **'Select Dates'**
  String get selectDates;

  /// No description provided for @searchSummaryFormat.
  ///
  /// In en, this message translates to:
  /// **'{adults} adults · {children} children · {rooms} room{rooms, plural, =1{} other{s}}'**
  String searchSummaryFormat(Object adults, Object children, num rooms);

  /// No description provided for @aboutThisProperty.
  ///
  /// In en, this message translates to:
  /// **'About This Property'**
  String get aboutThisProperty;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @readLess.
  ///
  /// In en, this message translates to:
  /// **'Read less'**
  String get readLess;

  /// No description provided for @guestsLoveLocation.
  ///
  /// In en, this message translates to:
  /// **'Guests love the location and amenities!'**
  String get guestsLoveLocation;

  /// No description provided for @mostPopularFacilities.
  ///
  /// In en, this message translates to:
  /// **'Most Popular Facilities'**
  String get mostPopularFacilities;

  /// No description provided for @viewAllAmenities.
  ///
  /// In en, this message translates to:
  /// **'View all amenities'**
  String get viewAllAmenities;

  /// No description provided for @nextStepPayment.
  ///
  /// In en, this message translates to:
  /// **'Next Step: Payment'**
  String get nextStepPayment;

  /// No description provided for @enterYourDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter your details'**
  String get enterYourDetails;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @fromTime.
  ///
  /// In en, this message translates to:
  /// **'From {time}'**
  String fromTime(Object time);

  /// No description provided for @untilTime.
  ///
  /// In en, this message translates to:
  /// **'Until {time}'**
  String untilTime(Object time);

  /// No description provided for @totalLengthOfStay.
  ///
  /// In en, this message translates to:
  /// **'Total length of stay: {nights} night{nights, plural, =1{} other{s}}'**
  String totalLengthOfStay(num nights);

  /// No description provided for @youSelected.
  ///
  /// In en, this message translates to:
  /// **'You selected:'**
  String get youSelected;

  /// No description provided for @priceSummary.
  ///
  /// In en, this message translates to:
  /// **'Price Summary'**
  String get priceSummary;

  /// No description provided for @originalPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Original Price'**
  String get originalPriceLabel;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed!'**
  String get bookingConfirmed;

  /// No description provided for @reservationSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your reservation has been successfully confirmed'**
  String get reservationSuccessMessage;

  /// No description provided for @accommodation.
  ///
  /// In en, this message translates to:
  /// **'Accommodation'**
  String get accommodation;

  /// No description provided for @hotel.
  ///
  /// In en, this message translates to:
  /// **'Hotel'**
  String get hotel;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @stayDetails.
  ///
  /// In en, this message translates to:
  /// **'Stay Details'**
  String get stayDetails;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @bookingIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Booking ID'**
  String get bookingIdLabel;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @payAtHotel.
  ///
  /// In en, this message translates to:
  /// **'Pay at Hotel'**
  String get payAtHotel;

  /// No description provided for @noPrepaymentNeeded.
  ///
  /// In en, this message translates to:
  /// **'No prepayment needed'**
  String get noPrepaymentNeeded;

  /// No description provided for @creditOrDebitCard.
  ///
  /// In en, this message translates to:
  /// **'Credit or Debit Card'**
  String get creditOrDebitCard;

  /// No description provided for @cardAcceptedBrands.
  ///
  /// In en, this message translates to:
  /// **'Visa, Mastercard, Amex'**
  String get cardAcceptedBrands;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @cardholderName.
  ///
  /// In en, this message translates to:
  /// **'Cardholder Name'**
  String get cardholderName;

  /// No description provided for @expiryDateHint.
  ///
  /// In en, this message translates to:
  /// **'MM/YY'**
  String get expiryDateHint;

  /// No description provided for @cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @taxesAndCharges.
  ///
  /// In en, this message translates to:
  /// **'+ \${amount} taxes and charges'**
  String taxesAndCharges(Object amount);

  /// No description provided for @breakfastIncluded.
  ///
  /// In en, this message translates to:
  /// **'Breakfast included'**
  String get breakfastIncluded;

  /// No description provided for @roomCapacityWarning.
  ///
  /// In en, this message translates to:
  /// **'This room can only accommodate {capacity} guest{capacity, plural, =1{} other{s}}, but you need {needed} guest{needed, plural, =1{} other{s}} per room'**
  String roomCapacityWarning(num capacity, num needed);

  /// No description provided for @nightsCountFormat.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 night} other{{count} nights}}'**
  String nightsCountFormat(num count);

  /// No description provided for @guestsCountFormat.
  ///
  /// In en, this message translates to:
  /// **'{adults} {adults, plural, =1{Adult} other{Adults}}, {children} {children, plural, =1{Child} other{Children}}'**
  String guestsCountFormat(num adults, num children);

  /// No description provided for @roomsCountFormat.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Room} other{{count} Rooms}}'**
  String roomsCountFormat(num count);

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @landingTagline.
  ///
  /// In en, this message translates to:
  /// **'Start Your Journey With Us Now!'**
  String get landingTagline;

  /// No description provided for @socialSignInPrefix.
  ///
  /// In en, this message translates to:
  /// **'You can sign up with :'**
  String get socialSignInPrefix;

  /// No description provided for @allInclusive.
  ///
  /// In en, this message translates to:
  /// **'All-inclusive'**
  String get allInclusive;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Error occurred: {error}'**
  String errorOccurred(Object error);

  /// No description provided for @welcomeBackComma.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBackComma;

  /// No description provided for @availableWithWarning.
  ///
  /// In en, this message translates to:
  /// **'Available (with warning)'**
  String get availableWithWarning;

  /// No description provided for @childrenMayShareBeds.
  ///
  /// In en, this message translates to:
  /// **'Children may share beds'**
  String get childrenMayShareBeds;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
