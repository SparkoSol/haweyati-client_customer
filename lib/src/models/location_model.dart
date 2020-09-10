import 'package:hive/hive.dart';
import 'package:haweyati/src/common/models/json_serializable.dart';

@HiveType(typeId: 103)
class Location extends HiveObject implements JsonSerializable {
  @HiveField(0) String city;
  @HiveField(1) String address;
  @HiveField(2) double latitude;
  @HiveField(3) double longitude;

  Location({
    this.city,
    this.address,
    this.latitude,
    this.longitude
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      city: json['city'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude']
    );
  }

  @override
  Map<String, dynamic> serialize() => {
    'city': city,
    'address': address,
    'latitude': latitude,
    'longitude': longitude
  };
}