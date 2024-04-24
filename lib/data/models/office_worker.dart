import 'package:json_annotation/json_annotation.dart';

part 'office_worker.g.dart';

@JsonSerializable()
class OfficeWorker {
  final String name;
  final String familyName;

  OfficeWorker({required this.name, required this.familyName});

  factory OfficeWorker.fromJson(Map<String, dynamic> json) => _$OfficeWorkerFromJson(json);

  Map<String, dynamic> toJson() => _$OfficeWorkerToJson(this);
}