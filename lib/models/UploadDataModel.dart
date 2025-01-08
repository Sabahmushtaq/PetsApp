import 'package:json_annotation/json_annotation.dart';

part 'UploadDataModel.g.dart';

@JsonSerializable()
class UploadDataModel {
  final String name;
  String breed;
  final String color;
  final int price;
  int stock;

  final String category;
  final bool vaccinated;
  bool verified;
  bool rejected;

  bool checked;
  List<String> images;
  String? reason;
  final String id;
  final String uid;
  final String date;

  UploadDataModel(
      {required this.name,
      required this.breed,
      required this.category,
      required this.color,
      required this.vaccinated,
      required this.price,
      required this.stock,
      required this.images,
      required this.verified,
      required this.rejected,
      required this.checked,
      this.reason,
      required this.id,
      required this.uid,
      required this.date});

  factory UploadDataModel.fromJson(Map<String, dynamic> json) =>
      _$UploadDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadDataModelToJson(this);
}
