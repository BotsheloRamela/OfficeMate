import 'package:json_annotation/json_annotation.dart';

part 'office.g.dart';

@JsonSerializable()
class Office {
  final String name;
  final String location;
  final int officeCapacity;
  final int officeColorId;
  final String officeId;
  final String email;
  final String phone;

  Office({
    required this.name,
    required this.location,
    required this.officeCapacity,
    required this.officeColorId,
    required this.officeId,
    required this.email,
    required this.phone
  });

  factory Office.fromJson(Map<String, dynamic> json) => _$OfficeFromJson(json);

  Map<String, dynamic> toJson() => _$OfficeToJson(this);
}