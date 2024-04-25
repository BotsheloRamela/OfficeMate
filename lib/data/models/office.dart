import 'package:json_annotation/json_annotation.dart';
import 'package:office_mate/data/models/office_worker.dart';

part 'office.g.dart';

@JsonSerializable()
class Office {
  final String name;
  final String location;
  final int occupantsCount;
  final int officeCapacity;
  final String officeColor;
  final String officeId;
  final String email;
  final String phone;
  final List<OfficeWorker> workers;

  Office({
    required this.name,
    required this.location,
    required this.occupantsCount,
    required this.officeCapacity,
    required this.officeColor,
    required this.officeId,
    required this.email,
    required this.phone,
    this.workers = const [],
  });

  factory Office.fromJson(Map<String, dynamic> json) => _$OfficeFromJson(json);

  Map<String, dynamic> toJson() => _$OfficeToJson(this);
}