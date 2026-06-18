import 'package:flutter/foundation.dart';
import 'package:go_hurghada/features/booking/domain/models/booking.dart';

/// Abstract interface for notification services
abstract class NotificationService {
  Future<void> sendBookingConfirmation(Booking booking);
}

/// Email notification service
///
/// Development: Prints to console
/// Production: Integrate with SendGrid, AWS SES, or similar
class EmailNotificationService implements NotificationService {
  @override
  Future<void> sendBookingConfirmation(Booking booking) async {
    // Stub for email sending
    final isActivity = booking.type == BookingType.activity;
    debugPrint('📧 Email sent to: ${booking.guestEmail}');
    debugPrint('---');
    debugPrint('Dear ${booking.guestName},');
    if (isActivity) {
      debugPrint(
        'Your booking for ${booking.activityName} has been confirmed!',
      );
      debugPrint('Date: ${booking.selectedDate.toString().split(' ')[0]}');
    } else {
      debugPrint('Your booking at ${booking.hotelName} has been confirmed!');
      debugPrint('Check-in: ${booking.checkInDate.toString().split(' ')[0]}');
      debugPrint('Check-out: ${booking.checkOutDate.toString().split(' ')[0]}');
    }
    debugPrint('Total: \$${booking.totalPrice.toStringAsFixed(2)}');
    debugPrint('---');

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

/// SMS notification service
///
/// Development: Prints to console
/// Production: Integrate with Twilio, AWS SNS, or similar
class SMSNotificationService implements NotificationService {
  @override
  Future<void> sendBookingConfirmation(Booking booking) async {
    // Stub for SMS sending
    // In production: integrate with Twilio, AWS SNS, or similar
    final message =
        'Your booking #${booking.id.substring(0, 8)} at ${booking.hotelName} is confirmed! Check-in: ${booking.checkInDate.toString().split(' ')[0]}';

    debugPrint('📱 SMS sent to: ${booking.guestPhone}');
    debugPrint('Message: $message');

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

/// Production-ready SendGrid email service (commented out for now)
/// 
/// To use: 
/// 1. Add http package to pubspec.yaml
/// 2. Get SendGrid API key
/// 3. Uncomment and configure
/*
import 'dart:convert';
import 'package:http/http.dart' as http;

class SendGridEmailService implements NotificationService {
  final String apiKey;
  
  SendGridEmailService({required this.apiKey});
  
  @override
  Future<void> sendBookingConfirmation(Booking booking) async {
    final response = await http.post(
      Uri.parse('https://api.sendgrid.com/v3/mail/send'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'personalizations': [{
          'to': [{'email': booking.guestEmail}],
        }],
        'from': {'email': 'bookings@gohurghada.com'},
        'subject': 'Booking Confirmation #${booking.id.substring(0, 8)}',
        'content': [{
          'type': 'text/html',
          'value': _buildEmailTemplate(booking),
        }],
      }),
    );
    
    if (response.statusCode != 202) {
      throw Exception('Failed to send email: ${response.body}');
    }
  }
}
*/
