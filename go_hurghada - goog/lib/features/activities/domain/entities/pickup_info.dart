import 'package:equatable/equatable.dart';

class PickupInfo extends Equatable {
  final String timeWindow;
  final List<String> locations;
  final String contactMethod;
  final String contactTiming;

  const PickupInfo({
    required this.timeWindow,
    required this.locations,
    required this.contactMethod,
    required this.contactTiming,
  });

  Map<String, dynamic> toJson() {
    return {
      'timeWindow': timeWindow,
      'locations': locations,
      'contactMethod': contactMethod,
      'contactTiming': contactTiming,
    };
  }

  factory PickupInfo.fromJson(Map<String, dynamic> json) {
    return PickupInfo(
      timeWindow: json['timeWindow'] ?? '',
      locations: List<String>.from(json['locations'] ?? []),
      contactMethod: json['contactMethod'] ?? '',
      contactTiming: json['contactTiming'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
    timeWindow,
    locations,
    contactMethod,
    contactTiming,
  ];
}
