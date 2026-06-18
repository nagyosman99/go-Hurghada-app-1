import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:go_hurghada/features/booking/domain/models/booking.dart';

/// PDF invoice generation service
///
/// Generates professional PDF invoices for hotel bookings
class PDFService {
  /// Generate PDF invoice for a booking
  Future<pw.Document> _generatePDF(Booking booking) async {
    final pdf = pw.Document();
    final isActivity = booking.type == BookingType.activity;

    // Calculate nights (only for hotels)
    final nights = !isActivity
        ? (booking.checkOutDate ?? DateTime.now())
              .difference(booking.checkInDate ?? DateTime.now())
              .inDays
        : 0;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.only(bottom: 20),
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(
                      width: 2,
                      color: PdfColor.fromInt(0xFF0066FF),
                    ),
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'BOOKING CONFIRMATION',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromInt(0xFF0044AA),
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Go Hurghada',
                          style: const pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Booking ID',
                          style: const pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.Text(
                          '#${booking.id.substring(0, 8).toUpperCase()}',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Date: ${booking.createdAt.toString().split(' ')[0]}',
                          style: const pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // Guest Information
              pw.Text(
                'Guest Information',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(0xFF0044AA),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Name', booking.guestName),
                    pw.SizedBox(height: 5),
                    _buildInfoRow('Email', booking.guestEmail),
                    pw.SizedBox(height: 5),
                    _buildInfoRow('Phone', booking.guestPhone),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Booking Details
              pw.Text(
                isActivity ? 'Activity Details' : 'Booking Details',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(0xFF0044AA),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (isActivity) ...[
                      _buildInfoRow('Activity', booking.activityName ?? ''),
                      pw.SizedBox(height: 5),
                      _buildInfoRow(
                        'Date',
                        booking.selectedDate.toString().split(' ')[0],
                      ),
                      pw.SizedBox(height: 5),
                      _buildInfoRow('Persons', booking.persons.toString()),
                      if (booking.pickupLocation != null &&
                          booking.pickupLocation!.isNotEmpty) ...[
                        pw.SizedBox(height: 5),
                        _buildInfoRow('Pickup', booking.pickupLocation!),
                      ],
                    ] else ...[
                      _buildInfoRow('Hotel', booking.hotelName ?? ''),
                      pw.SizedBox(height: 5),
                      _buildInfoRow('Room Type', booking.roomName ?? ''),
                      pw.SizedBox(height: 5),
                      _buildInfoRow(
                        'Check-in',
                        booking.checkInDate.toString().split(' ')[0],
                      ),
                      pw.SizedBox(height: 5),
                      _buildInfoRow(
                        'Check-out',
                        booking.checkOutDate.toString().split(' ')[0],
                      ),
                      pw.SizedBox(height: 5),
                      _buildInfoRow(
                        'Duration',
                        '$nights night${nights != 1 ? 's' : ''}',
                      ),
                    ],
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Price Summary
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFEEF5FF),
                  borderRadius: pw.BorderRadius.circular(5),
                  border: pw.Border.all(
                    color: PdfColor.fromInt(0xFFCCE0FF),
                    width: 1,
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Amount',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      '\$${booking.totalPrice.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xFF0066FF),
                      ),
                    ),
                  ],
                ),
              ),

              pw.Spacer(),

              // Footer
              pw.Container(
                padding: const pw.EdgeInsets.only(top: 20),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    top: pw.BorderSide(width: 1, color: PdfColors.grey300),
                  ),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Thank you for booking with Go Hurghada!',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xFF0044AA),
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'We look forward to welcoming you to Hurghada',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  /// Helper to build info rows in PDF
  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      children: [
        pw.Container(
          width: 100,
          child: pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  /// Save PDF to device storage
  Future<String> generateBookingInvoice(Booking booking) async {
    final pdf = await _generatePDF(booking);

    // Get documents directory
    final output = await getApplicationDocumentsDirectory();
    final file = File(
      '${output.path}/booking_${booking.id.substring(0, 8)}.pdf',
    );

    // Save PDF
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  /// Share PDF invoice via system share dialog
  Future<void> shareBookingInvoice(Booking booking) async {
    final pdf = await _generatePDF(booking);
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'booking_${booking.id.substring(0, 8)}.pdf',
    );
  }

  /// Print PDF invoice
  Future<void> printBookingInvoice(Booking booking) async {
    final pdf = await _generatePDF(booking);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  /// Generate PDF ticket for an activity
  Future<pw.Document> _generateActivityPDF({
    required String bookingId,
    required String activityTitle,
    required DateTime date,
    required int persons,
    required double totalPrice,
    required String userName,
    required String userEmail,
    required String userPhone,
    required String pickupLocation,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.only(bottom: 20),
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(
                      width: 2,
                      color: PdfColor.fromInt(0xFF0066FF),
                    ),
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'ACTIVITY TICKET',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromInt(0xFF0044AA),
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Go Hurghada',
                          style: const pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Booking ID',
                          style: const pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.Text(
                          '#${bookingId.substring(0, 8).toUpperCase()}',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Date: ${DateTime.now().toString().split(' ')[0]}',
                          style: const pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // Activity Information
              pw.Text(
                'Activity Information',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(0xFF0044AA),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Activity', activityTitle),
                    pw.SizedBox(height: 5),
                    _buildInfoRow('Date', date.toString().split(' ')[0]),
                    pw.SizedBox(height: 5),
                    _buildInfoRow('Persons', persons.toString()),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Guest & Pickup
              pw.Text(
                'Guest & Pickup Details',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(0xFF0044AA),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Name', userName),
                    pw.SizedBox(height: 5),
                    _buildInfoRow('Phone', userPhone),
                    pw.SizedBox(height: 5),
                    _buildInfoRow('Pickup', pickupLocation),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Price Summary
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFEEF5FF),
                  borderRadius: pw.BorderRadius.circular(5),
                  border: pw.Border.all(
                    color: PdfColor.fromInt(0xFFCCE0FF),
                    width: 1,
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Price',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xFF0066FF),
                      ),
                    ),
                  ],
                ),
              ),

              pw.Spacer(),

              // Footer
              pw.Container(
                padding: const pw.EdgeInsets.only(top: 20),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    top: pw.BorderSide(width: 1, color: PdfColors.grey300),
                  ),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'This is your official ticket. Please show it at the pickup.',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xFF0044AA),
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Thank you for booking with Go Hurghada!',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  /// Share Activity Ticket
  Future<void> shareActivityTicket({
    required String bookingId,
    required String activityTitle,
    required DateTime date,
    required int persons,
    required double totalPrice,
    required String userName,
    required String userEmail,
    required String userPhone,
    required String pickupLocation,
  }) async {
    final pdf = await _generateActivityPDF(
      bookingId: bookingId,
      activityTitle: activityTitle,
      date: date,
      persons: persons,
      totalPrice: totalPrice,
      userName: userName,
      userEmail: userEmail,
      userPhone: userPhone,
      pickupLocation: pickupLocation,
    );
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'activity_ticket_${bookingId.substring(0, 8)}.pdf',
    );
  }

  /// Print Activity Ticket
  Future<void> printActivityTicket({
    required String bookingId,
    required String activityTitle,
    required DateTime date,
    required int persons,
    required double totalPrice,
    required String userName,
    required String userEmail,
    required String userPhone,
    required String pickupLocation,
  }) async {
    final pdf = await _generateActivityPDF(
      bookingId: bookingId,
      activityTitle: activityTitle,
      date: date,
      persons: persons,
      totalPrice: totalPrice,
      userName: userName,
      userEmail: userEmail,
      userPhone: userPhone,
      pickupLocation: pickupLocation,
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
