// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTitle => 'Settings';

  @override
  String get privacySecurity => 'Privacy & Security';

  @override
  String get locationAccess => 'Location Access';

  @override
  String get locationAccessSubtitle =>
      'Enable location access to get local offers';

  @override
  String get shareThirdParties => 'Share with Third Parties';

  @override
  String get shareThirdPartiesSubtitle =>
      'Allow sharing data with app partners to improve offers and services';

  @override
  String get themeTitle => 'Themes';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get offersPromotions => 'Offers and Promotions';

  @override
  String get offersPromotionsSubtitle =>
      'Get notified about exclusive offers, discounts, and travel deals';

  @override
  String get reminders => 'Reminders';

  @override
  String get remindersSubtitle => 'Receive reminders for your upcoming trips';

  @override
  String get silentMode => 'Silent Mode';

  @override
  String get silentModeSubtitle =>
      'Mute all notifications except critical alerts';

  @override
  String get generalTitle => 'General';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get categoryFlight => 'Flight';

  @override
  String get categoryHotel => 'Hotel';

  @override
  String get categoryActivities => 'Activities';

  @override
  String get locationElGouna => 'El Gouna';

  @override
  String get locationMakadiBay => 'Makadi Bay';

  @override
  String get locationSomaBay => 'Soma Bay';

  @override
  String get locationSahlHasheesh => 'Sahl Hasheesh';

  @override
  String get activityScubaDiving => 'Scuba Diving';

  @override
  String get activityDesertSafari => 'Desert Safari';

  @override
  String get activityCityTours => 'City Tours';

  @override
  String get activityWaterSports => 'Water Sports';

  @override
  String get navHome => 'Home';

  @override
  String get navSaved => 'Saved';

  @override
  String get navSupport => 'Support';

  @override
  String get navProfile => 'Profile';

  @override
  String get navMyBookings => 'My Bookings';

  @override
  String get onboard1Title =>
      'Discover the beauty\nof your country step\nby step';

  @override
  String get onboard1Subtitle =>
      'Through our app, you\'ll explore new places within your country — from beaches and natural wonders to historical sites.';

  @override
  String get onboard2Title => 'Travel made easy\nbook and go!';

  @override
  String get onboard2Subtitle =>
      'Book flights, hotels, and local tours all in one app. Your next adventure starts here.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get selectCurrency => 'Select currency';

  @override
  String get selectCurrencyDescription =>
      'Select your preferred currency for pricing and transactions.';

  @override
  String get egyptianPound => 'Egyptian Pound';

  @override
  String get uaeDirham => 'United Arab Emirates Dirham';

  @override
  String get usDollar => 'United States Dollar';

  @override
  String get euro => 'Euro';

  @override
  String get popularDestinations => 'Popular Hurghada Destinations';

  @override
  String get popularActivities => 'Popular Activities';

  @override
  String get bestOffers => 'Best offers';

  @override
  String get seeAll => 'See all';

  @override
  String get seeAllLocations => 'See all locations';

  @override
  String get seeAllActivities => 'See all activities';

  @override
  String get seeAllOffers => 'See all offers';

  @override
  String get welcomeTo => 'Welcome to';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get emailAddress => 'Email address';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signInSuccessful => 'Sign in successful!';

  @override
  String get signUpSuccessful => 'Sign up successful! Please sign in.';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get enterEmailForOtp => 'Enter your Email to send OTP code';

  @override
  String get next => 'Next';

  @override
  String get findHotels => 'Find Hotels in Hurghada';

  @override
  String get location => 'Location';

  @override
  String get checkIn => 'Check-in';

  @override
  String get checkOut => 'Check-out';

  @override
  String get selectDate => 'Select Date';

  @override
  String get searchHotels => 'Search Hotels';

  @override
  String get guestsRooms => 'Guests & Rooms';

  @override
  String get rooms => 'Rooms';

  @override
  String get adults => 'Adults';

  @override
  String get children => 'Children';

  @override
  String get pleaseSelectCheckIn => 'Please select check-in date';

  @override
  String get pleaseSelectCheckOut => 'Please select check-out date';

  @override
  String get checkOutAfterCheckIn => 'Check-out must be after check-in';

  @override
  String get roundTrip => 'Round Trip';

  @override
  String get oneWay => 'One Way';

  @override
  String get searchFlights => 'Search Flights';

  @override
  String get departure => 'Departure';

  @override
  String get returnFlight => 'Return';

  @override
  String get passengers => 'Passengers';

  @override
  String get cabinClass => 'Class';

  @override
  String get to => 'To';

  @override
  String get selectAirport => 'Select airport';

  @override
  String get direct => 'Direct';

  @override
  String stops(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stops',
      one: '1 stop',
      zero: 'Direct',
    );
    return '$_temp0';
  }

  @override
  String get perPerson => 'per person';

  @override
  String get total => 'Total';

  @override
  String get book => 'Book';

  @override
  String get cheapest => 'Cheapest';

  @override
  String get fastest => 'Fastest';

  @override
  String get best => 'Best';

  @override
  String get errorNoReturnFlights => 'Could not find return flights';

  @override
  String get economy => 'Economy';

  @override
  String get business => 'Business';

  @override
  String get firstClass => 'First Class';

  @override
  String get cairo => 'Cairo';

  @override
  String get hurghada => 'Hurghada';

  @override
  String get sharmElSheikh => 'Sharm El Sheikh';

  @override
  String get luxor => 'Luxor';

  @override
  String get aswan => 'Aswan';

  @override
  String get alexandria => 'Alexandria';

  @override
  String get marsaAlam => 'Marsa Alam';

  @override
  String get giza => 'Giza';

  @override
  String get cairoAirport => 'Cairo International Airport';

  @override
  String get hurghadaAirport => 'Hurghada International Airport';

  @override
  String get sharmElSheikhAirport => 'Sharm El Sheikh International Airport';

  @override
  String get luxorAirport => 'Luxor International Airport';

  @override
  String get aswanAirport => 'Aswan International Airport';

  @override
  String get elNouzhaAirport => 'El Nouzha Airport';

  @override
  String get marsaAlamAirport => 'Marsa Alam International Airport';

  @override
  String get sphinxAirport => 'Sphinx International Airport';

  @override
  String get activitiesInHurghada => 'Activities in Hurghada';

  @override
  String get myAccount => 'My Account';

  @override
  String get guestUser => 'Guest User';

  @override
  String get noEmailSet => 'No email set';

  @override
  String get currencySettings => 'Currency Settings';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get logOut => 'Log out';

  @override
  String get selectRoom => 'Select Room';

  @override
  String get seeAvailability => 'See Availability';

  @override
  String get changeSearch => 'Change search';

  @override
  String get goBack => 'Go Back';

  @override
  String get completeBooking => 'Complete Booking';

  @override
  String get reviewBooking => 'Review Booking';

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String get myBookings => 'My Bookings';

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String get cancelBookingQuestion => 'Cancel Booking?';

  @override
  String get cancelBookingConfirmation =>
      'Are you sure you want to cancel this booking?';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get downloadPdfInvoice => 'Download PDF Invoice';

  @override
  String get bookActivity => 'Book Activity';

  @override
  String get continueToPayment => 'Continue to Payment';

  @override
  String get downloadTicket => 'Download Ticket';

  @override
  String get shareBooking => 'Share Booking';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get savePreference => 'Save Preference';

  @override
  String get aiConnectionTest => 'AI Connection Test';

  @override
  String get testGeminiApi => 'Test Gemini API Connection';

  @override
  String get retry => 'Retry';

  @override
  String get myBookingsButton => 'My Bookings';

  @override
  String get noBookingsFound => 'No bookings found.';

  @override
  String get cancel => 'Cancel';

  @override
  String get yesCancel => 'Yes, Cancel';

  @override
  String get bookingConfirmationSent => 'Confirmation sent to email and phone';

  @override
  String get errorHotelNotFound => 'Hotel not found';

  @override
  String get bookingFailed => 'Booking failed';

  @override
  String get pleaseSelectDates => 'Please select check-in and check-out dates';

  @override
  String hotelsIn(Object searchQuery) {
    return 'Hotels in $searchQuery';
  }

  @override
  String get errorLoadingRooms => 'Error loading rooms';

  @override
  String get availability => 'Availability';

  @override
  String get chooseFlight => 'Choose Flight';

  @override
  String get tour => 'Tour';

  @override
  String get description => 'Description';

  @override
  String get showMore => 'Show more';

  @override
  String get showLess => 'Show less';

  @override
  String get whatsIncluded => 'What\'s Included';

  @override
  String get whatsNotIncluded => 'What\'s Not Included';

  @override
  String get pickupInformation => 'Pickup Information';

  @override
  String get firstName => 'First Name';

  @override
  String get pleaseEnterFirstName => 'Please enter your first name';

  @override
  String get lastName => 'Last Name';

  @override
  String get pleaseEnterLastName => 'Please enter your last name';

  @override
  String get from => 'From';

  @override
  String get noRoomsAvailable => 'No rooms available';

  @override
  String get idLabel => 'ID';

  @override
  String get locationLabel => 'Location';

  @override
  String get priceLabel => 'Price';

  @override
  String get selectRoomTitle => 'Select Room';

  @override
  String get perPersonFrom => 'From';

  @override
  String get searchHint => 'Start your journey';

  @override
  String get noRoomsFound => 'No rooms available';

  @override
  String get errorGeneric => 'Error';

  @override
  String get fullName => 'Full Name';

  @override
  String get mobilePhone => 'Mobile Phone';

  @override
  String get specialRequests => 'Special Requests (Optional)';

  @override
  String get specialRequestsHint => 'Any special requirements?';

  @override
  String get downloadPdf => 'Download PDF Invoice';

  @override
  String get searchHotelsHint => 'Search hotels...';

  @override
  String get searchPrompt => 'Search';

  @override
  String get searchPlaceholder => 'Search by city or airport code';

  @override
  String get enterFullName => 'Enter your full name';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get enterPhone => 'Enter your phone number';

  @override
  String get selectHotel => 'Select your hotel';

  @override
  String get passwordUpdated => 'Password Updated Successfully!';

  @override
  String get noRoomsAvailableDates => 'No rooms available for these dates.';

  @override
  String get invalidOfferData => 'Error: Invalid offer data';

  @override
  String get confirmPay => 'Confirm & Pay';

  @override
  String get bookNow => 'Book Now';

  @override
  String get freeCancellation => 'Free cancellation available';

  @override
  String get reserveNowPayLater => 'Reserve now & pay later';

  @override
  String get updateSearch => 'Update Search';

  @override
  String maxGuests(Object count) {
    return 'Max $count guests';
  }

  @override
  String get perNight => 'per night';

  @override
  String totalPriceWithNights(num nights) {
    String _temp0 = intl.Intl.pluralLogic(
      nights,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'total for $nights night$_temp0';
  }

  @override
  String stayDurationFormat(Object adults, num nights) {
    String _temp0 = intl.Intl.pluralLogic(
      nights,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'for $nights night$_temp0, $adults adults';
  }

  @override
  String get reserve => 'Reserve';

  @override
  String get tooSmall => 'Too Small';

  @override
  String needsCapacity(Object count) {
    return 'Needs $count capacity per room';
  }

  @override
  String get privateBathroom => 'Private bathroom';

  @override
  String get airConditioning => 'Air conditioning';

  @override
  String get startingFrom => 'Starting from';

  @override
  String get viewDetails => 'View Details';

  @override
  String get facilities => 'Facilities';

  @override
  String get noHotelsFound => 'No hotels found';

  @override
  String get adjustSearchCriteria => 'Try adjusting your search criteria';

  @override
  String get errorLoadingHotels => 'Error loading hotels';

  @override
  String guestInfoBannerFormat(num perRoom, num rooms, num total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: 's',
      one: '',
    );
    String _temp1 = intl.Intl.pluralLogic(
      rooms,
      locale: localeName,
      other: 's',
      one: '',
    );
    String _temp2 = intl.Intl.pluralLogic(
      perRoom,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'You need rooms for $total guest$_temp0 ($rooms room$_temp1 × $perRoom guest$_temp2/room)';
  }

  @override
  String get selectDates => 'Select Dates';

  @override
  String searchSummaryFormat(Object adults, Object children, num rooms) {
    String _temp0 = intl.Intl.pluralLogic(
      rooms,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$adults adults · $children children · $rooms room$_temp0';
  }

  @override
  String get aboutThisProperty => 'About This Property';

  @override
  String get readMore => 'Read more';

  @override
  String get readLess => 'Read less';

  @override
  String get guestsLoveLocation => 'Guests love the location and amenities!';

  @override
  String get mostPopularFacilities => 'Most Popular Facilities';

  @override
  String get viewAllAmenities => 'View all amenities';

  @override
  String get nextStepPayment => 'Next Step: Payment';

  @override
  String get enterYourDetails => 'Enter your details';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get pleaseEnterPhoneNumber => 'Please enter your phone number';

  @override
  String fromTime(Object time) {
    return 'From $time';
  }

  @override
  String untilTime(Object time) {
    return 'Until $time';
  }

  @override
  String totalLengthOfStay(num nights) {
    String _temp0 = intl.Intl.pluralLogic(
      nights,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'Total length of stay: $nights night$_temp0';
  }

  @override
  String get youSelected => 'You selected:';

  @override
  String get priceSummary => 'Price Summary';

  @override
  String get originalPriceLabel => 'Original Price';

  @override
  String get discount => 'Discount';

  @override
  String get bookingConfirmed => 'Booking Confirmed!';

  @override
  String get reservationSuccessMessage =>
      'Your reservation has been successfully confirmed';

  @override
  String get accommodation => 'Accommodation';

  @override
  String get hotel => 'Hotel';

  @override
  String get room => 'Room';

  @override
  String get stayDetails => 'Stay Details';

  @override
  String get duration => 'Duration';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get notSet => 'Not set';

  @override
  String get bookingIdLabel => 'Booking ID';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get payAtHotel => 'Pay at Hotel';

  @override
  String get noPrepaymentNeeded => 'No prepayment needed';

  @override
  String get creditOrDebitCard => 'Credit or Debit Card';

  @override
  String get cardAcceptedBrands => 'Visa, Mastercard, Amex';

  @override
  String get cardNumber => 'Card Number';

  @override
  String get cardholderName => 'Cardholder Name';

  @override
  String get expiryDateHint => 'MM/YY';

  @override
  String get cvv => 'CVV';

  @override
  String taxesAndCharges(Object amount) {
    return '+ \$$amount taxes and charges';
  }

  @override
  String get breakfastIncluded => 'Breakfast included';

  @override
  String roomCapacityWarning(num capacity, num needed) {
    String _temp0 = intl.Intl.pluralLogic(
      capacity,
      locale: localeName,
      other: 's',
      one: '',
    );
    String _temp1 = intl.Intl.pluralLogic(
      needed,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'This room can only accommodate $capacity guest$_temp0, but you need $needed guest$_temp1 per room';
  }

  @override
  String nightsCountFormat(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nights',
      one: '1 night',
    );
    return '$_temp0';
  }

  @override
  String guestsCountFormat(num adults, num children) {
    String _temp0 = intl.Intl.pluralLogic(
      adults,
      locale: localeName,
      other: 'Adults',
      one: 'Adult',
    );
    String _temp1 = intl.Intl.pluralLogic(
      children,
      locale: localeName,
      other: 'Children',
      one: 'Child',
    );
    return '$adults $_temp0, $children $_temp1';
  }

  @override
  String roomsCountFormat(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Rooms',
      one: '1 Room',
    );
    return '$_temp0';
  }

  @override
  String get aboutSection => 'About';

  @override
  String get landingTagline => 'Start Your Journey With Us Now!';

  @override
  String get socialSignInPrefix => 'You can sign up with :';

  @override
  String get allInclusive => 'All-inclusive';

  @override
  String errorOccurred(Object error) {
    return 'Error occurred: $error';
  }

  @override
  String get welcomeBackComma => 'Welcome back,';

  @override
  String get availableWithWarning => 'Available (with warning)';

  @override
  String get childrenMayShareBeds => 'Children may share beds';
}
