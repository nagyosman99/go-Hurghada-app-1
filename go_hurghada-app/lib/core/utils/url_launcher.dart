import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  static Future<bool> launchURL(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  static Future<bool> launchBookingUrl(String bookingUrl) async {
    return await launchURL(bookingUrl);
  }
}
