import 'package:json_annotation/json_annotation.dart';

part 'office_worker.g.dart';

@JsonSerializable()
class OfficeWorker {
  final String name;
  final String familyName;
  final String officeId;
  final String avatarId;

  OfficeWorker({
    required this.name, 
    required this.familyName, 
    required this.officeId, 
    required this.avatarId
  });

  factory OfficeWorker.fromJson(Map<String, dynamic> json) => _$OfficeWorkerFromJson(json);

  Map<String, dynamic> toJson() => _$OfficeWorkerToJson(this);
}